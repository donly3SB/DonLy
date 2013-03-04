//
//  DeviceHardware.m
//  360Tools
//
//  Created by chendianbo on 13-1-9.
//  Copyright (c) 2013年 chendianbo. All rights reserved.
//

#import "DeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>//for wifi addr
#include <net/if.h>//for wifi addr
#include <ifaddrs.h>//for wifi addr

#import <mach/mach_host.h>
#include <netinet/in.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if_dl.h>


#define kIODeviceTreePlane        "IODeviceTree"

enum {
    kIORegistryIterateRecursively    = 0x00000001,
    kIORegistryIterateParents        = 0x00000002
};

typedef mach_port_t    io_object_t;
typedef io_object_t    io_registry_entry_t;
typedef char        io_name_t[128];
typedef UInt32        IOOptionBits;

CFTypeRef IORegistryEntrySearchCFProperty(io_registry_entry_t entry,
                                          const io_name_t plane,
                                          CFStringRef key,
                                          CFAllocatorRef allocator,
                                          IOOptionBits options
                                          );
kern_return_t IOMasterPort(mach_port_t bootstrapPort, mach_port_t* masterPort);
io_registry_entry_t IORegistryGetRootEntry(mach_port_t masterPort);
CFTypeRef IORegistryEntrySearchCFProperty(io_registry_entry_t entry,
                                          const io_name_t plane,
                                          CFStringRef key,
                                          CFAllocatorRef allocator,
                                          IOOptionBits options
                                          );
kern_return_t mach_port_deallocate(ipc_space_t task, mach_port_name_t name);

@implementation UIDeviceHardware

- (NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    
    return platform;
}

- (NSString*) systemName
{
    return [[UIDevice currentDevice] systemName];
}

- (NSString*) systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *) localWiFiIPAddress
{
    struct ifaddrs* addrs = nil;
    if (0 == getifaddrs(&addrs)) {
        const struct ifaddrs* cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return @"";
}

NSArray* getValue(NSString *iosearch)
{
    mach_port_t          masterPort;
    CFTypeID             propID = (CFTypeID) NULL;
    unsigned int         bufSize;
    
//    [self performSelector:@selector() withObject:nil];
    kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (kr != noErr) return nil;
    
    io_registry_entry_t entry = IORegistryGetRootEntry(masterPort);
    if (entry == MACH_PORT_NULL) return nil;
    
    CFTypeRef prop = IORegistryEntrySearchCFProperty(entry,
                                                     kIODeviceTreePlane,
                                                     (CFStringRef) iosearch,
                                                     nil,
                                                     kIORegistryIterateRecursively
                                                     );
    if (!prop) return nil;
    
    propID = CFGetTypeID(prop);
    if (!(propID == CFDataGetTypeID())) {
        mach_port_deallocate(mach_task_self(), masterPort);
        return nil;
    }
    
    CFDataRef propData = (CFDataRef) prop;
    if (!propData) return nil;
    
    bufSize = CFDataGetLength(propData);
    if (!bufSize) return nil;
    
    //NSString *p1 = [[[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:1] autorelease];
    NSString *p1 = [[[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:NSUTF8StringEncoding] autorelease];
    mach_port_deallocate(mach_task_self(), masterPort);
    
    return [p1 componentsSeparatedByString:@"/0"];
}

- (NSString*) imei
{
    NSArray *results = getValue(@"device-imei");
    if (results && 0 < [results count]) {
        NSString *string_content = [results objectAtIndex:0];
        const char *char_content = [string_content cStringUsingEncoding:NSUTF8StringEncoding];
        return [[[NSString alloc] initWithCString:(const char*)char_content encoding:NSUTF8StringEncoding] autorelease];
    }
    return @"";
}

- (NSString *) serialnumber
{
    NSArray *results = getValue(@"serial-number");
    if (results) return [results objectAtIndex:0];
    return @"";
}

- (NSString *) backlightlevel
{
    NSArray *results = getValue(@"backlight-level");
    if (results) return [results objectAtIndex:0];
    return @"";
}

- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf = nil;
    unsigned char       *ptr = nil;
    struct if_msghdr    *ifm = nil;
    struct sockaddr_dl  *sdl = nil;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

@end

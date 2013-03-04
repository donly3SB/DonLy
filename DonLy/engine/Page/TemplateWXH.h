//
//  TemplateWXH.h
//  DonLy
//
//  Created by chen dianbo on 13-3-1.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "common.h"

#define kRsc_WXH_Head   @"\
<html>\
<head>\
<title></title>\
<style type=\"text/css\">\
div,body,h3{ padding:0; margin:0;}\
.DemoDiv,.DemoDivOn { width: 32%; min-width:200px; height: 300px; padding:20px;}\
.xb1,  .xb2,  .xb3,  .xb4,  .xb5,  .xb6,  .xb7 { display: block; overflow: hidden; }\
.xb1,  .xb2,  .xb3,  .xb5,  .xb6 { height: 1px; }\
.xb1 { margin: 0 5px; background: #cfe2e5; }\
.DemoDivOn .xb1 { margin: 0 5px; background: #61a4b0; }\
.xb2 { margin: 0 3px; border-width: 0 2px; }\
.xb3 { margin: 0 2px; }\
.xb4 { height: 2px; margin: 0 1px; }\
.xb5 { margin: 0 3px; border-width: 0 2px; }\
.xb6 { margin: 0 2px; }\
.xb7 { height: 2px; margin: 0 1px; }\
.xb2,  .xb3,  .xb4 { background: #aad9e2; border-left: 1px solid #cfe2e5; border-right: 1px solid #cfe2e5; }\
.xb5,  .xb6,  .xb7 { background: #ffffff; border-left: 1px solid #cfe2e5; border-right: 1px solid #cfe2e5; }\
.DemoDivOn .xb2, .DemoDivOn .xb3, .DemoDivOn .xb4 { background: #aad9e2; border-left: 1px solid #61a4b0; border-right: 1px solid #61a4b0; }\
.DemoDivOn .xb5, .DemoDivOn .xb6, .DemoDivOn .xb7 { background: #ffffff; border-left: 1px solid #61a4b0; border-right: 1px solid #61a4b0; }\
.xboxcontent{display: block;  background: #FFFFFF; border: 0 solid #cfe2e5; border-width: 0 1px;}\
.DemoDivOn .xboxcontent { border: 0 solid #61a4b0;border-width: 0 1px; }\
.xtop { display: block; background: transparent; font-size: 1px; }\
.xbottom { display: block; background: transparent; font-size: 1px; }\
h3 { height: 20px; font-size: 16px; background: #aad9e2; text-indent: 10px; color: #000000; font-weight: bolder;}\
.content { padding-top: 3px; padding-left: 5px; padding-right: 5px; padding-bottom: 3px; }\
</style>\
</head>\
<body>\
<div class=\"DemoDiv\" onmouseover_fckprotectedatt=\"%20onmouseover%3D%22this.className%3D'DemoDivOn'%22\" onmouseout_fckprotectedatt=\"%20onmouseout%3D%22this.\className%3D'DemoDiv'%22\">\
<b class=\"xtop\"><b class=\"xb1\"></b><b class=\"xb2\"></b><b class=\"xb3\"></b><b class=\"xb4\"></b></b>\
<div class=\"xboxcontent\">"

#define kRsc_WXH_End   @"\
</div>\
<b class=\"xbottom\"><b class=\"xb7\"></b><b class=\"xb6\"></b><b class=\"xb5\"></b><b class=\"xb1\"></b></b>\
<div id=\"content\" class=\"content\"></div>\
</div>\
</body>\
</html>"

#define kRsc_WXH_Title @"<h3>%@</h3>"

#define kRsc_WXH_Content @"<div id=\"content\" class=\"content\">%@</div>"

#define kRsc_WXH_Image @"\
<div id=\"content\" class=\"content\">\
<img src=\"%@\" style=\"margin:12px;\" width=\"196px\" height=\"288px\">\
</div>"

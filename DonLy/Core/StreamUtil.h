/* ====================================================================
 * File: StreamUtil.cpp
 * Created: 2012/5/10
 * Author: tiony.bo
 * ====================================================================
 */

#ifndef __STREAMUTIL_H__
#define __STREAMUTIL_H__

#import <stdio.h>
//#import <Foundation/Foundation.h>

namespace Tools_v1 {

typedef int t_bool;
typedef long t_long;
typedef unsigned int t_uint;
typedef unsigned char t_uint8;
typedef signed char t_int8;
typedef short int t_int16;
typedef signed int t_int;
typedef long long t_int64;

class StreamReader {
public:
    StreamReader(char* aBuffer, t_int aBuffLength, t_bool aOwned);
    ~StreamReader();

    void SetBuff(char* aBuffer, t_int aBuffLength, t_bool aOwned);

    t_int8  readInt8(t_int8 aDefault);
    t_int16 readInt16(t_int16 aDefault);
    t_int   readInt(t_int aDefault);
    t_int64 readInt64(t_int64 aDefault);
    char*   readString(t_uint* aLen);

    void jumpString();
    void jump(t_uint aOffset);

    t_bool eof() const { return iBuffLength <= iOffset; }
    t_bool completed() const { return iBuffLength == iOffset; }

    t_uint size() const { return iOffset; }
    t_uint stepSize() const { return iStepSize; }
    t_int  errCode() const { return iErrCode; }

private:
    t_bool chk(t_uint aLen);

private:
    t_bool  iOwned;
    t_int   iOffset;
    t_uint  iStepSize;
    t_int   iErrCode;

    char*   iBuffer;//Owned
    t_uint  iBuffLength;
};

class StreamWriter {
public:
    StreamWriter(t_uint aBlockSize, t_uint aPageSize);
    ~StreamWriter();

    void Reset(t_uint aBlockSize, t_uint aPageSize);

    void writeInt8(t_int8 aVal);
    void writeInt16(t_int16 aVal);
    void writeInt(t_int aVal);
    void writeInt64(t_int64 aVal);
    void writeString(char* aBuff, t_uint aLen);

    char*  buff() const { return iBlockBuffer; }
    t_uint size() const { return iOffset; }
    t_int  errCode() const { return iErrCode; }
    t_uint stepSize() const { return iStepSize; }

private:
    t_bool baseChk();
    t_bool chk(t_uint aLen);

private:
    t_int   iErrCode;
    t_uint  iStepSize;

    t_uint  iOffset;
    t_uint  iPageSize;
    char*   iBlockBuffer;
    t_uint  iBlockLength;
};

class StreamFileReader {
public:
    StreamFileReader();
    ~StreamFileReader();

    t_int open(const char* aFileName);
    t_int close();

    t_int8  readInt8(t_int8 aDefault);
    t_int16 readInt16(t_int16 aDefault);
    t_int   readInt(t_int aDefault);
    t_int64 readInt64(t_int64 aDefault);
    char*   readString(t_uint* aLen/*OUT*/);//aLen <= KDefaultBlockSize
    char*   readBuffer(t_uint aLen);

    void jumpString();
    void jump(t_uint aOffset);
    void seek(t_uint aOffset);

    t_bool eof();
    t_long curOffset();
    t_uint blockSize() const;

    t_int  errCode() const { return iErrCode; }
    t_uint stepSize() const { return iStepSize; }
    t_long fileSize() const { return iFileSize; }

private:
    t_bool baseChk();
    t_bool chk(t_uint aLen);

private:
    t_int   iErrCode;
    t_uint  iStepSize;

    FILE*   iFile;
    t_long  iFileSize;

    t_uint  iOffset;//0 <= && <= iBlockLength
    char*   iBlockBuffer;
    t_uint  iBlockLength;
};

class StreamFileWriter {
public:
    StreamFileWriter();
    ~StreamFileWriter();

    t_int open(const char* aFileName, t_bool aAppend);
    t_int close();

    void  writeInt8(t_int8 aVal);
    void  writeInt16(t_int16 aVal);
    void  writeInt(t_int aVal);
    void  writeInt64(t_int64 aVal);
    void  writeString(const char* aBuff, t_uint aLen);//aLength <= KDefaultBlockSize
    void  writeBuffer(const char* aBuff, t_uint aLen);

    t_long fileSize();
    t_long curOffset();
    t_uint blockSize() const;
    void   seek(t_uint aOffset);
    t_int  errCode() const { return iErrCode; }
    t_uint stepSize() const { return iStepSize; }

private:
    t_bool baseChk();
    t_bool chk(t_uint aLen);
    t_int  flush();
    t_int  flush(const char* aBuffer, t_uint aLen);

private:
    t_int   iErrCode;
    t_uint  iStepSize;

    FILE*   iFile;
    t_long  iFileSize;

    t_uint  iOffset;//0 <= && <= blockSize()
    char*   iBlockBuffer;
};

//#define __ENABLE_STREAM_UNIT_TEST__    1
#ifdef __ENABLE_STREAM_UNIT_TEST__
void RunStreamTestL();
#endif // __ENABLE_STREAM_UNIT_TEST__
}// namespace Tools_v1

#endif // __STREAMUTIL_H__

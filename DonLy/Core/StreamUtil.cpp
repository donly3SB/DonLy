/* ====================================================================
 * File: StreamUtil.cpp
 * Created: 2012/5/10
 * Author: tiony.bo
 * ====================================================================
 */

#include "StreamUtil.h"

#include <STDLIB.H>
#include <string.H>

#define KDefaultBlockSize   10240//10K
#define KMaxStringLength    10485760//10M

namespace Tools_v1
{

typedef union { t_int iVal; unsigned char iBit[sizeof(t_int)]; } u_int;
typedef union { t_int16 iVal; unsigned char iBit[sizeof(t_int16)]; } u_int16;
typedef union { t_int64 iVal; unsigned char iBit[sizeof(t_int64)]; } u_int64;
//---------------------------------------------------------------------
StreamReader::StreamReader(char* aBuffer, t_int aBuffLength, t_bool aOwned)
: iOwned(aOwned), iOffset(0), iStepSize(0)
, iErrCode(0), iBuffer(aBuffer), iBuffLength(aBuffLength)
{}

StreamReader::~StreamReader() {
    SetBuff(0L, 0, 0);
}

void StreamReader::SetBuff(char* aBuffer, t_int aBuffLength, t_bool aOwned) {
    if (iOwned) {
        free(iBuffer);
    }
    iOwned = aOwned;
    iBuffer = aBuffer;
    iBuffLength = aBuffLength;

    iOffset = 0;
    iErrCode = 0;
    iStepSize = 0;
}

t_bool StreamReader::chk(t_uint aLen) {
    if (0 != iErrCode) return 0;
    if (!iBuffer) {
        iErrCode = -18;//not ready
        return 0;
    }
    if (iBuffLength < iOffset + aLen) {
        iErrCode = -9;//overflow
        return 0;
    }
    return 1;//ok
}

t_int8 StreamReader::readInt8(t_int8 aVal) {
    iStepSize = sizeof(t_int8);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBuffer + iOffset, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

t_int16 StreamReader::readInt16(t_int16 aVal) {
    iStepSize = sizeof(t_int16);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBuffer + iOffset, iStepSize);
        u_int16 tmp; tmp.iVal = aVal;
        tmp.iBit[1] ^= tmp.iBit[0] ^= tmp.iBit[1] ^= tmp.iBit[0];
        aVal = tmp.iVal;

        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

t_int StreamReader::readInt(t_int aVal) {
    iStepSize = sizeof(t_int);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBuffer + iOffset, iStepSize);
        u_int tmp; tmp.iVal = aVal;
        tmp.iBit[3] ^= tmp.iBit[0] ^= tmp.iBit[3] ^= tmp.iBit[0];
        tmp.iBit[2] ^= tmp.iBit[1] ^= tmp.iBit[2] ^= tmp.iBit[1];
        aVal = tmp.iVal;

        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

t_int64 StreamReader::readInt64(t_int64 aVal) {
    iStepSize = sizeof(t_int64);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBuffer + iOffset, iStepSize);
        u_int64 tmp; tmp.iVal = aVal;
        tmp.iBit[7] ^= tmp.iBit[0] ^= tmp.iBit[7] ^= tmp.iBit[0];
        tmp.iBit[6] ^= tmp.iBit[1] ^= tmp.iBit[6] ^= tmp.iBit[1];
        tmp.iBit[5] ^= tmp.iBit[2] ^= tmp.iBit[5] ^= tmp.iBit[2];
        tmp.iBit[4] ^= tmp.iBit[3] ^= tmp.iBit[4] ^= tmp.iBit[3];
        aVal = tmp.iVal;

        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

char* StreamReader::readString(t_uint* aLen) {
    char* buff = 0L;
    if (aLen) *aLen = 0;

    t_uint len = readInt(iBuffLength + 1);
    if (chk(len) && 0 < len) {
        buff = (char*)malloc(len);
        if (buff) {
            memmove((void *)buff, iBuffer + iOffset, len);
            iOffset += len;
            if (aLen) *aLen = len;
        } else {
            iErrCode = -4;//no memory
        }
    }
    iStepSize = 0==iErrCode?(sizeof(t_int)+len):0;

    return buff;
}

void StreamReader::jumpString() {
    t_uint len = readInt(iBuffLength + 1);
    if (chk(len)) {
        iOffset += len;
    }
    iStepSize = 0==iErrCode?(sizeof(t_int)+len):0;
}

void StreamReader::jump(t_uint aOffset) {
    if (chk(aOffset)) {
        iOffset += aOffset;
    }
    iStepSize = 0==iErrCode?aOffset:0;
}

//StreamWriter
//---------------------------------------------------------------------
StreamWriter::StreamWriter(t_uint aBlockSize, t_uint aPageSize)
: iErrCode(0), iStepSize(0), iOffset(0)
, iPageSize(aPageSize), iBlockBuffer(0L), iBlockLength(aBlockSize)
{}

StreamWriter::~StreamWriter() {
    Reset(0, iPageSize);
}

void StreamWriter::Reset(t_uint aBlockSize, t_uint aPageSize) {
    if (iBlockBuffer) {
        free(iBlockBuffer); iBlockBuffer = 0L;
    }
    iOffset = 0;
    iErrCode = 0;
    iStepSize = 0;
    iPageSize = aPageSize;
    iBlockLength = aBlockSize;
}

void StreamWriter::writeInt8(t_int8 aVal) {
    iStepSize = sizeof(t_int8);
    if (chk(iStepSize)) {
        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamWriter::writeInt16(t_int16 aVal) {
    iStepSize = sizeof(t_int16);
    if (chk(iStepSize)) {
        u_int16 tmp; tmp.iVal = aVal;
        tmp.iBit[1] ^= tmp.iBit[0] ^= tmp.iBit[1] ^= tmp.iBit[0];
        aVal = tmp.iVal;

        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamWriter::writeInt(t_int aVal) {
    iStepSize = sizeof(t_int);
    if (chk(iStepSize)) {
        u_int tmp; tmp.iVal = aVal;
        tmp.iBit[3] ^= tmp.iBit[0] ^= tmp.iBit[3] ^= tmp.iBit[0];
        tmp.iBit[2] ^= tmp.iBit[1] ^= tmp.iBit[2] ^= tmp.iBit[1];
        aVal = tmp.iVal;

        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamWriter::writeInt64(t_int64 aVal) {
    iStepSize = sizeof(t_int64);
    if (chk(iStepSize)) {
        u_int64 tmp; tmp.iVal = aVal;
        tmp.iBit[7] ^= tmp.iBit[0] ^= tmp.iBit[7] ^= tmp.iBit[0];
        tmp.iBit[6] ^= tmp.iBit[1] ^= tmp.iBit[6] ^= tmp.iBit[1];
        tmp.iBit[5] ^= tmp.iBit[2] ^= tmp.iBit[5] ^= tmp.iBit[2];
        tmp.iBit[4] ^= tmp.iBit[3] ^= tmp.iBit[4] ^= tmp.iBit[3];
        aVal = tmp.iVal;

        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamWriter::writeString(char* aBuff, t_uint aLen) {
    writeInt(aLen);
    if (chk(aLen)) {
        if (aBuff) {
            memmove(iBlockBuffer + iOffset, aBuff, aLen);
        }
        iOffset += aLen;
    }
    iStepSize = 0==iErrCode?(sizeof(t_int)+aLen):0;
}

t_bool StreamWriter::baseChk() {
    if (0 != iErrCode) return 0;
    if (iPageSize <= 0) {
        iErrCode = -18;//not ready
        return 0;
    }
    if (!iBlockBuffer) {
        iBlockBuffer = (char*)malloc(iPageSize);
        if (!iBlockBuffer) {
            iErrCode = -4;//no memory
            return 0;
        }
        iBlockLength = iPageSize;
    }
    return 1;
}

t_bool StreamWriter::chk(t_uint aLen) {
    if (!baseChk()) return 0;
    if (iBlockLength < iOffset + aLen) {
        if (iPageSize <= aLen) iPageSize += aLen;//Auto update block value
        iBlockLength += iPageSize;
        char* buff = (char*)malloc(iBlockLength);
        if (!buff) {
            iErrCode = -4;//no memory
            return 0;
        }
        memmove(buff, iBlockBuffer, iOffset);
        free(iBlockBuffer);
        iBlockBuffer = buff;
    }
    return 1;//ok
}

//StreamFile
//---------------------------------------------------------------------
StreamFileReader::StreamFileReader()
: iErrCode(0), iStepSize(0), iFile(0L)
, iFileSize(0L), iOffset(0), iBlockBuffer(0L), iBlockLength(0)
{}

StreamFileReader::~StreamFileReader() {
    close();
    if (iBlockBuffer) {
        free(iBlockBuffer); iBlockBuffer = 0L;
    }
}

t_int StreamFileReader::open(const char* aFileName) {
    close();

    //creat block memory
    if (!iBlockBuffer) {
        iBlockBuffer = (char*)malloc(KDefaultBlockSize);
        if (!iBlockBuffer) {
            iErrCode = -4;//no memory
            return iErrCode;
        }
    }

    //open file
    iFile = fopen(aFileName, "rb");
    if (!iFile) {
        iErrCode = -8;//Bad handle
        return iErrCode;
    }

    //get file size
    iErrCode = fseek(iFile, 0, SEEK_END);
    if (0 == iErrCode) {
        iFileSize = ftell(iFile);
        iErrCode = fseek(iFile, 0, SEEK_SET);
    }

    return iErrCode;
}

t_int StreamFileReader::close() {
    t_int err = 0;
    if (iFile) {
        err = fclose(iFile); iFile = 0L;
    }

    //reset member
    iOffset = 0;
    iErrCode = 0;
    iStepSize = 0;
    iFileSize = 0L;
    iBlockLength = 0;

    return err;
}

t_int8 StreamFileReader::readInt8(t_int8 aVal) {
    iStepSize = sizeof(t_int8);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBlockBuffer + iOffset, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

t_int16 StreamFileReader::readInt16(t_int16 aVal) {
    iStepSize = sizeof(t_int16);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBlockBuffer + iOffset, iStepSize);
        u_int16 tmp; tmp.iVal = aVal;
        tmp.iBit[1] ^= tmp.iBit[0] ^= tmp.iBit[1] ^= tmp.iBit[0];
        aVal = tmp.iVal;

        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

t_int StreamFileReader::readInt(t_int aVal) {
    iStepSize = sizeof(t_int);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBlockBuffer + iOffset, iStepSize);
        u_int tmp; tmp.iVal = aVal;
        tmp.iBit[3] ^= tmp.iBit[0] ^= tmp.iBit[3] ^= tmp.iBit[0];
        tmp.iBit[2] ^= tmp.iBit[1] ^= tmp.iBit[2] ^= tmp.iBit[1];
        aVal = tmp.iVal;

        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

t_int64 StreamFileReader::readInt64(t_int64 aVal) {
    iStepSize = sizeof(t_int64);
    if (chk(iStepSize)) {
        memmove((void *)&aVal, iBlockBuffer + iOffset, iStepSize);
        u_int64 tmp; tmp.iVal = aVal;
        tmp.iBit[7] ^= tmp.iBit[0] ^= tmp.iBit[7] ^= tmp.iBit[0];
        tmp.iBit[6] ^= tmp.iBit[1] ^= tmp.iBit[6] ^= tmp.iBit[1];
        tmp.iBit[5] ^= tmp.iBit[2] ^= tmp.iBit[5] ^= tmp.iBit[2];
        tmp.iBit[4] ^= tmp.iBit[3] ^= tmp.iBit[4] ^= tmp.iBit[3];
        aVal = tmp.iVal;

        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
    return aVal;
}

char* StreamFileReader::readString(t_uint* aLen/*OUT*/) {
    char* buff = 0L;
    t_uint len = readInt(KMaxStringLength);
    if (len <= KDefaultBlockSize) {
        if (chk(len) && 0 < len) {
            buff = (char*)malloc(len+1);
            if (buff) {
                memset(buff, 0x00, len+1);
                memmove((void *)buff, iBlockBuffer + iOffset, len);
                iOffset += len;
            } else {
                iErrCode = -4;//No memory
            }
        }
    } else
    if (len < KMaxStringLength) {
        buff = readBuffer(len);
    } else {
        if (0 == iErrCode) iErrCode = -9;//overflow
    }

    if (0 == iErrCode) {
        if (aLen) *aLen = len;
        iStepSize = sizeof(t_int) + len;
    } else {
        iStepSize = 0;
        if (aLen) *aLen = 0;
        if (buff) { free(buff); buff = 0L; }
    }

    return buff;
}

char* StreamFileReader::readBuffer(t_uint aLen) {
    iStepSize = 0;
    char* buff = 0L;
    if (aLen <= 0 || !baseChk()) return buff;

    buff = (char*)malloc(aLen+1);
    if (!buff) {
        iErrCode = -4;//No memory
        return buff;
    }
    memset(buff, 0x00, aLen+1);

    if (aLen <= KDefaultBlockSize) {
        if (chk(aLen)) {
            memmove((void *)buff, iBlockBuffer + iOffset, aLen);
            iOffset += aLen;
        }
    } else {
        if (feof(iFile)) {
            iErrCode = -25;//err eof
        } else {
            t_long filePos = ftell(iFile);
            filePos -= iBlockLength - iOffset;
            iErrCode = fseek(iFile, filePos, SEEK_SET);
            if (0 == iErrCode) {
                iOffset = 0;
                iBlockLength = 0;

                memset(buff, 0x00, aLen);
                const t_int len = fread(buff, 1, aLen, iFile);
                if (len < aLen && !feof(iFile)) {
                    iErrCode = -22;//read error
                }
            }
        }
    }
    if (0 == iErrCode) {
        iStepSize = aLen;
    } else {
        iStepSize = 0;
        free(buff); buff = 0L;
    }

    return buff;
}

void StreamFileReader::jumpString() {
    t_uint len = readInt(KMaxStringLength);
    if (len < KMaxStringLength) {
        jump(len);
    } else {
        if (0 == iErrCode) iErrCode = -9;//overflow
    }
    iStepSize = 0==iErrCode?(sizeof(t_int)+len):0;
}

void StreamFileReader::jump(t_uint aOffset) {
    if (aOffset <= 0 || !baseChk()) {
        iStepSize = 0;
        return ;
    }
    if (aOffset <= KDefaultBlockSize) {
        if (chk(aOffset)) {
            iOffset += aOffset;
        }
    } else
    if (aOffset < KMaxStringLength) {
        if (feof(iFile)) {
            iErrCode = -25;//err eof
        } else {
            t_long filePos = ftell(iFile);
            filePos -= iBlockLength - iOffset;
            iErrCode = fseek(iFile, filePos+aOffset, SEEK_SET);
            if (0 == iErrCode) {
                iOffset = 0;
                iBlockLength = 0;
            }
        }
    } else {
        if (0 == iErrCode) iErrCode = -9;//overflow
    }
    iStepSize = 0==iErrCode ? aOffset : 0;
}

void StreamFileReader::seek(t_uint aOffset) {
    if (baseChk()) {
        if (aOffset <= iFileSize) {
            iErrCode = fseek(iFile, aOffset, SEEK_SET);
            if (0 == iErrCode) {
                iOffset = 0;
                iStepSize = 0;
                iBlockLength = 0;
            }
        } else {
            iErrCode = -9;//overflow
        }
    }
}

t_bool StreamFileReader::eof() {
    if (baseChk() && iOffset == iBlockLength) {
        if (feof(iFile)) return 1;
        if (iFileSize == ftell(iFile)) return 1;
    }
    return 0;
}

t_long StreamFileReader::curOffset() {
    t_long curPos = 0;
    if (baseChk()) {
        curPos = ftell(iFile) - iBlockLength + iOffset;
    }
    return curPos;
}

t_uint StreamFileReader::blockSize() const { return KDefaultBlockSize; }

t_bool StreamFileReader::baseChk() {
    if (0 != iErrCode) return 0;
    if (!iBlockBuffer || !iFile) {
        iErrCode = -18;//not ready
        return 0;
    }
    return 1;
}

t_bool StreamFileReader::chk(t_uint aLen) {
    if (!baseChk()) return 0;
    if (KDefaultBlockSize < aLen) {
        iErrCode = -6;//error argument
        return 0;
    }
    if (iBlockLength < iOffset + aLen) {//read next block
        if (feof(iFile)) {
            iErrCode = -25;//err eof
        } else {
            t_long filePos = ftell(iFile);
            filePos -= iBlockLength - iOffset;
            iErrCode = fseek(iFile, filePos, SEEK_SET);
            if (0 == iErrCode) {
                memset(iBlockBuffer, 0x00, KDefaultBlockSize);
                iBlockLength = fread(iBlockBuffer, 1, KDefaultBlockSize, iFile);
                if (iBlockLength < KDefaultBlockSize && !feof(iFile)) {
                    iErrCode = -22;//read error
                }
            }
        }
        iOffset = 0;
    }

    return 0 == iErrCode;
}

//For write
//---------------------------------------------------------------------
StreamFileWriter::StreamFileWriter()
: iErrCode(0), iStepSize(0), iFile(0L)
, iFileSize(0L), iOffset(0), iBlockBuffer(0L)
{}

StreamFileWriter::~StreamFileWriter() {
    close();
    if (iBlockBuffer) {
        free(iBlockBuffer); iBlockBuffer = 0L;
    }
}

t_int StreamFileWriter::open(const char* aFileName, t_bool aAppend) {
    close();

    //creat block memory
    if (!iBlockBuffer) {
        iBlockBuffer = (char*)malloc(KDefaultBlockSize);
        if (!iBlockBuffer) {
            iErrCode = -4;//no memory
            return iErrCode;
        }
        memset(iBlockBuffer, 0x00, KDefaultBlockSize);
    }

    //open file
    if (aAppend) {
        iFile = fopen(aFileName, "rb+");
    }
    if (!iFile) {
        iFile = fopen(aFileName, "wb");
    }
    if (!iFile) {
        iErrCode = -8;//Bad handle
        return iErrCode;
    }

    //get file size
    if (aAppend) {
        iErrCode = fseek(iFile, 0, SEEK_END);
        if (0 == iErrCode) {
            iFileSize = ftell(iFile);
        }
    }

    return iErrCode;
}

t_int StreamFileWriter::close() {
    t_int err = 0;

    if (iFile) {
        if (baseChk()) flush();
        err = fclose(iFile); iFile = 0L;
    }

    //reset member
    iOffset = 0;
    iErrCode = 0;
    iStepSize = 0;
    iFileSize = 0L;

    return err;
}

void StreamFileWriter::writeInt8(t_int8 aVal) {
    iStepSize = sizeof(t_int8);
    if (chk(iStepSize)) {
        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamFileWriter::writeInt16(t_int16 aVal) {
    iStepSize = sizeof(t_int16);
    if (chk(iStepSize)) {
        u_int16 tmp; tmp.iVal = aVal;
        tmp.iBit[1] ^= tmp.iBit[0] ^= tmp.iBit[1] ^= tmp.iBit[0];
        aVal = tmp.iVal;

        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamFileWriter::writeInt(t_int aVal) {
    iStepSize = sizeof(t_int);
    if (chk(iStepSize)) {
        u_int tmp; tmp.iVal = aVal;
        tmp.iBit[3] ^= tmp.iBit[0] ^= tmp.iBit[3] ^= tmp.iBit[0];
        tmp.iBit[2] ^= tmp.iBit[1] ^= tmp.iBit[2] ^= tmp.iBit[1];
        aVal = tmp.iVal;

        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamFileWriter::writeInt64(t_int64 aVal) {
    iStepSize = sizeof(t_int64);
    if (chk(iStepSize)) {
        u_int64 tmp; tmp.iVal = aVal;
        tmp.iBit[7] ^= tmp.iBit[0] ^= tmp.iBit[7] ^= tmp.iBit[0];
        tmp.iBit[6] ^= tmp.iBit[1] ^= tmp.iBit[6] ^= tmp.iBit[1];
        tmp.iBit[5] ^= tmp.iBit[2] ^= tmp.iBit[5] ^= tmp.iBit[2];
        tmp.iBit[4] ^= tmp.iBit[3] ^= tmp.iBit[4] ^= tmp.iBit[3];
        aVal = tmp.iVal;

        memmove(iBlockBuffer + iOffset, (const char *)&aVal, iStepSize);
        iOffset += iStepSize;
    } else {
        iStepSize = 0;
    }
}

void StreamFileWriter::writeString(const char* aBuff, t_uint aLen) {
    writeInt(aLen);
    if (aLen <= KDefaultBlockSize) {
        if (chk(aLen)) {
            if (aBuff) {
                memmove(iBlockBuffer + iOffset, aBuff, aLen);
            }
            iOffset += aLen;
        }
    } else {
        writeBuffer(aBuff, aLen);
    }
    iStepSize = 0==iErrCode?(sizeof(t_int)+aLen):0;
}

void StreamFileWriter::writeBuffer(const char* aBuff, t_uint aLen) {
    iStepSize = 0;
    if (aLen <= 0 || !baseChk() || 0 != flush()) return ;
    if (aBuff) {
        flush(aBuff, aLen);
    } else {
        memset(iBlockBuffer, 0x00, KDefaultBlockSize);
        const t_uint cnt = aLen / KDefaultBlockSize;
        for (t_uint i=0; i<cnt; ++i) {
            if (0 != flush(iBlockBuffer, KDefaultBlockSize)) break;
        }
        if (0 == iErrCode) {
            flush(iBlockBuffer, aLen%KDefaultBlockSize);
        }
    }
    if (0 == iErrCode) {
        iStepSize = aLen;
        t_long filePos = ftell(iFile);
        if (iFileSize < filePos) {
            iFileSize = filePos;
        }
    }
}

void StreamFileWriter::seek(t_uint aOffset) {
    if (baseChk() && 0 == flush()) {
        if (aOffset <= fileSize()) {
            iErrCode = fseek(iFile, aOffset, SEEK_SET);
        } else {
            iErrCode = -9;//overflow
        }
    }
}

t_long StreamFileWriter::fileSize() {
    t_long fileSize = 0;
    if (baseChk()) {
        t_long curPos = ftell(iFile);
        fileSize = curPos < iFileSize ? iFileSize : curPos;
        fileSize += iOffset;
    }
    return fileSize;
}

t_long StreamFileWriter::curOffset() {
    t_long curPos = 0;
    if (baseChk()) {
        curPos = ftell(iFile) + iOffset;
    }
    return curPos;
}

t_uint StreamFileWriter::blockSize() const { return KDefaultBlockSize; }

t_bool StreamFileWriter::baseChk() {
    if (0 != iErrCode) return 0;
    if (!iBlockBuffer || !iFile) {
        iErrCode = -18;//not ready
        return 0;
    }
    return 1;
}

t_bool StreamFileWriter::chk(t_uint aLen) {
    if (!baseChk()) return 0;
    if (KDefaultBlockSize < aLen) {
        iErrCode = -6;//error argument
        return 0;
    }
    if (KDefaultBlockSize < iOffset + aLen) {
        flush();
    }
    return 0 == iErrCode;
}

t_int StreamFileWriter::flush() {
    if (0 == iOffset) return iErrCode;
    if (fwrite(iBlockBuffer, iOffset, 1, iFile)) {
        iErrCode = fflush(iFile);
        if (0 == iErrCode) {
            iOffset = 0;
            t_long filePos = ftell(iFile);
            if (iFileSize < filePos) {
                iFileSize = filePos;
            }
            memset(iBlockBuffer, 0x00, KDefaultBlockSize);
        }
    } else {
        iErrCode = -23;//write error
    }
    return iErrCode;
}

t_int StreamFileWriter::flush(const char* aBuffer, t_uint aLen) {
    if (!aBuffer || aLen <= 0) return iErrCode;
    if (fwrite(aBuffer, aLen, 1, iFile)) {
        iErrCode = fflush(iFile);
    } else {
        iErrCode = -23;//write error
    }
    return iErrCode;
}

//Unit test
//---------------------------------------------------------------------
#ifdef __ENABLE_STREAM_UNIT_TEST__
#include <STRING.H>
//#define assert(express) if(!(express)){ \
      User::Panic(_L("assert err"), 0); \
      }

void RunTest0L() {
    t_uint len = 0;
    const char* src = "abcdefghijklmnopqrstuvwxyz123456789*-+.~!@#$%^&*()_+{}[]:;<>,.?/|`";
    const t_uint srcLen = strlen(src);
#if (1)
    StreamFileWriter* writer = new(ELeave)StreamFileWriter();
    assert(0 == writer->open("c:\\test.dat", 0));

    //write
    t_uint seekPos = 0;
    for (t_int i=0; i<1000; ++i) {
//        if (i == 999 && seekPos == 0) {
//            seekPos = writer->curOffset();
//        }
//        if (i == 1555 && 0 != seekPos) {
//            writer->seek(seekPos);
//            assert(0 == writer->errCode());
//            i = 2555;
//            seekPos = 0;
//        }
        len = writer->curOffset();
        writer->writeString(0L, i%srcLen);
        assert(0 == writer->errCode());
        assert(sizeof(t_int) + i%srcLen == writer->stepSize());
        assert(sizeof(t_int) + i%srcLen + len == writer->curOffset());

        len = writer->curOffset();
        writer->writeInt(i);
        assert(0 == writer->errCode());
        assert(sizeof(t_int) == writer->stepSize());
        assert(sizeof(t_int) + len == writer->curOffset());

        len = writer->curOffset();
        writer->writeInt16(t_int16(i));
        assert(0 == writer->errCode());
        assert(sizeof(t_int16) == writer->stepSize());
        assert(sizeof(t_int16) + len == writer->curOffset());

        len = writer->curOffset();
        writer->writeBuffer(src, i%srcLen);
        assert(0 == writer->errCode());
        assert(i%srcLen == writer->stepSize());
        assert(i%srcLen + len == writer->curOffset());

        len = writer->curOffset();
        writer->writeInt64(20021017181259 + i);
        assert(0 == writer->errCode());
        assert(sizeof(t_int64) == writer->stepSize());
        assert(sizeof(t_int64) + len == writer->curOffset());

        len = writer->curOffset();
        writer->writeInt8(t_int8(i));
        assert(0 == writer->errCode());
        assert(sizeof(t_int8) == writer->stepSize());
        assert(sizeof(t_int8) + len == writer->curOffset());

        len = writer->curOffset();
        writer->writeString(src, i%srcLen);
        assert(0 == writer->errCode());
        assert(sizeof(t_int) + i%srcLen == writer->stepSize());
        assert(sizeof(t_int) + i%srcLen + len == writer->curOffset());
    }
    assert(0 == writer->close());
    delete writer;
#endif
    //read check
    char* buf = 0L;
    t_uint curPos = 0;
    StreamFileReader* reader = new(ELeave)StreamFileReader();
    assert(0 == reader->open("c:\\test.dat"));//inner_keyword_list
    for (t_int i=0, j=1; /*i<5000*/; ++i) {
//        if (i == 999) {
//            i = 2555;
//        }
        if (1000 <= i) {
            if (1000 <= j) break;
            reader->seek(seekPos);
            seekPos = 0;
            i = j;
            ++ j;
        }
        if (i == j && seekPos == 0) {
            seekPos = reader->curOffset();
        }

#if (0)
        curPos = reader->curOffset();
        buf = reader->readString(&len);
        assert(0 == reader->errCode());
        assert(len + sizeof(t_int) == reader->stepSize());
        assert(len == i%srcLen);
//        assert(0 == strncmp(buf, src, len));
        if (buf) free(buf);
        assert(sizeof(t_int) + len + curPos == reader->curOffset());
#else
        curPos = reader->curOffset();
        len = reader->readInt(KMaxStringLength);
        assert(len == i%srcLen);
        assert(0 == reader->errCode());
        assert(sizeof(t_int) == reader->stepSize());
        assert(sizeof(t_int) + curPos == reader->curOffset());

        curPos = reader->curOffset();
        reader->jump(len);
        assert(0 == reader->errCode());
        assert(len == reader->stepSize());
        assert(len + curPos == reader->curOffset());

//        curPos = reader->curOffset();
//        buf = reader->readBuffer(len);
//        assert(0 == reader->errCode());
//        assert(i%srcLen == reader->stepSize());
//        if (buf) free(buf);
//        assert(len + curPos == reader->curOffset());
#endif

        curPos = reader->curOffset();
        assert(reader->readInt(i+1) == i);
        assert(0 == reader->errCode());
        assert(sizeof(t_int) == reader->stepSize());
        assert(sizeof(t_int) + curPos == reader->curOffset());

        curPos = reader->curOffset();
        assert(reader->readInt16(t_int16(i+1)) == t_int16(i));
        assert(0 == reader->errCode());
        assert(sizeof(t_int16) == reader->stepSize());
        assert(sizeof(t_int16) + curPos == reader->curOffset());

        curPos = reader->curOffset();
        buf = reader->readBuffer(i%srcLen);
        assert(0 == reader->errCode());
        assert(i%srcLen == reader->stepSize());
        assert(0 == strncmp(buf, src, len));
        if (buf) free(buf);
        assert(i%srcLen + curPos == reader->curOffset());

        curPos = reader->curOffset();
        assert(reader->readInt64(20021017181259 + i + 1) == 20021017181259 + i);
        assert(0 == reader->errCode());
        assert(sizeof(t_int64) == reader->stepSize());
        assert(sizeof(t_int64) + curPos == reader->curOffset());

        curPos = reader->curOffset();
        reader->jump(sizeof(t_int8));
        assert(0 == reader->errCode());
        assert(sizeof(t_int8) == reader->stepSize());
        assert(sizeof(t_int8) + curPos == reader->curOffset());

//        curPos = reader->curOffset();
//        assert(reader->readInt8(t_int8(i+1)) == t_int8(i));
//        assert(0 == reader->errCode());
//        assert(sizeof(t_int8) == reader->stepSize());
//        assert(sizeof(t_int8) + curPos == reader->curOffset());

        reader->jumpString();
        assert(0 == reader->errCode());
        assert(sizeof(t_int) + i%srcLen == reader->stepSize());

//        curPos = reader->curOffset();
//        buf = reader->readString(&len);
//        assert(0 == reader->errCode());
//        assert(len + sizeof(t_int) == reader->stepSize());
//        assert(len == i%srcLen);
//        assert(0 == strncmp(buf, src, len));
//        if (buf) free(buf);
//        assert(sizeof(t_int) + len + curPos == reader->curOffset());
    }
    assert(reader->eof());
    assert(0 == reader->close());
    delete reader;
}

//---------------------------------------------------------------------
void RunTest1L() {
    t_uint len = 0;
    char* src = "abcdefghijklmnopqrstuvwxyz123456789*-+.~!@#$%^&*()_+{}[]:;<>,.?/|`";
    const t_uint srcLen = strlen(src);
    StreamWriter* writer = new(ELeave)StreamWriter(0, 100);
    //write test
    for (t_int i=0; i<5000; ++i) {
        len = writer->size();
        writer->writeInt(i);
        assert(0 == writer->errCode());
        assert(len + sizeof(t_int) == writer->size());

        len = writer->size();
        writer->writeInt16(t_int16(i));
        assert(0 == writer->errCode());
        assert(len + sizeof(t_int16) == writer->size());

        len = writer->size();
        writer->writeInt64(20021017181259 + i);
        assert(0 == writer->errCode());
        assert(len + sizeof(t_int64) == writer->size());

        len = writer->size();
        writer->writeInt8(t_int8(i));
        assert(0 == writer->errCode());
        assert(len + sizeof(t_int8) == writer->size());

        len = writer->size();
        writer->writeString(src, i%srcLen);
        assert(0 == writer->errCode());
        assert(len + sizeof(t_int) + i%srcLen == writer->size());
    }

    //read check
    StreamReader* reader = new(ELeave)StreamReader(writer->buff(), writer->size(), 0);
    for (t_int i=0; i<5000; ++i) {
        assert(reader->readInt(i+1) == i);
        assert(sizeof(t_int) == reader->stepSize());

        assert(reader->readInt16(t_int16(i+1)) == t_int16(i));
        assert(sizeof(t_int16) == reader->stepSize());

        assert(reader->readInt64(20021017181259 + i + 1) == 20021017181259 + i);
        assert(sizeof(t_int64) == reader->stepSize());

        assert(reader->readInt8(t_int8(i+1)) == t_int8(i));
        assert(sizeof(t_int8) == reader->stepSize());

        reader->jumpString();
        assert(0 == reader->errCode());
        assert(sizeof(t_int) + i%srcLen == reader->stepSize());

//        buf = reader->readString(&len);
//        assert(0 == reader->errCode());
//        assert(len + sizeof(t_int) == reader->stepSize());
//        assert(buf);
//        assert(len == i%srcLen);
//        assert(0 == strncmp(buf, src, len));
//        free(buf);
    }
    //check end
    assert(reader->eof());
    assert(reader->completed());

    delete reader;
    delete writer;
}

void RunStreamTestL() {
    RunTest0L();
    RunTest1L();
}
#endif //__ENABLE_STREAM_UNIT_TEST__
}//namespace Tools_v1
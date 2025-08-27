#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/Layout files
#pragma magic [ 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ] @ 0x00
#pragma endian little

struct AdditionalData {
    float X;
    float Y;
    float Z;
    float W;
};

struct LayoutEntry {
    s32 Count;
    s32 Unknown;
    padding[8];
    s32 pos = $;
    char EntryLabel[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 32 == 0) || ($ % 32 != 0)))];
    $ = pos;
    padding[0x40];
    s32 TestVariable;
    padding[4];
    s32 AdditionalDataLength;
    $ -= 0x1C;
    padding[0x20];
    float SizeX;
    float SkewY;
    float SkewZ;
    padding[8];
    float SizeY;
    padding[8];
    float SkewX;
    padding[4];
    float SizeZ;
    float SkewCorrection;
    float PositionX;
    float PositionY;
    float PositionZ;
    float ForceCorrection;
    padding[0x10];
    if (AdditionalDataLength < 32768) {
        AdditionalData AdditionalData[AdditionalDataLength];
    }
};
LayoutEntry Entries[while(!std::mem::eof())] @ 0x30;
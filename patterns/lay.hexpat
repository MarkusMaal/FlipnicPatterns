#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/Layout files
#pragma magic [ 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ] @ 0x00
#pragma endian little

struct LayoutEntry {
    s32 Count;
    s32 Unknown;
    padding[8];
    s32 pos = $;
    char EntryLabel[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 32 == 0) || ($ % 32 != 0)))];
    $ = pos;
    padding[0x30];
    $ += 0x10;
    s32 TestVariable [[hidden]];
    padding[4];
    s32 TestVariable2 [[hidden]];
    $ -= 0x1C;
    if (TestVariable == 1) {
        $ += 0x10 * (TestVariable2);
    }
    padding[0x20];
    float SizeX;
    float SkewY;
    float SizeZ;
    padding[8];
    float SizeY;
    padding[8];
    float SkewX;
    padding[4];
    float SkewZ;
    float SkewCorrection;
    float PositionX;
    float PositionY;
    float PositionZ;
    float ForceCorrection;
    padding[0x10];
};

LayoutEntry Entries[while(!std::mem::eof())] @ 0x30;
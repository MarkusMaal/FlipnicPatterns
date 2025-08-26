#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/Collision maps
#pragma magic [ 00 00 05 00 00 00 00 ?? ?? ?? 00 00 ?? ?? 00 00 ] @ 0x00
#pragma endian little

struct Label {
    u32 Start = $;
    char Label[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x8)];
};

struct Vec4 {
    float X [[color("A00000")]];
    float Y [[color("00A000")]];
    float Z [[color("0000A0")]];;
    float W [[color("A000A0")]];;
};

struct Definition {
    padding[0x10];
    Label Label;
    u32 Unknown[4] [[color("666666")]];
    s32 Count;
    u32 LastUnknown;
    Vec4 CollFirst[Count*2];
    s32 AdditionalDataCount;
    padding[0xC];
    Vec4 CollMain[AdditionalDataCount*2];
};

struct Definitions {
    bool HasDefaultValue @ 0x07;
    s32 GroundCount @ 0x08;
    s32 WallCount @ 0x0C;
    if (HasDefaultValue) {
        Vec4 InitialValue;
    }
    Definition Walls[WallCount];
    Definition Grounds[GroundCount];
};

u32 Magic @ 0x00;
Definitions Def @ 0x10;
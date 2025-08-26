#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/Path data
#pragma magic [ FF FF FF FF 00 00 00 00 00 00 00 00 00 00 00 00 ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?0 00 00 00 00 ] @ 0x00
#pragma endian little

struct Label {
    u32 Start = $;
    char Label[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ % 4 == 0)];
};


struct Vec4 {
    float X [[color("A00000")]];
    float Y [[color("00A000")]];
    float Z [[color("0000A0")]];;
    float W [[color("A000A0")]];;
};

struct Entries {
    s32 EntriesCount @ 0x30;
    s32 ValuesPerEntry @ 0x34;
    s32 Flags @ 0x38;
    match (Flags) {
        (-2147483646): Vec4 Entries[EntriesCount];
        (2): Vec4 Entries[EntriesCount * 2];
        (1): Vec4 Entries[EntriesCount];
        (_): float Entries[ValuesPerEntry * EntriesCount];
    }
};

s32 Reserved @ 0;
Label Label @ 0x10;
Entries Entries @ 0x40;
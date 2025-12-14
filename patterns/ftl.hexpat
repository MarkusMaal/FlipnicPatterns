#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/Texture list
#pragma magic [ 10 11 12 13 14 15 16 17 18 19 1A 1B ] @ 0x04
#pragma endian little

struct Header {
    u32 Entries [[color("50a050")]];
    u8 Magic[0xC] [[color("5000a0")]];
};

struct Entry {
    u32 Start = $;
    char Filename[while(std::mem::read_unsigned($,1) != 0x0)] [[color("202020")]];
    padding[while ($ < Start + 0x10)];
    u32 PosX [[color("ff0080")]];
    u32 PosY [[color("ff0080")]];
    u32 Width [[color("ff8f00")]];
    u32 Height [[color("ff8f00")]];
};

Header FtlHeader @ 0x00;
Entry Entries[FtlHeader.Entries] @ 0x10;
#include <std/mem>
u32 SectionCount[4] @0;


struct String20 {
    const u32 start = $;
    char SectionLabel[while(std::mem::read_unsigned($, 1) != 0x0 && ($ < start + 0x20))];
    padding[while($ < start + 0x20)];
};

struct String40 {
    const u32 start = $;
    char Filename[while(std::mem::read_unsigned($, 1) != 0x0 && ($ < start + 0x40))];
    padding[while($ < start + 0x40)];
};

struct MenuEntry {
    String40 FilenameArea;
    u32 PosX;
    u32 PosY;
    u32 Width;
    u32 Height;
    padding[0xC];
    u32 Index;
};

struct Section {
    String20 SectionNameArea;
    padding[4];
    u32 EntryCount[3];
    MenuEntry Entries[EntryCount[0]];
};

Section Sections[SectionCount[0]] @0x10;
char Magic[0x8] @ 0x00;
u32 TOCOffset @ 0x8;
u32 TOCEntriesCount @ 0xC;

struct String {
    char16 Message[parent.Length / 2];
};

struct Entry {
    u32 Offset;
    u16 Length;
    padding[2];
    String Message @ Offset;
} [[single_color]];

Entry TOC[TOCEntriesCount] @ TOCOffset;
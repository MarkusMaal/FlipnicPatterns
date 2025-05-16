#include <std/mem>
#include <hex/core>

char Magic[8] @ 0x00;
u32 TOCEntriesCount @0x08;
u32 TOCEndOffset @0x0C;

struct BallCounts {
    u32 Balls;
    u32 Credits;
};

struct StageEvent {
    const u32 Start = $;
    u32 Parameter;
    char EventLabel[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    if (EventLabel == "GAME_EVENT") {
        u32 UnknownData[2];
        BallCounts BallCounts[3];
    } else
    u8 UnknownData[0x20];
};

struct Subentry {
    if (parent.EntryLabel == "DRAWD") {
        float DrawDistance;
        bool Mirror;
    } else if (parent.EntryLabel == "EVENT") {
        StageEvent StageEvent;
    }
    else
    u8 Section[parent.SubentrySize];
};

struct Entry {
    char EntryLabel[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 16 == 0) || ($ % 8 != 0)))]; // TOC label
    padding[while(std::mem::read_unsigned($, 1) == 0x0 && ($ % 8 != 0))];
    u16 SubentryCount;
    u16 SubentrySize;
    u32 SubentryOffset;
    Subentry Data[SubentryCount] @ SubentryOffset;
    hex::core::add_virtual_file(EntryLabel, Data);
};

Entry TOC[TOCEntriesCount] @0x10;
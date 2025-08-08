#include <std/mem>
#include <hex/core>

char Magic[8] @ 0x00;
u32 TOCEntriesCount @0x08;
u32 TOCEndOffset @0x0C;

enum FMVType : u32 {
    LowRes = 0x02,
    HiRes
};

enum FontTypes : u32 {
    Invisible,
    CenterRegular = 0x04,
    Jackpot,
    SuperJackpot,
    WonderfulBackdrop = 0x08,
    WonderfulText,
    TotalLaneCounts,
    TotalBumperCounts,
    Bonus,
    ComboTopLeft,
    LaneCountsCenter,
    TimerTopRight,
    CenterAnimated,
    AllFlamingoes,
    ZeroGravity,
    ComboBonusPoints
};

struct BallName {
    const u32 Start = $;
    char Ball1[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    char Ball2[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x40)];
};
struct NameGeneric {
    const u32 Start = $;
    char Filename[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
};

struct IpuName {
    const u32 Start = $;
    char PssFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    char LP4File[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x40)];
    FMVType FMVType;
    u32 Unknown[3];
    bool WhiteBackground;
    padding[3];
};

struct IntName {
    const u32 Start = $;
    char SvagFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    char StsFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x40)];
};

struct SeqName {
    const u32 Start = $;
    char HeaderFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    u32 Index;
};

struct VabName {
    const u32 Start = $;
    char HeaderFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    char BankFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x40)];
    u32 Index;
};

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
        bool DisableIntro @ $ + 0x84;
        u32 UnknownData[2];
        BallCounts BallCounts[3];
    } else if (EventLabel == "FONT") {
        padding[4];
        FontTypes FontType;
        u32 MessageIdx;
        FontTypes FontSecondary;
        u32 SecondaryMessageIdx;
        padding[0xC];
    } else if (EventLabel == "FONT_EVENT") {
        padding[4];
        bool FontEnable;
        padding[3];
        FontTypes FontType;
        u32 MessageIdx;
        u32 Duration;
        u32 EntranceAnimationId;
        u32 ExitAnimationId;
        padding[0x4];
    } else
    u8 UnknownData[0x20];
};

struct Subentry {
    if (parent.EntryLabel == "DRAWD") {
        float DrawDistance;
        bool Mirror;
    } else if (parent.EntryLabel == "EVENT") {
        StageEvent StageEvent;
    } else if (parent.EntryLabel == "VABN") {
        VabName VabName;
    } else if (parent.EntryLabel == "SEQN") {
        SeqName SeqName;
    } else if (parent.EntryLabel == "INTN") {
        IntName IntName;
    } else if (parent.EntryLabel == "IPUN") {
        IpuName IpuName;
    } else if (parent.EntryLabel == "BALLN") {
        BallName BallName;
    } else if (parent.EntryLabel == "SKYN") {
        NameGeneric SkyName;
    } else if (parent.EntryLabel == "CAMN") {
        NameGeneric Camera;
    } else if (parent.EntryLabel == "LIGHTN") {
        NameGeneric Light;
    } else if (parent.EntryLabel == "PATHN") {
        NameGeneric Path;
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
};

Entry TOC[TOCEntriesCount] @0x10;
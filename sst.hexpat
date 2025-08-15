#include <std/mem>
#include <std/string>
#include <hex/core>

char Magic[8] @ 0x00;
u32 TOCEntriesCount @0x08;
u32 TOCEndOffset @0x0C;

// LowRes - supports alpha channel, but is lower resolution and not interlaced
// HiRes - does NOT support alpha, but higher resolution with interlacing
enum FMVType : u32 {
    LowRes = 0x02,
    HiRes
};

// when you change controls in extra menu, the game essentially swaps these in memory
enum ControllerButtons : s8 {
    Disabled = 0xFF,
    L2 = 0x0,
    R2,
    L1,
    R1,
    Triangle,
    Circle,
    Cross,
    Square, // not idea, but maybe 0x8 = Select?, 0xB = Start?, these won't work anyway, since they're reserved for stage status and pause menu
    L3 = 0x9,
    R3,
    DPadUp = 0xC,
    DPadRight,
    DPadDown,
    DPadLeft
};

// somewhat useless, since it's different for each stage
// reference FONTN for indicies
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

// IPU = video clips
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

// INT = voice clips
struct IntName {
    const u32 Start = $;
    char SvagFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    char StsFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x40)];
};

// SEQ = background music sequences (or mission start sounds)
struct SeqName {
    const u32 Start = $;
    char HeaderFile[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    u32 Index;
};

// VAB = sound banks for music sequences/sound effects
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

enum GameEvent : u32 {
    Timer = 0x04,
    Respawn = 0x06,
    Mission = 0x08
};

enum SequenceEvent : u32 {
    VideoEvent,
    FreezeAndPlaySound,
    SfxEvent,
    BgmEvent = 0x04,
    MuteEvent,
    ResetBgm,
    ScreenFade = 0x07,
    CameraSequence = 0x09,
    WonderfulSequence = 0x0D,
    GuideSfxEvent
};

// Completed is the same as StartedCompleted
enum MissionStatus : u32 {
    Incomplete,
    Started,
    Completed,
    StartedCompleted
};

enum TextEvent : u32 {
    BonusPoints
};

enum BallMode : u32 {
    PlungerLaunch = 0x08,
    Normal = 0x0C,
    Standing = 0x0F,
    Locked = 0x10,
};

enum GimmickTypes : u8 {
    Gate = 0x20,
    BlueCoin = 0x23,
    BallSavingBumper = 0x25,
    Flipper = 0x30,
    Paddle = 0x33,
    PaddleB = 0x36,
    Block,
    Bumper = 0x42,
    Key = 0x4D,
    
    BlueTarget = 0x5B,
    BumperB = 0x63,
    DeathLaser = 0x67,
    ColoredRing,
    MissionMarker = 0x82,
    Outhole = 0x84,
    StaticPlunger = 0x86,
    RingPlunger = 0x87,
    YellowCoin = 0x8C,
    RingPlungerB,
    ReverseStaticPlunger = 0x92,
    Lane = 0xC8,
    Arrow = 0xCE
};

// When you're near certain objects on the stage, you see light
// specular effects (e.g. edges of mission plates in optics)
struct SpecularLevels {
    float SpecularIntensity[12];
};

struct GimmickFlipper {
    s32 Reserved;
    padding[0x18];
    float Bounciness;
    padding[0x24];
    float FlipperStrength;
    padding[8];
};

struct GimmickBumper {
    s32 Reserved;
    padding[0x18];
    float Bounciness;
    float UnknownPhysicsValue;
    float Friction;
    padding[0x28];
};

struct GimmickGeneric {
    bool NoSpawn;
    padding[1];
    bool Invisible;
    padding[1];
    s32 Reserved;
    padding[0x2C];
    s32 SoundEffect;
    padding[0xC];
    ControllerButtons Button;
    s8 AnalogRange;
    padding[2];
};

struct EffName {
    NameGeneric Name;
    u8 UnknownData[8];
};

// Interactable element (flippers, slingshots, bumpers, etc.)
struct Gimmick {
    const u32 Start = $;
    $ += 0x28;
    GimmickGeneric General;
    $ -= 0x70;
    char GimmickLabel[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    GimmickTypes GimmickType;
    padding[15];
    match (GimmickType) {
        (GimmickTypes::Flipper): GimmickFlipper Flipper;
        (GimmickTypes::Bumper): GimmickBumper Bumper;
        (GimmickTypes::BumperB): GimmickBumper Bumper;
        (_): padding[0x50];
    }
};

// Event system
struct StageEvent {
    const u32 Start = $;
    u32 EventMagic;
    char EventLabel[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    if (EventLabel == "START") {
        padding[0x20];
    } else if ((EventLabel == "GAME_EVENT") && (EventMagic == 0x09)) {
        padding[4];
        bool RespawnBalls;
        padding[3];
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
    } else if (EventLabel == "" && EventMagic == 0x9) {
        padding[4];
        GameEvent EventType;
        if (EventType == 0x08) {
            s32 MissionId;
            MissionStatus StatusFlag;
        } else if (EventType == 0x06) {
            s32 SpawnId;
            padding[4];
        } else {
            u32 UnknownId;
            u32 UnknownValue;
        }
        padding[0x10];
    } else if (EventLabel == "" && EventMagic == 0xE) {
        padding[4];
        SequenceEvent EventType;
        if (EventType == 0x04) {
            s32 SequenceId;
            padding[4];
        } else if (EventType == 0x07) {
            bool FadeOut;
            padding[3];
            s32 NumTicks;
        }  else if (EventType == 0x09) {
            s32 CameraId;
            padding[4];
        } else if (EventType == 0x0D) {
            bool DisplayText;
            padding[7];
        } else if ((EventType == 0x01) || (EventType == 0x02) || (EventType == 0x0E)) {
            s32 SoundId;
            padding[4];
        }  else if (EventType == 0x0) {
            s32 FmvId;
            bool Randomize;
            padding[3];
            s32 RandomizerSeed;
            $ = $ - 4;
        } else {
            padding[8];
        }
        padding[0x10];
    } else if (EventLabel == "" && EventMagic == 0xC) {
        padding[4];
        u32 EventType;
        if (EventType == 0x02) {
            u32 BallId;
            BallMode BallMode;
        } else {
            u32 GenericId;
            u32 GenericValue;
        }
        padding[0x10];
    } else if (EventLabel == "" && EventMagic == 0xA) {
        padding[4];
        TextEvent EventType;
        if (EventType == 0x00) {
            s32 PointsIncrement;
            s32 Font;
            s32 MsgId;
            padding[0xC];
        } else {
            padding[0x18];
        }
    } else if (EventLabel == "" && EventMagic == 0x8) {
        $ -= 0x20;
        s32 EndEvent;
        $ += 0x1C;
        padding[0x20] [[comment("End of event section")]];
    }
    else
    u8 UnknownData[0x20];
};

// Definitions for SST element
struct Subentry {
    if (parent.EntryLabel == "DRAWD") {
        float DrawDistance;
        bool Mirror;
    } else if (parent.EntryLabel == "EVENT") {
        StageEvent StageEvent;
    } else if (parent.EntryLabel == "VABN") {
        VabName VabName;
    } else if (parent.EntryLabel == "EFFN") {
        EffName EffName;
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
    } else if (parent.EntryLabel == "PLIGHT") {
        SpecularLevels SpecularLevels;
    } else if (std::string::substr(parent.EntryLabel, 0, 3) == "GMK") {
        Gimmick Gimmick;
    }
    else
    u8 Section[parent.SubentrySize]; // not reverse engineered
};

// Table of Contents
struct Entry {
    char EntryLabel[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 16 == 0) || ($ % 8 != 0)))]; // TOC label
    padding[while(std::mem::read_unsigned($, 1) == 0x0 && ($ % 8 != 0))];
    u16 SubentryCount;
    u16 SubentrySize;
    u32 SubentryOffset;
    Subentry Data[SubentryCount] @ SubentryOffset;
};

Entry TOC[TOCEntriesCount] @0x10;
#include <std/mem>
#include <std/string>
#include <hex/core>

#pragma author MarkusMaal
#pragma description Flipnic/Stage information files
#pragma magic [ 46 70 6E 53 73 74 30 30 ] @ 0x00
#pragma endian little

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

struct BossData {
    const u32 Start = $;
    char Model[while(std::mem::read_unsigned($,1) != 0x0)];
    padding[while ($ < Start + 0x20)];
    padding[0x34];
    u32 Health;
    padding[4];
    u32 Timeout;
    padding [0xC];
    float Speed;
    float MovementAreaScale;
    padding[8];
    float OffsetX;
    padding[8];
    float FiringDistance;
    padding[8];
    float FiringRadius;
    padding [0xC];
    float Scale;
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
    SwitchArea,
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

enum BallEvent : u32 {
    ToggleControl = 0x02,
    LightRedMissionHexagon = 0x14,
    ToggleGate = 0x19
};

struct EffName {
    NameGeneric Name;
    u8 UnknownData[8];
};

enum FlashType : u32 {
    Off,
    Flashing,
    FastFlashing
};


enum GateState : u32 {
    Open,
    Spring,
    Open = 0xA,
    Blocked
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

// Examples:
// +------------+--------------------------------------------------------------------+
// | Binary/hex | Result                                                             |
// +------------+--------------------------------------------------------------------+
// | 0000b (0h) | Target on the ball, origin is static (puking simulator)            |
// | 0111b (7h) | Camera is static (uses values from FPC file)                       |
// | 0101b (5h) | Camera is static except when moving up/down (e.g. zero gravity)    |
// | 1000b (8h) | Camera is anchored to ball position (e.g. bumper area in optics)   |
// | 1011b (Bh) | Follows the ball along the X-axis (e.g. starting area in geometry) |
// +------------+--------------------------------------------------------------------+
bitfield CameraFlags {
    bool LockZAxis : 1; // if any of these are False, gets the target
    bool LockYAxis : 1; // value for specific axis from current ball
    bool LockXAxis : 1; // position instead of FPC file
    bool AnchorToTarget : 1; // if True, the origin gets anchored to ball position
    padding : 4;
};

// camera data? camera dynamics?
struct CamD {
    // should be in ascending order, if it isn't, the game automatically changes the order of entries
    // while loading the stage
    // every value **must** be unique, else the game crashes
    u32 Id [[color("0000c7")]];
    
    // LOD stands for level of detail, toggles whether to show low detailed version of the stage
    // around the current area (how far you can see with freecam depends on what DRAWD is set to)
    // or hide everything except the current area.
    u32 LodFlags [[color("00aa00")]];
    u32 Unk1 [[color("00aa22")]]; // maybe LOD related?
    u32 Unk2 [[color("22aa44")]];
    u32 Unk3 [[color("44aa66")]];
    padding[4];
    CameraFlags CameraProps [[color("cc00cc")]]; // see CameraFlags above
    padding[3];
    // which camera to get the values from (index of CAMN list)
    u32 CameraSource [[color("00aacc")]];
    padding[4];
    // <0.0 - flickers really fast, never resolves the target
    // =0.0 - camera instantly locks onto target on any given frame
    // >0.0 - camera moves slower towards the target (looks smoother)
    float StiffnessX [[color("990000")]];
    float StiffnessY [[color("cc3300")]];
    float StiffnessZ [[color("999900")]];
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
    } else if (EventLabel == "SMART_BALL" && EventMagic == 0x9) {
        padding[4];
        u32 EventFlag;
        u32 AreaId1;
        u32 AreaId2;
        u32 Balls;
        u8 BuzzerSoundEffectId;
        u16 Unknown; // related to buzzer sound?
        padding[1];
        u64 Unknown2; // honestly no idea
    } else if (EventLabel == "TIMER_EVENT" && EventMagic == 0x9) {
        padding[4];
        u32 TimerEventFlag;
        u32 TimerFrameCount;
        u32 GracePerioudFrameCount;
        u32 FontSource;
        u32 AnimatedFontSource;
        padding[8];
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
        } else if (EventType == 0xA) {
            s32 AreaCode;
            s32 Variation;
        } else if (EventType == 0x0D) {
            bool DisplayText;
            padding[7];
        } else if ((EventType == 0x01) || (EventType == 0x02) || (EventType == 0x0E)) {
            s32 SoundId;
            s32 BgmId;
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
        BallEvent EventType;
        if (EventType == 0x02) {
            u32 BallId;
            BallMode BallMode;
            padding[0x10];
        } else if (EventType == 0x14) {
            u32 AreaCode;
            u32 RedHexagonObjectId;
            FlashType FlashType;
            padding[0xC];
        } else {
            u32 GenericId;
            u32 GenericValue;
            if (GenericValue == 0xA) {
                $ -= 12;
                u32 AreaId;
                u32 GateId;
                u32 EventMagic;
                GateState GateState;
                $ += 12;
            } else {
                padding[0x10];
            }
        }
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
    } else if (EventMagic == 0x6) {
        if (EventLabel == "POINT") {
            padding[4];
            u32 BonusPoints[7];
        } else if (EventLabel == "TARGET") {
            padding[4];
            u32 BingoCheckEnable;
            u32 ObjectId;
            padding[0x14];
        } else {
            padding[4];
            u32 Flag;
            if (Flag == 0x16) {
                u32 MaybeConditionFlag;
                u32 MaybeEntranceAnimationTrigger;
                u32 AnimationId;
                padding[0xC];
            } else if (Flag == 0x15 && EventLabel == "DEATH") {
                u32 OutholeTriggerObjectId;
                padding[0x14];
            } else {
                padding[0x18];
            }
        }
    }
    else
    u8 UnknownData[0x20];
};

struct FpbHeader {
    u32 Entries;
    u32 FirstEntryOffset;
    u32 TOCLength;
};

struct FpbTOCEntry {
    u32 Length;
    u32 Offset;
    u32 Size;
    char Label[Length - 0xC];
    u8 UnknownData[Size] @ parent.Start + Offset;
};

// Definitions for SST element
struct Subentry {
    if (parent.EntryLabel == "DRAWD") {
        float DrawDistance;
        bool Mirror;
    } else if (parent.EntryLabel == "EVENT") {
        StageEvent StageEvent;
    } else if (parent.EntryLabel == "BOSS_CAS") {
        BossData BossData;
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
    } else if (parent.EntryLabel == "CAMD") {
        CamD CameraData;
    } else if (parent.EntryLabel == "LIGHTN") {
        NameGeneric Light;
    } else if (parent.EntryLabel == "PATHN") {
        NameGeneric Path;
    } else if (parent.EntryLabel == "PLIGHT") {
        SpecularLevels SpecularLevels;
    } else if (parent.EntryLabel == "BALLD") {
        float Gravity;
        padding[0x1C];
    } else if (parent.EntryLabel == "FLIESFPB") {
        // animation related data for the stick figure in Zero Gravity mission
        // will t-pose if you remove this section
        u32 Start = $;
        char Magic[3];
        padding[0xD];
        FpbHeader Header;
        FpbTOCEntry Entries[Header.Entries] @ Start + Header.FirstEntryOffset;
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
#include <std/mem>

u64 Magic @ 0x00;
u32 SecondaryCRC32 @ 0x08;
u32 PrimaryCRC32 @ 0x0C;
u32 Score @ 0x28;
u32 Combos @ 0x34;
u32 OriginalGameStage @ 0x10C8;
u32 Footer @ 0x277C;

enum Control : u8 {
    L2,
    R2,
    L1,
    R1,
    Triangle,
    Circle,
    Cross,
    Square,
    DPadUp = 0x0C,
    DPadRight,
    DPadDown,
    DPadLeft
};

enum Mission : u32 {
    UNDEFINED,
    ZERO_GRAVITY = 0x4f,
    MULTIBALL_1,
    MULTIBALL_2,
    MULTIBALL_3,
    LANE_COUNTS_MISSION_1,
    LANE_COUNTS_MISSION_2,
    LANE_COUNTS_MISSION_3,
    TOTAL_LANE__COUNTS,
    TOTAL_BUMPER_COUNTS,
    EXTRA_BALL,
    EXTRA_CREDIT,
    FREEZE_OVER,
    HIDDEN_PATH_DISCOVERY,
    CIRCLE_OF_LIFE,
    BUMPER_VILLAGE,
    PERFECT_BUMPER_VILLAGE,
    LUCKY_FLAMINGOS,
    HUNGRY_MONKEY,
    COLOR_PUZZLE,
    MONEY_MONEY_MONEY,
    UFO_QUIZ_SHOW,
    MOVE_ON_1,
    MOVE_ON_2,
    SPIDER_CRAB_SHOOT_DOWN,
    STOP_THE_FOUR_SHAFTS_1,
    STOP_THE_FOUR_SHAFTS_2,
    UFO_SHOOT_DOWN,
    CRAB_BABY_SHOOT_DOWN,
    POINT_OF_NO_RETURN_1,
    POINT_OF_NO_RETURN_2,
    POINT_OF_NO_RETURN_3,
    LOOP_THE_LOOP_1,
    LOOP_THE_LOOP_2,
    LOOP_THE_LOOP_3,
    CHU_CHU_MULTIBALL,
    SPACE_WARP,
    ALIEN_HILL,
    AREA_74,
    GALAXY_TENNIS,
    ONE_HUNDRED_BLOCKS,
    WARM_COLORED_BLOCKS
};

enum MissionType : u16 {
    Yellow,
    Red
};

enum Directory : u32 {
    JUNGLE1,
    ISEKI1,
    BOSS1,
    RETRO1,
    HIKARI1,
    DEMO1,
    JUNGLE2,
    ISEKI2,
    HIKARI2,
    VS1,
    VS2,
    VS3,
    VS4,
    BOSS2,
    BOSS3,
    BOSS4
};

enum MissionStatus : u8 {
    NotCompleted,
    Started,
    Completed = 0x02 ... 0x03
};

struct StageMap {
    Directory BiologyA;
    Directory EvolutionA;
    Directory MetallurgyA;
    Directory EvolutionB;
    Directory OpticsA;
    Directory EvolutionC;
    Directory BiologyB;
    Directory MetallurgyB;
    Directory OpticsB;
    Directory GeometryA;
    Directory EvolutionD;
};

enum SoundMode : u8 {
    Mono,
    Stereo
};

enum StageCompletion : u8 {
    NotCompleted,
    Started,
    Completed = 0x03
};

enum Difficulty : u32 {
    Easy,
    Normal,
    Hard
};

struct String {
    const u32 start = $;
    char Initials[while(std::mem::read_unsigned($, 1) != 0x0 && ($ < start + 0x20))];
    padding[while($ < start + 0x20)];
};

struct ScoreRow {
    u32 Score;
    padding[4];
    Difficulty Difficulty;
    u32 Combos;
    String InitialsArea;
    padding[4];
    u32 DefaultScore;
};

struct ScoreBoard {
    ScoreRow Rank[5];
};

struct Ranking {
    ScoreBoard OriginalGame;
    ScoreBoard BiologyA;
    ScoreBoard MetallurgyA;
    ScoreBoard OpticsA;
    ScoreBoard BiologyB;
    ScoreBoard MetallurgyB;
    ScoreBoard OpticsB;
    ScoreBoard GeometryA;
    ScoreBoard BiologyATimeAttack;
    ScoreBoard MetallurgyATimeAttack;
    ScoreBoard OpticsATimeAttack;
    ScoreBoard BiologyBTimeAttack;
    ScoreBoard MetallurgyBTimeAttack;
    ScoreBoard OpticsBTimeAttack;
    ScoreBoard GeometryATimeAttack;
};

struct MissionMap {
    Mission BiologyA[0x20];
    Mission EvolutionA[0x20];
    Mission MetallurgyA[0x20];
    Mission EvolutionB[0x20];
    Mission OpticsA[0x20];
    Mission EvolutionC[0x20];
    Mission BiologyB[0x20];
    Mission MetallurgyB[0x20];
    Mission OpticsB[0x20];
    Mission GeometryA[0x20];
    Mission EvolutionD[0x20];
};

struct StageBool {
    StageCompletion BiologyA;
    StageCompletion EvolutionA;
    StageCompletion MetallurgyA;
    StageCompletion EvolutionB;
    StageCompletion OpticsA;
    StageCompletion EvolutionC;
    StageCompletion BiologyB;
    StageCompletion MetallurgyB;
    StageCompletion OpticsB;
    StageCompletion GeometryA;
    StageCompletion EvolutionD;
};

struct MissionTypes {
    MissionType Color[0x20];
};

struct StageProgression {
    MissionStatus Completion[0x20];
};

struct Subpages {
    u8 MissionSubpageCount[0x20];
};

struct HelpIndicies {
    u8 MissionImageIndex[0x20];
};

Difficulty Difficulty @ 0x30;
SoundMode SoundMode @ 0x10;
s8 SFXVolume @ 0x11;
s8 BGMVolume @ 0x12;
bool DisableVibration @ 0x13;

Control LeftNudge @ 0x16;
Control RightNudge @ 0x17;
Control LeftFlipper @ 0x23;
Control RightFlipper @ 0x19;

StageBool OriginalUnlocks @ 0x274C;
StageBool FreeplayUnlocks @ 0x275C;
StageBool LastPlayedStage @ 0x276C;

u32 MissionRows[11] @ 0x110C;

Ranking Ranking @ 0x60;
StageMap Stages @ 0x10CC;
MissionMap MissionNames @ 0x114C;

MissionTypes MissionTypes[11] @ 0x194C;
StageProgression StageStatusOriginalGame[11] @ 0x214C;
StageProgression StageStatusFreeplay[11] @ 0x234C;
StageProgression StageStatusCurrent[11] @ 0x254C;
Subpages MissionSubpages[11] @ 0x1F4C;
HelpIndicies MissionImageIndicies[11] @ 0x1D4C;
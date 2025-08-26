#pragma author MarkusMaal
#pragma description Flipnic/Vibration data
#pragma endian little


s32 SectionsCount @ 0x00;


struct Value {
    s32 GimmickId;
    float Strength;
    padding[8];
};

struct Section {
    s32 ValueCount;
    s32 FlagCount;
    s32 Unknown;
    padding[4];
    Value Values[ValueCount+FlagCount];
};

Section Sections[SectionsCount] @ 0x10;
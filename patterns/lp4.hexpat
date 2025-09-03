#include <std/mem>

u32 MagicOffset = std::mem::size() - 0x30;

#pragma author MarkusMaal
#pragma description Flipnic/LP4 files
#pragma magic [ 00 00 00 00 83 74 83 40 83 43 83 8B 83 49 81 5B 83 76 83 93 82 C9 8E B8 94 73 82 B5 82 DC 82 B5 ] @ std::mem::size() - 0x30
#pragma endian little



struct AdditionalData {
    float X;
    float Y;
    float Z;
    float W;
};

struct Vec4 {
    float X;
    float Y;
    float Z;
    float W;
} [[single_color]];



struct LayoutSubheader {
    s32 pos = $;
    char EntryLabel[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 32 == 0) || ($ % 64 != 0)))];
    $ = pos;
    padding[0x20];
};

struct LayoutHeader {
    s32 Count;
    s32 Unknown;
    padding[8];
    LayoutSubheader Subheader;
};

struct Triplet {
    float X1;
    float Y1;
    float Z1;
    float W1;
    float X2;
    float Y2;
    float Z2;
    float W2;
    float X3;
    float Y3;
    float Z3;
    float W3;
} [[single_color]];

struct LayoutEntry {
    s32 KeyframeCount;
    bool IsAnimated;
    padding[0x1b];
    s32 TestVariable;
    padding[4];
    s32 AdditionalDataLength;
    $ -= 0x1C;
    padding[0x20];
    float SizeX;
    float SkewY;
    float SkewZ;
    padding[8];
    float SizeY;
    padding[8];
    float SkewX;
    padding[4];
    float SizeZ;
    float SkewCorrection;
    float PositionX;
    float PositionY;
    float PositionZ;
    float ForceCorrection;
    padding[0x10];
    if (AdditionalDataLength < 32768) {
        AdditionalData AdditionalData[AdditionalDataLength];
    }
    Triplet Keyframes[KeyframeCount];
    Vec4 AdditionalData2[KeyframeCount];
};

struct DataEntry {
    padding[4];
    s32 SectionCount;
    padding[8];
    LayoutHeader Header;
    LayoutEntry Entries[SectionCount];
};

enum FileType: u32 {
    VariableList,
    StaticModel,
    AnimatedModel,
    Particle,
    TextAnimation = 0x16
};

struct AdditionalParams {
    u32 p1;
    u32 p2;
    u32 p3;
    u32 p4;
};


struct NextSection {
    u32 TestVariable1 [[hidden]];
    u32 TestVariable2 [[hidden]];
    $ -= 8;
    if ((TestVariable1 == 0) && (TestVariable2 == 0)) {
        Vec4 SectionFooter[8];
        NextSection Ns;
    } else if ((TestVariable1 == TestVariable2) && (TestVariable1 == 1)) {
        padding[0x20];
        s32 KeyframeCount;
        padding[0xC];
        Vec4 Keyframes[KeyframeCount];
    } else if ((TestVariable1 == 0) && (TestVariable2 == 1)) {
        DataEntry Data;
    }
};

struct Body {
    if (parent.hasEmbeddedResources) {
        Vec4 LightMap[8];
    }
    DataEntry DataStart;
    NextSection Next[parent.modelCount];
    //LayoutHeader Header;
};

struct Header {
    u32 modelCount;
    FileType FileType;
    padding[4];
    u32 additionalParamCount;
    padding[1];
    bool hasEmbeddedResources;
    padding[1];
    bool is2dAnimation;
    float reserved;
    padding[8];
    AdditionalParams additionalParams[additionalParamCount];
    Body Body;
};

struct Sect {
    u8 SectionData[0x2B0];
} [[same_color]];


Header Header @ 0x00;
u8 Magic[0x1c] @ MagicOffset+4;
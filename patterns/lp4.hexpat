#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/LP4 files
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

struct VecHf4 {
    s16 X;
    s16 Y;
    s16 Z;
    padding[2];
} [[single_color]];

struct TextureCoordinate {
    s16 X [[color("aa0000")]]; // half float
    s16 Y [[color("0000aa")]]; // half float
    s16 Divider [[color("00aa00")]];
    s16 Unknown [[color("aa00aa")]];
};


struct NextSection {
    u32 TestVariable1 [[hidden]];
    u32 TestVariable2 [[hidden]];
    u32 TestVariable3 @ $ + 0x1C [[hidden]];
    $ -= 8;
    if ((TestVariable1 == 0) && (TestVariable2 == 0)) {
        Vec4 SectionFooter[8];
        NextSection Ns;
    } else if ((TestVariable1 == TestVariable2) && (TestVariable1 == 1)) {
        u32 AdditionalPointsCount @ $ + 0x18;
        padding[0x20];
        Vec4 AdditionalPoints[AdditionalPointsCount];
        s32 KeyframeOrPointsCount;
        s32 NormalCount;
        padding[4];
        s32 TextureUVCount;
        Vec4 Keyframes[KeyframeOrPointsCount];
        VecHf4 Normals[NormalCount];
        TextureCoordinate TextureUVs[TextureUVCount];
        padding[0xB0];
    } else if ((TestVariable1 == 0) && (TestVariable2 == 1)) {
        DataEntry Data;
    } else {
        Vec4 UnknownPoints[8];
    }
};

struct Body {
    DataEntry DataStart;
    NextSection Next[ModelCount];
};

struct Header {
    u32 modelCount;
    FileType FileType;
    padding[4];
    u32 additionalParamCount;
    padding[1];
    bool HasEmbeddedResources;
    padding[1];
    bool is2dAnimation;
    float reserved;
    padding[8];
    AdditionalParams additionalParams[additionalParamCount];
    u32 EndHeader = $;
    bool HasBoundingBox = HasEmbeddedResources;
};

struct Sect {
    u8 SectionData[0x2B0];
} [[same_color]];

struct BoundingBox {
    Vec4 BoundingBox[8];
};


Header Header @ 0x00;
BoundingBox BoundingBox[Header.HasBoundingBox] @ Header.EndHeader;
u32 ModelCount = Header.modelCount;
Body Body[while(!std::mem::eof())] @ $;
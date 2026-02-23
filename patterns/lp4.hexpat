#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/LP4 files
#pragma endian little



struct LightData {
    float R [[color("a00000")]];
    float G [[color("00a000")]];
    float B [[color("0000a0")]];
    float A;
};


struct JointDefinition {
    s32 pos = $;
    char EntryLabel[while(std::mem::read_unsigned($, 1) != 0x0)];
    $ = pos+0x20;
    
    float SkewX1;
    float SkewY1;
    float SkewZ1;
    padding[4];
    float SkewX2;
    float SkewY2;
    float SkewZ2;
    padding[4];
    float SkewX3;
    float SkewY3;
    float SkewZ3;
    float SkewCorrection;
    float PositionX;
    float PositionY;
    float PositionZ;
    float ForceCorrection;
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
    padding[0xb];
    padding[4];
    s32 JointCount;
    padding[8];
    bool HasLightmapData;
    padding[7];
    s32 AdditionalDataLength;
    $ -= 0x1C;
    padding[0x20];
    float SkewX1;
    float SkewY1;
    float SkewZ1;
    padding[4];
    float SkewX2;
    float SkewY2;
    float SkewZ2;
    padding[4];
    float SkewX3;
    float SkewY3;
    float SkewZ3;
    float SkewCorrection;
    float PositionX;
    float PositionY;
    float PositionZ;
    float ForceCorrection;
    padding[0x10];
    JointDefinition Joints[JointCount];
    LightData Lights[HasLightmapData ? AdditionalDataLength : 0];
    //Triplet Keyframes[KeyframeCount];
    //Vec4 AdditionalData2[KeyframeCount];
};

struct DataEntry {
    padding[4];
    s32 SectionCount;
    padding[8];
    LayoutHeader Header;
    //LayoutEntry Entries[SectionCount];
};

enum FileType: u32 {
    VariableList,
    StaticModel,
    AnimatedModel,
    Particle,
    TextAnimation = 0x16
};

struct AdditionalParams {
    u32 FrameCountA;
    u32 FrameCountB;
    u32 Unknown; // crazy glitching when the value is incorrect
    bool LoopingEnable;
    padding[3];
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
    
    // These allow some 3D-models to take up way less space
    // by having the next point be connected to 1 or 2 previous
    // points instead of repeating their coordinates (a poor man's
    // run length encoding sort of).
    s16 VertexFlags [[color("aa00aa")]];
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
        s32 UnknownCount;
        s32 TextureUVCount;
        Vec4 Keyframes[KeyframeOrPointsCount];
        VecHf4 Normals[NormalCount];
        TextureCoordinate TextureUVs[TextureUVCount];
        float Unknown[UnknownCount];
        padding[0x80];
        s8 TextureSection[0x30];
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
    u32 TimelineCount;
    padding[1];
    bool HasEmbeddedResources;
    padding[1];
    bool is2dAnimation;
    float reserved;
    padding[8];
    AdditionalParams additionalParams[TimelineCount];
    u32 EndHeader = $;
    bool HasBoundingBox = HasEmbeddedResources;
};

struct Sect {
    u8 SectionData[0x2B0];
} [[same_color]];

struct BoundingBox {
    Vec4 BoundingBox[8];
};

struct ModelContentHeader {
    u32 MaterialCount;
    u32 TestVariable;
    padding[0x10];
    s32 AnimationIndiciesCount = 0;
    s32 AnimationMorphsCount = 0;
    s32 AdditionalDataCount = 0;
    bool AddPaddingData = true;
    if ((MaterialCount > 0) && (TestVariable == 1)) {
        s32 AdDataCount;
        AdditionalDataCount = AdDataCount;
        s32 AnimIndiciesCount;
        AnimationIndiciesCount = AnimIndiciesCount;
        if ((AdditionalDataCount == 0) && (AnimationIndiciesCount == 0)) {
            AddPaddingData = false;
        } else {
            s32 AnimMorphsCount;
            AnimationMorphsCount = AnimMorphsCount;
        }
    }
    if (AddPaddingData) padding[0xC];
};

struct AnimationIndex {
    u32 Index;
    float UnknownFloat;
    padding[8];
};

struct AnimationIndices {
    s32 pos = $;
    char JointName[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 32 == 0) || ($ % 64 != 0)))];
    $ = pos + 0x20;
    u32 EntriesCount;
    padding[0xC];
    AnimationIndex Index[EntriesCount];
};

struct Geometry {
    u32 VertexCount;
    u32 NormalCount;
    u32 UnknownParamsCount;
    u32 UvCount;
    Vec4 Vertices[VertexCount];
    VecHf4 Normals[NormalCount];
    u32 UnknownParam[UnknownParamsCount];
    TextureCoordinate UVs[UvCount];
};

struct Material {
    s32 pos = $;
    char Label[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 32 == 0) || ($ % 64 != 0)))];
    $ = pos + 0x20;
    padding[0x60];
    pos = $;
    char TextureFile[while(std::mem::read_unsigned($, 1) != 0x0 && (($ % 32 == 0) || ($ % 64 != 0)))];
    $ = pos + 0x20;
    padding[0x10];
};


Header Header @ 0x00;
BoundingBox BoundingBox[Header.HasBoundingBox] @ Header.EndHeader;
u32 ModelCount = Header.modelCount;
u32 LCount @ 0x24 + (Header.HasBoundingBox ? 0x80 : 0) + Header.TimelineCount * 0x10;
$ += 4;
bool HasHitbox @ $;
$ += 3;
LayoutHeader LHeader @ $;
LayoutEntry LEntry[LCount] @ $;
Vec4 Hitbox[HasHitbox ? 8 : 0] @ $;
ModelContentHeader ContentHeader @ $;
AnimationIndices AnimationIndicies[ContentHeader.AnimationIndiciesCount] @ $;
Vec4 ExtraVertices[(ContentHeader.AdditionalDataCount > 0) ? ContentHeader.AdditionalDataCount - 1 : 0] @ $;
Geometry ModelGeometry[ContentHeader.MaterialCount > 0 ? 1 : 0] @ $;
Material ModelMaterials[ContentHeader.MaterialCount] @ $;
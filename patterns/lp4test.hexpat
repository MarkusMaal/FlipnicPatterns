#include <std/mem>

u32 MagicOffset = std::mem::size() - 0x30;

#pragma author MarkusMaal
#pragma description Flipnic/LP4 files (experimental)
#pragma endian little


enum FileType: u32 {
    VariableList,
    StaticModel,
    AnimatedModel,
    Particle,
    TextAnimation = 0x16
};
struct Header {
    u32 modelCount;
    FileType FileType;
    u32 additionalDataLength;
    u32 additionalParamCount;
    padding[1];
    bool hasEmbeddedResources;
    padding[1];
    bool is2dAnimation;
    float reserved;
    padding[0x8];
};

struct Vec4 {
    float X;
    float Y;
    float Z;
    float W;
} [[single_color]];

struct AnimationJointDefinition {
    char Label[0x14];
    padding[0x3C];
    Vec4 UnknownFloats;
};

struct Model {
   padding[4];
   u32 AttributeSetCount;
   padding[4];
   u32 ExtraUnknownDataCount;
   padding[0x10];
   char Label[0x1C];
   padding[0x18];
   u32 AnimationJoints;
   padding[0x18];
   float ScaleX;
   padding[0x10];
   float ScaleY;
   padding[0x10];
   float ScaleZ;
   padding[4];
   float OffsetX;
   float OffsetY;
   float OffsetZ;
   padding[0x14];
   AnimationJointDefinition JointDefintions[AnimationJoints];
};

Header Header @ 0x00;
Vec4 AdditionalHeaderData[8] @ 0x50;
u32 FirstEntryOffset = 0xA0 + Header.additionalDataLength * 0x10;
Model FirstModel @ FirstEntryOffset;
u8 Magic[0x1c] @ MagicOffset+4;
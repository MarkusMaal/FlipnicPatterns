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

struct Vec4 {
    float X;
    float Y;
    float Z;
    float W;
};

struct Header {
    u32 modelCount;
    FileType FileType;
    u32 additionalParamCount[2];
    padding[1];
    bool hasEmbeddedResources;
    padding[1];
    bool is2dAnimation;
    float reserved;
    padding[8];
    AdditionalParams additionalParams[additionalParamCount[0]];
    if (hasEmbeddedResources) {
        Vec4 LightMap[8];
    }
};

Header Header @ 0x00;
// Created based on information found at
// https://www.ps2savetools.com/ps2icon-0.5.pdf

#include <std/mem>

struct FrameKey {
    float Time;
    float Value;
};

struct FrameData {
   u32 ShapeID;
   u32 NumKeys;
   FrameKey Keys[NumKeys];
};

struct Animation {
    u32 ID;
    u32 FrameLength;
    float AnimSpeed;
    u32 PlayOffset;
    u32 Frames;
    FrameData FrameData[Frames];
};

struct TextureData {
    u16 TexX; // f16
    u16 TexY; // f16
    u32 RGBA; // f16
};

struct VertexCoordinate {
    u16 CoordX; // f16
    u16 CoordY; // f16
    u16 CoordZ; // f16
    u16 Light;
    u16 NormalCoordX; // f16
    u16 NormalCoordY; // f16
    u16 NormalCoordZ; // f16
    u16 NormalLight;
    TextureData Texture;
} [[single_color]];

struct Vertex {
    if (std::mem::read_unsigned(0x04, 4) == 1) {
        VertexCoordinate Coordinate;   
    } else {
        VertexCoordinate Coordinate[4];
    }
};

struct TIMPixel {
    u16 PixelData;
    u8 Reserved;
};

struct Texture {
    if (std::mem::read_unsigned(0x08, 4) == 7) {
        TIMPixel Pixels[while(!std::mem::eof())];
    } else {
        u32 TextureSize;
        u16 RLECompressedData[TextureSize/2]; // Run length encoding
    }
};


u32 IconFileId @ 0;
u32 AnimationShapes @ 4;
u32 TextureType @ 8;
u32 Unknown @ 12;
u32 VertexCount @ 16;
Vertex Verticies[VertexCount] @ 20;
Animation IconAnimation @ $;
Texture Texture @ $;
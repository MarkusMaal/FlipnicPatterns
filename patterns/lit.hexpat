#pragma author MarkusMaal
#pragma description Flipnic/Environment lighting
#pragma magic [ FF FF FF FF 00 00 00 00 00 00 00 00 00 00 00 00 ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 00 00 00 00 ] @ 0x00
#pragma endian little

struct ColorIntensity {
    float R [[color("aa0000")]];
    float G [[color("00aa00")]];
    float B [[color("0000aa")]];
    padding[4];
};

u32 Magic @ 0x00;
ColorIntensity ColorIntensities[7] @ 0x10;
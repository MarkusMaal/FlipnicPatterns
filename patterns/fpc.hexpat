#include <std/mem>
 
#pragma author MarkusMaal
#pragma description Flipnic/Camera sequences
#pragma magic [ 00 00 00 00 ?? ?? 00 00 10 00 00 00 ] @ 0x00
#pragma endian little

u8 Padding[4] @ 0;
u32 SequenceCount @ 0x4;
u32 CamDataOffset @ 0x8;
u32 TotalFrames @ 0xC;
float FOV @ 0x1C;

struct Frame {
    float Par1;
    float Par2;
    float Par3;
    float Par4;
};

struct Coordinate {
    float X;
    float Y;
    float Z;
};

Coordinate CameraOrigin @ 0x10;
Coordinate CameraTarget @ 0x20;

struct Sequence {
    try {
        u32 VariableIndex;
        u32 CameraFrames;
        u32 SectionLength;
        u32 Delimiter;
        float AnimationFrames[CameraFrames];
        padding[4*(SectionLength-CameraFrames)];
    } catch {
        // ignored
    }
};

Sequence seqs[SequenceCount] @ 0x30;
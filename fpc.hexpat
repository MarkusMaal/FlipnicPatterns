#include <std/mem>
 
u8 Padding[4] @ 0;
u32 SequenceCount @ 0x4;
u32 CamDataOffset @ 0x8;
u32 TotalFrames @ 0xC;
u32 FOV @ 0x1C;

// unsure about first couple bytes...

struct Frame {
    u32 Par1;
    u32 Par2;
    u32 Par3;
    u32 Par4;
};

struct Sequence {
    try {
        u32 Id;
        u32 CameraFrames;
        u32 SequenceFrames;
        u32 Reserved;
        const u32 Sequences = std::mem::read_unsigned(4, 4);
        Frame AnimationFrames[CameraFrames / Sequences] [[single_color]];
        Frame ControlFrames[SequenceFrames - CameraFrames] [[single_color]];
    } catch {
        // ignored
    }
};

Sequence seqs[SequenceCount] @ 0x30;
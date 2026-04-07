#include <std/mem>

#pragma author Markusmaal
#pragma description SCEI/Sony ADPCM Compressed Audio
#pragma endian little

bitfield DecodingCoefficient {
    Shift : 4;
    Predict : 4;
};

enum VagFlags : u8 {
    VagfNothing,
    VagfLoopLastBlock,
    VagfLoopRegion,
    VagfLoopEnd,
    VagfLoopFirstBlock,
    VagfUnk,
    VagfLoopStart,
    VagfPlaybackEnd
};

struct AudioBlock {
    DecodingCoefficient DecodingCoefficient;
    VagFlags LoopInformation;
    u8 Samples[14];
};

struct StereoBlock {
    AudioBlock ChannelL[0x40] [[color("000088")]];
    AudioBlock ChannelR[0x40] [[color("880088")]];
};

bool isStereo = true;

struct Blocks {
    if (isStereo) {
        StereoBlock StereoBlocks[while(!std::mem::eof())];
    } else {
        AudioBlock MonoBlocks[while(!std::mem::eof())];
    }
};

// try to identify stereo tracks by checking if data in offsets
// 0x00 - 0x20 and 0x400 - 0x420 is identical
for (u32 i = 0, i < 0x20, i += 1) {
    u8 compA = std::mem::read_unsigned(i, 1);
    u8 compB = std::mem::read_unsigned(i+0x400, 1);
    if (compA != compB) {
        isStereo = false; // different data = not stereo
        break;
    }
}
$ = 0;
Blocks Blocks @ 0;
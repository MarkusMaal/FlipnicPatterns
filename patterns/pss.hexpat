#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/Interleaved audio and video streams
#pragma magic [ 49 4E 54 00 ] @ 0x00
#pragma endian little

enum StreamType : u32 {
    End = 0x00444E45,
    Audio = 0x00544E49,
    Video = 0x00555049,
};

struct Stream {
    StreamType Type;
    if (Type == StreamType::Audio) {
        u32 StreamID;
    } else 
        padding[4];
    if (Type == StreamType::End) {
        padding[4];
        u32 Unknown;
    } else {
        u32 BufferSize;
        u32 NextBuffer;
        padding[NextBuffer];
    }
};

Stream streams[while (std::mem::read_unsigned($, 4) != 0x00444E45)] @0x00;
Stream end @ $;
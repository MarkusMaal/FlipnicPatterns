#include <std/mem>

#pragma author MarkusMaal
#pragma description Flipnic/IPU video stream
#pragma magic [ 69 70 75 6D ] @ 0x00
#pragma endian little

u16 height @ 0xA;
u16 width @ 0x8;
u32 frames @ 0xC;
u32 footer_offset @ 0x4;
u32 magic @0x0;
u32 end_code @ footer_offset+4;


bitfield IpuFlags {
    MpegType : 1;
    QScaleType : 1;
    IntraVlcFormat : 1;
    AlternateScan : 1;
    DctTypeDecode : 1;
    IntraDcPrecision : 2;
};

struct FrameData {
    u8 MpegData[while(std::mem::read_unsigned($, 4) != 0xB0010000)];
    u32 FrameDelimiter;
};

IpuFlags Flags @ 0x10;

// remove this if you don't care about frame data (reduces pattern evaluation time)
FrameData FramesData[while($ < footer_offset)] @ 0x11;
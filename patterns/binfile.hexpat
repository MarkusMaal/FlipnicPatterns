#include <std/mem>
#include <hex/core>

#pragma author MarkusMaal
#pragma description Flipnic/Virtual filesystem blobs
#pragma magic [ 2A 54 6F 70 20 4F 66 20 43 44 20 44 61 74 61 ] @ 0x00
#pragma endian little

struct Data {
    u8 Section[parent.Size * 0x800];
};

struct CdEntry {
    char Filename[while(std::mem::read_unsigned($, 1) != 0x0)];
    padding[while(std::mem::read_unsigned($, 1) == 0x0 && ($ % 0x40 != 0x3C))];
    u32 Offset;
    const u32 Size = std::mem::read_unsigned($+0x3C, 4) - Offset;
    Data Data @ Offset * 0x800;
    hex::core::add_virtual_file(Filename, Data);
} [[single_color]];

struct TOCMarker {
    char Marker[while(std::mem::read_unsigned($, 1) != 0x0)];
    padding[while(std::mem::read_unsigned($, 1) == 0x0)];
    u32 Offset;
} [[single_color]];

TOCMarker StreamStartPointer @ 0x00;
CdEntry TOC[while(std::mem::read_unsigned($, 4) != 0x646E452A)] @ 0x40;
TOCMarker StreamEndPointer @ $;

#include <std/mem>
#include <hex/core>

struct Data {
    u8 Section[parent.Size];
};

struct MemEntry {
    char Filename[while(std::mem::read_unsigned($, 1) != 0x0)];
    padding[while(std::mem::read_unsigned($, 1) == 0x0 && ($ % 0x40 != 0x3C))];
    u32 Offset;
    const u32 Size = std::mem::read_unsigned($+0x3C, 4) - Offset;
    Data Data @ Offset;
    hex::core::add_virtual_file(Filename, Data);
} [[single_color]];

struct TOCMarker {
    char Marker[while(std::mem::read_unsigned($, 1) != 0x0)];
    padding[while(std::mem::read_unsigned($, 1) == 0x0)];
    u32 Offset;
} [[single_color]];

MemEntry TOC[while(std::mem::read_unsigned($, 4) != 0x646E452A)] @ 0x00;
TOCMarker StreamEndPointer @ $;
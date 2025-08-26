// Source:
// https://openkh.dev/common/tm2.html

//
// this is not neccessarily specific to Flipnic
// because TIM2 is used for many PS2 games
//
// but some stuff may need to be changed
// if you use this pattern for other games
//

#include <type/color>

#pragma author MarkusMaal
#pragma description PlayStation 2/TIM2 textures
#pragma magic [ 54 49 4D 32 ] @ 0x00
#pragma endian little


struct MipMap {
    u32 MiptbpRegister[4];
    u32 SizeArray[8];
};


struct Colors {
    u8 red [[color("00FF0000")]];;
    u8 green [[color("0000FF00")]];
    u8 blue  [[color("000000FF")]];
    u8 alpha [[static, color(std::format("{:02X}{:02X}{:02X}", red, green, blue)), comment("Color preview")]];
};

struct Picture {
    u32 PictureSize;
    u32 PalletteClutSize;
    u32 ImageBitmapSize;
    u16 HeaderSize;
    u16 ClutColorCount;
    u8 PictureFormat;
    u8 MipmapCount;
    u8 ClutColorType;
    u8 ImageColorType;
    u16 ImageWidth;
    u16 ImageHeight;
    u64 GsTexRegister[2];
    u32 GsFlagsRegister;
    u32 GsClutRegister;
    MipMap ImageMipMap[MipmapCount - 1];
    u8 Bitmap[ImageBitmapSize];
    Colors Pallette[PalletteClutSize/4] ;
};

struct Header {
    char Magic[4];
    u8 FormatRevision;
    u8 Format;
    u16 PictureCount;
    u32 Reserved[2];
    Picture Pictures[PictureCount];
};

Header Tim2 @ 0x00;
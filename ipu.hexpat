u16 height @ 0xA;
u16 width @ 0x8;
u32 frames @ 0xC;
u32 footer_offset @ 0x4;
u32 magic @0x0;
u16 footer[4] @ footer_offset;
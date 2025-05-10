#include <std/mem>

struct Header {
    u32 HeaderSize;
    u32 BankSize;
    char Identifier[8];
    u32 StartOfInstrumentSet;
    u32 EndOfInstrumentSet;
    if (std::mem::read_unsigned($, 1) != 0xFF) {
        u32 SeparatorEnd;
        u8 Separator[SeparatorEnd-EndOfInstrumentSet] @ EndOfInstrumentSet;
    } else {
        u8 Separator[HeaderSize-EndOfInstrumentSet] @ EndOfInstrumentSet;
    }
    u8 Padding[while(std::mem::read_unsigned($, 1) == 0xFF)];
    u16 InstrumentCount @ StartOfInstrumentSet;
};
    
Header Header @ 0x00;
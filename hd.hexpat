// massive help on the Jam header format
// 


#include <std/mem>

struct ProgChunk {
    u8 CountOrFlag;
    s8 BaseVolume;
    s8 MaybePan;
    s8 field_0x03;
    s8 UnkPitchRelated_0x04;
    s8 LfoTableIndex;
    s8 StartNoteRange;
    s8 EndNoteRange;
    
};

struct Program {
    s16 Offset;
   try {
        ProgChunk ChunkData @ Offset;
    } catch {
    }
};

struct ProgramChunk {
    s16 EntryCount;
    const s16 AbsoluteEnd = (EntryCount + 1) * 2 + $;
    Program Programs[while ($ < AbsoluteEnd)];
};

struct Velocity {
   padding[2];
   u8 Velocity[128];
};




struct SevenBitVariable {
    s8 v[2];
};

struct SeProgEntry {
    try {
        u8 evType;
        s8 seProgChunkEntryUnk;
        s8 unk_A0;
        s8 seProgChunkIndex;
        SevenBitVariable var;
    } catch {
        // ignored
    }
};

struct EntryOffset {
    u16 LastIndex;
    u16 Offset;
    //SeProgEntry EntryData[LastIndex+1] @ Offset;
};
struct SeqChunk {
    u16 LastIndex;
    u16 DataOffsets[LastIndex+1];
    EntryOffset EntryOffsets[LastIndex+1];

};

struct JamHeader {
    u32 HeaderSize;
    u32 BankSize;
    padding[4];
    char Magic[4];
    u32 ProgramChunkOffset;
    u32 VelocityChunkOffset;
    u32 LfoTableChunkOffset;
    u32 SeSeqChunkOffset;
    u32 UnkChunkOffset;
    u32 SeProgChunkOffset;
    u32 ReservedOffsets[2];
    u32 ProgramChunkMemoryOffset;
    u32 VelocityChunkMemoryOffset;
    u32 LfoTableChunkMemoryOffset;
    u32 SeSeqChunkMemoryOffset;
    u32 UnkChunkMemoryOffset;
    u32 SeProgChunkMemoryOffset;
    u32 ReservedMemOffsets;
    u32 Padding[while(std::mem::read_unsigned($+4, 4) == 0xFFFFFFFF)];
    u32 LastPadding;
    Velocity Velocity @ VelocityChunkOffset;
    if (SeSeqChunkOffset < std::mem::size()) {
        SeqChunk SeSeqChunk @ SeSeqChunkOffset;
    }
    if (ProgramChunkOffset < std::mem::size()) {
        ProgramChunk Programs @ ProgramChunkOffset;
    }
};
    
JamHeader Header @ 0x00;
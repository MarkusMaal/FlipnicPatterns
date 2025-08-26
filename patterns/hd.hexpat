// massive help on the Jam header format
// https://raw.githubusercontent.com/Nenkai/GT-File-Specifications-Documentation/refs/heads/master/Formats/PS2/GT4/GT4_INST_SShd_Jam_Custom.bt

#pragma author MarkusMaal
#pragma description Flipnic/VAG audiobank header
#pragma magic [ 00 00 00 00 53 53 68 64 ] @ 0x08
#pragma endian little

struct _7bitVariable {
    u8 values[]; // In practice, keep reading until !(value & 0x80)
};


enum Flags : u8 {
    SetNoiseShiftFrequency        = 0x02,
    PitchModulateSpeedAndDepth    = 0x20,
    Reverb                        = 0x80,
};

struct JamSplitChunk {
    u8 NoteMin [[color("FF00FF")]];
    u8 NoteMax [[color("FF00FF")]];
    u8 BaseNote [[color("FF00FF")]]; // smaller values = higher pitch
    u8 Karaoke [[color("FF00FF")]];

    u8  SD_VA_SSA_hi;  // upper 8 bits
    u16 SD_VA_SSA_lo;  // lower 16 bits

    s16 SD_VP_ADSR1;
    s16 SD_VP_ADSR2;
    u8  Volume [[color("00FFFF")]];
    u8  Pan [[color("00FFFF")]];
    u8  UnkPitchRelated_0x0E;
    u8  LfoTableIndex;
    u8 Reverb;
} [[color("00007F")]];


struct SampleEntryInfo {
    u32 EntryCount;
    u32 Offset;
};

struct ProgChunk {
    u8 FlagBitAndCount [[color("FF0000")]];
    u8 BaseVolume [[color("F70000")]];
    u8 MaybePan [[color("EF0000")]];
    u8 field_0x03 [[color("E70000")]];
    u8 UnkPitchRelated_0x04  [[color("DF0000")]];
    u8 LfoTableIndex  [[color("D70000")]];
    u8 StartNoteRange  [[color("CF0000")]];
    u8 EndNoteRange  [[color("C70000")]];

    // dynamic array depending on CountOrFlag
    try {
        JamSplitChunk chunks[FlagBitAndCount+1];
    } catch {
        JamSplitChunk chunks[FlagBitAndCount+1-0x80];
    }
};

struct ProgramChunkOffset {
    u16 Offset;
    try {
        ProgChunk ProgChunk @ Offset + parent.ProgramChunkPhysicalOffset;
    } catch {}
};

struct ProgramChunk {
    s32 ProgramChunkPhysicalOffset = parent.ProgramChunkPhysicalOffset;
    u16 EntryCount;
    ProgramChunkOffset ProgramChunkOffset[EntryCount + 1];
};


struct VelocityChunk {
    u16 Empty;
    u8 Velocity[0x80];
};

struct EntryOffsets2 {
    u16 LastIndex;
    u16 Offset;
};


struct SeSeqChunk {
    u16 LastIndex;
    u16 DataOffsets[LastIndex + 1];

    EntryOffsets2 EntryOffsets2[LastIndex + 1];
};


struct SeSeqProgChunk {
    u16 MaxIndex;
    u16 EntryOffsets[MaxIndex + 1];

    u8 unk[8];
};

struct UnkUnusedMaybeChunk {
    u8 Unk;
};


struct JamHeader {
    u32 JamHeaderSize;
    u32 BdSize;
    u32 _empty_;
    char Magic[4];

    s32 ProgramChunkPhysicalOffset;
    s32 VelocityChunkPhysicalOffset;
    s32 LfoTableChunkPhysicalOffset;
    s32 SeSeqChunkPhysicalOffset;
    s32 UnkChunkPhysicalOffset;
    s32 SeProgChunkPhysicalOffset;
    s32 reserved_physoffsets[2];

    u32 ProgramChunkMemoryOffset;
    u32 VelocityChunkMemoryOffset;
    u32 LfoTableChunkMemoryOffset;
    u32 SeSeqChunkMemoryOffset;
    u32 UnkChunkMemoryOffset;
    u32 SeProgChunkMemoryOffset;
    u32 reserved_memoffsets[2];

    u32 unks[11];
    u32 LastUnk;
    if (ProgramChunkPhysicalOffset != -1) {
        ProgramChunk Programs @ ProgramChunkPhysicalOffset;
    }
    if (VelocityChunkPhysicalOffset != -1) {
        VelocityChunk VelocityChunk @ VelocityChunkPhysicalOffset;
    }
    if (SeSeqChunkPhysicalOffset != -1) {
        SeSeqChunk SeSeqChunk @ SeSeqChunkPhysicalOffset;
    }
    if (UnkChunkPhysicalOffset != -1) {
        UnkUnusedMaybeChunk UnkUnusedMaybeChunk @ UnkChunkPhysicalOffset;
    }
    if (SeProgChunkPhysicalOffset != -1) {
        SeSeqProgChunk SeSeqProgChunk @ SeProgChunkPhysicalOffset;
    }
};


JamHeader Header @ 0;
// massive help on the Jam header format
// https://raw.githubusercontent.com/Nenkai/GT-File-Specifications-Documentation/refs/heads/master/Formats/PS2/GT4/GT4_INST_SShd_Jam_Custom.bt
//
// more helpful information here as well (specifically the "VOICE HEADER (*.HD)" section)
// https://psx-spx.consoledev.net/cdromfileformats/#cdrom-file-audio-other-formats

#pragma author MarkusMaal
#pragma description Flipnic/VAB audiobank header
#pragma magic [ 00 00 00 00 53 53 68 64 ] @ 0x08
#pragma endian little

#include <std/mem>

struct _7bitVariable {
    u8 values[]; // In practice, keep reading until !(value & 0x80)
};


enum Flags : u8 {
    SetNoiseShiftFrequency        = 0x02,
    PitchModulateSpeedAndDepth    = 0x20,
    Reverb                        = 0x80,
};

bitfield JamFlags {
    bool HighPriority: 1;
    bool Noise: 1;
    padding: 2;
    bool PitchBend : 1;
    bool Modulation : 1;
    bool BreathWaveFromProg : 1;
    bool Reverb : 1;
};

struct JamSplitChunk {
    u8 NoteMin [[color("FF00FF")]];
    u8 NoteMax [[color("FF00FF")]];
    u8 BaseNote [[color("FF00FF")]]; // smaller values = higher pitch
    s8 FineTunePitch [[color("FF00FF")]];

    u16 SampleOffset [[color("00FF00")]];  // Offset of the sample divided by 8 relative to BD file (i.e. if the value here is 01 20, the offset would be 0x1008)
    u32  AttackDecaySustainRelease;        // Envelope stuff here
    u8 VolumeOverride [[color("00FFFF")]];
    u8  Volume [[color("00FFFF")]];
    u8  Pan [[color("00FFFF")]];
    u8  PitchBend;
    u8  BreathWaveIdx;
    JamFlags Flags [[color("202020")]];
} [[color("00007F")]];


struct SampleEntryInfo {
    u32 EntryCount;
    u32 Offset;
};

struct ProgChunk {
    u8 FlagBitAndCount [[color("FF0000")]];
    u8 BaseVolume [[color("F70000")]];
    u8 MaybePan [[color("EF0000")]];
    padding[1];
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


struct SeProgChunk {
    u8 FlagBitAndCount [[color("FF0000")]];
    u8 BaseVolume [[color("F70000")]];
    u8 MaybePan [[color("EF0000")]];
    padding[1];
    u8 UnkPitchRelated_0x04  [[color("DF0000")]];
    u8 LfoTableIndex  [[color("D70000")]];
    u8 StartNoteRange  [[color("CF0000")]];
    u8 ProgramCount  [[color("C70000")]]; // seems to be count - 0x1F for some reason?
    
    JamSplitChunk chunks[ProgramCount - 0x1F];
};

struct Prog {
    u16 EntryOffset;
    SeProgChunk prg @ parent.RelativeStart + EntryOffset;
};

struct SeSeqProgChunk {
    const u32 RelativeStart = $;
    u16 MaxIndex;
    Prog Entries[MaxIndex + 1];
};

struct Seq {
    u16 SequenceOffset;
    u8 SequenceData[while(std::mem::read_unsigned($, 3) != 0x2FFF)] @ parent.RelativeStart + SequenceOffset;
};

struct SeSeqEntrySequences {
    const u32 RelativeStart = parent.RelativeStart;
    u16 LastIndex;
    Seq SequenceOffsets[LastIndex+1];
};

struct SeSeqEntry {
    const u32 RelativeStart = parent.RelativeStart;
    s16 DataOffset;
    if (DataOffset != -1) {
        SeSeqEntrySequences Sequences @ RelativeStart + DataOffset;
    }
};

struct SeSeqChunk {
    const u32 RelativeStart = $;
    u16 LastIndex;
    SeSeqEntry Entries[LastIndex + 1];
};

// wtf is this?
// seems to always be 0x310 in length if it's in there
// and the values are always identical
struct UnkUnusedMaybeChunk {
    u8 UnknownData[0x310];
};


struct BreathWave {
    u8 BreathWaves[0x40];
};

struct BreathTableChunk {
    const u32 RelativeStart = $;
    u16 UpperBound;
    u16 Offsets[UpperBound+1];
    BreathWave BreathWaves[UpperBound+1];
};


struct JamHeader {
    u32 JamHeaderSize;
    u32 BdSize;
    u32 _empty_;
    char Magic[4];

    s32 ProgramChunkPhysicalOffset;
    s32 VelocityChunkPhysicalOffset;
    s32 BreathTableChunkPhysicalOffset;
    s32 SeSeqChunkPhysicalOffset;
    s32 UnkChunkPhysicalOffset;
    s32 SeProgChunkPhysicalOffset;
    s32 reserved_physoffsets[2];

    u32 ProgramChunkMemoryOffset;
    u32 VelocityChunkMemoryOffset;
    u32 BreathTableChunkMemoryOffset;
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
    if (BreathTableChunkPhysicalOffset != -1) {
        BreathTableChunk BreathTableChunk @ BreathTableChunkPhysicalOffset;
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
#include <std/mem>

// based on the information found at
// http://alinconstantin.dynu.com/WebDocs/SCC/VssVerScc.htm

#pragma author MarkusMaal
#pragma description Microsoft Visual SourceSafe/Source Code Control files
#pragma magic [ 34 12 01 00 ] @ 0x00
#pragma endian little

struct FileEntry {
    u32 dwFileID [[color("aa0000")]];           /* the number identifying the file in the VSS database that is tracked by this vssver.scc file */
    u32 dwFileChecksum [[color("00aa00")]];     /* the file's checksum */
    u32 dwFileTimestamp [[color("0000aa")]];    /* a file timestamp */
    u32 dwFileVersion [[color("aa00aa")]];      /* the version of the file from the VSS database that you have locally */
};

struct FileHeader 
{
    u32 dwSignature;        /* 0x00011234 */
    u8 arrDatabaseGuid[16]; /* a GUID identifying the VSS database associated with the vssver2.scc file */
    u32 dwChecksum;         /* a checksum of the vssver.scc file */
    u32 dwProjectID;        /* the number identifying the project from VSS database accociated with the vssver.scc files */
    padding[4];             /* always 00 00 00 00 for vssver.scc, vssver2.scc would supposedy have number of files here */
    FileEntry Entries[while(!std::mem::eof() && std::mem::read_unsigned($, 16) != 0x00 && std::mem::read_unsigned($, 4) != 0x11234)];
};

FileHeader Header[while(!std::mem::eof() && std::mem::read_unsigned($, 16) != 0x00)] @ 0x00;
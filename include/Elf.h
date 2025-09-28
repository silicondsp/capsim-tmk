#ifndef Elf_h
#define Elf_h

// File Specification *********************************************************
//
// Name: Elf.h
//
// Contents: ELF object file format (Executable and Linkable Format)
//
// End File Specification *****************************************************

// Copyright ******************************************************************
//
// BOPS Confidential Source Code
//
// Copyright (C) BOPS, Inc. 1997
//
// End Copyright **************************************************************

// Change Log *****************************************************************
//
// $History: Elf.h $
// 
// *****************  Version 9  *****************
// User: Johnd        Date: 9/07/00    Time: 8:31a
// Updated in $/ManArray/Software/Tools/peppers/ElfDump
// Added rsyms.
// 
// *****************  Version 8  *****************
// User: Johnd        Date: 5/31/00    Time: 9:03a
// Updated in $/ManArray/Software/Tools/peppers/ElfDump
// added lbrac and rbrac
// 
// *****************  Version 7  *****************
// User: Carlb        Date: 2/28/00    Time: 6:35p
// Updated in $/ManArray/Software/Tools/peppers/ElfDump
// 02/28/00 Restoration checkin
// 
// *****************  Version 7  *****************
// User: Johnd        Date: 2/15/00    Time: 12:45p
// Updated in $/ManArray/Software/Tools/peppers/ElfDump
// 
// *****************  Version 6  *****************
// User: Carlb        Date: 4/14/99    Time: 5:55p
// Updated in $/ManArray/Software/Tools/peppers/ElfDump
// Incident 754 - Repackaged all core and system simulator tools to
// compile in C++
// 
// *****************  Version 5  *****************
// User: Chrisd       Date: 7/24/98    Time: 8:53a
// Updated in $/Kittyhawk2x2/Software/Tools/peppers/ElfDump
// 
// *****************  Version 4  *****************
// User: Chrisd       Date: 7/17/98    Time: 4:01p
// Updated in $/Kittyhawk2x2/Software/Tools/peppers/ElfDump
// Incident 136
// 
// *****************  Version 3  *****************
// User: Carlb        Date: 6/25/98    Time: 3:19p
// Updated in $/Kittyhawk2x2/Software/Tools/peppers/ElfDump
// Added stab entry dump
// 
// *****************  Version 2  *****************
// User: Carlb        Date: 3/27/98    Time: 4:59p
// Updated in $/Kittyhawk2x2/Software/Tools/peppers/ElfDump
// First release of ELF dumper utility
// 
// *****************  Version 1  *****************
// User: Carlb        Date: 3/27/98    Time: 2:37p
// Created in $/Kittyhawk2x2/Software/Tools/peppers/ElfDump
//
// End Change Log *************************************************************

//-----------------------------------------------------------------------------
// Includes
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Constants
//-----------------------------------------------------------------------------
#define EI_NIDENT 16

//-----------------------------------------------------------------------------
// Types
//-----------------------------------------------------------------------------
typedef unsigned int   Elf32_Addr;
typedef unsigned short Elf32_Half;
typedef unsigned int   Elf32_Off;
typedef int            Elf32_Sword;
typedef unsigned int   Elf32_Word;

// ??? Check the following lines.
#ifndef GLOBAL_OFFSET_TABLE_NAME
#define GLOBAL_OFFSET_TABLE_NAME "_GLOBAL_OFFSET_TABLE_"
#endif

//-----------------------------------------------------------------------------
// ELF Header
//-----------------------------------------------------------------------------
typedef struct {
   unsigned char  e_ident[EI_NIDENT]; // ELF Identification
   Elf32_Half     e_type;             // Object file type
   Elf32_Half     e_machine;          // Machine architecture
   Elf32_Word     e_version;          // Object file version (always set to EV_CURRENT)
   Elf32_Addr     e_entry;            // Virtual address to which the system first transfers control
   Elf32_Off      e_phoff;            // Program header table file offset in bytes
   Elf32_Off      e_shoff;            // Section header table file offset in bytes
   Elf32_Word     e_flags;            // Processor specific flags
   Elf32_Half     e_ehsize;           // ELF header size in bytes
   Elf32_Half     e_phentsize;        // Size in bytes of one entry in program header table
   Elf32_Half     e_phnum;            // Number of entries in program header table
   Elf32_Half     e_shentsize;        // Size in bytes of one entry in section header table
   Elf32_Half     e_shnum;            // Number of entries in section header table
   Elf32_Half     e_shstrndx;         // Index of section name string table in section header table
} Elf32_Ehdr;

// e_ident indexes and values
#define EI_MAG0         0             /*   0x7F                */
#define EI_MAG1         1             /*   'E'                 */
#define EI_MAG2         2             /*   'L'                 */
#define EI_MAG3         3             /*   'F'                 */
#define EI_CLASS        4             /*   Class               */
#define ELFCLASSNONE       0          /*     Invalid           */
#define ELFCLASS32         1          /*     32-bit objects    */
#define ELFCLASS64         2          /*     64-bit objects    */
#define EI_DATA         5             /*   Data Endianess      */
#define ELFDATANONE        0          /*     Invalid           */
#define ELFDATALSB         1          /*     LSB little endian */
#define ELFDATAMSB         2          /*     MSB big endian    */
#define EI_VERSION      6             /*   Must be EV_CURRENT  */
#define EV_NONE            0          /*     Invalid           */
#define EV_CURRENT         1          /*     Current           */
#define EI_PAD          7             /*   Unused bytes        */

// e_type values
#define ET_NONE        0              /*   No file type       */
#define ET_REL         1              /*   Relocatable file   */
#define ET_EXEC        2              /*   Executable file    */
#define ET_DYN         3              /*   Shared object file */
#define ET_CORE        4              /*   Core file          */
#define ET_LOPROC  0xff00             /*   Processor Specific */
#define ET_HIPROC  0xffff             /*   Processor Specific */

// e_machine values
#define EM_NONE           0
#define EM_M32            1
#define EM_SPARC          2
#define EM_386            3
#define EM_68K            4 
#define EM_88K            5
#define EM_860            7
#define EM_MIPS           8
#define EM_BOPS2x2   0x7856

// e_version values
#define EV_NONE           0
#define EV_CURRENT        1


//-----------------------------------------------------------------------------
// Section Header
//-----------------------------------------------------------------------------

typedef struct {
   Elf32_Word sh_name;         // Index into string table section for name of this section
   Elf32_Word sh_type;         // Categorize section contents and semantics
   Elf32_Word sh_flags;        // Attributes of section
   Elf32_Addr sh_addr;         // Addr of 1st byte if section appears in memory image of a process
   Elf32_Off  sh_offset;       // Offset in bytes to first byte of section data
   Elf32_Word sh_size;         // Size in bytes of section (If sh_type == SHT_NOBITS, section occupies no space
   Elf32_Word sh_link;         // Section header table index link to section with related info for this section
   Elf32_Word sh_info;         //
   Elf32_Word sh_addralign;    // Address alignment constraint, must be power of 2. Value of 0 or 1 means no alignment constraint
   Elf32_Word sh_entsize;      // Size in bytes for each entry in table for section, otherwise 0
} Elf32_Shdr;

//Elf32_Shdr* master_pSecHdr; 
//Elf32_Half numSections;
//char* master_pSecHdrStrTbl;
//char* master_fileData;

// sh_type values
#define SHT_NULL            0
#define SHT_PROGBITS        1
#define SHT_SYMTAB          2
#define SHT_STRTAB          3
#define SHT_RELA            4
#define SHT_HASH            5
#define SHT_DYNAMIC         6
#define SHT_NOTE            7
#define SHT_NOBITS          8
#define SHT_REL             9
#define SHT_SHLIB          10
#define SHT_DYNSYM         11
#define SHT_LOPROC 0x70000000
#define SHT_HIPROC 0x7fffffff
#define SHT_LOUSER 0x80000000
#define SHT_HIUSER 0xffffffff

// Special section indexes
#define SHN_UNDEF           0
#define SHN_ABS        0xfff1 // The symbol has an absolute value that will not change because of relocation.

#define SHF_WRITE             0x01
#define SHF_ALLOC             0x02
#define SHF_EXECINSTR         0x04
#define SHF_MASKPROC    0xf0000000


//-----------------------------------------------------------------------------
// Program Header
//-----------------------------------------------------------------------------
typedef struct {
   Elf32_Word p_type;          // Segment type
   Elf32_Off  p_offset;        // Segment file offset in bytes
   Elf32_Addr p_vaddr;         // Virtual address of segment
   Elf32_Addr p_paddr;         // Physical address of segment
   Elf32_Word p_filesz;        // Number of bytes in the file image of segment
   Elf32_Word p_memsz;         // Number of bytes in the memory image of segment
   Elf32_Word p_flags;         // Segment flags
   Elf32_Word p_align;         // Segment alignment in memory and file
} Elf32_Phdr;

// p_type values
#define PT_NULL            0   /*   Segment unused, rest of fields are invalid */
#define PT_LOAD            1   /*   A loadable segment   */
#define PT_DYNAMIC         2   /*   Dynamic linking info */
#define PT_INTERP          3   /*   Specifies location and size of a null-term path name to invoke as an interpreter */
#define PT_NOTE            4   /*   Specifies location and size of auxilliary info */
#define PT_SHLIB           5   /*   Reserved for shared lib, but does not conform to ABI */
#define PT_PHDR            6   /*   Specifies location and size of the program header table in the file and memory image */
#define PT_LOPROC 0X70000000   /*   Reserved for processor specific semantics */
#define PT_HIPROC 0X7FFFFFFF


//-----------------------------------------------------------------------------
// Symbol Table Entry
//-----------------------------------------------------------------------------
typedef struct {
   Elf32_Word    st_name;      // Index into symbol string table for name of this symbol
   Elf32_Addr    st_value;     // Value of symbol
   Elf32_Word    st_size;      // Size in bytes of section (If sh_type == SHT_NOBITS, section occupies no space
   unsigned char st_info;      // Symbol Type and binding
   unsigned char st_other;     // Must be 0
   Elf32_Half    st_shndx;     // Section header table index
} Elf32_Sym;

// Macros to access Symbol Binding, Type, Info (Binding/Type)
#define ELF32_ST_BIND(b)   (((b) >> 4) & 0xf)
#define ELF32_ST_TYPE(t)   ( (t)       & 0xf)
#define ELF32_ST_INFO(b,t) ((((b) & 0xf) << 4) | ((t) & 0xf))

// ELF32_ST_BIND values
#define STB_LOCAL   0
#define STB_GLOBAL  1
#define STB_WEAK    2
#define STB_LOPROC 13
#define STB_HIPROC 15

// ELF32_ST_TYPE value
#define STT_NOTYPE   0
#define STT_OBJECT   1
#define STT_FUNC     2
#define STT_SECTION  3
#define STT_FILE     4
#define STT_LOPROC  13
#define STT_HIPROC  15


//-----------------------------------------------------------------------------
// Relocation Table Entry (REL)
//-----------------------------------------------------------------------------
typedef struct {
   Elf32_Addr    r_offset;     // Byte Offset from beginning of section to data affected by relocation
   Elf32_Word    r_info;       // Symbol table index (31:8) and Relocation Type (7:0)
} Elf32_Rel;

typedef struct {
   Elf32_Addr    r_offset;     // Byte Offset from beginning of section to data affected by relocation
   Elf32_Word    r_info;       // Symbol table index (31:8) and Relocation Type (7:0)
   Elf32_Sword   r_addend;     // Constant addend used to compute relocation value
} Elf32_Rela;

// Macros to access Symbol Table Index / Relocation Type
#define ELF32_R_SYM(s)     (((s) >> 8) & 0xffffff)
#define ELF32_R_TYPE(t)    ((t) & 0xff)
#define ELF32_R_INFO(s,t)  ((((s) & 0xffffff) << 8) | ((t) & 0xff))

// Relocation Types
#define R_386_NONE      0
#define R_386_32        1
#define R_386_PC32      2
#define R_386_GOT32     3
#define R_386_PLT32     4
#define R_386_COPY      5
#define R_386_GLOB_DAT  6
#define R_386_JMP_SLOT  7
#define R_386_RELATIVE  8
#define R_386_GOTOFF    9
#define R_386_GOTPC    10


//-----------------------------------------------------------------------------
// Stab Table Entry (.stab section)
//-----------------------------------------------------------------------------
typedef struct {
   Elf32_Word    n_strx;     // Index in .stabstr section to stab string
   unsigned char n_type;     // Type of stab entry
   unsigned char n_other;    // Unused field, always zero
   Elf32_Half    n_desc;     // Description field
   Elf32_Word    n_value;    // Value of stab
} Elf32_Stab;

// non-Stab symbol types
#define STAB_N_UNDEF  0x00 // Undefined symbol
// Stab types
#define STAB_N_GSYM   0x20 // Global variable.  Only name is significant.  Use corresponding name in symbol table for address.
#define STAB_N_FNAME  0x22
#define STAB_N_FUN    0x24
#define STAB_N_STSYM  0x26
#define STAB_N_LCSYM  0x28
#define STAB_N_MAIN   0x2A
#define STAB_N_NSYMS  0x32
#define STAB_N_ROSYM  0x2C
#define STAB_N_RSYM   0x40 // Register variable.
#define STAB_N_SLINE  0x44 // Line number in Text segment.
#define STAB_N_DSLINE 0x46
#define STAB_N_BSLINE 0x48
#define STAB_N_SO     0x64 // Path and name of source file.
#define STAB_N_LSYM   0x80
#define STAB_N_BINCL  0x82
#define STAB_N_SOL    0x84
#define STAB_N_PSYM   0xA0
#define STAB_N_EINCL  0xA2
#define STAB_N_ENTRY  0xA4 
#define STAB_N_LBRAC  0xC0 
#define STAB_N_RBRAC  0xE0 

//-----------------------------------------------------------------------------
// Macros
//-----------------------------------------------------------------------------

#define OFFSET(x) ( (char*)x - m_fileData )
#define SWAP16(x) ( ( (x >> 8) & 0xff) + ( (x & 0xff) << 8) )
#define SWAP32(x) ( ( (x >> 24) & 0xff) + ( (x & 0xff0000) >> 8) + ( (x & 0xff00) << 8) + ( (x & 0xff) << 24) )

//-----------------------------------------------------------------------------
// Variables
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Function Prototypes
//-----------------------------------------------------------------------------

#undef GLOBAL

#endif

\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK CONFIGURATION)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1992
\
\ The code on this site has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://www.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file contains configuration that is common to all eight banks.
\
\ ******************************************************************************

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 NOST = 20              \ The number of stardust particles in normal space (this
                        \ goes down to 3 in witchspace)

 NOSH = 8               \ The maximum number of ships in our local bubble of
                        \ universe

 NTY = 33               \ The number of different ship types

 MSL = 1                \ Ship type for a missile
 SST = 2                \ Ship type for a Coriolis space station
 ESC = 3                \ Ship type for an escape pod
 PLT = 4                \ Ship type for an alloy plate
 OIL = 5                \ Ship type for a cargo canister
 AST = 7                \ Ship type for an asteroid
 SPL = 8                \ Ship type for a splinter
 SHU = 9                \ Ship type for a Shuttle
 CYL = 11               \ Ship type for a Cobra Mk III
 ANA = 14               \ Ship type for an Anaconda
 HER = 15               \ Ship type for a rock hermit (asteroid)
 COPS = 16              \ Ship type for a Viper
 SH3 = 17               \ Ship type for a Sidewinder
 KRA = 19               \ Ship type for a Krait
 ADA = 20               \ Ship type for a Adder
 WRM = 23               \ Ship type for a Worm
 CYL2 = 24              \ Ship type for a Cobra Mk III (pirate)
 ASP = 25               \ Ship type for an Asp Mk II
 THG = 29               \ Ship type for a Thargoid
 TGL = 30               \ Ship type for a Thargon
 CON = 31               \ Ship type for a Constrictor
 COU = 32               \ Ship type for a Cougar
 DOD = 33               \ Ship type for a Dodecahedron ("Dodo") space station

 NI% = 42               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 Y = 72                 \ The centre y-coordinate of the space view

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

 LL = 29                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

\ ******************************************************************************
\
\ NES PPU registers
\
\ See https://www.nesdev.org/wiki/PPU_registers
\
\ ******************************************************************************

 PPU_CTRL   = &2000
 PPU_MASK   = &2001
 PPU_STATUS = &2002
 OAM_ADDR   = &2003
 OAM_DATA   = &2004
 PPU_SCROLL = &2005
 PPU_ADDR   = &2006
 PPU_DATA   = &2007
 OAM_DMA    = &4014

\ ******************************************************************************
\
\ NES 2A03 CPU registers (I/O and sound)
\
\ See https://www.nesdev.org/wiki/2A03
\
\ ******************************************************************************

 SQ1_VOL    = &4000
 SQ1_SWEEP  = &4001
 SQ1_LO     = &4002
 SQ1_HI     = &4003
 SQ2_VOL    = &4004
 SQ2_SWEEP  = &4005
 SQ2_LO     = &4006
 SQ2_HI     = &4007
 TRI_LINEAR = &4008
 TRI_LO     = &400A
 TRI_HI     = &400B
 NOISE_VOL  = &400C
 L400D      = &400D
 NOISE_LO   = &400E
 NOISE_HI   = &400F
 DMC_FREQ   = &4010
 DMC_RAW    = &4011
 DMC_START  = &4012
 DMC_LEN    = &4013
 SND_CHN    = &4015
 JOY1       = &4016
 JOY2       = &4017

\ ******************************************************************************
\
\ Addresses in bank 7
\
\ ******************************************************************************

 S%                 = &C007
 SNE                = &C500
 ACT                = &C520
 XX21               = &C540
 SetPPUTablesTo0    = &D06D
 LD8C5              = &D8C5
 TWOS               = &D9F7
 yLookupLo          = &DA18
 yLookupHi          = &DAF8
 subm_DBD8          = &DBD8
 LOIN               = &DC0F
 LE04A              = &E04A
 LE0BA              = &E0BA
 PIXEL              = &E4F0
 subm_E909          = &E909
 LE5B0_EN           = &E5B0
 LE602_DE           = &E602
 LE653_FR           = &E653
 DELAY              = &EBA2
 SetupPPUForIconBar = &EC7D
 PAS1               = &EF7A
 DETOK_b2           = &F082
 DTS_b2             = &F09D
 C8980_b0           = &F186
 MVS5_b0            = &F1A2
 TT27_b0            = &F237
 TT66               = &F26E
 LF2BD              = &F2BD
 LF2CE              = &F2CE
 CLYNS              = &F2DE
 subm_F362          = &F362
 NLIN4              = &F473
 DORND2             = &F4AC
 DORND              = &F4AD
 PROJ               = &F4C1
 UnpackToRAM        = &F52D
 UnpackToPPU        = &F5AF
 MLS2               = &F6BA
 MLS1               = &F6C2
 MULTS              = &F6C6
 SQUA2              = &F70E
 MLU1               = &F718
 MLU2               = &F71D
 MULTU              = &F721
 FMLTU2             = &F766
 FMLTU              = &F770
 MUT2               = &F7D2
 MUT1               = &F7D6
 MULT1              = &F7DA
 MULT12             = &F83C
 MAD                = &F86F
 ADD                = &F872
 TIS1               = &F8AE
 DV42               = &F8D1
 DV41               = &F8D4
 DVID4              = &F8D8
 DVID3B2            = &F962
 LL5                = &FA55
 LL28               = &FA91
 NORM               = &FAF8

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/nes/main/workspace/sprite_buffer.asm"
INCLUDE "library/common/main/workspace/wp.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"

\ ******************************************************************************
\
\       Name: pattBuffer0
\       Type: Variable
\   Category: Drawing lines
\    Summary: Pattern buffer for colour 0 (1 bit per pixel)
\
\ ******************************************************************************

 ORG &6000

.pattBuffer0

 SKIP 8 * 256           \ 256 patterns, 8 bytes per pattern (8x8 pixels)

\ ******************************************************************************
\
\       Name: pattBuffer1
\       Type: Variable
\   Category: Drawing lines
\    Summary: Pattern buffer for colour 1 (1 bit per pixel)
\
\ ******************************************************************************

.pattBuffer1

 SKIP 8 * 256           \ 256 patterns, 8 bytes per pattern (8x8 pixels)

\ ******************************************************************************
\
\       Name: nameBuffer0
\       Type: Variable
\   Category: Drawing lines
\    Summary: Buffer for nametable and attribute table 0
\
\ ******************************************************************************

.nameBuffer0

 SKIP 30 * 32           \ 30 rows of 32 tile numbers

 SKIP 8 * 8             \ 8 rows of 8 attribute bytes (each is a 2x2 tile block)

\ ******************************************************************************
\
\       Name: nameBuffer1
\       Type: Variable
\   Category: Drawing lines
\    Summary: Buffer for nametable and attribute table 1
\
\ ******************************************************************************

.nameBuffer1

 SKIP 30 * 32           \ 30 rows of 32 tile numbers

 SKIP 8 * 8             \ 8 rows of 8 attribute bytes (each is a 2x2 tile block)


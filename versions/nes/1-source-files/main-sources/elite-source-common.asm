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
\ Exported addresses from banks 0 to 6
\
\ ******************************************************************************

IF NOT(_BANK = 0)

 subm_8926          = &8926
 subm_8980          = &8980
 MVS5               = &8A14
 DemoShips          = &9522
 BR1                = &A379
 TT27_0             = &A8D9
 ZINF_0             = &AE03
 MAS4               = &B1CA
 subm_B1D4          = &B1D4
 subm_B2C3          = &B2C3
 subm_B2EF          = &B2EF
 subm_B358          = &B358
 subm_B39D          = &B39D
 subm_B3BC          = &B3BC
 PAS1               = &B8F7
 TT66               = &BEB5

ENDIF

IF NOT(_BANK = 1)

 E%                 = &8042
 KWL%               = &8063
 KWH%               = &8084
 LL9                = &A070
 CLIP               = &A65D
 CIRCLE2            = &AF9D
 SUN                = &AC25
 STARS              = &B1BE
 HALL               = &B738
 TIDY               = &B85C
 SCAN               = &B975
 LBAF3              = &BAF3

ENDIF

IF NOT(_BANK = 2)

 DETOK              = &B0EF
 DTS                = &B187
 PDESC              = &B3E8
 TT27               = &B44F
 ex                 = &B4AA
 DASC               = &B4F5
 CHPR               = &B635

ENDIF

IF NOT(_BANK = 3)

 ClearTiles         = &B341

ENDIF

IF NOT(_BANK = 4)

 LB882              = &B882
 GetSystemImage2    = &B8F9
 SetSystemImage2    = &B93C
 subm_B96B          = &B96B
 subm_B9C1          = &B9C1
 subm_B9F9          = &B9F9

ENDIF

IF NOT(_BANK = 5)

 SetSystemImage1    = &BED7
 GetSystemImage1    = &BEEA
 subm_BF41          = &BF41

ENDIF

IF NOT(_BANK = 6)

 ResetSound         = &8012
 subm_8021          = &8021
 PlayMusic          = &811E
 DIALS              = &A2C3
 LL164              = &B980
 TITLE              = &BC83

ENDIF

 \ These variables should be added as labels and moved into the above

 \ Bank 3

 LA730              = &A730
 LA775              = &A775
 LA7B7              = &A7B7
 LA972              = &A972
 LA9D1              = &A9D1
 LAABC              = &AABC
 LAC1D              = &AC1D
 LAC5C              = &AC5C
 LAE18              = &AE18
 LAFCD              = &AFCD
 LB0E1              = &B0E1
 LB18E              = &B18E
 LB219              = &B219
 LB248              = &B248
 LB2BC              = &B2BC
 LB2FB              = &B2FB
 LB63D              = &B63D
 LB673              = &B673
 LB9E2              = &B9E2
 LBA23              = &BA23

 \ Bank 6

 L89D1              = &89D1
 LA082              = &A082
 LA0F8              = &A0F8
 LA166              = &A166
 LA4A5              = &A4A5
 LA5AB              = &A5AB
 LB459              = &B459
 LB88C              = &B88C
 LB8FE              = &B8FE
 LB90D              = &B90D
 LB919              = &B919
 LBA17              = &BA17
 LBA63              = &BA63
 LBB37              = &BB37
 LBBDE              = &BBDE
 LBE52              = &BE52
 LBED2              = &BED2


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

\ ******************************************************************************
\
\ Commander file?
\
\ ******************************************************************************

.L7800

 SKIP 2048

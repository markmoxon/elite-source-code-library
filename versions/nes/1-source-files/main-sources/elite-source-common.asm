\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (COMMON VARIABLES)
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
\ This source file contains variables, macros and addresses that are shared by
\ all eight banks.
\
\ ******************************************************************************

 _NTSC = (_VARIANT = 1)
 _PAL  = (_VARIANT = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 Q% = _REMOVE_CHECKSUMS \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

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
 ADA = 20               \ Ship type for an Adder
 WRM = 23               \ Ship type for a Worm
 CYL2 = 24              \ Ship type for a Cobra Mk III (pirate)
 ASP = 25               \ Ship type for an Asp Mk II
 THG = 29               \ Ship type for a Thargoid
 TGL = 30               \ Ship type for a Thargon
 CON = 31               \ Ship type for a Constrictor
 COU = 32               \ Ship type for a Cougar
 DOD = 33               \ Ship type for a Dodecahedron ("Dodo") space station

 JL = ESC               \ Junk is defined as starting from the escape pod

 JH = SHU+2             \ Junk is defined as ending before the Cobra Mk III
                        \
                        \ So junk is defined as the following: escape pod,
                        \ alloy plate, cargo canister, asteroid, splinter,
                        \ Shuttle or Transporter

 PACK = SH3             \ The first of the eight pack-hunter ships, which tend
                        \ to spawn in groups. With the default value of PACK the
                        \ pack-hunters are the Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm and Cobra Mk III (pirate)

 POW = 15               \ Pulse laser power in the NES version is POW + 9,
                        \ rather than just POW in the other versions (all other
                        \ lasers are the same)

 Mlas = 50              \ Mining laser power

 Armlas = INT(128.5+1.5*POW)  \ Military laser power

 NI% = 38               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 NIK% = NI% + 4         \ The number of bytes in each block in K% (as each block
                        \ contains four extra bytes)

 X = 128                \ The centre x-coordinate of the space view
 Y = 72                 \ The centre y-coordinate of the space view

 RE = &3E               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

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

 PPU_PATT_0 = &0000
 PPU_PATT_1 = &1000
 PPU_NAME_0 = &2000
 PPU_NAME_1 = &2400

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
\ Exported addresses from bank 0
\
\ ******************************************************************************

IF NOT(_BANK = 0)

 subm_8926          = &8926
 SendScreenToPPU    = &8980
 MVS5               = &8A14
 DemoShips          = &9522
 StartAfterLoad     = &A379
 PrintCtrlCode      = &A8D9
 ZINF               = &AE03
 MAS4               = &B1CA
 subm_B1D4          = &B1D4
 ShowStartScreen    = &B2C3
 DEATH2             = &B2EF
 subm_B358          = &B358
 subm_B39D          = &B39D
 TITLE              = &B3BC
 PAS1               = &B8F7
 TT66               = &BEB5

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 1
\
\ ******************************************************************************

IF NOT(_BANK = 1)

 E%                 = &8042
 KWL%               = &8063
 KWH%               = &8084
 SHIP_MISSILE       = &80A5
 SHIP_CORIOLIS      = &81A3
 SHIP_ESCAPE_POD    = &82BF
 SHIP_PLATE         = &8313
 SHIP_CANISTER      = &8353
 SHIP_BOULDER       = &83FB
 SHIP_ASTEROID      = &849D
 SHIP_SPLINTER      = &8573
 SHIP_SHUTTLE       = &85AF
 SHIP_TRANSPORTER   = &86E1
 SHIP_COBRA_MK_3    = &88C3
 SHIP_PYTHON        = &8A4B
 SHIP_BOA           = &8B3D
 SHIP_ANACONDA      = &8C33
 SHIP_ROCK_HERMIT   = &8D35
 SHIP_VIPER         = &8E0B
 SHIP_SIDEWINDER    = &8EE5
 SHIP_MAMBA         = &8F8D
 SHIP_KRAIT         = &90BB
 SHIP_ADDER         = &91A1
 SHIP_GECKO         = &92D1
 SHIP_COBRA_MK_1    = &9395
 SHIP_WORM          = &945B
 SHIP_COBRA_MK_3_P  = &950B
 SHIP_ASP_MK_2      = &9693
 SHIP_PYTHON_P      = &97BD
 SHIP_FER_DE_LANCE  = &98AF
 SHIP_MORAY         = &99C9
 SHIP_THARGOID      = &9AA1
 SHIP_THARGON       = &9BBD
 SHIP_CONSTRICTOR   = &9C29
 SHIP_COUGAR        = &9D2B
 SHIP_DODO          = &9E2D
 LL9                = &A070
 CLIP               = &A65D
 CIRCLE2            = &AF9D
 SUN                = &AC25
 STARS              = &B1BE
 HALL               = &B738
 TIDY               = &B85C
 SCAN               = &B975
 subm_BAF3          = &BAF3

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 2
\
\ ******************************************************************************

IF NOT(_BANK = 2)

 DETOK              = &B0EF
 DTS                = &B187
 PDESC              = &B3E8
 TT27               = &B44F
 ex                 = &B4AA
 DASC               = &B4F5
 CHPR               = &B635

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 3
\
\ ******************************************************************************

IF NOT(_BANK = 3)

 iconBarImage0      = &8100
 iconBarImage1      = &8500
 iconBarImage2      = &8900
 iconBarImage3      = &8D00
 iconBarImage4      = &9100
 subm_A730          = &A730
 subm_A775          = &A775
 SetupView          = &A7B7
 subm_A972          = &A972
 subm_A9D1          = &A9D1
 ResetScreen        = &AABC
 subm_AC1D          = &AC1D
 subm_AC5C          = &AC5C
 subm_AE18          = &AE18
 subm_AFCD          = &AFCD
 subm_B0E1          = &B0E1
 subm_B18E          = &B18E
 subm_B219          = &B219
 subm_B248          = &B248
 subm_B2BC          = &B2BC
 subm_B2FB          = &B2FB
 ClearScreen        = &B341
 subm_B63D          = &B63D
 subm_B673          = &B673
 SetViewAttribs     = &B9E2
 SetSightSprites    = &BA23

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 4
\
\ ******************************************************************************

IF NOT(_BANK = 4)

 subm_B882          = &B882
 GetCmdrImage       = &B8F9
 SetCmdrImage       = &B93C
 subm_B96B          = &B96B
 subm_B9C1          = &B9C1
 subm_B9F9          = &B9F9

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 5
\
\ ******************************************************************************

IF NOT(_BANK = 5)

 SetSystemImage     = &BED7
 GetSystemImage     = &BEEA
 SetDemoAutoPlay    = &BF41

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 6
\
\ ******************************************************************************

IF NOT(_BANK = 6)

 ResetSound         = &8012
 subm_8021          = &8021
 PlayMusic          = &811E
 subm_89D1          = &89D1
 subm_A082          = &A082
 subm_A0F8          = &A0F8
 subm_A166          = &A166
 DIALS              = &A2C3
 DrawEquipment      = &A4A5
 subm_A5AB          = &A5AB
 SVE                = &B459

 IF _NTSC

  subm_B88C         = &B88C
  subm_B8FE         = &B8FE
  JAMESON           = &B90D
  subm_B919         = &B919
  LL164             = &B980
  subm_BA17         = &BA17
  subm_BA63         = &BA63
  ChangeCmdrName    = &BB37
  SetKeyLogger      = &BBDE
  StartScreen       = &BC83
  subm_BE52         = &BE52
  subm_BED2         = &BED2

 ELIF _PAL

  subm_B88C         = &B89B
  subm_B8FE         = &B90D
  JAMESON           = &B91C
  subm_B919         = &B928
  LL164             = &B98F
  subm_BA17         = &BA26
  subm_BA63         = &BA72
  ChangeCmdrName    = &BB46
  SetKeyLogger      = &BBED
  StartScreen       = &BC92
  subm_BE52         = &BE6D
  subm_BED2         = &BEED

 ENDIF

ENDIF

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

.attrBuffer0

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

.attrBuffer1

 SKIP 8 * 8             \ 8 rows of 8 attribute bytes (each is a 2x2 tile block)

\ ******************************************************************************
\
\       Name: L7800
\       Type: Variable
\   Category: ???
\    Summary: Commander file?
\
\ ******************************************************************************

.L7800

 SKIP 2048

INCLUDE "library/nes/main/macro/setup_ppu_for_icon_bar.asm"
INCLUDE "library/common/main/macro/item.asm"
INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/enhanced/main/macro/ejmp.asm"
INCLUDE "library/enhanced/main/macro/echr.asm"
INCLUDE "library/enhanced/main/macro/etok.asm"
INCLUDE "library/enhanced/main/macro/etwo.asm"
INCLUDE "library/enhanced/main/macro/ernd.asm"
INCLUDE "library/enhanced/main/macro/tokn.asm"
INCLUDE "library/common/main/macro/char.asm"
INCLUDE "library/common/main/macro/twok.asm"
INCLUDE "library/common/main/macro/cont.asm"
INCLUDE "library/common/main/macro/rtok.asm"
INCLUDE "library/nes/main/macro/add_cycles_clc.asm"
INCLUDE "library/nes/main/macro/add_cycles.asm"
INCLUDE "library/nes/main/macro/subtract_cycles.asm"
INCLUDE "library/nes/main/macro/fill_memory.asm"
INCLUDE "library/nes/main/macro/send_data_to_ppu.asm"

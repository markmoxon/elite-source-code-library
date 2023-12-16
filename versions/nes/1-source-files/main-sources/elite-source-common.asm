\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (COMMON VARIABLES)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
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

 Armlas = INT(128.5 + 1.5*POW)  \ Military laser power

 NI% = 38               \ The number of bytes in each ship's data block (as
                        \ stored in INWK and K%)

 NIK% = 42              \ The number of bytes in each block in K% (as each block
                        \ contains four extra bytes)

 X = 128                \ The centre x-coordinate of the space view
 Y = 72                 \ The centre y-coordinate of the space view

 RE = &3E               \ The obfuscation byte used to hide the recursive tokens
                        \ table from crackers viewing the binary code

 VE = &57               \ The obfuscation byte used to hide the extended tokens
                        \ table from crackers viewing the binary code

 LL = 29                \ The length of lines (in characters) of justified text
                        \ in the extended tokens system

 W2 = 3                 \ The horizontal character spacing in the scroll text
                        \ (i.e. the difference in x-coordinate between the
                        \ left edges of adjacent characters in words)

 WY = 1                 \ The vertical spacing between points in the scroll text
                        \ grid for each character

 W2Y = 3                \ The vertical line spacing in the scroll text (i.e. the
                        \ difference in y-coordinate between the tops of the
                        \ characters in adjacent lines)


 YPAL = 6 AND _PAL      \ A margin of 6 pixels that is applied to a number of
                        \ y-coordinates for the PAL version only (as the PAL
                        \ version has a taller screen than NTSC)

\ ******************************************************************************
\
\ NES PPU registers
\
\ ******************************************************************************

 PPU_CTRL   = &2000     \ The PPU control register, which allows us to choose
                        \ which nametable and pattern table is being displayed,
                        \ and to toggle the NMI interrupt at VBlank

 PPU_MASK   = &2001     \ The PPU mask register, which controls how sprites and
                        \ the tile background are displayed

 PPU_STATUS = &2002     \ The PPU status register, which can be checked to see
                        \ whether VBlank has started, and whether sprite 0 has
                        \ been hit (so we can detect when the icon bar is being
                        \ drawn)

 OAM_ADDR   = &2003     \ The OAM address port (this is not used in Elite)

 OAM_DATA   = &2004     \ The OAM data port (this is not used in Elite)

 PPU_SCROLL = &2005     \ The PPU scroll position register, which is used to
                        \ scroll the leftmost tile on each row around to the
                        \ right

 PPU_ADDR   = &2006     \ The PPU address register, which is used to set the
                        \ destination address within the PPU when sending data
                        \ to the PPU

 PPU_DATA   = &2007     \ The PPU data register, which is used to send data to
                        \ the PPU, to the address specified in PPU_ADDR

 OAM_DMA    = &4014     \ The OAM DMA register, which is used to initiate a DMA
                        \ transfer of sprite data to the PPU

 PPU_PATT_0 = &0000     \ The address of pattern table 0 in the PPU

 PPU_PATT_1 = &1000     \ The address of pattern table 1 in the PPU

 PPU_NAME_0 = &2000     \ The address of nametable 0 in the PPU

 PPU_ATTR_0 = &23C0     \ The address of attribute table 0 in the PPU

 PPU_NAME_1 = &2400     \ The address of nametable 1 in the PPU

 PPU_ATTR_1 = &27C0     \ The address of attribute table 1 in the PPU

\ ******************************************************************************
\
\ NES CPU registers (I/O and sound)
\
\ ******************************************************************************

 SQ1_VOL    = &4000     \ The APU duty cycle and volume register for square wave
                        \ channel 1

 SQ1_SWEEP  = &4001     \ The APU sweep control register for square wave channel
                        \ 1

 SQ1_LO     = &4002     \ The APU period register (low byte) for square wave
                        \ channel 1

 SQ1_HI     = &4003     \ The APU period register (high byte) for square wave
                        \ channel 1

 SQ2_VOL    = &4004     \ The APU duty cycle and volume register for square wave
                        \ channel 2

 SQ2_SWEEP  = &4005     \ The APU sweep control register for square wave channel
                        \ 2

 SQ2_LO     = &4006     \ The APU period register (low byte) for square wave
                        \ channel 2

 SQ2_HI     = &4007     \ The APU period register (high byte) for square wave
                        \ channel 2

 TRI_LINEAR = &4008     \ The APU linear counter register for the triangle wave
                        \ channel

 TRI_LO     = &400A     \ The APU period register (low byte) for the triangle
                        \ wave channel

 TRI_HI     = &400B     \ The APU period register (high byte) for the triangle
                        \ wave channel

 NOISE_VOL  = &400C     \ The APU volume register for the noise channel

 NOISE_LO   = &400E     \ The APU period register (low byte) for the noise
                        \ channel

 NOISE_HI   = &400F     \ The APU period register (high byte) for the noise
                        \ channel

 DMC_FREQ   = &4010     \ Controls the IRQ flag, loop flag and frequency of the
                        \ DMC channel (this is not used in Elite)

 DMC_RAW    = &4011     \ Controls the DAC on the DMC channel (this is not used
                        \ in Elite)

 DMC_START  = &4012     \ Controls the start adddress on the DMC channel (this
                        \ is not used in Elite)

 DMC_LEN    = &4013     \ Controls the sample length on the DMC channel (this is
                        \ not used in Elite)

 SND_CHN    = &4015     \ The APU sound channel register, which enables
                        \ individual sound channels to be enabled or disabled

 JOY1       = &4016     \ The joystick port, with controller 1 mapped to JOY1
                        \ and controller 2 mapped to JOY1 + 1

 APU_FC     = &4017     \ The APU frame counter control register, which controls
                        \ the triggering of IRQ interrupts for sound generation,
                        \ and the sequencer step mode

\ ******************************************************************************
\
\ Exported addresses from bank 0
\
\ ******************************************************************************

IF NOT(_BANK = 0)

 UpdateView         = &8926
 DrawScreenInNMI    = &8980
 MVS5               = &8A14
 PlayDemo           = &9522
 SetupAfterLoad     = &A379
 PrintCtrlCode      = &A8D9
 ZINF               = &AE03
 MAS4               = &B1CA
 CheckForPause      = &B1D4
 ShowStartScreen    = &B2C3
 DEATH2             = &B2EF
 StartGame          = &B358
 ChangeToView       = &B39D
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
 HideFromScanner    = &BAF3

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 2
\
\ ******************************************************************************

IF NOT(_BANK = 2)

 TKN1               = &800C
 TKN1_DE            = &8DFD
 TKN1_FR            = &9A2C
 QQ18               = &A3CF
 QQ18_DE            = &A79C
 QQ18_FR            = &AC4D
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
 DrawDashNames      = &A730
 ResetScanner       = &A775
 SendViewToPPU      = &A7B7
 SendBitplaneToPPU  = &A972
 SetupViewInNMI     = &A9D1
 ResetScreen        = &AABC
 ShowIconBar        = &AC1D
 UpdateIconBar      = &AC5C
 SetupIconBar       = &AE18
 SetLinePatterns    = &AFCD
 LoadNormalFont     = &B0E1
 LoadHighFont       = &B18E
 DrawSystemImage    = &B219
 DrawImageFrame     = &B248
 DrawSmallBox       = &B2BC
 DrawBackground     = &B2FB
 ClearScreen        = &B341
 FadeToBlack        = &B63D
 FadeToColour       = &B673
 SetViewAttrs       = &B9E2
 SIGHT              = &BA23

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 4
\
\ ******************************************************************************

IF NOT(_BANK = 4)

 cobraNames         = &B7EC
 GetHeadshotType    = &B882
 GetHeadshot        = &B8F9
 GetCmdrImage       = &B93C
 DrawBigLogo        = &B96B
 DrawImageNames     = &B9C1
 DrawSmallLogo      = &B9F9

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 5
\
\ ******************************************************************************

IF NOT(_BANK = 5)

 GetSystemImage     = &BED7
 GetSystemBack      = &BEEA
 SetDemoAutoPlay    = &BF41

ENDIF

\ ******************************************************************************
\
\ Exported addresses from bank 6
\
\ ******************************************************************************

IF NOT(_BANK = 6)

 StopSoundsS        = &8012
 ChooseMusic        = &8021
 MakeSounds         = &811E
 StartEffect        = &89D1
 DrawCmdrImage      = &A082
 DrawSpriteImage    = &A0F8
 PauseGame          = &A166
 DIALS              = &A2C3
 DrawEquipment      = &A4A5
 ShowScrollText     = &A5AB
 SVE                = &B459

 IF _NTSC

  CheckSaveSlots    = &B88C
  ResetCommander    = &B8FE
  JAMESON           = &B90D
  DrawLightning     = &B919
  LL164             = &B980
  DrawLaunchBox     = &BA17
  InputName         = &BA63
  ChangeCmdrName    = &BB37
  SetKeyLogger      = &BBDE
  ChooseLanguage    = &BC83
  TT24              = &BE52
  ClearDashEdge     = &BED2

 ELIF _PAL

  CheckSaveSlots    = &B89B
  ResetCommander    = &B90D
  JAMESON           = &B91C
  DrawLightning     = &B928
  LL164             = &B98F
  DrawLaunchBox     = &BA26
  InputName         = &BA72
  ChangeCmdrName    = &BB46
  SetKeyLogger      = &BBED
  ChooseLanguage    = &BC92
  TT24              = &BE6D
  ClearDashEdge     = &BEED

 ENDIF

ENDIF

INCLUDE "library/common/main/workspace/zp.asm"
INCLUDE "library/common/main/workspace/xx3.asm"
INCLUDE "library/nes/main/workspace/sprite_buffer.asm"
INCLUDE "library/common/main/workspace/wp.asm"
INCLUDE "library/common/main/workspace/k_per_cent.asm"
INCLUDE "library/nes/main/workspace/cartridge_wram.asm"
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

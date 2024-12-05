\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (COMMON VARIABLES)
\
\ NES Elite was written by Ian Bell and David Braben and is copyright D. Braben
\ and I. Bell 1991/1992
\
\ The code in this file has been reconstructed from a disassembly of the version
\ released on Ian Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file contains variables, macros and addresses that are shared by
\ all eight ROM banks in NES Elite.
\
\ ******************************************************************************

 INCLUDE "versions/nes/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _DISC_DOCKED           = FALSE
 _DISC_FLIGHT           = FALSE
 _ELITE_A_DOCKED        = FALSE
 _ELITE_A_FLIGHT        = FALSE
 _ELITE_A_SHIPS_R       = FALSE
 _ELITE_A_SHIPS_S       = FALSE
 _ELITE_A_SHIPS_T       = FALSE
 _ELITE_A_SHIPS_U       = FALSE
 _ELITE_A_SHIPS_V       = FALSE
 _ELITE_A_SHIPS_W       = FALSE
 _ELITE_A_ENCYCLOPEDIA  = FALSE
 _ELITE_A_6502SP_IO     = FALSE
 _ELITE_A_6502SP_PARA   = FALSE

 _NTSC = (_VARIANT = 1)
 _PAL  = (_VARIANT = 2)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &8000          \ The address where the code will be run

 LOAD% = &8000          \ The address where the code will be loaded

 Q% = _MAX_COMMANDER    \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander

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

\ ******************************************************************************
\
\ Include all ROM banks
\
\ ******************************************************************************

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-0.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-1.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-2.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-3.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-4.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-5.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-6.asm"
 CLEAR CODE%, P%

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-bank-7.asm"

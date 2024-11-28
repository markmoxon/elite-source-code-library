\ ******************************************************************************
\
\ COMMODORE 64 ELITE LOADER FILE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source disks released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
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
\ This source file produces the following binary file:
\
\   * COMLOD.unprot.bin
\
\ after reading in the following files:
\
\   * LODATA.bin
\   * SHIPS.bin
\   * CODIALS.bin
\   * SPRITE.bin
\   * DATE4.bin
\
\ ******************************************************************************

 INCLUDE "versions/c64/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _GMA85_NTSC            = (_VARIANT = 1)
 _GMA86_PAL             = (_VARIANT = 2)
 _SOURCE_DISK_BUILD     = (_VARIANT = 3)
 _SOURCE_DISK_FILES     = (_VARIANT = 4)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &4000          \ The address where the code will be run

 LOAD% = &4000          \ The address where the code will be loaded

 KEY3 = &8E             \ The seed for decrypting COMLOD from U% to V%, which is
                        \ the second block of data, after the decryption routine

 KEY4 = &6C             \ The seed for decrypting COMLOD from W% to X%, which is
                        \ the first block of data, before the decryption routine

 L1 = &0001             \ The 6510 input/output port register, which we can use
                        \ to configure the Commodore 64 memory layout (see page
                        \ 260 of the Programmer's Reference Guide)

 SCBASE = &4000         \ The address of the screen bitmap

IF _GMA85_NTSC OR _GMA86_PAL

 DSTORE% = SCBASE + &AF90       \ The address of a copy of the dashboard bitmap,
                                \ which gets copied into screen memory when
                                \ setting up a new screen

 SPRITELOC% = SCBASE + &2800    \ The address where the sprite bitmaps get
                                \ copied to during the loading process

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 DSTORE% = SCBASE + &2800       \ The address of a copy of the dashboard bitmap,
                                \ which gets copied into screen memory when
                                \ setting up a new screen

 SPRITELOC% = SCBASE + &3100    \ The address where the sprite bitmaps get
                                \ copied to during the loading process

ENDIF

 D% = &D000             \ The address where the ship data will be loaded
                        \ (i.e. XX21)

 VIC = &D000            \ Registers for the VIC-II video controller chip, which
                        \ are memory-mapped to the 46 bytes from &D000 to &D02E
                        \ (see page 454 of the Programmer's Reference Guide)

 COLMEM = &D800         \ Colour RAM, which is used (along with screen RAM) to
                        \ define the colour map of the dashboard in multicolour
                        \ bitmap mode

 CIA = &DC00            \ Registers for the CIA1 I/O interface chip, which
                        \ are memory-mapped to the 16 bytes from &DC00 to &DC0F
                        \ (see page 428 of the Programmer's Reference Guide)

 CIA2 = &DD00           \ Registers for the CIA2 I/O interface chip, which
                        \ are memory-mapped to the 16 bytes from &DD00 to &DD0F
                        \ (see page 428 of the Programmer's Reference Guide)

\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &0018 to &001B
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

 ORG &0018

.ZP

 SKIP 2                 \ Stores addresses used for moving content around

.ZP2

 SKIP 2                 \ Stores addresses used for moving content around

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

\ ******************************************************************************
\
\       Name: W%
\       Type: Variable
\   Category: Utility routines
\    Summary: Denotes the start of the first block of loader code, as used in
\             the encryption/decryption process
\
\ ******************************************************************************

.W%

 SKIP 0

\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for recursive tokens, the game font and ship
\             blueprints
\
\ ******************************************************************************

.LODATA

 INCBIN "versions/c64/3-assembled-output/LODATA.bin"

.SHIPS

 INCBIN "versions/c64/3-assembled-output/SHIPS.bin"

IF _GMA85_NTSC OR _GMA86_PAL

 EQUB &1F, &3F          \ These bytes appear to be unused and just contain
 EQUB &58               \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISK_BUILD

 EQUB &B3, &1F, &3F, &58, &98, &A0, &40, &20   \ These bytes appear to be
 EQUB &1F, &F0, &8C, &98, &1A, &46, &10, &8C   \ unused and just contain random
 EQUB &CF, &3C, &B2, &CF, &C2, &7D, &FF, &2A   \ workspace noise left over from
 EQUB &92, &AB, &A8, &BD, &3E, &85, &9E, &19   \ the BBC Micro assembly process
 EQUB &85, &F5, &3A, &EF, &06, &E6, &E4, &04
 EQUB &07, &E7, &E5, &EA, &AA, &2E, &98, &2F
 EQUB &10, &F0, &E2, &02, &12, &F2, &E3, &03
 EQUB &DA, &BA, &E4, &04, &DB, &BB, &E5, &19
 EQUB &39, &85, &25, &2E, &98, &3A, &BB, &B0
 EQUB &12, &13, &03, &E3, &F3, &F2, &E2, &7D
 EQUB &1A, &B2, &5D, &02, &E2, &F0, &10, &03
 EQUB &E3, &F2, &8D, &1A, &B2, &40, &78, &2F
 EQUB &E4, &01, &2C, &ED, &E3, &21, &2B, &5C
 EQUB &52, &22, &A8, &CB, &07, &2E, &DB, &BB
 EQUB &E5, &05, &DC, &BC

ELIF _SOURCE_DISK_FILES

 EQUB &38, &E0, &60, &3F, &0F, &7C, &24, &B2   \ These bytes appear to be
 EQUB &60, &56, &9C, &67, &23, &FA, &81, &91   \ unused and just contain random
 EQUB &3F, &7C, &29, &BC, &3D, &53, &65, &FB   \ workspace noise left over from
 EQUB &C3, &23, &B7, &9E, &7A, &2F, &29, &F5   \ the BBC Micro assembly process
 EQUB &EC, &CA, &E8, &0B, &EE, &CC, &CF, &94
 EQUB &D8, &C6, &C7, &3F, &00, &D2, &E4, &14
 EQUB &04, &D5, &E6, &DD, &94, &9E, &E8, &DF
 EQUB &96, &A0, &FE, &52, &BE, &AA, &53, &C6
 EQUB &D2, &F5, &6B, &C2, &25, &16, &E6, &D6
 EQUB &E5, &D4, &5F, &A3, &E5, &1D, &60, &E4
 EQUB &D2, &00, &13, &E6, &D5, &7F, &B3, &E5
 EQUB &00, &B9, &A7, &13, &E5, &2D, &19, &D0
 EQUB &04, &4C, &87, &AE, &74, &CA, &73, &D2
 EQUB &35, &09, &96, &A0, &EA, &E1, &98, &A2
 EQUB &66, &AE, &C6, &04

ENDIF

\ ******************************************************************************
\
\       Name: X%
\       Type: Variable
\   Category: Utility routines
\    Summary: Denotes the end of the first block of loader code, as used in the
\             encryption/decryption process
\
\ ******************************************************************************

.X%

 SKIP 0

\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

 JMP &0185

.FRIN

 JSR &0134

.ENTRY

 CLD
 LDA #LO(U%-1)
 STA FRIN
 LDA #HI(U%-1)
 STA FRIN+1
 LDA #HI(V%-1)
 LDY #LO(V%-1)
 LDX #KEY3
 JSR DEEORS
 LDA #LO(W%-1)
 STA FRIN
 LDA #HI(W%-1)
 STA FRIN+1
 LDA #HI(X%-1)
 LDY #LO(X%-1)
 LDX #KEY4
 JSR DEEORS
 JMP U%

\ ******************************************************************************
\
\       Name: DEEORS
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.DEEORS

 STX ZP2
 STA ZP+1
 LDA #0
 STA ZP

.DEEORL

 LDA (ZP),Y
 SEC
 SBC ZP2
 STA (ZP),Y
 STA ZP2
 TYA
 BNE P%+4
 DEC ZP+1
 DEY
 CPY FRIN
 BNE DEEORL
 LDA ZP+1
 CMP FRIN+1
 BNE DEEORL
 RTS

\ ******************************************************************************
\
\       Name: U%
\       Type: Variable
\   Category: Utility routines
\    Summary: Denotes the start of the second block of loader code, as used in
\             the encryption/decryption process
\
\ ******************************************************************************

.U%

 SKIP 0

\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

 LDX #&16               \ ???
 LDA #0
 STA ZP
 LDA #&7
 STA ZP+1
 LDA #LO(LODATA)
 STA ZP2
 LDA #HI(LODATA)
 JSR mvblock

 SEI                    \ Disable interrupts while we set the 6510 input/output
                        \ port register and configure the VIC-II chip

 LDA L1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ L1 to %100 to set the input/output port to the
 ORA #%00000100         \ following:
 STA L1                 \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ and return from the subroutine using a tail call
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

IF _GMA85_NTSC OR _GMA86_PAL

 LDX #&29               \ ???

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 LDX #&20

ENDIF

 LDA #LO(D%)
 STA ZP
 LDA #HI(D%)
 STA ZP+1
 LDA #LO(SHIPS)
 STA ZP2
 LDA #HI(SHIPS)
 JSR mvblock

 LDA L1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ L1 to %101 to set the input/output port to the
 ORA #%00000101         \ following:
 STA L1                 \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

 LDA CIA2+2             \ Set bits 0-1 of CIA2 port A to the output direction
 ORA #%00000011         \ so we can write to the VIC-II bank selector, which is
 STA CIA2+2             \ mapped here (0 means input, 1 means output)

 LDA CIA2+0             \ Set bits 0-1 of CIA2 port A to configure the VIC-II to
 AND #%11111100         \ use bank 1 (&4000 to &7FFF)
 ORA #%00000010         \
 STA CIA2+0             \ The bank number is inverted, so setting bits 0-1 to
                        \ %10 actually sets bank %01

 LDA #%00000011         \ Set CIA1 register &0D to enable and disable interrupts
 STA CIA+&D             \ as follows:
                        \
                        \   * Bit 0 set = configure interrupts generated by
                        \                 timer A underflow
                        \
                        \   * Bit 1 set = configure interrupts generated by
                        \                 timer B underflow
                        \
                        \   * Bits 2-4 clear = do not change configuration of
                        \                      other interrupts
                        \
                        \   * Bit 7 clear = disable interupts whose
                        \                   corresponding bits are set
                        \
                        \ So this disables interrupts that are generated by
                        \ timer A underflow and timer B underflow, while leaving
                        \ other interrupts as they are

 STA CIA2+&D            \ Set CIA2 register &0D to enable and disable interrupts
                        \ as follows:
                        \
                        \   * Bit 0 set = configure interrupts generated by
                        \                 timer A underflow
                        \
                        \   * Bit 1 set = configure interrupts generated by
                        \                 timer B underflow
                        \
                        \   * Bits 2-4 clear = do not change configuration of
                        \                      other interrupts
                        \
                        \   * Bit 7 clear = disable interupts whose
                        \                   corresponding bits are set
                        \
                        \ So this disables interrupts that are generated by
                        \ timer A underflow and timer B underflow, while leaving
                        \ other interrupts as they are

 LDA #&81               \ Set VIC register &18 to set the address of screen RAM
 STA VIC+&18            \ to offset &2000 within the VIC-II bank at &4000 (so
                        \ the screen's colour data is at &6000)

 LDA #0                 \ ???
 STA VIC+&20 \Border Colour
 LDA #0
 STA VIC+&21 \Background Col 0
 LDA #&3B
 STA VIC+&11
 LDA #&C0
 STA VIC+&16 \Set HIRES

 LDA #%00000000         \ Clear bits 0 to 7 of VIC register &15 to disable all
 STA VIC+&15            \ eight sprites

 LDA #9                 \ ???
 STA VIC+&29
 LDA #12
 STA VIC+&2A
 LDA #6
 STA VIC+&2B
 LDA #1
 STA VIC+&2C
 LDA #5
 STA VIC+&2D
 LDA #9
 STA VIC+&2E \Sprite Cols
 LDA #8
 STA VIC+&25
 LDA #7
 STA VIC+&26 \Sprite Multicol Regs
 LDA #0
 STA VIC+&1C \Sprites Hires
 LDA #&FF
 STA VIC+&17
 STA VIC+&1D \Expand Sprites
 LDA #0
 STA VIC+&10 \Sprites X Coord high bits
 LDX #&A1
 LDY #&65
 STX VIC+0
 STY VIC+1
 LDA #18
 LDY #12
 STA VIC+2
 STY VIC+3
 ASL A
 STA VIC+4
 STY VIC+5
 ASL A
 STA VIC+6
 STY VIC+7
 ASL A
 STA VIC+8
 STY VIC+9
 LDA #14
 STA VIC+10
 STY VIC+11
 ASL A
 STA VIC+12
 STY VIC+13
 ASL A
 STA VIC+14
 STY VIC+15 \Sprite coords
 LDA #2
 STA VIC+&1B \Sprite Priority
 \.. .Screen Mems....
 LDA #0
 STA ZP
 TAY
 LDX #&40

.LOOP2

 STX ZP+1

.LOOP1

 STA (ZP),Y
 INY
 BNE LOOP1
 LDX ZP+1
 INX
 CPX #&60
 BNE LOOP2 \Bit map region
 LDA #&10

.LOOP3

 STX ZP+1

.LOOP4

 STA (ZP),Y
 INY
 BNE LOOP4
 LDX ZP+1
 INX
 CPX #&68
 BNE LOOP3 \Screen Mem for upper screen
 LDA #LO(SCBASE+&2400+&2D0)
 STA ZP
 LDA #HI(SCBASE+&2400+&2D0)
 STA ZP+1
 LDA #LO(sdump)
 STA ZP2
 LDA #HI(sdump)
 JSR mvsm
\LDX #0
\.LOOP20
\LDA date,X
\STA SCBASE+&7A0,X
\DEX
\BNE LOOP20
 LDA #0
 STA ZP
 LDA #&60
 STA ZP+1
 LDX #25

.LOOP10

 LDA #&70
 LDY #36
 STA (ZP),Y
 LDY #3
 STA (ZP),Y
 DEY
 LDA #0

.frogl

 STA (ZP),Y
 DEY
 BPL frogl
 LDY #37
 STA (ZP),Y
 INY
 STA (ZP),Y
 INY
 STA (ZP),Y
 LDA ZP
 CLC
 ADC #40
 STA ZP
 BCC P%+4
 INC ZP+1
 DEX
 BNE LOOP10
 LDA #0
 STA ZP
 LDA #&64
 STA ZP+1
 LDX #18

.LOOP11

 LDA #&70
 LDY #36
 STA (ZP),Y
 LDY #3
 STA (ZP),Y
 DEY
 LDA #0

.newtl

 STA (ZP),Y
 DEY
 BPL newtl
 LDY #37
 STA (ZP),Y
 INY
 STA (ZP),Y
 INY
 STA (ZP),Y
 LDA ZP
 CLC
 ADC #40
 STA ZP
 BCC P%+4
 INC ZP+1
 DEX
 BNE LOOP11
 LDA #&70
 LDY #31

.LOOP16

 STA &63C4,Y
 DEY
 BPL LOOP16 \Bottom Row Yellow
 LDA #0
 STA ZP
 TAY
 LDX #HI(COLMEM)
 STX ZP+1
 LDX #4

.LOOP19

 STA (ZP),Y
 INY
 BNE LOOP19
 INC ZP+1
 DEX
 BNE LOOP19
 LDA #LO(COLMEM+&2D0)
 STA ZP
 LDA #HI(COLMEM+&2D0)
 STA ZP+1
 LDA #LO(cdump)
 STA ZP2
 LDA #HI(cdump)
 JSR mvsm
 LDY #34
 LDA #7

.LOOP15

 STA COLMEM+2,Y
 DEY
 BNE LOOP15

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #&A0

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 LDA #&C4

ENDIF

 STA &63F8
 STA &67F8

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #&A4

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 LDA #&C8

ENDIF

 STA &63F9
 STA &67F9

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #&A5

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 LDA #&C9

ENDIF

 STA &63FA
 STA &67FA
 STA &63FC
 STA &67FC
 STA &63FE
 STA &67FE

IF _GMA85_NTSC OR _GMA86_PAL

 LDA #&A6

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 LDA #&CA

ENDIF

 STA &63FB
 STA &67FB
 STA &63FD
 STA &67FD
 STA &63FF
 STA &67FF \Sprite Pointers
 LDA L1
 AND #&F8
 ORA #6
 STA L1 \hiram=1, loram=0  (page KERNAL etc)
 CLI
 LDX #9
 LDA #LO(DSTORE%)
 STA ZP
 LDA #HI(DSTORE%)
 STA ZP+1
 LDA #LO(DIALS)
 STA ZP2
 LDA #HI(DIALS)
 JSR mvblock
 LDY #0

.LOOP12

 LDA spritp,Y
 STA SPRITELOC%,Y
 DEY
 BNE LOOP12

.LOOP13

 LDA spritp+&100,Y
 STA SPRITELOC%+&100,Y
 DEY
 BNE LOOP13
 JMP &CE0E

\ ******************************************************************************
\
\       Name: mvblock
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.mvblock

 STA ZP2+1
 LDY #0

.LOOP5

 LDA (ZP2),Y
 STA (ZP),Y
 DEY
 BNE LOOP5
 INC ZP2+1
 INC ZP+1
 DEX
 BNE LOOP5
 RTS

.mvsm LDX#1

 JSR mvblock
 LDY #&17
 LDX #1

\was JMPLOOP5

.LOOP5new

 LDA (ZP2),Y
 STA (ZP),Y
 DEY
 BPL LOOP5new
 LDX #0
 RTS  \<<

\ ******************************************************************************
\
\       Name: sdump
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Screen RAM colour data for the dashboard
\
\ ------------------------------------------------------------------------------
\
\ The sdump and cdump variables contain screen and colour RAM that sets the
\ default colours for the dashboard
\
\ The dashboard section of the screen is in multicolour bitmap mode, which gives
\ four colours at a resolution of 160x200 pixels. The colour of each character
\ block is determined by the contents of screen and colour RAM, and the sdump
\ and cdump tables contain the colour data that is copied to screen and colour
\ RAM for the dashboard.
\
\ The colour data in sdump gets copied to SCBASE + &2400 + &2D0 in screen RAM by
\ part 3 of the loader. This is the memory layout of screen memory for Elite:
\
\   :                                   :
\   |                                   |
\   +-----------------------------------+   &6800
\   |                                   |
\   | Screen RAM for space view (1K)    |
\   |                                   |
\   +-----------------------------------+   &6400
\   |                                   |
\   | Screen RAM for text view (1K)     |
\   |                                   |
\   +-----------------------------------+   &6000
\   |                                   |
\   | Screen bitmap (8K, &2000 bytes)   |
\   |                                   |
\   +-----------------------------------+   &4000 = SCBASE
\   |                                   |
\   :                                   :
\
\ SCBASE + &2400 part is therefore the address of screen RAM for the space view.
\ The dashboard starts on character row 18 of the space view, so the offset of
\ the start of the dashboard within screen RAM is 18 * 40 = 720 = &2D0. We
\ therefore copy sdump to SCBASE + &2400 + &2D0 to set the colour data for the
\ dashboard in the space view.
\
\ As the space view is in multicolour bitmap mode, colour data is also stored in
\ colour RAM at COLMEM. As with screen RAM, the dashboard starts at offset &2D0,
\ so part 3 of the loader also copies cdump to COLMEM + &2D0.
\
\ The sdump and cdump tables in the loader binary are built in the original
\ source code by a BBC BASIC program called S.COMLODS. This takes a set of DATA
\ statements that describe the colour layout of the dashboard, and creates the
\ data for sdump and cdump. BeebAsm isn't as flexible as BBC BASIC, so instead
\ we have to stick to EQUB statements, but here are the data statements for
\ reference:
\
\   REM 'Yellow' Screen Mem low nybble
\   REM   |.....,||,.....||......||.....,||,.....|
\   DATA "0007774444777777777777777777777777777000"
\   DATA "0007774444777777777777777777773333777000"
\   DATA "0007779999777777777777777777773333777000"
\   DATA "0007778888777777777777777777774444777000"
\   DATA "000777AAAA777777777777777777774444777000"
\   DATA "000777DDDD777777777777777777774444777000"
\   DATA "0007777777777777777777777777774444777000"
\
\   REM 'Red' Screen Mem high nybble
\   REM   |.....,||,.....||......||.....,||,.....|
\   DATA "0000117777222222222222222222622222330000"
\   DATA "0000112222222222222222222266662222330000"
\   DATA "0000332222222222222222222222622222330000"
\   DATA "0000332222222222222222222222222222110000"
\   DATA "0000332222222222222222222222222222110000"
\   DATA "0000332222202222222222222222022222110000"
\   DATA "0000CC0000202222222222222222022222110000"
\
\   REM 'Green' Colour Mem nybble
\   REM   |.....,||,.....||......||.....,||,.....|
\   DATA "0000555555DDDDDDDDDDDDDDDD55555555550000"
\   DATA "0000555555DDDDDDDDDDDDDDDD55555555550000"
\   DATA "0000555555DDDDDDDDDDDDDDDD55555555550000"
\   DATA "0000555555DDDDDDDDDDDDDDDDD5555555550000"
\   DATA "0000555555DDDDDDDDDDDDDDDDDDDD5555550000"
\   DATA "0000555555DDDDDDDDDDDDDDDDDDDD5555550000"
\   DATA "0000FF7777DDDDDDD33333DDDDDDDD7777550000"
\
\ and these are the Commodore 64 colours (so a 7 in the above denotes yellow,
\ for example):
\
\   * &0 = black
\   * &1 = white
\   * &2 = red
\   * &3 = cyan
\   * &4 = purple
\   * &5 = green
\   * &6 = blue
\   * &7 = yellow
\   * &8 = orange
\   * &9 = brown
\   * &A = pink
\   * &B = dark grey
\   * &C = grey
\   * &D = light green
\   * &E = light blue
\   * &F = light grey 
\
\ The data in sdump is formed from the first two tables, with the digit from the
\ first table in the low nibble and the second table in the high nibble. The
\ data in cdump takes the third table as the low nibble and sets 0 as the high
\ nibble.
\
\ Because of the way colour data works in multicolour bitmap mode, this means
\ that:
\
\   * The first table defines the colour of %10 in the bitmap in each character
\     block.
\
\   * The second table defines the colour of %01 in the bitmap in each character
\     block.
\
\   * The third table defines the colour of %11 in the bitmap in each character
\     block.
\
\ As an example, look at the left side of the first table. The "000777" at the
\ start of each line covers the left margin and the indicator labels, but the
\ interesting part is the next four character blocks, which cover the bars in
\ the indicators. The top two are "4444", then we have "9999", "8888", "AAAA"
\ and "DDDD"; these make the two shield bars purple (4), the fuel bar brown (9),
\ the cabin temperature bar orange (8), the laser temperature bar pink (A) and
\ the altitude bar light green (D).
\
\ In the original source, the colour comments refer to the predominant colours,
\ so the first table defines %10 as yellow (7) for the bulk of the scanner, the
\ second table defines %01 as red (2) in a similar way, and the third table
\ defines %11 as green (5) for the indicator scale lines down the side of the
\ dashboard.
\
\ ******************************************************************************

.sdump

 EQUB &00, &00, &00, &07, &17, &17, &74, &74
 EQUB &74, &74, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &67, &27, &27, &27
 EQUB &27, &27, &37, &37, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &17, &17, &24, &24
 EQUB &24, &24, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &67, &67, &67, &67, &23, &23
 EQUB &23, &23, &37, &37, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &29, &29
 EQUB &29, &29, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &67, &27, &23, &23
 EQUB &23, &23, &37, &37, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &28, &28
 EQUB &28, &28, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &2A, &2A
 EQUB &2A, &2A, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &37, &37, &2D, &2D
 EQUB &2D, &2D, &27, &07, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &07, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00
 EQUB &00, &00, &00, &07, &C7, &C7, &07, &07
 EQUB &07, &07, &27, &07, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &27, &27, &27, &27
 EQUB &27, &27, &27, &27, &07, &27, &24, &24
 EQUB &24, &24, &17, &17, &07, &00, &00, &00

IF _GMA85_NTSC OR _GMA86_PAL

 EQUB &60, &D3          \ These bytes appear to be unused and just contain
 EQUB &66, &1D          \ random workspace noise left over from the BBC Micro
 EQUB &A0, &40          \ assembly process
 EQUB &B3, &D3

ELIF _SOURCE_DISK_BUILD

 EQUB &B4, &48          \ These bytes appear to be unused and just contain
 EQUB &9F, &CD          \ random workspace noise left over from the BBC Micro
 EQUB &EA, &11          \ assembly process
 EQUB &F1, &19

ELIF _SOURCE_DISK_FILES

 EQUB &99, &02          \ These bytes appear to be unused and just contain
 EQUB &E5, &6B          \ random workspace noise left over from the BBC Micro
 EQUB &26, &B9          \ assembly process
 EQUB &37, &D7

ENDIF

\ ******************************************************************************
\
\       Name: cdump
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Colour RAM colour data for the dashboard
\
\ ------------------------------------------------------------------------------
\
\ See the sdump variable for an explanation of the cdump colour data.
\
\ ******************************************************************************

.cdump

 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &0F, &0F, &07, &07
 EQUB &07, &07, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &03, &03, &03, &03, &03, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &07, &07
 EQUB &07, &07, &05, &05, &00, &00, &00, &00

IF _GMA85_NTSC OR _GMA86_PAL

 EQUB &8D, &18          \ These bytes appear to be unused and just contain
 EQUB &8F, &50          \ random workspace noise left over from the BBC Micro
 EQUB &46, &7E          \ assembly process
 EQUB &A4, &F4

ELIF _SOURCE_DISK_BUILD

 EQUB &B3, &56          \ These bytes appear to be unused and just contain
 EQUB &2B, &6B          \ random workspace noise left over from the BBC Micro
 EQUB &74, &D4          \ assembly process
 EQUB &D8, &FF

ELIF _SOURCE_DISK_FILES

 EQUB &00, &FB          \ These bytes appear to be unused and just contain
 EQUB &0E, &F3          \ random workspace noise left over from the BBC Micro
 EQUB &79, &7D          \ assembly process
 EQUB &48, &96

ENDIF

\ ******************************************************************************
\
\       Name: spritp
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.spritp

 INCBIN "versions/c64/3-assembled-output/SPRITE.bin"

IF _GMA85_NTSC OR _GMA86_PAL

 EQUB &38, &35, &25, &67, &FA, &B5, &A5, &A2   \ These bytes appear to be
 EQUB &22, &C1, &DF, &EB, &77, &CE, &F4, &07   \ unused and just contain random
 EQUB &37, &CF, &33, &4D, &A5, &89, &76, &CD   \ workspace noise left over from
 EQUB &6D, &69, &8D, &56, &CD, &94, &98, &F6   \ the BBC Micro assembly process
 EQUB &B8, &CE, &14, &13, &D1, &98, &CE, &B1
 EQUB &77, &CE, &F4, &1C, &B1, &40, &68, &30
 EQUB &87, &CD, &A9, &90, &B2, &08, &C1, &DB
 EQUB &CF, &33, &49, &80, &6B, &CA, &3A, &CF

ELIF _SOURCE_DISK_BUILD

 EQUB &97, &F3, &4F, &73, &B6, &DB, &39, &7A   \ These bytes appear to be
 EQUB &56, &EE, &F5, &D3, &4F, &E4, &C4, &F5   \ unused and just contain random
 EQUB &FE, &05, &D3, &4F, &68, &91, &3E, &F9   \ workspace noise left over from
 EQUB &00, &D3, &4F, &27, &53, &41, &F6, &FD   \ the BBC Micro assembly process
 EQUB &D6, &26, &CB, &24, &C5, &ED, &14, &3C
 EQUB &E9, &F0, &D3, &4F, &62, &8E, &41, &F1
 EQUB &F8, &D3, &4F, &30, &5F, &44, &05, &0C
 EQUB &D3, &4F, &68, &99, &A1, &CB, &B7, &34

ELIF _SOURCE_DISK_FILES

 EQUB &DC, &80, &1F, &87, &29, &80, &80, &E3   \ These bytes appear to be
 EQUB &8A, &42, &CE, &41, &9D, &20, &CB, &DC   \ unused and just contain random
 EQUB &44, &E3, &C8, &22, &33, &A8, &B9, &F3   \ workspace noise left over from
 EQUB &03, &D8, &22, &B7, &F9, &CF, &37, &F9   \ the BBC Micro assembly process
 EQUB &D3, &22, &76, &7A, &94, &37, &F3, &D3
 EQUB &FC, &F1, &EF, &E9, &B2, &01, &50, &25
 EQUB &D9, &C3, &22, &B1, &F0, &CF, &32, &E9
 EQUB &CB, &22, &7F, &8F, &A3, &49, &11, &48

ENDIF

\ ******************************************************************************
\
\       Name: date
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.date

IF _GMA85_NTSC OR _GMA86_PAL

  EQUB &33, &8D, &49, &EA, &53, &29, &2C, &2F   \ These bytes appear to be
  EQUB &87, &C4, &A0, &70, &96, &90, &B3, &38   \ unused and just contain random
  EQUB &B9, &53, &9A, &91, &AE, &2E, &70, &F8   \ workspace noise left over from
  EQUB &C8, &1B, &7C, &A1, &D1, &37, &2B, &4C   \ the BBC Micro assembly process
  EQUB &97, &F3, &4F, &73, &AD, &D2, &39, &71   \
  EQUB &4D, &EE, &F5, &D3, &4F, &E7, &C7, &F5   \ They contain part of the
  EQUB &FE, &05, &D3, &4F, &68, &88, &35, &F9   \ encrypted HICODE binary, from
  EQUB &00, &D3, &4F, &27, &4A, &38, &F6, &FD   \ file offset &1C8A to &1D89,
  EQUB &D6, &26, &CB, &1B, &BC, &ED, &0B, &33   \ from when it was assembled in
  EQUB &E9, &F0, &D3, &4F, &62, &85, &38, &F1   \ memory
  EQUB &F8, &D3, &4F, &30, &56, &3B, &05, &0C
  EQUB &D3, &4F, &68, &90, &98, &CB, &B7, &34
  EQUB &ED, &01, &08, &D3, &4F, &07, &2F, &3D
  EQUB &D1, &D8, &D3, &4F, &62, &83, &36, &DB
  EQUB &E2, &DB, &2B, &07, &71, &1A, &93, &4F
  EQUB &F8, &34, &D4, &33, &6F, &51, &CE, &D5
  EQUB &EA, &66, &8D, &AF, &37, &04, &2B, &FE
  EQUB &D7, &03, &2A, &F7, &D0, &06, &0D, &DB
  EQUB &AD, &A5, &2F, &CE, &A4, &2E, &CE, &A3
  EQUB &4D, &06, &60, &D2, &5B, &BC, &9D, &13
  EQUB &4F, &A8, &CD, &3A, &F7, &1E, &3E, &17
  EQUB &F4, &FB, &DD, &B2, &4C, &97, &35, &EA
  EQUB &45, &C9, &E9, &B0, &2F, &8B, &12, &F7
  EQUB &B6, &8B, &AB, &45, &C9, &E9, &B0, &06
  EQUB &BB, &0B, &36, &E2, &B7, &AB, &CF, &E3
  EQUB &EA, &D9, &29, &A2, &F1, &8F, &B5, &D3
  EQUB &8A, &CE, &F1, &8F, &75, &C4, &14, &0B
  EQUB &56, &0A, &E0, &2B, &35, &E6, &BC, &0C
  EQUB &30, &EA, &44, &96, &1B, &AE, &8A, &EA
  EQUB &0B, &0C, &86, &44, &96, &38, &2C, &36
  EQUB &D3, &4F, &29, &50, &D3, &05, &45, &C9
  EQUB &E9, &B0, &E9, &19, &B5, &0B, &FB, &B9

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_FILES

 INCBIN "versions/c64/1-source-files/images/C.DATE4.bin"

ENDIF

\ ******************************************************************************
\
\       Name: DIALS
\       Type: Variable
\   Category: Drawing the screen
\    Summary: ???
\
\ ******************************************************************************

.DIALS

 SKIP 24

 INCBIN "versions/c64/1-source-files/images/C.CODIALS.bin"

IF _GMA85_NTSC OR _GMA86_PAL

 EQUB &F5               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISK_BUILD

 EQUB &B2               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

ELIF _SOURCE_DISK_FILES

 EQUB &DB               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

ENDIF

\ ******************************************************************************
\
\       Name: V%
\       Type: Variable
\   Category: Utility routines
\    Summary: Denotes the end of the second block of loader code, as used in the
\             encryption/decryption process
\
\ ******************************************************************************

.V%

 SKIP 0

\ ******************************************************************************
\
\ Save COMLOD.unprot.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 PRINT "S.C.COMLOD ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
 SAVE "versions/c64/3-assembled-output/COMLOD.unprot.bin", CODE%, P%, LOAD%

 PRINT "Addresses for the scramble routines in elite-checksum.py"
 PRINT "W% = ", ~W%
 PRINT "X% = ", ~X%
 PRINT "U% = ", ~U%
 PRINT "V% = ", ~V%

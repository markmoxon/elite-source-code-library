\ ******************************************************************************
\
\ NES ELITE GAME SOURCE (BANK 7)
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
\ This source file produces the following binary file:
\
\   * bank7.bin
\
\ ******************************************************************************

 INCLUDE "versions/nes/1-source-files/main-sources/elite-bank-options.asm"

IF _BANK = 7

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

 INCLUDE "versions/nes/1-source-files/main-sources/elite-source-common.asm"

ENDIF

\ ******************************************************************************
\
\ ELITE BANK 7
\
\ Produces the binary file bank7.bin.
\
\ ******************************************************************************

 CODE_BANK_7% = &C000
 LOAD_BANK_7% = &C000

 ORG CODE_BANK_7%

\INCLUDE "library/nes/main/subroutine/resetmmc1.asm"

\ ******************************************************************************
\
\       Name: ResetMMC1_b7
\       Type: Variable
\   Category: Start and end
\    Summary: The MMC1 mapper reset routine at the start of the ROM bank
\
\ ------------------------------------------------------------------------------
\
\ When the NES is switched on, it is hardwired to perform a JMP (&FFFC). At this
\ point, there is no guarantee as to which ROM banks are mapped to &8000 and
\ &C000, so to ensure that the game starts up correctly, we put the same code
\ in each ROM at the following locations:
\
\   * We put &C000 in address &FFFC in every ROM bank, so the NES always jumps
\     to &C000 when it starts up via the JMP (&FFFC), irrespective of which
\     ROM bank is mapped to &C000.
\
\   * We put the same reset routine at the start of every ROM bank, so the same
\     routine gets run, whichever ROM bank is mapped to &C000.
\
\ This reset routine is therefore called when the NES starts up, whatever the
\ bank configuration ends up being. It then switches ROM bank 7 to &C000 and
\ jumps into bank 7 at the game's entry point S%, which starts the game.
\
\ We need to give a different label to this version of the reset routine so we
\ can assemble bank 7 at the same time as banks 0 to 6, to enable the lower
\ banks to see the exported addresses for bank 7.
\
\ ******************************************************************************

.ResetMMC1_b7

 SEI                    \ Disable interrupts

 INC &C006              \ Reset the MMC1 mapper, which we can do by writing a
                        \ value with bit 7 set into any address in ROM space
                        \ (i.e. any address from &8000 to &FFFF)
                        \
                        \ The INC instruction does this in a more efficient
                        \ manner than an LDA/STA pair, as it:
                        \
                        \   * Fetches the contents of address &C006, which
                        \     contains the high byte of the JMP destination
                        \     below, i.e. the high byte of S%, which is &C0
                        \
                        \   * Adds 1, to give &C1
                        \
                        \   * Writes the value &C1 back to address &C006
                        \
                        \ &C006 is in the ROM space and &C1 has bit 7 set, so
                        \ the INC does all that is required to reset the mapper,
                        \ in fewer cycles and bytes than an LDA/STA pair
                        \
                        \ Resetting MMC1 maps bank 7 to &C000 and enables the
                        \ bank at &8000 to be switched, so this instruction
                        \ ensures that bank 7 is present

 JMP S%                 \ Jump to S% in bank 7 to start the game

\ ******************************************************************************
\
\       Name: S%
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.S%

 SEI

 CLD

 LDX #&FF
 TXS

 LDX #0
 STX startupDebug

 LDA #%00010000
 STA PPU_CTRL

 STA ppuCtrlCopy

 LDA #0
 STA PPU_MASK

.sper1

 LDA PPU_STATUS
 BPL sper1

.sper2

 LDA PPU_STATUS
 BPL sper2

.sper3

 LDA PPU_STATUS
 BPL sper3

 LDA #&00
 STA K%
 LDA #&3C
 STA K%+1

.CC035

 LDX #&FF
 TXS

 JSR ResetVariables

 JMP ShowStartScreen

\ ******************************************************************************
\
\       Name: ResetVariables
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ResetVariables

 LDA #0
 STA PPU_CTRL

 STA ppuCtrlCopy

 STA PPU_MASK

 STA setupPPUForIconBar

 LDA #&40
 STA JOY2

 INC &C006

 LDA PPU_STATUS

.resv1

 LDA PPU_STATUS
 BPL resv1

.resv2

 LDA PPU_STATUS
 BPL resv2

.resv3

 LDA PPU_STATUS
 BPL resv3

 LDA #0
 TAX

.resv4

 STA ZP,X

 INX

 BNE resv4

 LDA #3
 STA SC+1
 LDA #0
 STA SC

 TXA

 LDX #3

 TAY

.resv5

 STA (SC),Y

 INY

 BNE resv5

 INC SC+1

 DEX

 BNE resv5

 JSR SetupMMC1

 JSR ResetSoundL045E

 LDA #&80
 ASL A

 JSR DrawTitleScreen_b3

 JSR ResetDrawingPlane

 JSR ResetBuffers

 LDA #0
 STA DTW6

 LDA #&FF
 STA DTW2

 LDA #&FF
 STA DTW8

\ ******************************************************************************
\
\       Name: SetBank0
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page bank 0 into memory at &8000
\
\ ******************************************************************************

.SetBank0

 LDA #0
 JMP SetBank

\ ******************************************************************************
\
\       Name: SetNonZeroBank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page a specified bank into memory at &8000, but only if it is
\             non-zero
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the bank to page into memory at &8000
\
\ ******************************************************************************

.SetNonZeroBank

 CMP currentBank
 BNE SetBank

 RTS

\ ******************************************************************************
\
\       Name: ResetBank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Retrieve a bank number from the stack and page that bank into
\             memory at &8000
\
\ ******************************************************************************

.ResetBank

 PLA

\ ******************************************************************************
\
\       Name: SetBank
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page a specified bank into memory at &8000
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the bank to page into memory at &8000
\
\ ******************************************************************************

.SetBank

 DEC runningSetBank

 STA currentBank

 STA &FFFF
 LSR A
 STA &FFFF
 LSR A
 STA &FFFF
 LSR A
 STA &FFFF
 LSR A
 STA &FFFF

 INC runningSetBank

 BNE CC0CA

 RTS

.CC0CA

 LDA #0
 STA runningSetBank

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 TXA
 PHA
 TYA
 PHA

 JSR PlayMusic_b6

 PLA
 TAY
 PLA
 TAX

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: LC0DF
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LC0DF

 EQUB   6,   6,   7,   7

\ ******************************************************************************
\
\       Name: LC0E3
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LC0E3

 EQUB &0B,   9, &0D, &0A

IF _NTSC

 EQUB &20, &20, &20, &20                      ; C0DF: 06 06 07... ...
 EQUB &10,   0, &C4, &ED, &5E, &E5, &22, &E5  ; C0EB: 10 00 C4... ...
 EQUB &22,   0,   0, &ED, &5E, &E5, &22,   9  ; C0F3: 22 00 00... "..
 EQUB &68,   0,   0,   0,   0                 ; C0FB: 68 00 00... h..

ELIF _PAL

 EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
 EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
 EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
 EQUB &FF

ENDIF

INCLUDE "library/advanced/main/variable/log.asm"
INCLUDE "library/advanced/main/variable/logl.asm"
INCLUDE "library/advanced/main/variable/antilog-alogh.asm"
INCLUDE "library/6502sp/main/variable/antilogodd.asm"
INCLUDE "library/common/main/variable/sne.asm"
INCLUDE "library/common/main/variable/act.asm"
INCLUDE "library/common/main/variable/xx21.asm"

\ ******************************************************************************
\
\       Name: BarNametableToPPU
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send the nametable entries for the icon bar to the PPU
\
\ ------------------------------------------------------------------------------
\
\ Nametable data for the icon bar is sent to PPU nametables 0 and 1.
\ 
\ ******************************************************************************

.BarNametableToPPU

 SUBTRACT_CYCLES 2131   \ Subtract 2131 from the cycle count

 LDX iconBarOffset      \ Set X to the low byte of iconBarOffset(1 0), to use in
                        \ the following calculations

 STX dataForPPU         \ Set dataForPPU(1 0) = nameBuffer0 + iconBarOffset(1 0)
 LDA iconBarOffset+1    \
 CLC                    \ So dataForPPU(1 0) points to the entry in nametable
 ADC #HI(nameBuffer0)   \ buffer 0 for the start of the icon bar (the addition
 STA dataForPPU+1       \ works because the low byte of nameBuffer0 is 0)

 LDA iconBarOffset+1    \ Set (A X) = PPU_NAME_0 + iconBarOffset(1 0)
 ADC #HI(PPU_NAME_0)    \
                        \ The addition works because the low byte of PPU_NAME_0
                        \ is 0

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \              = PPU_NAME_0 + iconBarOffset(1 0)
                        \
                        \ So PPU_ADDR points to the tile entry in the PPU's
                        \ nametable 0 for the start of the icon bar

 LDY #0                 \ We now send the nametable entries for the icon bar to
                        \ the PPU's nametable 0, so set a counter in Y

.ibar1

 LDA (dataForPPU),Y     \ Send the Y-th nametable entry from dataForPPU(1 0) to
 STA PPU_DATA           \ the PPU

 INY                    \ Increment the loop counter

 CPY #2*32              \ Loop back until we have sent 2 rows of 32 tiles
 BNE ibar1

 LDA iconBarOffset+1    \ Set (A X) = PPU_NAME_1 + iconBarOffset(1 0)
 ADC #HI(PPU_NAME_1-1)  \
                        \ The addition works because the low byte of PPU_NAME_1
                        \ is 0 and because the C flag is set (as we just passed
                        \ through the BNE above)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \              = PPU_NAME_1 + iconBarOffset(1 0)
                        \
                        \ So PPU_ADDR points to the tile entry in the PPU's
                        \ nametable 1 for the start of the icon bar

 LDY #0                 \ We now send the nametable entries for the icon bar to
                        \ the PPU's nametable 1, so set a counter in Y

.ibar2

 LDA (dataForPPU),Y     \ Send the Y-th nametable entry from dataForPPU(1 0) to
 STA PPU_DATA           \ the PPU

 INY                    \ Increment the loop counter

 CPY #2*32              \ Loop back until we have sent 2 rows of 32 tiles
 BNE ibar2

 LDA skipBarPatternsPPU \ If bit 7 of skipBarPatternsPPU is set, we do not send
 BMI ibar3              \ the pattern data to the PPU, so jump to ibar3 to skip
                        \ the following

 JMP BarPatternsToPPU   \ Bit 7 of skipBarPatternsPPU is clear, we do want to
                        \ send the icon bar's pattern data to the PPU, so jump
                        \ to BarPatternsToPPU to do just that, returning from
                        \ the subroutine using a tail call

.ibar3

 STA barPatternCounter  \ Set barPatternCounter = 128 so the NMI handler does
                        \ not send any more icon bar data to the PPU

 JMP ConsiderSendTiles  \ Jump to ConsiderSendTiles to start sending tiles to
                        \ the PPU, but only if there are enough free cycles

\ ******************************************************************************
\
\       Name: BarPatternsHiToPPU
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send tile pattern data 64-127 for the icon bar to the PPU, split
\             across multiple calls to the NMI handler if required
\
\ ------------------------------------------------------------------------------
\
\ Pattern data for icon bar patterns 64 to 127 is sent to PPU pattern table 0
\ only.
\
\ ******************************************************************************

.BarPatternsHiToPPU

 SUBTRACT_CYCLES 666    \ Subtract 666 from the cycle count

 BMI patt1              \ If the result is negative, jump to patt1 to stop
                        \ sending patterns in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP patt2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to patt2
                        \ to send the patterns

.patt1

 ADD_CYCLES 623         \ Add 623 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.patt2

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0
 STA dataForPPU

 LDA barPatternCounter  \ Set Y = (barPatternCounter mod 64) * 8
 ASL A                  \
 ASL A                  \ And set the C flag to the overflow bit
 ASL A                  \
 TAY                    \ The mod 64 part comes from the fact that we shift bits
                        \ 7 and 6 left out of A and discard them, so this is the
                        \ same as (barPatternCounter AND %00111111) * 8

 LDA #%00000001         \ Set addr4 = %0000001C
 ROL A                  \
 STA addr4              \ And clear the C flag (as it gets set to bit 7 of A)
                        \
                        \ So we now have the following:
                        \
                        \   (addr4 Y) = (2 0) + (barPatternCounter mod 64) * 8
                        \             = &0200 + (barPatternCounter mod 64) * 8
                        \             = 64 * 8 + (barPatternCounter mod 64) * 8
                        \             = (64 + barPatternCounter mod 64) * 8
                        \
                        \ We only call this routine when this is true:
                        \
                        \   64 < barPatternCounter < 128
                        \
                        \ in which case we know that:
                        \
                        \   64 + barPatternCounter mod 64 = barPatternCounter
                        \
                        \ So we if we substitute this into the above, we get:
                        \
                        \   (addr4 Y) = (10 + 64 + barPatternCounter mod 64) * 8
                        \             = barPatternCounter * 8

 TYA                    \ Set (A X) = (addr4 Y) + PPU_PATT_0 + &50
 ADC #&50               \           = PPU_PATT_0 + &50 + barPatternCounter * 8
 TAX                    \
                        \ Starting with the low bytes

 LDA addr4              \ And then the high bytes (this works because we know
 ADC #HI(PPU_PATT_0)    \ the low byte of PPU_PATT_0 is 0)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \           = PPU_PATT_0 + &50 + barPatternCounter * 8
                        \           = PPU_PATT_0 + (10 + barPatternCounter) * 8
                        \
                        \ So PPU_ADDR points to a pattern in PPU pattern table
                        \ 0, which is at address PPU_PATT_0 in the PPU
                        \ 
                        \ So it points to pattern 10 when barPatternCounter = 0,
                        \ and points to patterns 10 to 137 as barPatternCounter
                        \ increments from 0 to 127

 LDA iconBarImageHi     \ Set dataForPPU(1 0) = (iconBarImageHi 0) + (addr4 0)
 ADC addr4              \
 STA dataForPPU+1       \ We know from above that:
                        \
                        \   (addr4 Y) = &0200 + (barPatternCounter mod 64) * 8
                        \             = 64 * 8 + (barPatternCounter mod 64) * 8
                        \             = (64 + barPatternCounter mod 64) * 8
                        \             = barPatternCounter * 8
                        \
                        \ So this means that:
                        \
                        \   dataForPPU(1 0) + Y
                        \           = (iconBarImageHi 0) + (addr4 0) + Y
                        \           = (iconBarImageHi 0) + (addr4 Y)
                        \           = (iconBarImageHi 0) + barPatternCounter * 8
                        \
                        \ We know that (iconBarImageHi 0) points to the current
                        \ icon bar's image data  aticonBarImage0, iconBarImage1,
                        \ iconBarImage2, iconBarImage3 or iconBarImage4
                        \
                        \ So dataForPPU(1 0) + Y points to the pattern within
                        \ the icon bar's image data that corresponds to pattern
                        \ number barPatternCounter, so this is the data that we
                        \ want to send to the PPU using LDA (dataForPPU),Y below

 LDX #32                \ We now send 32 bytes to the PPU, which equates to four
                        \ tile patterns (as each tile pattern contains eight
                        \ bytes)
                        \
                        \ We send 32 pattern bytes, starting from the Y-th byte
                        \ of dataForPPU(1 0), which corresponds to pattern
                        \ number barPatternCounter in dataForPPU(1 0)

.patt3

 LDA (dataForPPU),Y     \ Send the Y-th byte from dataForPPU(1 0) to the PPU
 STA PPU_DATA

 INY                    \ Increment the index in Y to point to the next byte
                        \ from dataForPPU(1 0)

 DEX                    \ Decrement the loop counter

 BEQ patt4              \ If the loop counter is now zero, jump to patt4 to exit
                        \ the loop

 JMP patt3              \ Loop back to send the next byte

.patt4

 LDA barPatternCounter  \ Add 4 to barPatternCounter, as we just sent four tile
 CLC                    \ patterns
 ADC #4
 STA barPatternCounter

 BPL BarPatternsHiToPPU \ If barPatternCounter < 128, loop back to the start of
                        \ the routine to send another four pattern tiles

 JMP ConsiderSendTiles  \ Jump to ConsiderSendTiles to start sending tiles to
                        \ the PPU, but only if there are enough free cycles

\ ******************************************************************************
\
\       Name: BarPatternsToPPU
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send pattern data for the icon bar to the PPU, split across
\             multiple calls to the NMI handler if required
\
\ ------------------------------------------------------------------------------
\
\ Pattern data for icon bar patterns 0 to 63 is sent to both pattern table 0 and
\ 1 in the PPU, while pattern data for icon bar patterns 64 to 127 is sent to
\ pattern table 0 only (the latter is done via the BarPatternsHiToPPU routine).
\
\ Arguments:
\
\   A                   A counter for the icon bar tile patterns to send to the
\                       PPU, which works its way from 0 to 128 as pattern data
\                       is sent to the PPU over successive calls to the NMI
\                       handler
\
\ ******************************************************************************

.BarPatternsToPPU

 ASL A                  \ If bit 6 of A is set, then 64 < A < 128, so jump to
 BMI BarPatternsHiToPPU \ BarPatternsHiToPPU to send patterns 64 to 127 to
                        \ pattern table 0 in the PPU

                        \ If we get here then both bit 6 and bit 7 of A are
                        \ clear, so 0 < A < 64, so we now send patterns 0 to 63
                        \ to pattern table 0 and 1 in the PPU

 SUBTRACT_CYCLES 1297   \ Subtract 1297 from the cycle count

 BMI patn1              \ If the result is negative, jump to patn1 to stop
                        \ sending patterns in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP patn2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to patn2
                        \ to send the patterns

.patn1

 ADD_CYCLES 1251        \ Add 1251 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.patn2

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0
 STA dataForPPU

 LDA barPatternCounter  \ Set Y = barPatternCounter * 8
 ASL A                  \
 ASL A                  \ And set the C flag to the overflow bit
 ASL A                  \
 TAY                    \ Note that in the above we shift bits 7 and 6 left out
                        \ out of A and discard them, but because we know that
                        \ 0 < barPatternCounter < 64, this has no effect

 LDA #%00000000         \ Set addr4 = %0000000C
 ROL A                  \
 STA addr4              \ And clear the C flag (as it gets set to bit 7 of A)
                        \
                        \ So we now have the following:
                        \
                        \   (addr4 Y) = barPatternCounter * 8

 TYA                    \ Set (A X) = (addr4 Y) + PPU_PATT_0 + &50
 ADC #&50               \           = PPU_PATT_0 + &50 + barPatternCounter * 8
 TAX                    \
                        \ Starting with the low bytes

 LDA addr4              \ And then the high bytes (this works because we know
 ADC #HI(PPU_PATT_0)    \ the low byte of PPU_PATT_0 is 0)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \           = PPU_PATT_0 + &50 + barPatternCounter * 8
                        \           = PPU_PATT_0 + (10 + barPatternCounter) * 8
                        \
                        \ So PPU_ADDR points to a pattern in PPU pattern table
                        \ 0, which is at address PPU_PATT_0 in the PPU
                        \ 
                        \ So it points to pattern 10 when barPatternCounter = 0,
                        \ and points to patterns 10 to 137 as barPatternCounter
                        \ increments from 0 to 127

 LDA iconBarImageHi     \ Set dataForPPU(1 0) = (iconBarImageHi 0) + (addr4 0)
 ADC addr4              \
 STA dataForPPU+1       \ This means that:
                        \
                        \   dataForPPU(1 0) + Y
                        \           = (iconBarImageHi 0) + (addr4 0) + Y
                        \           = (iconBarImageHi 0) + (addr4 Y)
                        \           = (iconBarImageHi 0) + barPatternCounter * 8
                        \
                        \ We know that (iconBarImageHi 0) points to the current
                        \ icon bar's image data  aticonBarImage0, iconBarImage1,
                        \ iconBarImage2, iconBarImage3 or iconBarImage4
                        \
                        \ So dataForPPU(1 0) + Y points to the pattern within
                        \ the icon bar's image data that corresponds to pattern
                        \ number barPatternCounter, so this is the data that we
                        \ want to send to the PPU using LDA (dataForPPU),Y below

 LDX #32                \ We now send 32 bytes to the PPU, which equates to four
                        \ tile patterns (as each tile pattern contains eight
                        \ bytes)
                        \
                        \ We send 32 pattern bytes, starting from the Y-th byte
                        \ of dataForPPU(1 0), which corresponds to pattern
                        \ number barPatternCounter in dataForPPU(1 0)

.patn3

 LDA (dataForPPU),Y     \ Send the Y-th byte from dataForPPU(1 0) to the PPU
 STA PPU_DATA

 INY                    \ Increment the index in Y to point to the next byte
                        \ from dataForPPU(1 0)

 DEX                    \ Decrement the loop counter

 BEQ patn4              \ If the loop counter is now zero, jump to patn4 to exit
                        \ the loop

 JMP patn3              \ Loop back to send the next byte

.patn4

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0
 STA dataForPPU

 LDA barPatternCounter  \ Set Y = barPatternCounter * 8
 ASL A                  \
 ASL A                  \ And set the C flag to the overflow bit
 ASL A                  \
 TAY                    \ Note that in the above we shift bits 7 and 6 left out
                        \ out of A and discard them, but because we know that
                        \ 0 < barPatternCounter < 64, this has no effect

 LDA #%00000000         \ Set addr4 = %0000000C
 ROL A                  \
 STA addr4              \ And clear the C flag (as it gets set to bit 7 of A)
                        \
                        \ So we now have the following:
                        \
                        \   (addr4 Y) = barPatternCounter * 8

 TYA                    \ Set (A X) = (addr4 Y) + PPU_PATT_1 + &50
 ADC #&50               \           = PPU_PATT_1 + &50 + barPatternCounter * 8
 TAX                    \
                        \ Starting with the low bytes

 LDA addr4              \ And then the high bytes (this works because we know
 ADC #HI(PPU_PATT_1)    \ the low byte of PPU_PATT_1 is 0)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \           = PPU_PATT_1 + &50 + barPatternCounter * 8
                        \           = PPU_PATT_1 + (10 + barPatternCounter) * 8
                        \
                        \ So PPU_ADDR points to a pattern in PPU pattern table
                        \ 1, which is at address PPU_PATT_1 in the PPU
                        \ 
                        \ So it points to pattern 10 when barPatternCounter = 0,
                        \ and points to patterns 10 to 137 as barPatternCounter
                        \ increments from 0 to 127

 LDA iconBarImageHi     \ Set dataForPPU(1 0) = (iconBarImageHi 0) + (addr4 0)
 ADC addr4              \
 STA dataForPPU+1       \ This means that:
                        \
                        \   dataForPPU(1 0) + Y
                        \           = (iconBarImageHi 0) + (addr4 0) + Y
                        \           = (iconBarImageHi 0) + (addr4 Y)
                        \           = (iconBarImageHi 0) + barPatternCounter * 8
                        \
                        \ We know that (iconBarImageHi 0) points to the current
                        \ icon bar's image data  aticonBarImage0, iconBarImage1,
                        \ iconBarImage2, iconBarImage3 or iconBarImage4
                        \
                        \ So dataForPPU(1 0) + Y points to the pattern within
                        \ the icon bar's image data that corresponds to pattern
                        \ number barPatternCounter, so this is the data that we
                        \ want to send to the PPU using LDA (dataForPPU),Y below

 LDX #32                \ We now send 32 bytes to the PPU, which equates to four
                        \ tile patterns (as each tile pattern contains eight
                        \ bytes)
                        \
                        \ We send 32 pattern bytes, starting from the Y-th byte
                        \ of dataForPPU(1 0), which corresponds to pattern
                        \ number barPatternCounter in dataForPPU(1 0)

.patn5

 LDA (dataForPPU),Y     \ Send the Y-th byte from dataForPPU(1 0) to the PPU
 STA PPU_DATA

 INY                    \ Increment the index in Y to point to the next byte
                        \ from dataForPPU(1 0)

 DEX                    \ Decrement the loop counter

 BEQ patn6              \ If the loop counter is now zero, jump to patn6 to exit
                        \ the loop

 JMP patn5              \ Loop back to send the next byte

.patn6

 LDA barPatternCounter  \ Add 4 to barPatternCounter, as we just sent four tile
 CLC                    \ patterns
 ADC #4
 STA barPatternCounter

 JMP BarPatternsToPPU   \ Loop back to the start of the routine to send another
                        \ four pattern tiles to both PPU pattern tables

\ ******************************************************************************
\
\       Name: BarPatternsToPPU1
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send the tile pattern data for the icon bar to the PPU (this is a
\             jump so we can call this routine using a branch instruction)
\
\ ******************************************************************************

.BarPatternsToPPU1

 JMP BarPatternsToPPU   \ Jump to BarPatternsToPPU to send the tile pattern data
                        \ for the icon bar to the PPU, returning from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: BarNametableToPPU1
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send the nametable entries for the icon bar to the PPU (this is a
\             jump so we can call this routine using a branch instruction)
\
\ ******************************************************************************

.BarNametableToPPU1

 JMP BarNametableToPPU  \ Jump to BarNametableToPPU to send the nametable
                        \ entries for the icon bar to the PPU, returning from
                        \ the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ConsiderSendTiles
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: If there are enough free cycles, move on to the next stage of
\             sending tile patterns to the PPU
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS1                Contains an RTS
\
\ ******************************************************************************

.ConsiderSendTiles

 LDX nmiBitplane        \ Set A to the bitplane flags for the NMI bitplane
 LDA bitplaneFlags,X

 AND #%00010000         \ If bit 4 of A is clear, return from the subroutine
 BEQ RTS1               \ (as RTS1 contains an RTS)

 SUBTRACT_CYCLES 42     \ Subtract 42 from the cycle count

 BMI next1              \ If the result is negative, jump to next1 to stop
                        \ sending patterns in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP next2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to
                        \ SendPatternsToPPU via next2 to move on to the next
                        \ stage of sending tile patterns to the PPU

.next1

 ADD_CYCLES 65521       \ Add 65521 to the cycle count (i.e. subtract 15) ???

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.next2

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to move on to the next stage
                        \ of sending tile patterns to the PPU

.RTS1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SendBuffersToPPU (Part 1 of 3)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send the icon bar nametable and palette data to the PPU, if it has
\             changed
\
\ ******************************************************************************

.SendBuffersToPPU

 LDA barPatternCounter  \ If barPatternCounter = 0, then we need to send the
 BEQ BarNametableToPPU1 \ nametable entries for the icon bar to the PPU, so
                        \ jump to BarNametableToPPU via BarNametableToPPU1,
                        \ returning from the subroutine using a tail call

 BPL BarPatternsToPPU1  \ If 0 < barPatternCounter < 128, then we need to send
                        \ the pattern data for the icon bar to the PPU, so
                        \ jump to BarPatternsToPPU via BarPatternsToPPU1,
                        \ returning from the subroutine using a tail call

                        \ If we get here then barPatternCounter >= 128, so we
                        \ do not need to send any icon bar data to the PPU

\ ******************************************************************************
\
\       Name: SendBuffersToPPU (Part 2 of 3)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Check whether we are already sending tile data to the PPU, and if
\             we are then pick up where we left off, otherwise jump to part 3
\
\ ******************************************************************************

 LDX nmiBitplane        \ Set A to the bitplane flags for the NMI bitplane
 LDA bitplaneFlags,X

 AND #%00010000         \ If bit 4 is clear, then we have not already started
 BEQ sbuf7              \ sending tile data to the PPU in a previous VBlank, so
                        \ jump to sbuf7 to start sending tile data in part 3

                        \ Otherwise we were already sending tile data in the
                        \ previous VBlank, so we continue where we left off in
                        \ the last call to the NMI handler

 SUBTRACT_CYCLES 56     \ Subtract 56 from the cycle count

 TXA                    \ Set Y to the inverse of X, so Y is the opposite
 EOR #1                 \ bitplane to the NMI bitplane
 TAY

 LDA bitplaneFlags,Y    \ Set A to the bitplane flags for the opposite plane
                        \ to the NMI bitplane

 AND #%10100000         \ If bitplanes are enabled, and bit 7 is set and bit 5
 ORA enableBitplanes    \ is clear in the flags for the opposite bitplane, keep
 CMP #%10000001         \ going to check whether we have tiles to send,
 BNE sbuf2              \ otherwise jump to SendPatternsToPPU via sbuf2 to
                        \ continue sending tiles to the PPU

                        \ If we get here then bitplanes are enabled, bit 7 is
                        \ set and bit 5 is clear in the flags for the opposite
                        \ bitplane, so ???

 LDA nextTileNumber,X   \ Set A to the next free tile number for the NMI
                        \ bitplane

 BNE sbuf1              \ If it it zero (i.e. we have no free tiles), then set
 LDA #255               \ A to 255, so we can use A as an upper limit

.sbuf1

 CMP pattTileNumber1,X  \ If A >= pattTileNumber1, then the number of the last
 BEQ sbuf3              \ free tile is bigger than the number of the tile for
 BCS sbuf3              \ which we are currently sending pattern data to the PPU
                        \ for this bitplane, which means there is still some
                        \ pattern data to send before we have processed all the
                        \ tiles, so jump to sbuf3
                        \
                        \ Ths BEQ appears to be superfluous here as BCS will
                        \ catch an equality

                        \ If we get here then we have finished sending pattern
                        \ data to the PPU, so we now move on to the nametable
                        \ entries by jumping to SendPatternsToPPU after
                        \ adjusting the cycle count

 SUBTRACT_CYCLES 32     \ Subtract 32 from the cycle count

.sbuf2

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to continue sending tile
                        \ data to the PPU

.sbuf3

                        \ If we get here then we still have pattern data to send
                        \ to the PPU

 LDA bitplaneFlags,X    \ Set A to the bitplane flags for the NMI bitplane

 ASL A                  \ Shift A left by one place, so bit 7 becomes bit 6 of
                        \ the original flags, and so on

 BPL RTS1               \ If bit 6 of the bitplane flags is clear, return from
                        \ the subroutine (as RTS1 contains an RTS)

 LDY lastTileNumber,X   \ Set Y to the number of the last tile we need to send
                        \ for this bitplane

 AND #%00001000         \ If bit 3 of the bitplane flags is set, set Y = 128
 BEQ sbuf4
 LDY #128

.sbuf4

 TYA                    \ Set A = Y - nameTileNumber1
 SEC                    \       = lastTileNumber - nameTileNumber1
 SBC nameTileNumber1,X  \
                        \ So this is the number of tiles for which we have to
                        \ send nametable entries, as nameTileNumber1 is the
                        \ number of the tile for which we are currently sending
                        \ nametable entries to the PPU

 CMP #48                \ If A < 48, jump to sbuf6 to flip the palette bitplane
 BCC sbuf6              \ before sending the next batch of tiles ???

 SUBTRACT_CYCLES 60     \ Subtract 60 from the cycle count

.sbuf5

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to continue sending tile
                        \ data to the PPU

.sbuf6

 LDA ppuCtrlCopy        \ If PPU_CTRL is zero, then ??? so jump to sbuf5 to skip
 BEQ sbuf5              \ the following bitplane flip

 SUBTRACT_CYCLES 134    \ Subtract 134 from the cycle count

 LDA enableBitplanes    \ If bitplanes are enabled, then enableBitplanes = 1,
 EOR paletteBitplane    \ so this flips paletteBitplane between 0 and 1, but
 STA paletteBitplane    \ only when bitplanes are enabled

 JSR SetPaletteForPlane \ Set either background palette 0 or sprite palette 1,
                        \ according to the palette bitplane and view type

 JMP SendPatternsToPPU  \ Jump to SendPatternsToPPU to continue sending tile
                        \ data to the PPU

\ ******************************************************************************
\
\       Name: SendBuffersToPPU (Part 3 of 3)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: If we need to send tile nametable and pattern data to the PPU for
\             either bitplane, start doing just that
\
\ ******************************************************************************

.sbuf7

 SUBTRACT_CYCLES 298    \ Subtract 298 from the cycle count

 LDA bitplaneFlags      \ If bit 7 is set and bit 5 is clear in the flags for
 AND #%10100000         \ bitplane 0, keep going to process bitplane 0,
 CMP #%10000000         \ otherwise jump to sbuf8 to consider bitplane 1
 BNE sbuf8

 NOP                    \ This looks like code that has been disabled
 NOP
 NOP
 NOP
 NOP

 LDX #0                 \ Set X = 0 and jump to sbuf11 to start sending tile
 JMP sbuf11             \ data to the PPU for bitplane 0

.sbuf8

 LDA bitplaneFlags+1    \ If bit 7 is set and bit 5 is clear in the flags for
 AND #%10100000         \ bitplane 1, jump to sbuf10 to process bitplane 1
 CMP #%10000000
 BEQ sbuf10

 ADD_CYCLES_CLC 223     \ Add 223 to the cycle count

 RTS                    \ Return from the subroutine

.sbuf9

 ADD_CYCLES_CLC 45      \ Add 45 to the cycle count

 JMP SetupTilesForPPU   \ Jump to SetupTilesForPPU to set up the variables for
                        \ sending tile data to the PPU

.sbuf10

 LDX #1                 \ Set X = 1 so we start sending tile data to the PPU
                        \ for bitplane 1

.sbuf11

 STX nmiBitplane        \ Set the NMI bitplane to the value in X, which will
                        \ be 0 or 1 depending on the value of the bitplane flags
                        \ we tested above

 LDA enableBitplanes    \ If enableBitplanes = 0 then bitplanes are not enabled
 BEQ sbuf9              \ (we must be on the start screen), so jump to sbuf9 to
                        \ update the cycle count and skip the following two
                        \ instructions

 STX paletteBitplane    \ Set the palette bitplane to be the same as the NMI
                        \ bitplane

 JSR SetPaletteForPlane \ Set either background palette 0 or sprite palette 1,
                        \ according to the palette bitplane and view type

\ ******************************************************************************
\
\       Name: SetupTilesForPPU
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Set up the variables needed to send the tile nametable and pattern
\             data to the PPU
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The current value of nmiBitplane
\
\ ******************************************************************************

.SetupTilesForPPU

 TXA                    \ Set nmiBitplanex8 = X << 3
 ASL A                  \                  = nmiBitplane * 8
 ASL A
 ASL A
 STA nmiBitplanex8

 LSR A                  \ Set A = nmiBitplane << 2
                        \
                        \ So A = 0 or 4 (%100), depending on the current value
                        \ of nmiBitplane

 ORA #HI(PPU_NAME_0)    \ Set the high byte of ppuNametableAddr(1 0) to
 STA ppuNametableAddr+1 \ HI(PPU_NAME_0) + A, which will be HI(PPU_NAME_0) or
                        \ HI(PPU_NAME_0) + 4, depending on the current value of
                        \ nmiBitplane

 LDA #HI(PPU_PATT_1)    \ Set ppuPatternTableHi to point to the high byte of
 STA ppuPatternTableHi  \ pattern table 1 in the PPU

 LDA #0                 \ Zero the low byte of ppuNametableAddr(1 0), so we end
 STA ppuNametableAddr   \ up with ppuNametableAddr(1 0) set to:
                        \
                        \   * PPU_NAME_0 (&2000) when nmiBitplane = 0
                        \
                        \   * PPU_NAME_1 (&2400) when nmiBitplane = 1
                        \
                        \ So ppuNametableAddr(1 0) points to the PPU nametable
                        \ for this bitplane

 LDA nameTileNumber
 STA nameTileNumber1,X

 STA nameTileNumber2,X

 LDA pattTileNumber
 STA pattTileNumber1,X

 STA pattTileNumber2,X

 LDA bitplaneFlags,X    \ Set bit 4 in the bitplane flags to indicate that we
 ORA #%00010000         \ are now sending tile data to the PPU in the NMI
 STA bitplaneFlags,X    \ handler (so we can detect this if we have to split
                        \ the process across multiple VBlanks/calls to the NMI
                        \ handler)

 LDA #0
 STA addr4

 LDA pattTileNumber1,X
 ASL A
 ROL addr4
 ASL A
 ROL addr4
 ASL A
 STA pattTileBuffLo,X

 LDA addr4
 ROL A
 ADC pattBufferHiAddr,X
 STA pattTileBuffHi,X

 LDA #0
 STA addr4

 LDA nameTileNumber1,X
 ASL A
 ROL addr4
 ASL A
 ROL addr4
 ASL A
 STA nameTileBuffLo,X
 ROL addr4

 LDA addr4
 ADC nameBufferHiAddr,X
 STA nameTileBuffHi,X

 LDA ppuNametableAddr+1
 SEC
 SBC nameBufferHiAddr,X
 STA ppuToBuffNameHi,X

 JMP SendPatternsToPPU

\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 1 of 5)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.spat1

 ADD_CYCLES_CLC 4       \ Add 4 to the cycle count

 JMP SendNametableNow

.spat2

 JMP spat21

.SendPatternsToPPU

 SUBTRACT_CYCLES 182    \ Subtract 182 from the cycle count

 BMI spat3              \ If the result is negative, jump to spat3 to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP spat4              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to spat4
                        \ to ???

.spat3

 ADD_CYCLES 141         \ Add 141 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.spat4

 LDA nextTileNumber,X
 BNE spat5
 LDA #255

.spat5

 STA lastTile
 LDA ppuNametableAddr+1
 SEC
 SBC nameBufferHiAddr,X
 STA ppuToBuffNameHi,X
 LDY pattTileBuffLo,X
 LDA pattTileBuffHi,X
 STA dataForPPU+1
 LDA pattTileNumber1,X
 STA L00C9
 SEC
 SBC lastTile
 BCS spat1
 LDX ppuCtrlCopy
 BEQ spat6
 CMP #&BF
 BCC spat2

.spat6

 LDA L00C9
 LDX #0
 STX addr4
 STX dataForPPU
 ASL A
 ROL addr4
 ASL A
 ROL addr4
 ASL A
 ROL addr4
 ASL A
 TAX

 LDA addr4              \ Set A = ppuPatternTableHi + addr4 * 2
 ROL A                  \       = &10 + addr4 * 2
 ADC ppuPatternTableHi

 STA PPU_ADDR
 STA addr4+1
 TXA
 ADC nmiBitplanex8
 STA PPU_ADDR
 STA addr4
 JMP spat9

\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 2 of 5)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.spat7

 INC dataForPPU+1

 SUBTRACT_CYCLES 27     \ Subtract 27 from the cycle count

 JMP spat13

.spat8

 JMP spat17

.spat9

 LDX L00C9

.spat10

 SUBTRACT_CYCLES 400    \ Subtract 400 from the cycle count

 BMI spat11
 JMP spat12

.spat11

 ADD_CYCLES 359         \ Add 359 to the cycle count

 JMP spat30

.spat12

 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 BEQ spat7

.spat13

 LDA addr4
 CLC
 ADC #&10
 STA addr4
 LDA addr4+1
 ADC #0
 STA addr4+1
 STA PPU_ADDR
 LDA addr4
 STA PPU_ADDR
 INX
 CPX lastTile
 BCS spat8
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 BEQ spat16

.spat14

 LDA addr4
 ADC #&10
 STA addr4
 LDA addr4+1
 ADC #0
 STA addr4+1
 STA PPU_ADDR
 LDA addr4
 STA PPU_ADDR
 INX
 CPX lastTile
 BCS spat18
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 BEQ spat20

.spat15

 LDA addr4
 ADC #&10
 STA addr4
 LDA addr4+1
 ADC #0
 STA addr4+1
 STA PPU_ADDR
 LDA addr4
 STA PPU_ADDR
 INX
 CPX lastTile
 BCS spat19
 JMP spat10

.spat16

 INC dataForPPU+1

 SUBTRACT_CYCLES 29     \ Subtract 29 from the cycle count

 CLC
 JMP spat14

.spat17

 ADD_CYCLES_CLC 224     \ Add 224 to the cycle count

 JMP spat19

.spat18

 ADD_CYCLES_CLC 109     \ Add 109 to the cycle count

.spat19

 STX L00C9
 NOP
 LDX nmiBitplane
 STY pattTileBuffLo,X
 LDA dataForPPU+1
 STA pattTileBuffHi,X
 LDA L00C9
 STA pattTileNumber1,X

 JMP SendNametableToPPU \ Jump to SendNametableToPPU to start sending the tile
                        \ nametable to the PPU

.spat20

 INC dataForPPU+1

 SUBTRACT_CYCLES 29     \ Subtract 29 from the cycle count

 CLC
 JMP spat15

\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 3 of 5)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.spat21

 LDA L00C9
 LDX #0
 STX addr4
 STX dataForPPU
 ASL A
 ROL addr4
 ASL A
 ROL addr4
 ASL A
 ROL addr4
 ASL A
 TAX

 LDA addr4              \ Set A = ppuPatternTableHi + addr4 * 2
 ROL A                  \       = &10 + addr4 * 2
 ADC ppuPatternTableHi

 STA PPU_ADDR
 STA addr4+1
 TXA
 ADC nmiBitplanex8
 STA PPU_ADDR
 STA addr4
 JMP spat23

\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 4 of 5)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.spat22

 INC dataForPPU+1

 SUBTRACT_CYCLES 27     \ Subtract 27 from the cycle count

 JMP spat27

.spat23

 LDX L00C9

.spat24

 SUBTRACT_CYCLES 266    \ Subtract 266 from the cycle count

 BMI spat25
 JMP spat26

.spat25

 ADD_CYCLES 225         \ Add 225 to the cycle count

 JMP spat30

.spat26

 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 BEQ spat22

.spat27

 LDA addr4
 CLC
 ADC #&10
 STA addr4
 LDA addr4+1
 ADC #0
 STA addr4+1
 STA PPU_ADDR
 LDA addr4
 STA PPU_ADDR
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 BEQ spat29

.spat28

 LDA addr4
 ADC #&10
 STA addr4
 LDA addr4+1
 ADC #0
 STA addr4+1
 STA PPU_ADDR
 LDA addr4
 STA PPU_ADDR
 INX
 INX
 JMP spat24

.spat29

 INC dataForPPU+1

 SUBTRACT_CYCLES 29     \ Subtract 29 from the cycle count

 CLC
 JMP spat28

\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 5 of 5)
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.spat30

 STX L00C9
 LDX nmiBitplane
 STY pattTileBuffLo,X
 LDA dataForPPU+1
 STA pattTileBuffHi,X
 LDA L00C9
 STA pattTileNumber1,X

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

\ ******************************************************************************
\
\       Name: subm_CB42
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.subm_CB42

 LDX nmiBitplane        \ Set bit 5 and clear all other bits in the bitplane
 LDA #%00100000         \ flags for the NMI bitplane
 STA bitplaneFlags,X

 SUBTRACT_CYCLES 227    \ Subtract 227 from the cycle count

 BMI CCB5B              \ If the result is negative, jump to CCB5B to stop
                        \ sending PPU data in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP CCB6A              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to CCB6A
                        \ to ???

.CCB5B

 ADD_CYCLES 176         \ Add 176 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.CCB6A

 TXA                    \ Flip the NMI bitplane between 0 and 1
 EOR #1
 STA nmiBitplane

 CMP paletteBitplane    \ If the NMI bitplane is now different to the palette
 BNE CCB8E              \ bitplane, jump to CCB8E to update the cycle count
                        \ and return from the subroutine

 TAX                    \ Set X to the newly flipped NMI bitplane

 LDA bitplaneFlags,X    \ If bit 7 is set and bit 5 is clear in the flags for
 AND #%10100000         \ the new NMI bitplane, jump to CCB80 to update the
 CMP #%10000000         \ cycle count and return from the subroutine
 BEQ CCB80

                        \ If we get here then ???

 JMP SetupTilesForPPU   \ Jump to SetupTilesForPPU to set up the variables for
                        \ sending tile data to the PPU

.CCB80

 ADD_CYCLES_CLC 151     \ Add 151 to the cycle count

 RTS                    \ Return from the subroutine

.CCB8E

 ADD_CYCLES_CLC 163     \ Add 163 to the cycle count

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SendNametableToPPU
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send the tile nametable to the PPU if there are enough cycles left
\             in the current VBlank
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   SendNametableNow    Send the nametable without checking the cycle count
\
\ ******************************************************************************

.snam1

 ADD_CYCLES_CLC 58      \ Add 58 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.snam2

 ADD_CYCLES_CLC 53      \ Add 53 to the cycle count

 JMP subm_CB42

.SendNametableToPPU

 SUBTRACT_CYCLES 109    \ Subtract 109 from the cycle count

 BMI snam3

 JMP SendNametableNow

.snam3

 ADD_CYCLES 68          \ Add 68 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.SendNametableNow

 LDX nmiBitplane
 LDA bitplaneFlags,X
 ASL A
 BPL snam1
 LDY lastTileNumber,X
 AND #8
 BEQ snam4
 LDY #&80

.snam4

 STY lastTile
 LDA nameTileNumber1,X
 STA nameTileCounter
 SEC
 SBC lastTile
 BCS snam2
 LDY nameTileBuffLo,X
 LDA nameTileBuffHi,X
 STA dataForPPU+1
 CLC
 ADC ppuToBuffNameHi,X
 STA PPU_ADDR
 STY PPU_ADDR
 LDA #0
 STA dataForPPU

.snam5

 SUBTRACT_CYCLES 393    \ Subtract 393 from the cycle count

 BMI snam6
 JMP snam7

.snam6

 ADD_CYCLES 349         \ Add 349 to the cycle count

 JMP snam10

.snam7

 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 LDA (dataForPPU),Y
 STA PPU_DATA
 INY
 BEQ snam9
 LDA nameTileCounter
 ADC #3
 STA nameTileCounter
 CMP lastTile
 BCS snam8
 JMP snam5

.snam8

 STA nameTileNumber1,X
 STY nameTileBuffLo,X
 LDA dataForPPU+1
 STA nameTileBuffHi,X

 JMP subm_CB42

.snam9

 INC dataForPPU+1

 SUBTRACT_CYCLES 26     \ Subtract 26 from the cycle count

 LDA nameTileCounter
 CLC
 ADC #4
 STA nameTileCounter
 CMP lastTile
 BCS snam8
 JMP snam5

.snam10

 LDA nameTileCounter
 STA nameTileNumber1,X
 STY nameTileBuffLo,X
 LDA dataForPPU+1
 STA nameTileBuffHi,X

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

\ ******************************************************************************
\
\       Name: CopyNameBuffer0To1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.CopyNameBuffer0To1

 LDY #0
 LDX #&10

.CCD38

 LDA nameBuffer0,Y
 STA nameBuffer1,Y
 LDA nameBuffer0+8*32,Y
 STA nameBuffer1+8*32,Y
 LDA nameBuffer0+16*32,Y
 STA nameBuffer1+16*32,Y
 LDA nameBuffer0+24*32,Y
 STA nameBuffer1+24*32,Y

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 DEX
 BNE CCD58
 LDX #&10

.CCD58

 DEY
 BNE CCD38
 LDA tileNumber
 STA nextTileNumber
 STA nextTileNumber+1
 RTS

\ ******************************************************************************
\
\       Name: DrawBoxTop
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DrawBoxTop

 LDY #1
 LDA #3

.loop_CCD66

 STA nameBuffer0,Y
 INY
 CPY #&20
 BNE loop_CCD66
 RTS

\ ******************************************************************************
\
\       Name: DrawBoxEdges
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DrawBoxEdges

 LDX drawingBitplane
 BNE CCDF2

 LDA boxEdge1

 STA nameBuffer0+1
 STA nameBuffer0+1*32+1
 STA nameBuffer0+2*32+1
 STA nameBuffer0+3*32+1
 STA nameBuffer0+4*32+1
 STA nameBuffer0+5*32+1
 STA nameBuffer0+6*32+1
 STA nameBuffer0+7*32+1
 STA nameBuffer0+8*32+1
 STA nameBuffer0+9*32+1
 STA nameBuffer0+10*32+1
 STA nameBuffer0+11*32+1
 STA nameBuffer0+12*32+1
 STA nameBuffer0+13*32+1
 STA nameBuffer0+14*32+1
 STA nameBuffer0+15*32+1
 STA nameBuffer0+16*32+1
 STA nameBuffer0+17*32+1
 STA nameBuffer0+18*32+1
 STA nameBuffer0+19*32+1

 LDA boxEdge2

 STA nameBuffer0
 STA nameBuffer0+1*32
 STA nameBuffer0+2*32
 STA nameBuffer0+3*32
 STA nameBuffer0+4*32
 STA nameBuffer0+5*32
 STA nameBuffer0+6*32
 STA nameBuffer0+7*32
 STA nameBuffer0+8*32
 STA nameBuffer0+9*32
 STA nameBuffer0+10*32
 STA nameBuffer0+11*32
 STA nameBuffer0+12*32
 STA nameBuffer0+13*32
 STA nameBuffer0+14*32
 STA nameBuffer0+15*32
 STA nameBuffer0+16*32
 STA nameBuffer0+17*32
 STA nameBuffer0+18*32
 STA nameBuffer0+19*32

 RTS

.CCDF2

 LDA boxEdge1

 STA nameBuffer1+1
 STA nameBuffer1+1*32+1
 STA nameBuffer1+2*32+1
 STA nameBuffer1+3*32+1
 STA nameBuffer1+4*32+1
 STA nameBuffer1+5*32+1
 STA nameBuffer1+6*32+1
 STA nameBuffer1+7*32+1
 STA nameBuffer1+8*32+1
 STA nameBuffer1+9*32+1
 STA nameBuffer1+10*32+1
 STA nameBuffer1+11*32+1
 STA nameBuffer1+12*32+1
 STA nameBuffer1+13*32+1
 STA nameBuffer1+14*32+1
 STA nameBuffer1+15*32+1
 STA nameBuffer1+16*32+1
 STA nameBuffer1+17*32+1
 STA nameBuffer1+18*32+1
 STA nameBuffer1+19*32+1

 LDA boxEdge2

 STA nameBuffer1
 STA nameBuffer1+1*32
 STA nameBuffer1+2*32
 STA nameBuffer1+3*32
 STA nameBuffer1+4*32
 STA nameBuffer1+5*32
 STA nameBuffer1+6*32
 STA nameBuffer1+7*32
 STA nameBuffer1+8*32
 STA nameBuffer1+9*32
 STA nameBuffer1+10*32
 STA nameBuffer1+11*32
 STA nameBuffer1+12*32
 STA nameBuffer1+13*32
 STA nameBuffer1+14*32
 STA nameBuffer1+15*32
 STA nameBuffer1+16*32
 STA nameBuffer1+17*32
 STA nameBuffer1+18*32
 STA nameBuffer1+19*32

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS

INCLUDE "library/common/main/variable/univ.asm"
INCLUDE "library/common/main/subroutine/ginf.asm"

\ ******************************************************************************
\
\       Name: HideSprites59To62
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide sprites 59 to 62
\
\ ******************************************************************************

.HideSprites59To62

 LDX #4                 \ Set X = 4 so we hide four sprites

 LDY #236               \ Set Y so we start hiding from sprite 236 / 4 = 59

 JMP HideSprites        \ Jump to HideSprites to hide four sprites from sprite
                        \ 59 onwards (i.e. 59 to 62), returning from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: HideScannerSprites
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: ???
\
\ ******************************************************************************

.HideScannerSprites

 LDX #0

.loop_CCEA7

 LDA FRIN,X
 BEQ CCEBC
 BMI CCEB9
 JSR GINF
 LDY #&1F
 LDA (XX19),Y
 AND #&EF
 STA (XX19),Y

.CCEB9

 INX
 BNE loop_CCEA7

.CCEBC

 LDY #44                \ Set Y so we start hiding from sprite 44 / 4 = 11

 LDX #27                \ Set X = 27 so we hide 27 sprites


                        \ Fall through into HideSprites to hide 27 sprites
                        \ from sprite 11 onwards (i.e. 11 to 37)

\ ******************************************************************************
\
\       Name: HideSprites
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide X sprites from sprite Y / 4 onwards
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of sprites to hide
\
\   Y                   The number of the first sprite to hide * 4
\
\ ******************************************************************************

.HideSprites

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

.hspr1

 STA ySprite0,Y         \ Set the y-coordinate for sprite Y / 4 to 240 to hide
                        \ it (the division by four is because each sprite in the
                        \ sprite buffer has four bytes of data)

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the loop counter in X

 BNE hspr1              \ Loop back until we have hidden X sprites

 RTS                    \ Return from the subroutine

 EQUB &0C, &20, &1F     \ These bytes appear to be unused

INCLUDE "library/nes/main/variable/namebufferhiaddr.asm"
INCLUDE "library/nes/main/variable/pattbufferhiaddr.asm"

\ ******************************************************************************
\
\       Name: IRQ
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Handle IRQ interrupts by doing nothing
\
\ ******************************************************************************

.IRQ

 RTI                    \ Return from the interrupt handler

\ ******************************************************************************
\
\       Name: NMI
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The NMI interrupt handler that gets called every VBlank and which
\             updates the screen, reads the controllers and plays music
\
\ ******************************************************************************

.NMI

 JSR SendPaletteSprites \ Send the current palette and sprite data to the PPU

 LDA showUserInterface  \ Set the value of setupPPUForIconBar so that if there
 STA setupPPUForIconBar \ is an on-screen user interface (which there will be if
                        \ this isn't the game over screen), then the calls to
                        \ the SETUP_PPU_FOR_ICON_BAR macro sprinkled throughout
                        \ the codebase will make sure we set nametable 0 and
                        \ palette table 0 when the PPU starts drawing the icon
                        \ bar

IF _NTSC

 LDA #&1A               \ Set cycleCount = 6797 (&1A8D)
 STA cycleCount+1
 LDA #&8D
 STA cycleCount

ELIF _PAL

 LDA #&1D               \ Set cycleCount = 7433 (&1D09)
 STA cycleCount+1
 LDA #&09
 STA cycleCount

ENDIF

 JSR UpdateScreen       \ Update the screen by copying the nametable and pattern
                        \ data for the relevant tiles to the PPU

 JSR ReadControllers    \ Read the buttons on the controllers
 
 LDA L03EE              \ If bit 7 of L03EE is set, call subm_E802 ???
 BPL inmi1
 JSR subm_E802

.inmi1

 JSR MoveIconBarPointer \ Move the sprites that make up the icon bar pointer

 JSR UpdateJoystick     \ Update the values of JSTX and JSTY with the values
                        \ from the controller

 JSR UpdateNMITimer     \ Update the NMI timer, which we can use in place of
                        \ hardware timers (which the NES does not support)

 LDA runningSetBank     \ If the NMI handler was called from within the SetBank
 BNE inmi2              \ routine, then runningSetBank will be &FF, so jump to
                        \ inmi2 to skip the call to PlayMusic

 JSR PlayMusic_b6       \ Play any background music that might be in progress

 LDA nmiStoreA          \ Restore the values of A, X and Y that we stored at
 LDX nmiStoreX          \ the start of the NMI handler
 LDY nmiStoreY

 RTI                    \ Return from the interrupt handler

.inmi2

 INC runningSetBank     \ Set runningSetBank = 0 by incrementing it from &FF

 LDA nmiStoreA          \ Restore the values of A, X and Y that we stored at
 LDX nmiStoreX          \ the start of the NMI handler
 LDY nmiStoreY

 RTI                    \ Return from the interrupt handler

\ ******************************************************************************
\
\       Name: UpdateNMITimer
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Update the NMI timer, which we can use in place of hardware
\             timers (which the NES does not support)
\
\ ******************************************************************************

.UpdateNMITimer

 DEC nmiTimer           \ Decrement the NMI timer counter, so that it counts
                        \ each NMI interrupt

 BNE nmit1              \ If it hsn't reached zero yet, jump to nmit1 to return
                        \ from the subroutine

 LDA #50                \ Wrap the NMI timer round to start counting down from
 STA nmiTimer           \ 50 once again, as it just reached zero

 LDA nmiTimerLo         \ Increment (nmiTimerHi nmiTimerLo)
 CLC
 ADC #1
 STA nmiTimerLo
 LDA nmiTimerHi
 ADC #0
 STA nmiTimerHi

.nmit1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SendPaletteSprites
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Send the current palette and sprite data to the PPU
\
\ ******************************************************************************

.SendPaletteSprites

 STA nmiStoreA          \ Store the values of A, X and Y so we can retrieve them
 STX nmiStoreX          \ at the end of the NMI handler
 STY nmiStoreY

 LDA PPU_STATUS         \ Read from PPU_STATUS to clear bit 7 of PPU_STATUS and
                        \ reset the VBlank start flag

 INC frameCounter       \ Increment the frame counter

 LDA #0                 \ Write 0 to OAM_ADDR so we can use OAM_DMA to send
 STA OAM_ADDR           \ sprite data to the PPU

 LDA #&02               \ Write &02 to OAM_DMA to upload 256 bytes of sprite
 STA OAM_DMA            \ data from the sprite buffer at &02xx into the PPU

 LDA #%00000000         \ Set PPU_MASK as follows:
 STA PPU_MASK           \
                        \   * Bit 0 clear = normal colour (not monochrome)
                        \   * Bit 1 clear = hide leftmost 8 pixels of background
                        \   * Bit 2 clear = hide sprites in leftmost 8 pixels
                        \   * Bit 3 clear = hide background
                        \   * Bit 4 clear = hide sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

\ ******************************************************************************
\
\       Name: SetPaletteForPlane
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Set either background palette 0 or sprite palette 1, according to
\             the palette bitplane and view type
\
\ ******************************************************************************

.SetPaletteForPlane

 LDA QQ11a              \ Set A to the current view (or the old view that is
                        \ still being shown, if we are in the process of
                        \ changing view)

 BNE paph2              \ If this is not the space view, jump to paph2

                        \ If we get here then this is the space view

 LDY visibleColour      \ Set Y to the colour to use for visible pixels

 LDA paletteBitplane    \ If paletteBitplane is non-zero (i.e. 1), jump to paph1
 BNE paph1

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDA hiddenColour       \ Set A to the colour to use for hidden pixels

 STA PPU_DATA           \ Set palette 0 to the following:
 STY PPU_DATA           \
 STY PPU_DATA           \   * Colour 0 = background (black)
                        \
                        \   * Colour 1 = hidden colour
                        \
                        \   * Colour 2 = visible colour
                        \
                        \   * Colour 3 = visible colour
                        \
                        \ So pixels in colour 1 will be invisible, while pixels
                        \ in colour 2 will be visible

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

.paph1

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDA hiddenColour       \ Set A to the colour to use for hidden pixels

 STY PPU_DATA           \ Set palette 0 to the following:
 STA PPU_DATA           \
 STY PPU_DATA           \   * Colour 0 = background (black)
                        \
                        \   * Colour 1 = visible colour
                        \
                        \   * Colour 2 = hidden colour
                        \
                        \   * Colour 3 = visible colour
                        \
                        \ So pixels in colour 1 will be visible, while pixels
                        \ in colour 2 will be invisible

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

.paph2

                        \ If we get here then this is not the space view

 CMP #&98               \ If this is the Status Mode screen, jump to paph3
 BEQ paph3

                        \ If we get here then this is not the space view or the
                        \ Status Mode screen

 LDA #&3F               \ Set PPU_ADDR = &3F15, so it points to sprite palette 1
 STA PPU_ADDR           \ in the PPU
 LDA #&15
 STA PPU_ADDR

 LDA visibleColour      \ Set palette 0 to the following:
 STA PPU_DATA           \
 LDA paletteColour2     \   * Colour 0 = background (black)
 STA PPU_DATA           \
 LDA paletteColour3     \   * Colour 1 = visible colour
 STA PPU_DATA           \
                        \   * Colour 2 = paletteColour2
                        \
                        \   * Colour 3 = paletteColour3

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

.paph3

                        \ If we get here then this is the Status Mode screen

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDA visibleColour      \ Set palette 0 to the following:
 STA PPU_DATA           \
 LDA paletteColour2     \   * Colour 0 = background (black)
 STA PPU_DATA           \
 LDA paletteColour3     \   * Colour 1 = visible colour
 STA PPU_DATA           \
                        \   * Colour 2 = paletteColour2
                        \
                        \   * Colour 3 = paletteColour3

 LDA #&00               \ Change the PPU address away from the palette entries
 STA PPU_ADDR           \ to prevent the palette being corrupted
 LDA #&00
 STA PPU_ADDR

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SendPalettesToPPU
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Send the palette data from XX3 to the PPU
\
\ ******************************************************************************

.SendPalettesToPPU

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to palette 0 in
 STA PPU_ADDR           \ the PPU
 LDA #&01
 STA PPU_ADDR

 LDX #1                 \ We are about to send the palette data from XX3 to
                        \ the PPU, so set an index counter in X so we send the
                        \ following:
                        \
                        \   XX3+1 goes to &3F01
                        \   XX3+2 goes to &3F02
                        \   ...
                        \   XX3+&30 goes to &3F30
                        \   XX3+&31 goes to &3F31
                        \
                        \ So the following loop sends data for the four
                        \ background palettes and the four sprite palettes

.sepa1

 LDA XX3,X              \ Set A to the X-th entry in XX3

 AND #%00111111         \ Clear bits 6 and 7

 STA PPU_DATA           \ Send the palette entry to the PPU

 INX                    \ Increment the loop counter

 CPX #&20               \ Loop back until we have sent XX3+1 through XX3+&1F
 BNE sepa1

 SUBTRACT_CYCLES 559    \ Subtract 559 from the cycle count

 JMP UpdateScreen+4     \ Return to UpdateScreen to continue with the next
                        \ instruction following the call to this routine

\ ******************************************************************************
\
\       Name: UpdateScreen
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Update the screen with the contents of the buffers
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   UpdateScreen+4      Re-entry point following the call to SendPalettesToPPU
\                       at the start of the routine
\
\ ******************************************************************************

.UpdateScreen

 LDA updatePaletteInNMI \ If updatePaletteInNMI is non-zero, then jump up to
 BNE SendPalettesToPPU  \ SendPalettesToPPU to send the palette data in XX3 to
                        \ the PPU, before continuing with the next instruction

 JSR SendBuffersToPPU   \ Send the contents of the nametable and pattern buffers
                        \ to the PPU to update the screen

 JSR SetPPURegisters    \ Set PPU_CTRL, PPU_ADDR and PPU_SCROLL for the current
                        \ palette bitplane

 LDA cycleCount         \ Add 100 (&0064) to cycleCount
 CLC
 ADC #&64
 STA cycleCount
 LDA cycleCount+1
 ADC #&00
 STA cycleCount+1

 BMI upsc1              \ If cycleCount is negative, skip the following
                        \ instruction

 JSR ClearBuffers       \ ???

.upsc1

 LDA #%00011110         \ Set PPU_MASK as follows:
 STA PPU_MASK           \
                        \   * Bit 0 clear = normal colour (i.e. not monochrome)
                        \   * Bit 1 set   = show leftmost 8 pixels of background
                        \   * Bit 2 set   = show sprites in leftmost 8 pixels
                        \   * Bit 3 set   = show background
                        \   * Bit 4 set   = show sprites
                        \   * Bit 5 clear = do not intensify greens
                        \   * Bit 6 clear = do not intensify blues
                        \   * Bit 7 clear = do not intensify reds

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetPPURegisters
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Set PPU_CTRL, PPU_ADDR and PPU_SCROLL for the current palette
\             bitplane
\
\ ******************************************************************************

.SetPPURegisters

 LDX #%10010000         \ Set X to use as the value of PPU_CTRL for when
                        \ paletteBitplane is 1:
                        \ 
                        \   * Bits 0-1    = base nametable address %00 (&2000)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 set   = background pattern table is at &1000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 set   = enable VBlank NMI generation

 LDA paletteBitplane    \ If paletteBitplane is non-zero, skip the following
 BNE resp1

 LDX #%10010001         \ Set X to use as the value of PPU_CTRL for when
                        \ paletteBitplane is 0:
                        \ 
                        \   * Bits 0-1    = base nametable address %01 (&2400)
                        \   * Bit 2 clear = increment PPU_ADDR by 1 each time
                        \   * Bit 3 clear = sprite pattern table is at &0000
                        \   * Bit 4 set   = background pattern table is at &1000
                        \   * Bit 5 clear = sprites are 8x8 pixels
                        \   * Bit 6 clear = use PPU 0 (the only option on a NES)
                        \   * Bit 7 set   = enable VBlank NMI generation

.resp1

 STX PPU_CTRL           \ Configure the PPU with the correct value of PPU_CTRL
                        \ for the current palette bitplane

 STX ppuCtrlCopy        \ Store a copy of PPU_CTRL in ppuCtrlCopy

 LDA #&20               \ If paletteBitplane = 0 then set A = &24, otherwise set
 LDX paletteBitplane    \ A = &20, to use as the high byte of the PPU_ADDR
 BNE resp2              \ address
 LDA #&24

.resp2

 STA PPU_ADDR           \ Set PPU_ADDR to point to the nametable address that we
 LDA #&00               \ just configured:
 STA PPU_ADDR           \
                        \   * &2000 (nametable 0) when paletteBitplane = 0
                        \
                        \   * &2400 (nametable 1) when paletteBitplane = 1

 LDA PPU_DATA           \ Read from PPU_DATA eight times to clear the pipeline
 LDA PPU_DATA           \ and reset the internal PPU read buffer
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA
 LDA PPU_DATA

 LDA #8                 \ Set the horizontal scroll to 8, so the leftmost tile
 STA PPU_SCROLL         \ on each row is not visible ???

 LDA #0                 \ Set the vertical scroll to 0
 STA PPU_SCROLL

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetPPUTablesTo0
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: Set nametable 0 and pattern table 0 for drawing the icon bar
\
\ ******************************************************************************

.SetPPUTablesTo0

 LDA #0                 \ Clear bit 7 of setupPPUForIconBar, so this routine
 STA setupPPUForIconBar \ doesn't get called again until the next NMI interrupt
                        \ at the next VBlank (as the SETUP_PPU_FOR_ICON_BAR
                        \ macro and SetupPPUForIconBar routine only update the
                        \ PPU when bit 7 is set)

 LDA ppuCtrlCopy        \ Set A to the current value of PPU_CTRL

 AND #%11101110         \ Clear bits 0 and 4, which will set the base nametable
                        \ address to &2000 (for nametable 0) and the pattern
                        \ table address to &0000 (for pattern table 0)

 STA PPU_CTRL           \ Update PPU_CTRL to set nametable 0 and pattern table 0

 STA ppuCtrlCopy        \ Store the new value of PPU_CTRL in ppuCtrlCopy

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ClearBuffers
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.ClearBuffers

 LDA cycleCount+1
 BEQ CD0D0

 SUBTRACT_CYCLES 363    \ Subtract 363 from the cycle count

 BMI CD092
 JMP CD0A1

.CD092

 ADD_CYCLES 318         \ Add 318 to the cycle count

 JMP CD0D0

.CD0A1

 LDA addr7              \ Store addr7(1 0) and addr6(1 0) on the stack
 PHA
 LDA addr7+1
 PHA
 LDA addr6
 PHA
 LDA addr6+1
 PHA

 LDX #0
 JSR ClearPlaneBuffers

 LDX #1
 JSR ClearPlaneBuffers

 PLA                    \ Retore addr7(1 0) and addr6(1 0) from the stack
 STA addr6+1
 PLA
 STA addr6
 PLA
 STA addr7+1
 PLA
 STA addr7

 ADD_CYCLES_CLC 238     \ Add 238 to the cycle count

.CD0D0

 SUBTRACT_CYCLES 32     \ Subtract 32 from the cycle count

 BMI CD0E2
 JMP CD0F1

.CD0E2

 ADD_CYCLES 65527       \ Add 65527 to the cycle count (i.e. subtract 9)

 JMP CD0F7

.CD0F1

 NOP
 NOP
 NOP
 JMP CD0D0

.CD0F7

 RTS

\ ******************************************************************************
\
\       Name: ReadControllers
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ReadControllers

 LDA #1
 STA JOY1
 LSR A
 STA JOY1
 TAX
 JSR ScanButtons
 LDX scanController2
 BEQ CD15A

\ ******************************************************************************
\
\       Name: ScanButtons
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ScanButtons

 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1A,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1B,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1Select,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1Start,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1Up,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1Down,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1Left,X
 LDA JOY1,X
 AND #3
 CMP #1
 ROR controller1Right,X

.CD15A

 RTS

\ ******************************************************************************
\
\       Name: Unused copy of WSCAN
\       Type: Subroutine
\   Category: Utility routines
\    Summary: An unused copy of WSCAN that waits for the next VBlank, but
\             without checking if the PPU has started drawing the icon bar
\
\ ******************************************************************************

 LDA frameCounter       \ Set A to the frame counter, which increments with each
                        \ call to the NMI handler

.wscn1

 CMP frameCounter       \ Loop back to wscn1 until the frame counter changes,
 BEQ wscn1              \ which will happen when the NMI handler is called again
                        \ (i.e. at the next VBlank)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait until the next NMI interrupt (i.e. the next VBlank)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   WSCAN-3             Wait until two NMI interrupts have passed
\
\ ******************************************************************************

 JSR WSCAN              \ Call WSCAN to wait for the next NMI interrupt, then
                        \ fall through into WSCAN to wait for the next one

.WSCAN

 PHA                    \ Store A on the stack to preserve it

 LDX frameCounter       \ Set X to the frame counter, which increments with each
                        \ call to the NMI handler

.WSCAN1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 CPX frameCounter       \ Loop back to WSCAN1 until the frame counter changes,
 BEQ WSCAN1             \ which will happen when the NMI handler is called again
                        \ (i.e. at the next VBlank)

 PLA                    \ Retrieve A from the stack so that it's preserved

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: subm_D17F
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D17F

 LDA setupPPUForIconBar
 BEQ subm_D17F

.loop_CD183

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA setupPPUForIconBar
 BNE loop_CD183
 RTS

\ ******************************************************************************
\
\       Name: subm_D19C
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

 LDX #0
 JSR subm_D19C
 LDX #1

.subm_D19C

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA bitplaneFlags,X
 BEQ CD1C7
 AND #%00100000
 BNE CD1B8
 JSR CD1C8
 JMP subm_D19C

.CD1B8

 JSR CD1C8
 LDA #0
 STA bitplaneFlags,X
 LDA pattTileNumber
 STA tileNumber
 JMP DrawBoxTop

.CD1C7

 RTS

.CD1C8

 LDY frameCounter
 LDA nameTileNumber1,X
 STA SC
 LDA nameTileNumber2,X
 CPY frameCounter
 BNE CD1C8
 LDY SC
 CPY maxTileNumber
 BCC CD1DE
 LDY maxTileNumber

.CD1DE

 STY SC
 CMP SC
 BCS CD239
 STY nameTileNumber2,X
 LDY #0
 STY addr6+1
 ASL A
 ROL addr6+1
 ASL A
 ROL addr6+1
 ASL A
 STA addr6
 LDA addr6+1
 ROL A
 ADC nameBufferHiAddr,X
 STA addr6+1
 LDA #0
 ASL SC
 ROL A
 ASL SC
 ROL A
 ASL SC
 ROL A
 ADC nameBufferHiAddr,X
 STA SC+1

.CD20B

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC
 SEC
 SBC addr6
 STA addr7
 LDA SC+1
 SBC addr6+1
 BCC CD239
 STA addr7+1
 ORA addr7
 BEQ CD239
 LDA #3
 STA cycleCount+1
 LDA #&16
 STA cycleCount
 JSR ClearMemory
 JMP CD20B

.CD239

 LDY frameCounter
 LDA pattTileNumber1,X
 STA SC
 LDA pattTileNumber2,X
 CPY frameCounter
 BNE CD239
 LDY SC
 CMP SC
 BCS CD2A2
 STY pattTileNumber2,X
 LDY #0
 STY addr6+1
 ASL A
 ROL addr6+1
 ASL A
 ROL addr6+1
 ASL A
 STA addr6
 LDA addr6+1
 ROL A
 ADC pattBufferHiAddr,X
 STA addr6+1
 LDA #0
 ASL SC
 ROL A
 ASL SC
 ROL A
 ASL SC
 ROL A
 ADC pattBufferHiAddr,X
 STA SC+1

.CD274

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC
 SEC
 SBC addr6
 STA addr7
 LDA SC+1
 SBC addr6+1
 BCC CD239
 STA addr7+1
 ORA addr7
 BEQ CD2A2
 LDA #3
 STA cycleCount+1
 LDA #&16
 STA cycleCount
 JSR ClearMemory
 JMP CD274

.CD2A2

 RTS

\ ******************************************************************************
\
\       Name: LD2A3
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LD2A3

 EQUB %00110000

\ ******************************************************************************
\
\       Name: ClearPlaneBuffers
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.CD2A4

 NOP
 NOP

.CD2A6

 SUBTRACT_CYCLES 39     \ Subtract 39 from the cycle count

.CD2B3

 RTS

.CD2B4

 ADD_CYCLES_CLC 126     \ Add 126 to the cycle count

 JMP CD37E

.ClearPlaneBuffers

 LDA cycleCount+1
 BEQ CD2B3

 LDA bitplaneFlags,X
 BIT LD2A3
 BEQ CD2A4

 AND #8
 BEQ CD2A6

 SUBTRACT_CYCLES 213    \ Subtract 213 from the cycle count

 BMI CD2E6
 JMP CD2F5

.CD2E6

 ADD_CYCLES 153         \ Add 153 to the cycle count

 JMP CD2B3

.CD2F5

 LDA nameTileNumber2,X
 LDY nameTileNumber1,X
 CPY maxTileNumber
 BCC CD2FF
 LDY maxTileNumber

.CD2FF

 STY addr7
 CMP addr7
 BCS CD2B4

 LDY #0
 STY addr6+1
 ASL A
 ROL addr6+1
 ASL A
 ROL addr6+1
 ASL A
 STA addr6
 LDA addr6+1
 ROL A
 ADC nameBufferHiAddr,X
 STA addr6+1

 LDA #0
 ASL addr7
 ROL A
 ASL addr7
 ROL A
 ASL addr7
 ROL A
 ADC nameBufferHiAddr,X
 STA addr7+1

 LDA addr7
 SEC
 SBC addr6
 STA addr7
 LDA addr7+1
 SBC addr6+1
 BCC CD359
 STA addr7+1
 ORA addr7
 BEQ CD35D
 JSR ClearMemory
 LDA addr6+1
 SEC
 SBC nameBufferHiAddr,X
 LSR A
 ROR addr6
 LSR A
 ROR addr6
 LSR A
 LDA addr6
 ROR A
 CMP nameTileNumber2,X
 BCC CD37B
 STA nameTileNumber2,X
 JMP CD37E

.CD359

 NOP
 NOP
 NOP
 NOP

.CD35D

 ADD_CYCLES_CLC 28      \ Add 28 to the cycle count

 JMP CD37E

.CD36D

 ADD_CYCLES_CLC 126     \ Add 126 to the cycle count

.CD37A

 RTS

.CD37B

 NOP
 NOP
 NOP

.CD37E

 SUBTRACT_CYCLES 187    \ Subtract 187 from the cycle count

 BMI CD390
 JMP CD39F

.CD390

 ADD_CYCLES 146         \ Add 146 to the cycle count

 JMP CD37A

.CD39F

 LDA pattTileNumber2,X
 LDY pattTileNumber1,X
 STY addr7
 CMP addr7
 BCS CD36D
 NOP

 LDY #0
 STY addr6+1
 ASL A
 ROL addr6+1
 ASL A
 ROL addr6+1
 ASL A
 STA addr6
 LDA addr6+1
 ROL A
 ADC pattBufferHiAddr,X
 STA addr6+1

 LDA #0
 ASL addr7
 ROL A
 ASL addr7
 ROL A
 ASL addr7
 ROL A
 ADC pattBufferHiAddr,X
 STA addr7+1
 LDA addr7
 SEC
 SBC addr6
 STA addr7
 LDA addr7+1
 SBC addr6+1
 BCC CD3FC
 STA addr7+1
 ORA addr7
 BEQ CD401

 JSR ClearMemory

 LDA addr6+1
 SEC
 SBC pattBufferHiAddr,X
 LSR A
 ROR addr6
 LSR A
 ROR addr6
 LSR A
 LDA addr6
 ROR A
 CMP pattTileNumber2,X
 BCC CD3FC
 STA pattTileNumber2,X
 RTS

.CD3FC

 NOP
 NOP
 NOP
 NOP
 RTS

.CD401

 ADD_CYCLES_CLC 35      \ Add 35 to the cycle count

 RTS

\ ******************************************************************************
\
\       Name: FillMemory
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.FillMemory

 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY

\ ******************************************************************************
\
\       Name: FillMemory32Bytes
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.FillMemory32Bytes

 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 RTS

\ ******************************************************************************
\
\       Name: ClearMemory
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ******************************************************************************

.ClearMemory

 LDA addr7+1
 BEQ CD789

 SUBTRACT_CYCLES 2105   \ Subtract 2105 from the cycle count

 BMI CD726
 JMP CD735

.CD726

 ADD_CYCLES 2059        \ Add 2059 to the cycle count

 JMP CD743

.CD735

 LDA #0
 LDY #0
 JSR FillMemory
 DEC addr7+1
 INC addr6+1
 JMP ClearMemory

.CD743

 SUBTRACT_CYCLES 318    \ Subtract 318 from the cycle count

 BMI CD755
 JMP CD764

.CD755

 ADD_CYCLES 277         \ Add 277 to the cycle count

 JMP CD788

.CD764

 LDA #0
 LDY #0
 JSR FillMemory32Bytes
 LDA addr6
 CLC
 ADC #&20
 STA addr6
 LDA addr6+1
 ADC #0
 STA addr6+1
 JMP CD743

.CD77B

 ADD_CYCLES_CLC 132     \ Add 132 to the cycle count

.CD788

 RTS

.CD789

 SUBTRACT_CYCLES 186    \ Subtract 186 from the cycle count

 BMI CD79B
 JMP CD7AA

.CD79B

 ADD_CYCLES 138         \ Add 138 to the cycle count

 JMP CD788

.CD7AA

 LDA addr7
 BEQ CD77B
 LSR A
 LSR A
 LSR A
 LSR A
 CMP cycleCount+1
 BCS CD809
 LDA #0
 STA addr7+1
 LDA addr7
 ASL A
 ROL addr7+1
 ASL A
 ROL addr7+1
 ASL A
 ROL addr7+1
 EOR #&FF
 SEC
 ADC cycleCount
 STA cycleCount
 LDA addr7+1
 EOR #&FF
 ADC cycleCount+1
 STA cycleCount+1
 LDY #0
 STY addr7+1
 LDA addr7
 PHA
 ASL A
 ROL addr7+1
 ADC addr7
 STA addr7
 LDA addr7+1
 ADC #0
 STA addr7+1
 LDA #LO(ClearMemory)
 SBC addr7
 STA addr7
 LDA #HI(ClearMemory)
 SBC addr7+1
 STA addr7+1
 LDA #0
 JSR CD806
 PLA
 CLC
 ADC addr6
 STA addr6
 LDA addr6+1
 ADC #0
 STA addr6+1
 RTS

.CD806

 JMP (addr7)

.CD809

 ADD_CYCLES_CLC 118     \ Add 118 to the cycle count

.CD816

 SUBTRACT_CYCLES 321    \ Subtract 321 from the cycle count

 BMI CD828
 JMP CD837

.CD828

 ADD_CYCLES 280         \ Add 280 to the cycle count

 JMP CD855

.CD837

 LDA addr7
 SEC
 SBC #&20
 BCC CD856
 STA addr7
 LDA #0
 LDY #0
 JSR FillMemory32Bytes
 LDA addr6
 CLC
 ADC #&20
 STA addr6
 BCC CD816
 INC addr6+1
 JMP CD816

.CD855

 RTS

.CD856

 ADD_CYCLES_CLC 269     \ Add 269 to the cycle count

.CD863

 SUBTRACT_CYCLES 119    \ Subtract 119 from the cycle count

 BMI CD875
 JMP CD884

.CD875

 ADD_CYCLES 78          \ Add 78 to the cycle count

 JMP CD855

.CD884

 LDA addr7
 SEC
 SBC #8
 BCC CD8B7
 STA addr7
 LDA #0
 LDY #0
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 STA (addr6),Y
 INY
 LDA addr6
 CLC
 ADC #8
 STA addr6
 BCC CD8B4
 INC addr6+1

.CD8B4

 JMP CD863

.CD8B7

 ADD_CYCLES_CLC 66      \ Add 66 to the cycle count

 RTS

\ ******************************************************************************
\
\       Name: subm_D8C5
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D8C5

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA bitplaneFlags
 AND #%01000000
 BNE subm_D8C5

 LDA bitplaneFlags+1
 AND #%01000000
 BNE subm_D8C5

 RTS

\ ******************************************************************************
\
\       Name: ChangeDrawingPlane
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.ChangeDrawingPlane

 LDA drawingBitplane
 EOR #1
 TAX
 JSR SetDrawingBitplane
 JMP subm_D19C

\ ******************************************************************************
\
\       Name: SetDrawingBitplane
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: ???
\
\ ******************************************************************************

.SetDrawingBitplane

 STX drawingBitplane
 LDA nextTileNumber,X
 STA tileNumber
 LDA nameBufferHiAddr,X
 STA nameBufferHi
 LDA #0
 STA pattBufferAddr
 STA drawingPlaneDebug

\ ******************************************************************************
\
\       Name: SetPatternBuffer
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SetPatternBuffer

 LDA pattBufferHiAddr,X
 STA pattBufferAddr+1
 LSR A
 LSR A
 LSR A
 STA pattBufferHiDiv8
 RTS

\ ******************************************************************************
\
\       Name: subm_D908
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D908

 LDY #0

.CD90A

 LDA (V),Y
 STA (SC),Y
 DEY
 BNE CD90A
 INC V+1
 INC SC+1
 DEX
 BNE CD90A
 RTS

\ ******************************************************************************
\
\       Name: subm_D919
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D919

 LDY #0
 INC V
 INC V+1

.CD91F

 LDA (SC2),Y
 STA (SC),Y
 INY
 BNE CD92A
 INC SC+1
 INC SC2+1

.CD92A

 DEC V
 BNE CD91F
 DEC V+1
 BNE CD91F
 RTS

\ ******************************************************************************
\
\       Name: subm_D933
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D933

 LDA PPU_STATUS

.loop_CD936

 LDA PPU_STATUS
 BPL loop_CD936

.loop_CD93B

 LDA PPU_STATUS
 BPL loop_CD93B

.CD940

 LDA PPU_STATUS
 BPL CD940
 RTS

\ ******************************************************************************
\
\       Name: subm_D946
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D946

 TXA
 PHA
 JSR CD940
 JSR PlayMusic_b6
 PLA
 TAX
 RTS

\ ******************************************************************************
\
\       Name: subm_D951
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D951

 JSR subm_D8C5

 LDA tileNumber
 STA nextTileNumber
 STA nextTileNumber+1

 LDA #88
 STA nameTileNumber

 LDA #100
 STA lastTileNumber
 STA lastTileNumber+1

 LDA #%11000100         \ Set bits 2, 6 and 7 of both bitplane flags
 STA bitplaneFlags
 STA bitplaneFlags+1

 JMP subm_D8C5

\ ******************************************************************************
\
\       Name: subm_D96F
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D96F

 JSR ChangeDrawingPlane
 JSR LL9_b1

\ ******************************************************************************
\
\       Name: subm_D975
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D975

 LDA #%11001000

\ ******************************************************************************
\
\       Name: subm_D977
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_D977

 PHA

 JSR DrawBoxEdges

 LDX drawingBitplane
 LDA tileNumber
 STA nextTileNumber,X

 PLA
 STA bitplaneFlags,X

 RTS

\ ******************************************************************************
\
\       Name: SendToPPU2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SendToPPU2

 LDY #0
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA (SC),Y
 STA PPU_DATA
 INY
 LDA SC
 CLC
 ADC #&10
 STA SC
 BCC CD9F3
 INC SC+1

.CD9F3

 DEX
 BNE SendToPPU2
 RTS

INCLUDE "library/common/main/variable/twos.asm"
INCLUDE "library/common/main/variable/twos2.asm"
INCLUDE "library/common/main/variable/twfl.asm"
INCLUDE "library/common/main/variable/twfr.asm"
INCLUDE "library/nes/main/variable/ylookuplo.asm"
INCLUDE "library/nes/main/variable/ylookuphi.asm"

\ ******************************************************************************
\
\       Name: subm_DBD8
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_DBD8

 LDA #0
 STA SC+1
 LDA YC
 BEQ CDBFE
 LDA YC
 CLC
 ADC #1
 ASL A
 ASL A
 ASL A
 ASL A
 ROL SC+1
 SEC
 ROL A
 ROL SC+1
 STA SC
 STA SC2
 LDA SC+1
 ADC #&70
 STA SC+1
 ADC #4
 STA SC2+1
 RTS

.CDBFE

 LDA #HI(nameBuffer0+1*32+1)    \ Set SC(1 0) to the address of the second tile
 STA SC+1                       \ on tile row 1 in nametable buffer 0
 LDA #LO(nameBuffer0+1*32+1)
 STA SC

 LDA #HI(nameBuffer1+1*32+1)    \ Set SC2(1 0) to the address of the second tile
 STA SC2+1                      \ on tile row 1 in nametable buffer 1
 LDA #LO(nameBuffer1+1*32+1)
 STA SC2

 RTS

INCLUDE "library/common/main/subroutine/loin_part_1_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_2_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_3_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_4_of_7.asm"
INCLUDE "library/common/main/subroutine/loin_part_5_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_6_of_7.asm"
INCLUDE "library/nes/main/subroutine/loin_part_7_of_7.asm"

\ ******************************************************************************
\
\       Name: FillCharacterBlock
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: ???
\
\ ******************************************************************************

.FillCharacterBlock

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY YSAV
 LDA P
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC2
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC2+1
 LDA P+1
 SEC
 SBC P
 LSR A
 LSR A
 LSR A
 TAY
 DEY

.CE075

 LDA (SC2),Y
 BNE CE083
 LDA #&33
 STA (SC2),Y
 DEY
 BPL CE075
 LDY YSAV
 RTS

.CE083

 STY T
 LDY pattBufferHiDiv8
 STY SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #7

.loop_CE0A3

 LDA #&FF
 EOR (SC),Y
 STA (SC),Y
 DEY
 BPL loop_CE0A3
 LDY T
 DEY
 BPL CE075
 LDY YSAV
 RTS

\ ******************************************************************************
\
\       Name: HLOIN (Part 1 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line from (X1, Y1) to (X2, Y1)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.hlin1

 JMP hlin23             \ Jump to hlin23 to ???

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

.hlin2

 RTS                    \ Return from the subroutine

.HLOIN

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDX X1                 \ Set X = X1

 CPX X2                 \ If X1 = X2 then the start and end points are the same,
 BEQ hlin2              \ so return from the subroutine (as hlin2 contains
                        \ an RTS)

 BCC hlin3              \ If X1 < X2, jump to hlin3 to skip the following code,
                        \ as (X1, Y1) is already the left point

 LDA X2                 \ Swap the values of X1 and X2, so we know that (X1, Y1)
 STA X1                 \ is on the left and (X2, Y1) is on the right
 STX X2

 TAX                    \ Set X = X1

.hlin3

 DEC X2                 \ Decrement X2 so we do not draw a pixel at the end
                        \ point

 TXA                    \ Set SC2(1 0) = yLookup(Y) + X1 * 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC2                \ Adding nameBufferHi and X1 * 8 therefore sets SC2(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC2+1              \ the pixel at (X1, Y), i.e. the line we are drawing

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)
                        \
                        \ As we are drawing a horizontal line, we do not need to
                        \ vary the value of Y, as we will always want to draw on
                        \ the same pixel row within each character block

 TXA                    \ Set T = X1 with bits 0-2 cleared
 AND #%11111000         \
 STA T                  \ Each character block contains 8 pixel rows, so to get
                        \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2
                        \
                        \ T is therefore the offset within the row of the start
                        \ of the line at x-coordinate X1

 LDA X2                 \ Set A = X2 with bits 0-2 cleared
 AND #%11111000         \
 SEC                    \ A is therefore the offset within the row of the end
                        \ of the line at x-coordinate X2

 SBC T                  \ Set A = A - T
                        \
                        \ So A contains the width of the line in terms of pixel
                        \ bytes (which is the same as the number of character
                        \ blocks that the line spans, less 1 and multiplied by
                        \ 8)

 BEQ hlin1              \ If the line starts and ends in the same character
                        \ block then A will be zero, so jump to hlin23 via hlin1
                        \ to ???

 LSR A                  \ Otherwise set R = A / 8
 LSR A                  \
 LSR A                  \ So R contains the number of character blocks that the
 STA R                  \ line spans, less 1 (so R = 0 means it spans one block,
                        \ R = 1 means it spans two blocks, and so on)

\ ******************************************************************************
\
\       Name: HLOIN (Part 2 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the left end of the line
\
\ ******************************************************************************

                        \ We now start the drawing process, beginning with the
                        \ left end of the line, whose nametable entry is in
                        \ SC2(1 0)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BNE hlin5              \ tile has already been allocated to this entry, so skip
                        \ the following

 LDA tileNumber         \ If tileNumber is zero then we have run out of tiles to
 BEQ hlin4              \ use for drawing lines and pixels, so jump to hlin9 via
                        \ hlin4 to move on to the next character block to the
                        \ right, as we don't have enough dynamic tiles to draw
                        \ the left end of the line

 STA (SC2,X)            \ Otherwise tileNumber contains the number of the next
                        \ available tile for drawing, so allocate this tile to
                        \ cover the pixels that we want to draw by setting the
                        \ nametable entry to the tile number we just fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 JMP hlin7              \ Jump to hlin7 to draw the line, starting by drawing
                        \ the left end into the newly allocated tile number in A

.hlin4

 JMP hlin9              \ Jump to hlin9 to move right by one character block
                        \ without drawing anything

.hlin5

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A >= 60, then the tile that's already allocated is
 BCS hlin7              \ one of the tiles we have reserved for dynamic drawing,
                        \ so jump to hlin7 to draw the line, starting by drawing
                        \ the left end into the tile number in A

 CMP #37                \ If A < 37, then the tile that's already allocated is
 BCC hlin4              \ one of the icon bar tiles, so jump to hlin9 via hlin4
                        \ to move right by one character block without drawing
                        \ anything, as we can't draw on the icon bar

                        \ If we get here then 37 <= A <= 59, so the tile that's
                        \ already allocated is one of the pre-rendered tiles
                        \ containing horizontal and vertical line patterns
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered tile's pattern in a newly
                        \ allocated dynamic tile, and then draw our line into
                        \ the dynamic tile, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC3+1              \ pattern that we want to copy
 STA SC3

 LDA tileNumber         \ If tileNumber is zero then we have run out of dynamic
 BEQ hlin4              \ tiles for drawing lines and pixels, so jump to hlin9
                        \ via hlin4 to move right by one character block without
                        \ drawing anything, as we don't have enough dynamic
                        \ tiles to draw the left end of the line

 LDX #0                 \ Otherwise tileNumber contains the number of the next
 STA (SC2,X)            \ available tile for drawing, so allocate this tile to
                        \ contain the pre-rendered tile that we want to copy by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the dynamic tile we just fetched
 ROL SC+1
 STA SC

                        \ We now have a new dynamic tile in SC(1 0) into which
                        \ we can draw the left end of our line, so we now need
                        \ to copy the pattern of the pre-rendered tile that we
                        \ want to draw on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC3(1 0) to SC(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC3(1 0) to SC(1 0), so
                        \ set a counter in Y

.hlin6

 LDA (SC3),Y            \ Copy the Y-th byte of SC3(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 DEY                    \ Decrement the counter

 BPL hlin6              \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 JMP hlin8              \ Jump to hlin8 to draw the left end of the line into
                        \ the tile that we just copied

.hlin7

                        \ If we get here then we have either allocated a new
                        \ tile number for the line, or the tile number already
                        \ allocated to this part of the line is >= 60, which is
                        \ a dynamic tile into which we can draw
                        \
                        \ In either case the tile number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

.hlin8

                        \ We now draw the left end of our horizontal line

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

 EOR (SC),Y             \ Store this into the pattern buffer at SC(1 0), using
 STA (SC),Y             \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn the line's left cap

.hlin9

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer
 INC SC2+1

 LDX R                  \ Fetch the number of character blocks in which we need
                        \ to draw, which we stored in R above

 DEX                    \ If R = 1, then we only have the right cap to draw, so
 BNE hlin10             \ jump to hlin17 to draw the right end of the line
 JMP hlin17

.hlin10

 STX R                  \ Otherwise we haven't reached the right end of the line
                        \ yet, so decrement R as we have just drawn one block

\ ******************************************************************************
\
\       Name: HLOIN (Part 3 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the middle part of the line
\
\ ******************************************************************************

                        \ We now draw the middle part of the line (i.e. the part
                        \ between the left and right caps)

.hlin11

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hlin13             \ tile has not yet been allocated to this entry, so jump
                        \ to hlin13 to allocate a new dynamic tile

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A < 60, then the tile that's already allocated is
 BCC hlin15             \ either an icon bar tile, or one of the pre-rendered
                        \ tiles containing horizontal and vertical line
                        \ patterns, so jump to hlin15 to process drawing on top
                        \ off the pre-rendered tile

                        \ If we get here then the tile number already allocated
                        \ to this part of the line is >= 60, which is a dynamic
                        \ tile into which we can draw
                        \
                        \ The tile number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 EOR (SC),Y             \ Store this into the pattern buffer at SC(1 0), using
 STA (SC),Y             \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn one character block
                        \ of the middle portion of the line

.hlin12

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer
 INC SC2+1

 DEC R                  \ Decrement the number of character blocks in which we
                        \ need to draw, as we have just drawn one block

 BNE hlin11             \ If there are still more character blocks to draw, loop
                        \ back to hlin11 to draw the next one

 JMP hlin17             \ Otherwise we have finished drawing the middle portion
                        \ of the line, so jump to hlin17 to draw the right end
                        \ of the line

.hlin13

                        \ If we get here then there is no dynamic tile allocated
                        \ to the part of the line we want to draw, so we can use
                        \ one of the pre-rendered tiles that contains an 8-pixel
                        \ horizontal line on the correct pixel row
                        \
                        \ We jump here with X = 0

 TYA                    \ Set A = Y + 37
 CLC                    \
 ADC #37                \ Tiles 37 to 44 contain pre-rendered patterns as
                        \ follows:
                        \
                        \   * Tile 37 has a horizontal line on pixel row 0
                        \   * Tile 38 has a horizontal line on pixel row 1
                        \     ...
                        \   * Tile 43 has a horizontal line on pixel row 6
                        \   * Tile 44 has a horizontal line on pixel row 7
                        \
                        \ So A contains the pre-rendered tile number that
                        \ contains an 8-pixel line on pixel row Y, and as Y
                        \ contains the offset of the pixel row for the line we
                        \ are drawing, this means A contains the correct tile
                        \ number for this part of the line

 STA (SC2,X)            \ Display the pre-rendered tile on-screen by setting
                        \ the nametable entry to A

 JMP hlin12             \ Jump up to hlin12 to move on to the next character
                        \ block to the right

.hlin14

                        \ If we get here then A + Y = 50, which means we can
                        \ alter the current pre-rendered tile to draw our line
                        \
                        \ This is how it works. Tiles 44 to 51 contain
                        \ pre-rendered patterns as follows:
                        \
                        \   * Tile 44 has a horizontal line on pixel row 7
                        \   * Tile 45 is filled from pixel row 7 to pixel row 6
                        \   * Tile 46 is filled from pixel row 7 to pixel row 5
                        \     ...
                        \   * Tile 50 is filled from pixel row 7 to pixel row 1
                        \   * Tile 51 is filled from pixel row 7 to pixel row 0
                        \
                        \ Y contains the number of the pixel row for the line we
                        \ are drawing, so if A + Y = 50, this means:
                        \
                        \   * We want to draw pixel row 0 on top of tile 50
                        \   * We want to draw pixel row 1 on top of tile 49
                        \     ...
                        \   * We want to draw pixel row 5 on top of tile 45
                        \   * We want to draw pixel row 6 on top of tile 44
                        \
                        \ In other words, if A + Y = 50, then we want to draw
                        \ the pixel row just above the rows that are already
                        \ filled in the pre-rendered pattern, which means we
                        \ can simply swap the pre-rendered pattern to the next
                        \ one in the list (e.g. going from four filled lines to
                        \ five filled lines, for example)
                        \
                        \ We jump here with a BEQ, so the C flag is set for the
                        \ following addition, so the C flag can be used as the
                        \ plus 1 in the two's complement calculation

 TYA                    \ Set A = 51 + C + ~Y
 EOR #&FF               \       = 51 + (1 + ~Y)
 ADC #51                \       = 51 - Y
                        \
                        \ So A contains the number of the pre-rendered tile that
                        \ has our horizontal line drawn on pixel row Y, and all
                        \ the lines below that filled, which is what we want

 STA (SC2,X)            \ Display the pre-rendered tile on-screen by setting
                        \ the nametable entry to A

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer
 INC SC2+1

 DEC R                  \ Decrement the number of character blocks in which we
                        \ need to draw, as we have just drawn one block

 BNE hlin11             \ If there are still more character blocks to draw, loop
                        \ back to hlin11 to draw the next one

 JMP hlin17             \ Otherwise we have finished drawing the middle portion
                        \ of the line, so jump to hlin17 to draw the right end
                        \ of the line

.hlin15

                        \ If we get here then A <= 59, so the tile that's
                        \ already allocated is either an icon bar tile, or one
                        \ of the pre-rendered tiles containing horizontal and
                        \ vertical line patterns
                        \
                        \ We jump here with the C flag clear, so the addition
                        \ below will work correctly, and with X = 0, so the
                        \ write to (SC2,X) will also work properly

 STA SC                 \ Set SC to the number of the tile that is already
                        \ allocated to this part of the screen, so we can
                        \ retrieve it later

 TYA                    \ If A + Y = 50, then we are drawing our line just
 ADC SC                 \ above the top line of a pre-rendered tile that is
 CMP #50                \ filled from the bottom row to the row just below Y, 
 BEQ hlin14             \ so jump to hlin14 to switch this tile to another
                        \ pre-rendered tile that contains the line we want to
                        \ draw (see hlin14 for a full explanation of this logic)

                        \ If we get here then 37 <= A <= 59, so the tile that's
                        \ already allocated is one of the pre-rendered tiles
                        \ containing horizontal and vertical line patterns, but
                        \ isn't a tile we can simply replace with another
                        \ pre-rendered tile
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered tile's pattern in a newly
                        \ allocated dynamic tile, and then draw our line into
                        \ the dynamic tile, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDA tileNumber         \ If tileNumber is zero then we have run out of dynamic
 BEQ hlin12             \ tiles for drawing lines and pixels, so jump to hlin12
                        \ to move right by one character block without drawing
                        \ anything, as we don't have enough dynamic tiles to
                        \ draw this part of the line

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 STA (SC2,X)            \ Otherwise tileNumber contains the number of the next
                        \ available tile for drawing, so allocate this tile to
                        \ contain the pre-rendered tile that we want to copy by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the dynamic tile we just fetched
 ROL SC3+1
 STA SC3

 LDA SC                 \ Set A to the the number of the tile that is already
                        \ allocated to this part of the screen, which we stored
                        \ in SC above

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC+1               \ pattern that we want to copy
 STA SC

                        \ We now have a new dynamic tile in SC3(1 0) into which
                        \ we can draw the left end of our line, so we now need
                        \ to copy the pattern of the pre-rendered tile that we
                        \ want to draw on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC(1 0) to SC3(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC(1 0) to SC3(1 0), so
                        \ set a counter in Y

.hlin16

 LDA (SC),Y             \ Copy the Y-th byte of SC(1 0) to the Y-th byte of
 STA (SC3),Y            \ SC3(1 0)

 DEY                    \ Decrement the counter

 BPL hlin16             \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 EOR (SC3),Y            \ Store this into the pattern buffer at SC3(1 0), using
 STA (SC3),Y            \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn one character block
                        \ of the middle portion of the line

 JMP hlin12             \ Loop back to hlin12 to continue drawing  the line in
                        \ the next character block to the right

\ ******************************************************************************
\
\       Name: HLOIN (Part 4 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the right end of the line
\
\ ******************************************************************************

.hlin17

                        \ We now finish off the drawing process with the right
                        \ end of the line

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BNE hlin19             \ tile has already been allocated to this entry, so skip
                        \ the following

 LDA tileNumber         \ If tileNumber is zero then we have run out of tiles to
 BEQ hlin18             \ use for drawing lines and pixels, so jump to hlin30
                        \ via hlin18 to return from the subroutine, as we don't
                        \ have enough dynamic tiles to draw the right end of the
                        \ line

 STA (SC2,X)            \ Otherwise tileNumber contains the number of the next
                        \ available tile for drawing, so allocate this tile to
                        \ cover the pixels that we want to draw by setting the
                        \ nametable entry to the tile number we just fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 JMP hlin21             \ Jump to hlin21 to draw the right end of the line into
                        \ the newly allocated tile number in A

.hlin18

 JMP hlin30             \ Jump to hlin30 to return from the subroutine

.hlin19

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A >= 60, then the tile that's already allocated is
 BCS hlin21             \ oneof the tiles we have reserved for dynamic drawing,
                        \ so jump to hlin21 to draw the right end of the line

 CMP #37                \ If A < 37, then the tile that's already allocated is
 BCC hlin18             \ one of the icon bar tiles, so jump to hlin30 via
                        \ hlin18 to return from the subroutine, as we can't draw
                        \ on the icon bar

                        \ If we get here then 37 <= A <= 59, so the tile that's
                        \ already allocated is one of the pre-rendered tiles
                        \ containing horizontal and vertical line patterns
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered tile's pattern in a newly
                        \ allocated dynamic tile, and then draw our line into
                        \ the dynamic tile, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC3+1              \ pattern that we want to copy
 STA SC3

 LDA tileNumber         \ If tileNumber is zero then we have run out of dynamic
 BEQ hlin18             \ tiles for drawing lines and pixels, so jump to hlin30
                        \ via hlin18 to return from the subroutine, as we don't
                        \ have enough dynamic tiles to draw the right end of the
                        \ line

 LDX #0                 \ Otherwise tileNumber contains the number of the next
 STA (SC2,X)            \ available tile for drawing, so allocate this tile to
                        \ contain the pre-rendered tile that we want to copy by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the dynamic tile we just fetched
 ROL SC+1
 STA SC

                        \ We now have a new dynamic tile in SC(1 0) into which
                        \ we can draw the right end of our line, so we now need
                        \ to copy the pattern of the pre-rendered tile that we
                        \ want to draw on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC3(1 0) to SC(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC3(1 0) to SC(1 0), so
                        \ set a counter in Y

.hlin20

 LDA (SC3),Y            \ Copy the Y-th byte of SC3(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 DEY                    \ Decrement the counter

 BPL hlin20             \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 JMP hlin22             \ Jump to hlin22 to draw the right end of the line into
                        \ the tile that we just copied

.hlin21

                        \ If we get here then we have either allocated a new
                        \ tile number for the line, or the tile number already
                        \ allocated to this part of the line is >= 60, which is
                        \ a dynamic tile into which we can draw
                        \
                        \ In either case the tile number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

.hlin22

                        \ We now draw the right end of our horizontal line

 LDA X2                 \ Set X = X2 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line ends (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X), which is the
                        \ shape we want for the right end of the line

 JMP hlin29             \ Jump to hlin29 to poke the pixel byte into the pattern
                        \ buffer

\ ******************************************************************************
\
\       Name: HLOIN (Part 5 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the line when it's all within one character block
\
\ ******************************************************************************

.hlin23

                        \ If we get here then the line starts and ends in the
                        \ same character block

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BNE hlin25             \ tile has already been allocated to this entry, so skip
                        \ the following

 LDA tileNumber         \ If tileNumber is zero then we have run out of tiles to
 BEQ hlin24             \ use for drawing lines and pixels, so jump to hlin30
                        \ via hlin24 to return from the subroutine, as we don't
                        \ have enough dynamic tiles to draw the line

 STA (SC2,X)            \ Otherwise tileNumber contains the number of the next
                        \ available tile for drawing, so allocate this tile to
                        \ cover the pixels that we want to draw by setting the
                        \ nametable entry to the tile number we just fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 JMP hlin27             \ Jump to hlin27 to draw the line into the newly
                        \ allocated tile number in A

.hlin24

 JMP hlin30             \ Jump to hlin30 to return from the subroutine

.hlin25

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A >= 60, then the tile that's already allocated is
 BCS hlin27             \ one of the tiles we have reserved for dynamic drawing,
                        \ so jump to hlin27 to draw the line into the tile
                        \ number in A

 CMP #37                \ If A < 37, then the tile that's already allocated is
 BCC hlin24             \ one of the icon bar tiles, so jump to hlin30 via
                        \ hlin24 to return from the subroutine, as we can't draw
                        \ on the icon bar

                        \ If we get here then 37 <= A <= 59, so the tile that's
                        \ already allocated is one of the pre-rendered tiles
                        \ containing horizontal and vertical line patterns
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered tile's pattern in a newly
                        \ allocated dynamic tile, and then draw our line into
                        \ the dynamic tile, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC3+1              \ pattern that we want to copy
 STA SC3

 LDA tileNumber         \ If tileNumber is zero then we have run out of dynamic
 BEQ hlin24             \ tiles for drawing lines and pixels, so jump to hlin30
                        \ via hlin24 to return from the subroutine, as we don't
                        \ have enough dynamic tiles to draw the line

 LDX #0                 \ Otherwise tileNumber contains the number of the next
 STA (SC2,X)            \ available tile for drawing, so allocate this tile to
                        \ contain the pre-rendered tile that we want to copy by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC tileNumber         \ Increment tileNumber to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the dynamic tile we just fetched
 ROL SC+1
 STA SC

                        \ We now have a new dynamic tile in SC(1 0) into which
                        \ we can draw our line, so we now need to copy the
                        \ pattern of the pre-rendered tile that we want to draw
                        \ on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC3(1 0) to SC(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC3(1 0) to SC(1 0), so
                        \ set a counter in Y

.hlin26

 LDA (SC3),Y            \ Copy the Y-th byte of SC3(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 DEY                    \ Decrement the counter

 BPL hlin26             \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 JMP hlin28             \ Jump to hlin28 to draw the line into the tile that
                        \ we just copied

.hlin27

                        \ If we get here then we have either allocated a new
                        \ tile number for the line, or the tile number already
                        \ allocated to this part of the line is >= 60, which is
                        \ a dynamic tile into which we can draw
                        \
                        \ In either case the tile number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

.hlin28

                        \ We now draw our horizontal line into the relevant
                        \ character block

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

 STA T                  \ Store the pixel shape for the right end of the line in
                        \ T

 LDA X2                 \ Set X = X2 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line ends (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X), which is the
                        \ shape we want for the right end of the line

 AND T                  \ Set A to the overlap of the pixel byte for the left
                        \ end of the line (in T) and the right end of the line
                        \ (in A) by AND'ing them together, which gives us the
                        \ pixels that are in the horizontal line we want to draw

.hlin29

 EOR (SC),Y             \ Store this into the pattern buffer at SC(1 0), using
 STA (SC),Y             \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn our entire horizontal
                        \ line within this one character block

.hlin30

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawVerticalLine
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DrawVerticalLine

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY YSAV
 LDY Y1
 CPY Y2
 BEQ CE391
 BCC CE35C
 LDA Y2
 STA Y1
 STY Y2
 TAY

.CE35C

 LDA XX15
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC2
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC2+1
 LDA XX15
 AND #7
 STA S
 LDA Y2
 SEC
 SBC Y1
 STA R
 TYA
 AND #7
 TAY
 BNE CE394
 JMP CE43D

.CE384

 STY T
 LDA R
 ADC T
 SBC #7
 BCC CE391
 JMP CE423

.CE391

 LDY YSAV
 RTS

.CE394

 STY Q

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0
 LDA (SC2,X)
 BNE CE3B7
 LDA tileNumber
 BEQ CE3B4
 STA (SC2,X)
 INC tileNumber
 JMP CE3F7

.CE3B4

 JMP CE384

.CE3B7

 CMP #60
 BCS CE3F7
 CMP #37
 BCC CE3B4
 LDX pattBufferHiDiv8
 STX SC3+1
 ASL A
 ROL SC3+1
 ASL A
 ROL SC3+1
 ASL A
 ROL SC3+1
 STA SC3
 LDA tileNumber
 BEQ CE3B4
 LDX #0
 STA (SC2,X)
 INC tileNumber
 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 STY T
 LDY #7

.loop_CE3EB

 LDA (SC3),Y
 STA (SC),Y
 DEY
 BPL loop_CE3EB
 LDY T
 JMP CE406

.CE3F7

 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC

.CE406

 LDX S
 LDY Q
 LDA R
 BEQ CE420

.loop_CE40E

 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 DEC R
 BEQ CE420
 INY
 CPY #8
 BCC loop_CE40E
 BCS CE423

.CE420

 LDY YSAV
 RTS

.CE423

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #0
 LDA SC2
 CLC
 ADC #&20
 STA SC2
 BCC CE43D
 INC SC2+1

.CE43D

 LDA R
 BEQ CE420
 SEC
 SBC #8
 BCS CE449
 JMP CE394

.CE449

 STA R
 LDX #0
 LDA (SC2,X)
 BEQ CE4AA
 CMP #60
 BCC CE4B4
 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 LDX S
 LDY #0
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 INY
 LDA (SC),Y
 ORA TWOS,X
 STA (SC),Y
 JMP CE423

.CE4AA

 LDA S
 CLC
 ADC #&34
 STA (SC2,X)

.CE4B1

 JMP CE423

.CE4B4

 STA SC
 LDA tileNumber
 BEQ CE4B1
 INC tileNumber
 STA (SC2,X)
 LDX pattBufferHiDiv8
 STX SC3+1
 ASL A
 ROL SC3+1
 ASL A
 ROL SC3+1
 ASL A
 ROL SC3+1
 STA SC3
 LDA SC
 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 STY T
 LDY #7
 LDX S

.loop_CE4E4

 LDA (SC),Y
 ORA TWOS,X
 STA (SC3),Y
 DEY
 BPL loop_CE4E4
 BMI CE4B1

\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.PIXEL

 STX SC2
 STY T1
 TAY
 TXA
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC+1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0
 LDA (SC,X)
 BNE CE521
 LDA tileNumber
 BEQ CE540
 STA (SC,X)
 INC tileNumber

.CE521

 LDX pattBufferHiDiv8
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 TYA
 AND #7
 TAY
 LDA SC2
 AND #7
 TAX
 LDA TWOS,X
 ORA (SC),Y
 STA (SC),Y

.CE540

 LDY T1
 RTS

\ ******************************************************************************
\
\       Name: DrawDash
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DrawDash

 STX SC2
 STY T1
 TAY
 TXA
 LSR A
 LSR A
 LSR A
 CLC
 ADC yLookupLo,Y
 STA SC
 LDA nameBufferHi
 ADC yLookupHi,Y
 STA SC+1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0
 LDA (SC,X)
 BNE CE574
 LDA tileNumber
 BEQ CE540
 STA (SC,X)
 INC tileNumber

.CE574

 LDX #&0C
 STX SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC
 TYA
 AND #7
 TAY
 LDA SC2
 AND #7
 TAX
 LDA TWOS2,X
 ORA (SC),Y
 STA (SC),Y
 LDY T1
 RTS

\ ******************************************************************************
\
\       Name: ECBLB2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ECBLB2

 LDA #&20
 STA ECMA
 LDY #2
 JMP NOISE

\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.MSBAR

 TYA
 PHA
 LDY LE5AB,X
 PLA
 STA nameBuffer0+22*32,Y
 LDY #0
 RTS

\ ******************************************************************************
\
\       Name: LE5AB
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LE5AB

 EQUB &00, &5F, &5E, &3F, &3E                 ; E5AB: 00 5F 5E... ._^

\ ******************************************************************************
\
\       Name: LE5B0_EN
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LE5B0_EN

IF _NTSC

 EQUB &9F, &C2, &00, &75, &05, &8A, &40, &04  ; E5B0: 9F C2 00... ...

ELIF _PAL

 EQUB &9F, &C2, &00, &76, &05, &8A, &40, &04  ; E5B0: 9F C2 00... ...

ENDIF

 EQUB &83, &C2, &00, &6E, &03, &9C, &04, &14  ; E5B8: 83 C2 00... ...
 EQUB &44, &06, &40, &1F, &40, &1F, &21, &0E  ; E5C0: 44 06 40... D.@
 EQUB &83, &10, &03, &88, &8D, &01, &1F, &01  ; E5C8: 83 10 03... ...
 EQUB &15, &08, &14, &8E, &08, &1F, &08, &14  ; E5D0: 15 08 14... ...
 EQUB &08, &14, &21, &02, &83, &C3, &08, &01  ; E5D8: 08 14 21... ..!
 EQUB &04, &10, &03, &88, &9F, &9F, &22, &16  ; E5E0: 04 10 03... ...
 EQUB &83, &10, &03, &88, &21, &12, &83, &01  ; E5E8: 83 10 03... ...
 EQUB &08, &04, &1F, &10, &03, &88, &21, &02  ; E5F0: 08 04 1F... ...
 EQUB &83, &04, &13, &24, &11, &C3, &00, &01  ; E5F8: 83 04 13... ...
 EQUB &04, &C0                                ; E600: 04 C0       ..

\ ******************************************************************************
\
\       Name: LE602_DE
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LE602_DE

IF _NTSC

 EQUB &9F, &C2, &00, &75, &05, &8A, &40, &04  ; E602: 9F C2 00... ...

ELIF _PAL

 EQUB &9F, &C2, &00, &76, &05, &8A, &40, &04  ; E602: 9F C2 00... ...

ENDIF

 EQUB &83, &C2, &00, &6E, &03, &9C, &04, &14  ; E60A: 83 C2 00... ...
 EQUB &44, &06, &40, &1F, &40, &1F, &21, &0E  ; E612: 44 06 40... D.@
 EQUB &83, &10, &03, &88, &8D, &01, &1F, &01  ; E61A: 83 10 03... ...
 EQUB &13, &08, &14, &8E, &08, &1F, &08, &1F  ; E622: 13 08 14... ...
 EQUB &08, &16, &21, &02, &83, &C3, &08, &01  ; E62A: 08 16 21... ..!
 EQUB &04, &10, &03, &88, &9F, &22, &16, &83  ; E632: 04 10 03... ...
 EQUB &10, &03, &88, &21, &12, &83, &10, &03  ; E63A: 10 03 88... ...
 EQUB &88, &21, &02, &83, &01, &0C, &04, &1F  ; E642: 88 21 02... .!.
 EQUB &04, &1E, &24, &16, &C3, &00, &01, &04  ; E64A: 04 1E 24... ..$
 EQUB &C0                                     ; E652: C0          .

\ ******************************************************************************
\
\       Name: LE653_FR
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LE653_FR

IF _NTSC

 EQUB &9F, &C2, &00, &75, &05, &8A, &40, &04  ; E653: 9F C2 00... ...

ELIF _PAL

 EQUB &9F, &C2, &00, &76, &05, &8A, &40, &04  ; E653: 9F C2 00... ...

ENDIF

 EQUB &83, &C2, &00, &6E, &03, &9C, &04, &14  ; E65B: 83 C2 00... ...
 EQUB &44, &06, &40, &1F, &40, &1F, &21, &0E  ; E663: 44 06 40... D.@
 EQUB &83, &10, &03, &88, &8D, &01, &1F, &01  ; E66B: 83 10 03... ...
 EQUB &15, &08, &14, &8E, &08, &1F, &08, &1F  ; E673: 15 08 14... ...
 EQUB &08, &14, &21, &02, &83, &C3, &08, &01  ; E67B: 08 14 21... ..!
 EQUB &04, &10, &03, &88, &9F, &98, &22, &16  ; E683: 04 10 03... ...
 EQUB &83, &10, &03, &88, &21, &12, &83, &10  ; E68B: 83 10 03... ...
 EQUB &03, &88, &21, &02, &83, &01, &0E, &04  ; E693: 03 88 21... ..!
 EQUB &1F, &24, &11, &04, &1C, &C3, &00, &01  ; E69B: 1F 24 11... .$.
 EQUB &04                                     ; E6A3: 04          .

\ ******************************************************************************
\
\       Name: LE6A4_subm_E802
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LE6A4_subm_E802

 EQUB &89, &10, &03, &88, &28, &19, &C2, &00  ; E6A4: 89 10 03... ...
 EQUB &A5, &00, &9F, &9F, &22, &16, &83, &10  ; E6AC: A5 00 9F... ...
 EQUB &03, &88, &9F, &04, &04, &83, &40, &04  ; E6B4: 03 88 9F... ...
 EQUB &83, &9F, &22, &12, &83, &10, &03, &88  ; E6BC: 83 9F 22... .."
 EQUB &9F, &01, &04, &83, &01, &04, &83, &01  ; E6C4: 9F 01 04... ...
 EQUB &04, &83, &01, &04, &83, &01, &04, &83  ; E6CC: 04 83 01... ...
 EQUB &01, &04, &83, &01, &04, &83, &01, &04  ; E6D4: 01 04 83... ...
 EQUB &83, &04, &04, &83, &01, &04, &83, &04  ; E6DC: 83 04 04... ...
 EQUB &04, &83, &04, &04, &83, &04, &04, &83  ; E6E4: 04 83 04... ...
 EQUB &04, &04, &83, &04, &04, &83, &04, &04  ; E6EC: 04 04 83... ...
 EQUB &83, &04, &04, &83, &04, &04, &83, &04  ; E6F4: 83 04 04... ...
 EQUB &04, &83, &04, &04, &83, &04, &04, &83  ; E6FC: 04 83 04... ...
 EQUB &04, &04, &83, &04, &04, &83, &04, &04  ; E704: 04 04 83... ...
 EQUB &83, &01, &04, &83, &9F, &10, &03, &88  ; E70C: 83 01 04... ...
 EQUB &9F, &9F, &22, &02, &83, &10, &03, &88  ; E714: 9F 9F 22... .."
 EQUB &9F, &9F, &9F, &9F, &21, &16, &83, &10  ; E71C: 9F 9F 9F... ...
 EQUB &03, &88, &9F, &08, &1E, &9F, &22, &02  ; E724: 03 88 9F... ...
 EQUB &83, &10, &03, &88, &9F, &10, &03, &88  ; E72C: 83 10 03... ...
 EQUB &9F, &9F, &9F, &10, &03, &88, &9F, &01  ; E734: 9F 9F 9F... ...
 EQUB &1F, &05, &1F, &01, &05, &9F, &10, &03  ; E73C: 1F 05 1F... ...
 EQUB &88, &9F, &9F, &9F, &10, &03, &88, &22  ; E744: 88 9F 9F... ...
 EQUB &02, &83, &9F, &10, &03, &88, &9F, &9F  ; E74C: 02 83 9F... ...
 EQUB &10, &03, &88, &9F, &21, &1A, &83, &10  ; E754: 10 03 88... ...
 EQUB &03, &88, &96, &22, &12, &83, &10, &03  ; E75C: 03 88 96... ...
 EQUB &88, &C4, &00, &6B, &03, &02, &16, &04  ; E764: 88 C4 00... ...
 EQUB &1E, &21, &22, &83, &10, &03, &88, &10  ; E76C: 1E 21 22... .!"
 EQUB &03, &88, &10, &03, &88, &10, &03, &88  ; E774: 03 88 10... ...

IF _NTSC

 EQUB &C2, &00, &64, &05, &22, &3A, &83, &10  ; E77C: C2 00 64... ..d

ELIF _PAL

 EQUB &C2, &00, &65, &05, &22, &3A, &83, &10  ; E77C: C2 00 64... ..d

ENDIF

 EQUB &03, &88, &C2, &00, &A5, &00, &9F, &21  ; E784: 03 88 C2... ...
 EQUB &02, &83, &10, &03, &88, &9F, &02, &04  ; E78C: 02 83 10... ...
 EQUB &83, &02, &04, &83, &02, &04, &83, &02  ; E794: 83 02 04... ...
 EQUB &04, &83, &02, &04, &83, &02, &04, &83  ; E79C: 04 83 02... ...
 EQUB &02, &04, &83, &02, &04, &83, &04, &04  ; E7A4: 02 04 83... ...
 EQUB &83, &02, &04, &83, &21, &12, &83, &10  ; E7AC: 83 02 04... ...
 EQUB &03, &88, &9F, &40, &1F, &40, &1F, &40  ; E7B4: 03 88 9F... ...
 EQUB &1F, &40, &1F, &22, &36, &83, &10, &03  ; E7BC: 1F 40 1F... .@.
 EQUB &88, &9F, &9F, &08, &1F, &08, &1F, &28  ; E7C4: 88 9F 9F... ...
 EQUB &0A, &83, &21, &0E, &83, &10, &03, &88  ; E7CC: 0A 83 21... ..!
 EQUB &9F, &9F, &21, &0E, &83, &10, &03, &88  ; E7D4: 9F 9F 21... ..!
 EQUB &9F, &21, &12, &83, &24, &1F, &08, &1F  ; E7DC: 9F 21 12... .!.
 EQUB &08, &1F, &83, &10, &03, &88, &C3, &08  ; E7E4: 08 1F 83... ...
 EQUB &01, &04, &9F, &21, &02, &83, &10, &03  ; E7EC: 01 04 9F... ...
 EQUB &88, &22, &1E, &83, &28, &0A, &C3, &00  ; E7F4: 88 22 1E... .".

IF _NTSC

 EQUB &86, &04, &10, &03, &88, &80            ; E7FC: 86 04 10... ...

ELIF _PAL

 EQUB &87, &04, &10, &03, &88, &80            ; E7FC: 86 04 10... ...

ENDIF

\ ******************************************************************************
\
\       Name: subm_E802
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_E802

 LDA controller1A
 ORA controller1B
 ORA controller1Left
 ORA controller1Right
 ORA controller1Up
 ORA controller1Down
 ORA controller1Start
 ORA controller1Select
 BPL CE822
 LDA #0
 STA L03EE
 RTS

.CE822

 LDX L04BD
 BNE CE83F
 LDY #0
 LDA (addr2),Y
 BMI CE878
 STA L04BC
 INY
 LDA (addr2),Y
 SEC
 TAX

.CE835

 LDA #1

.CE837

 ADC addr2
 STA addr2
 BCC CE83F
 INC addr2+1

.CE83F

 DEX
 STX L04BD
 LDA L04BC
 ASL controller1Right
 LSR A
 ROR controller1Right
 ASL controller1Left
 LSR A
 ROR controller1Left
 ASL controller1Down
 LSR A
 ROR controller1Down
 ASL controller1Up
 LSR A
 ROR controller1Up
 ASL controller1Select
 LSR A
 ROR controller1Select
 ASL controller1B
 LSR A
 ROR controller1B
 ASL controller1A
 LSR A
 ROR controller1A
 RTS

.CE878

 ASL A
 BEQ CE8DA
 BMI CE886
 ASL A
 TAX

.CE87F

 LDA #0
 STA L04BC
 BEQ CE835

.CE886

 ASL A
 BEQ CE8D1
 PHA
 INY
 LDA (addr2),Y
 STA L04BC
 INY
 LDA (addr2),Y
 STA addr4
 INY
 LDA (addr2),Y
 STA addr4+1
 LDY #0
 LDX #1
 PLA
 CMP #8
 BCS CE8AC
 LDA (addr4),Y
 BNE CE83F

.CE8A7

 LDA #4
 CLC
 BCC CE837

.CE8AC

 BNE CE8B4
 LDA (addr4),Y
 BEQ CE83F
 BNE CE8A7

.CE8B4

 CMP #&10
 BCS CE8BE
 LDA (addr4),Y
 BMI CE83F
 BPL CE8A7

.CE8BE

 BNE CE8C7
 LDA (addr4),Y
 BMI CE8A7
 JMP CE83F

.CE8C7

 LDA #&C0
 STA controller1Start
 LDX #&16
 CLC
 BCC CE87F

.CE8D1

 LDA #&E6
 STA addr2+1
 LDA #&A4
 STA addr2
 RTS

.CE8DA

 STA L03EE
 RTS

\ ******************************************************************************
\
\       Name: subm_E8DE
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_E8DE

 LDA controller1Start
 AND #&C0
 CMP #&40
 BNE CE8EE
 LDA #&50
 STA L0465
 BNE CE8FA

.CE8EE

 LDA L0465
 CMP #&50
 BEQ CE8FA

.CE8F5

 LDA #0
 STA L0465

.CE8FA

 LDA #&F0
 STA ySprite1
 STA ySprite2
 STA ySprite3
 STA ySprite4
 RTS

\ ******************************************************************************
\
\       Name: subm_E909
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_E909

 ASL A
 ASL A
 STA L0460
 LDX #0

 STX L0463
 STX L0462
 STX L0468
 STX L0467

IF _PAL

 STX PAL_EXTRA

ENDIF

 RTS

\ ******************************************************************************
\
\       Name: MoveIconBarPointer
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Move the sprites that make up the icon bar pointer
\
\ ******************************************************************************

.MoveIconBarPointer

IF _NTSC

 DEC L0467

ELIF _PAL

 DEC &0468
 BNE CE928
 LSR &045F

.CE928

ENDIF

 BPL CE925
 INC L0467

.CE925

 DEC L0463
 BPL CE92D
 INC L0463

.CE92D

 LDA L0473
 BMI CE8F5
 LDA L045F
 BEQ subm_E8DE
 LDA L0462
 CLC
 ADC L0460
 STA L0460
 AND #3
 BNE CE98D
 LDA #0
 STA L0462
 LDA L0463
 BNE CE98D
 LDA controller1B
 ORA scanController2
 BPL CE98D
 LDX controller1Left
 BMI CE964
 LDA #0
 STA controller1Left
 JMP CE972

.CE964

 LDA #&FF
 CPX #&80
 BNE CE96F
 LDX #&0C
 STX L0463

.CE96F

 STA L0462

.CE972

 LDX controller1Right
 BMI CE97F
 LDA #0
 STA controller1Right
 JMP CE98D

.CE97F

 LDA #1
 CPX #&80
 BNE CE98A
 LDX #&0C
 STX L0463

.CE98A

 STA L0462

.CE98D

 LDA L0460
 BPL CE999
 LDA #0
 STA L0462
 BEQ CE9A4

.CE999

 CMP #&2D
 BCC CE9A4
 LDA #0
 STA L0462
 LDA #&2C

.CE9A4

 STA L0460
 LDA L0460
 AND #3
 ORA L0462
 BNE CEA04
 LDA controller1B
 BMI CEA04
 LDA controller1B
 BMI CEA04
 LDA controller1Select
 BNE CEA04
 LDA #&FB
 STA tileSprite1
 STA tileSprite2
 LDA L0461
 CLC

IF _NTSC

 ADC #&0B

ELIF _PAL

 ADC #&11

ENDIF

 STA ySprite1
 STA ySprite2
 LDA L0460
 ASL A
 ASL A
 ADC L0460
 ADC #6
 STA xSprite4
 ADC #1
 STA xSprite1
 ADC #&0D
 STA xSprite2
 ADC #1
 STA xSprite3
 LDA L0461
 CLC

IF _NTSC

 ADC #&13

ELIF _PAL

 ADC #&19

ENDIF

 STA ySprite4
 STA ySprite3
 LDA L0460
 BNE CEA40
 JMP CEA40

.CEA04

 LDA #&FC
 STA tileSprite1
 STA tileSprite2
 LDA L0461
 CLC

IF _NTSC

 ADC #8

ELIF _PAL

 ADC #&E

ENDIF

 STA ySprite1
 STA ySprite2
 LDA L0460
 ASL A
 ASL A
 ADC L0460
 ADC #6
 STA xSprite4
 ADC #1
 STA xSprite1
 ADC #&0D
 STA xSprite2
 ADC #1
 STA xSprite3
 LDA L0461
 CLC

IF _NTSC

 ADC #&10

ELIF _PAL

 ADC #&16

ENDIF

 STA ySprite4
 STA ySprite3

.CEA40

 LDA controller1Left
 ORA controller1Right
 ORA controller1Up
 ORA controller1Down
 BPL CEA53
 LDA #0
 STA L0468

.CEA53

 LDA controller1Select
 AND #&F0
 CMP #&80
 BEQ CEA73
 LDA controller1B
 AND #&C0
 CMP #&80
 BNE CEA6A
 LDA #&1E
 STA L0468

.CEA6A

 CMP #&40
 BNE CEA7E

IF _NTSC

 LDA L0468
 BEQ CEA7E

.CEA73

 LDA L0460
 LSR A
 LSR A
 TAY
 LDA (L00BE),Y
 STA L0465

ELIF _PAL

 LDA &0469
 BNE CEA80
 STA &045F
 BEQ CEA7E

.CEA80

 LDA #&28
 STA &0468
 LDA &045F
 BNE CEA73
 INC &045F
 BNE CEA7E

.CEA73

 LSR &045F
 LDA &0461
 LSR A
 LSR A
 TAY
 LDA (&BE),Y
 STA &0466

ENDIF

.CEA7E

 LDA controller1Start
 AND #&C0
 CMP #&40
 BNE CEA8C
 LDA #&50
 STA L0465

.CEA8C

 RTS

\ ******************************************************************************
\
\       Name: ScaleController
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ScaleController

 LDA controller1B
 BNE CEAA7
 LDA controller1Left
 ASL A
 ASL A
 ASL A
 ASL A
 STA controller1Leftx8
 LDA controller1Right
 ASL A
 ASL A
 ASL A
 ASL A
 STA controller1Rightx8
 RTS

.CEAA7

 LDA #0
 STA controller1Leftx8
 STA controller1Rightx8
 RTS

\ ******************************************************************************
\
\       Name: UpdateJoystick
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Update the values of JSTX and JSTY with the values from the
\             controller
\
\ ******************************************************************************

.UpdateJoystick

 LDA QQ11a
 BNE ScaleController
 LDX JSTX
 LDA #8
 STA addr4
 LDY scanController2
 BNE CEAC5
 LDA controller1B
 BMI CEB0C

.CEAC5

 LDA controller1Right,Y
 BPL CEACD
 JSR subm_EB19

.CEACD

 LDA controller1Left,Y
 BPL CEAD5
 JSR subm_EB0D

.CEAD5

 STX JSTX
 TYA
 BNE CEADB

.CEADB

 LDA #4
 STA addr4
 LDX JSTY
 LDA L03EB
 BMI CEAFB
 LDA controller1Down,Y
 BPL CEAEF
 JSR subm_EB19

.CEAEF

 LDA controller1Up,Y
 BPL CEAF7

.loop_CEAF4

 JSR subm_EB0D

.CEAF7

 STX JSTY
 RTS

.CEAFB

 LDA controller1Up,Y
 BPL CEB03
 JSR subm_EB19

.CEB03

 LDA controller1Down,Y
 BMI loop_CEAF4
 STX JSTY
 RTS

.CEB0C

 RTS

\ ******************************************************************************
\
\       Name: subm_EB0D
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EB0D

 TXA
 CLC
 ADC addr4
 TAX
 BCC CEB16
 LDX #&FF

.CEB16

 BPL CEB24
 RTS

\ ******************************************************************************
\
\       Name: subm_EB19
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EB19

 TXA
 SEC
 SBC addr4
 TAX
 BCS CEB22
 LDX #1

.CEB22

 BPL CEB26

.CEB24

 LDX #&80

.CEB26

 RTS

\ ******************************************************************************
\
\       Name: LEB27
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

 EQUB &01, &02, &03, &04, &05, &06, &07, &23  ; EB27: 01 02 03... ...
 EQUB &08, &00, &00, &0C, &00, &00, &00, &00  ; EB2F: 08 00 00... ...
 EQUB &11, &02, &03, &04, &15, &16, &17, &18  ; EB37: 11 02 03... ...
 EQUB &19, &1A, &1B, &0C, &00, &00, &00, &00  ; EB3F: 19 1A 1B... ...
 EQUB &01, &02, &24, &23, &15, &26, &27, &16  ; EB47: 01 02 24... ..$
 EQUB &29, &17, &1B, &0C, &00, &00, &00, &00  ; EB4F: 29 17 1B... )..
 EQUB &31, &32, &33, &34, &35, &00, &00, &00  ; EB57: 31 32 33... 123
 EQUB &00, &00, &00, &3C, &00, &00, &00, &00  ; EB5F: 00 00 00... ...

\ ******************************************************************************
\
\       Name: HideStardust
\       Type: Subroutine
\   Category: Stardust
\    Summary: Hide the stardust sprites
\
\ ******************************************************************************

.HideStardust

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX NOSTM              \ Set X = NOSTM so we hide NOSTM+1 sprites

 LDY #152               \ Set Y so we start hiding from sprite 152 / 4 = 38

                        \ Fall through into HideSprites1 to hide NOSTM+1 sprites
                        \ from sprite 38 onwards (i.e. 38 to 58 in normal space
                        \ when NOSTM is 20, or 38 to 41 in witchspace when NOSTM
                        \ is 3)

\ ******************************************************************************
\
\       Name: HideSprites1
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide X + 1 sprites from sprite Y / 4 onwards
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of sprites to hide (we hide X + 1)
\
\   Y                   The number of the first sprite to hide * 4
\
\ ******************************************************************************

.HideSprites1

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

.hisp1

 STA ySprite0,Y         \ Set the y-coordinate for sprite Y / 4 to 240 to hide
                        \ it (the division by four is because each sprite in the
                        \ sprite buffer has four bytes of data)

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the loop counter in X

 BPL hisp1              \ Loop back until we have hidden X + 1 sprites

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: subm_EB86
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EB86

 LDA QQ11a              \ If QQ11 = QQ11a, then we are not currently changing
 CMP QQ11               \ view, so jump to HideSprites5To63 to hide sprites 5
 BEQ HideSprites5To63   \ to 63

\ ******************************************************************************
\
\       Name: subm_EB8C
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EB8C

 JSR subm_B63D_b3

\ ******************************************************************************
\
\       Name: HideSprites5To63
\       Type: Subroutine
\   Category: Drawing sprites
\    Summary: Hide sprites 5 to 63
\
\ ******************************************************************************

.HideSprites5To63

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #58                \ Set X = 58 so we hide 59 sprites

 LDY #20                \ Set Y so we start hiding from sprite 20 / 4 = 5

 BNE HideSprites1       \ Jump to HideSprites1 to hide 59 sprites from sprite
                        \ 5 onwards (i.e. 5 to 63), returning from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: DELAY
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.DELAY

 JSR WSCAN
 DEY
 BNE DELAY
 RTS

\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BEEP

 LDY #3
 BNE NOISE

\ ******************************************************************************
\
\       Name: EXNO3
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.EXNO3

 LDY #&0D
 BNE NOISE

\ ******************************************************************************
\
\       Name: subm_EBB1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_EBB1

 LDX #0
 JSR CEBCF

.loop_CEBB6

 LDX #1
 JSR CEBCF
 LDX #2
 BNE CEBCF

\ ******************************************************************************
\
\       Name: ECBLB
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ECBLB

 LDX noiseLookup1,Y
 CPX #3
 BCC CEBCF
 BNE loop_CEBB6
 LDX #0
 JSR CEBCF
 LDX #2

.CEBCF

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #0
 STA L0478,X
 LDA #&1A
 BNE CEC2B

\ ******************************************************************************
\
\       Name: BOOP
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.BOOP

 LDY #4
 BNE NOISE

\ ******************************************************************************
\
\       Name: subm_EBE9
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.subm_EBE9

 LDY #1
 BNE NOISE

\ ******************************************************************************
\
\       Name: subm_EBED
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.subm_EBED

 JSR subm_EBB1
 LDY #&15

\ ******************************************************************************
\
\       Name: NOISE
\       Type: Subroutine
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.NOISE

 LDA L03EC
 BPL CEC2E
 LDX noiseLookup1,Y
 CPX #3
 BCC CEC0A
 TYA
 PHA
 DEX
 DEX
 DEX
 JSR CEC0A
 PLA
 TAY
 LDX #2

.CEC0A

 LDA L0302,X
 BEQ CEC17
 LDA noiseLookup2,Y
 CMP L0478,X
 BCC CEC2E

.CEC17

 LDA noiseLookup2,Y
 STA L0478,X

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 TYA

.CEC2B

 JSR subm_89D1_b6

.CEC2E

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS

\ ******************************************************************************
\
\       Name: noiseLookup1
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.noiseLookup1

 EQUB 2, 1, 1, 1, 1, 0, 0, 1, 2, 2, 2, 2, 3   ; EC3C: 02 01 01... ...
 EQUB 2, 2, 0, 0, 0, 0, 0, 2, 3, 3, 2, 1, 2   ; EC49: 02 02 00... ...
 EQUB 0, 2, 0, 1, 0, 0                        ; EC56: 00 02 00... ...

\ ******************************************************************************
\
\       Name: noiseLookup2
\       Type: Variable
\   Category: Sound
\    Summary: ???
\
\ ******************************************************************************

.noiseLookup2

 EQUB &80, &82, &C0, &21, &21, &10, &10, &41  ; EC5C: 80 82 C0... ...
 EQUB &82, &32, &84, &20, &C0, &60, &40, &80  ; EC64: 82 32 84... .2.
 EQUB &80, &80, &80, &90, &84, &33, &33, &20  ; EC6C: 80 80 80... ...
 EQUB &C0, &18, &10, &10, &10, &10, &10, &60  ; EC74: C0 18 10... ...
 EQUB &60                                     ; EC7C: 60          `

\ ******************************************************************************
\
\       Name: SetupPPUForIconBar
\       Type: Subroutine
\   Category: Drawing tiles
\    Summary: If the PPU has started drawing the icon bar, configure the PPU to
\             use nametable 0 and pattern table 0, while preserving A
\
\ ******************************************************************************

.SetupPPUForIconBar

 PHA                    \ Store the value of A on the stack so we can retrieve
                        \ it below

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 PLA                    \ Retrieve the value of A from the stack so it is
                        \ unchanged

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetShipBlueprint
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Fetch a specified byte from the current ship blueprint
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The offset of the byte to return from the blueprint
\
\ Returns:
\
\   A                   The Y-th byte of the current ship blueprint
\
\ ******************************************************************************

.GetShipBlueprint

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 LDA (XX0),Y            \ Set A to the Y-th byte of the current ship blueprint

                        \ Fall through into ResetBankA to retrieve the bank
                        \ number we stored above and page it back into memory

\ ******************************************************************************
\
\       Name: ResetBankA
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page a specified bank into memory at &8000 while preserving the
\             value of A
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Stack               The number of the bank to page into memory at &8000
\
\ ******************************************************************************

.ResetBankA

 STA ASAV               \ Store the value of A so we can retrieve it below

 PLA                    \ Fetch the ROM bank number from the stack

 JSR SetBank            \ Page bank A into memory at &8000

 LDA ASAV               \ Restore the value of A that we stored above

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetDefaultNEWB
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Fetch the default NEWB flags for a specified ship type
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The ship type
\
\ Returns:
\
\   A                   The default NEWB flags for ship type Y
\
\ ******************************************************************************

.GetDefaultNEWB

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 LDA E%-1,Y             \ Set A to the default NEWB flags for ship type Y

 JMP ResetBankA         \ Jump to ResetBankA to retrieve the bank number we
                        \ stored above and page it back into memory, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: IncreaseTally
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.IncreaseTally

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 LDA KWL%-1,X
 ASL A
 PHA
 LDA KWH%-1,X
 ROL A
 TAY
 PLA
 ADC TALLYL
 STA TALLYL
 TYA
 ADC TALLY
 STA TALLY

\ ******************************************************************************
\
\       Name: ResetBankP
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Page a specified bank into memory at &8000 while preserving the
\             value of A and the processor flags
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Stack               The number of the bank to page into memory at &8000
\
\ ******************************************************************************

.ResetBankP

 PLA                    \ Fetch the ROM bank number from the stack

 PHP                    \ Store the processor flags on the stack so we can
                        \ retrieve them below

 JSR SetBank            \ Page bank A into memory at &8000

 PLP                    \ Restore the processor flags, so we return the correct
                        \ Z and N flags for the value of A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: subm_ECE2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   subm_ECE2-1         Contains an RTS
\
\ ******************************************************************************

.subm_ECE2

 LDA L0465
 BEQ subm_ECE2-1

\ ******************************************************************************
\
\       Name: subm_B1D4_b0
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B1D4 routine in ROM bank 0
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   N, Z flags          Set according to the value of A passed to the routine
\
\ ******************************************************************************

.subm_B1D4_b0

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_B1D4          \ Call subm_B1D4, now that it is paged into memory

 JMP ResetBankP         \ Jump to ResetBankP to retrieve the bank number we
                        \ stored above, page it back into memory and set the
                        \ processor flags according to the value of A, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: Set_K_K3_XC_YC
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.Set_K_K3_XC_YC

 LDA #2
 STA K
 STA K+1
 LDA #&45
 STA K+2
 LDA #8
 STA K+3
 LDA #3
 STA XC
 LDA #&19
 STA YC
 LDX #7
 LDY #7
 JMP subm_A0F8_b6

\ ******************************************************************************
\
\       Name: PlayMusic_b6
\       Type: Subroutine
\   Category: Sound
\    Summary: Call the PlayMusic routine in ROM bank 6
\
\ ******************************************************************************

.PlayMusic_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR PlayMusic          \ Call PlayMusic, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_8021_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_8021 routine in ROM bank 6
\
\ ******************************************************************************

.subm_8021_b6

 PHA                    \ ???
 JSR WSCAN
 PLA

 ORA #&80
 STA L045E

 AND #&7F

 LDX L03ED
 BMI subm_ECE2-1

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 6 is already paged into memory, jump to
 CMP #6                 \ bank1
 BEQ bank1

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_8021          \ Call subm_8021, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank1

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_8021          \ ???

\ ******************************************************************************
\
\       Name: subm_89D1_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_89D1 routine in ROM bank 6
\
\ ******************************************************************************

.subm_89D1_b6

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 6 is already paged into memory, jump to
 CMP #6                 \ bank2
 BEQ bank2

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_89D1          \ Call subm_89D1, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank2

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_89D1          \ ???

\ ******************************************************************************
\
\       Name: WaitResetSound
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.WaitResetSound

 JSR WSCAN

\ ******************************************************************************
\
\       Name: ResetSoundL045E
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ResetSoundL045E

 LDA #0
 STA L045E

\ ******************************************************************************
\
\       Name: ResetSound_b6
\       Type: Subroutine
\   Category: Sound
\    Summary: Call the ResetSound routine in ROM bank 6
\
\ ******************************************************************************

.ResetSound_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR ResetSound         \ Call ResetSound, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_BF41_b5
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BF41 routine in ROM bank 5
\
\ ******************************************************************************

.subm_BF41_b5

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #5                 \ Page ROM bank 5 into memory at &8000
 JSR SetBank

 JSR subm_BF41          \ Call subm_BF41, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B9F9_b4
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B9F9 routine in ROM bank 4
\
\ ******************************************************************************

.subm_B9F9_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR subm_B9F9          \ Call subm_B9F9, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B96B_b4
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B96B routine in ROM bank 4
\
\ ******************************************************************************

.subm_B96B_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR subm_B96B          \ Call subm_B96B, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B63D_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B63D routine in ROM bank 3
\
\ ******************************************************************************

.subm_B63D_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B63D          \ Call subm_B63D, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B88C_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B88C routine in ROM bank 6
\
\ ******************************************************************************

.subm_B88C_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_B88C          \ Call subm_B88C, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: LL9_b1
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Call the LL9 routine in ROM bank 1
\
\ ******************************************************************************

.LL9_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank3
 BEQ bank3

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR LL9                \ Call LL9, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank3

 JMP LL9                \ Call LL9, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_BA23_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BA23 routine in ROM bank 3
\
\ ******************************************************************************

.subm_BA23_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_BA23          \ Call subm_BA23, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: TIDY_b1
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Call the TIDY routine in ROM bank 1
\
\ ******************************************************************************

.TIDY_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank4
 BEQ bank4

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR TIDY               \ Call TIDY, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank4

 JMP TIDY               \ Call TIDY, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: StartScreen_b6
\       Type: Subroutine
\   Category: Start and end
\    Summary: Call the StartScreen routine in ROM bank 6
\
\ ******************************************************************************

.StartScreen_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR StartScreen        \ Call StartScreen, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DemoShips_b0
\       Type: Subroutine
\   Category: Demo
\    Summary: Call the SpawnDemoShips routine in ROM bank 0
\
\ ******************************************************************************

.DemoShips_b0

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JMP DemoShips          \ Call DemoShips, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: STARS_b1
\       Type: Subroutine
\   Category: Stardust
\    Summary: Call the STARS routine in ROM bank 1
\
\ ******************************************************************************

.STARS_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank5
 BEQ bank5

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR STARS              \ Call STARS, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank5

 JMP STARS              \ Call STARS, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: CIRCLE2_b1
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Call the CIRCLE2 routine in ROM bank 1
\
\ ******************************************************************************

.CIRCLE2_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank6
 BEQ bank6

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR CIRCLE2            \ Call CIRCLE2, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank6

 JMP CIRCLE2            \ Call CIRCLE2, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: SUN_b1
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Call the SUN routine in ROM bank 1
\
\ ******************************************************************************

.SUN_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank7
 BEQ bank7

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR SUN                \ Call SUN, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank7

 JMP SUN                \ Call SUN, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B2FB_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B2FB routine in ROM bank 3
\
\ ******************************************************************************

.subm_B2FB_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B2FB          \ Call subm_B2FB, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B219_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B219 routine in ROM bank 3
\
\ ******************************************************************************

.subm_B219_b3

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank8
 BEQ bank8

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_B219          \ Call subm_B219, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank8

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_B219          \ Call subm_B219, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B9C1_b4
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B9C1 routine in ROM bank 4
\
\ ******************************************************************************

.subm_B9C1_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR subm_B9C1          \ Call subm_B9C1, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A082_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A082 routine in ROM bank 6
\
\ ******************************************************************************

.subm_A082_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_A082          \ Call subm_A082, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A0F8_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A0F8 routine in ROM bank 6
\
\ ******************************************************************************

.subm_A0F8_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_A0F8          \ Call subm_A0F8, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B882_b4
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B882 routine in ROM bank 4
\
\ ******************************************************************************

.subm_B882_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR subm_B882          \ Call subm_B882, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A4A5_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A4A5 routine in ROM bank 6
\
\ ******************************************************************************

.subm_A4A5_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_A4A5          \ Call subm_A4A5, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DEATH2_b0
\       Type: Subroutine
\   Category: Start and end
\    Summary: Switch to ROM bank 0 and call the DEATH2 routine
\
\ ******************************************************************************

.DEATH2_b0

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JMP DEATH2             \ Call DEATH2, which is now paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B358_b0
\       Type: Subroutine
\   Category: ???
\    Summary: Switch to ROM bank 0 and call the subm_B358 routine
\
\ ******************************************************************************

.subm_B358_b0

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JMP subm_B358          \ Call subm_B358, which is now paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B9E2_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B9E2 routine in ROM bank 3
\
\ ******************************************************************************

.subm_B9E2_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank9
 BEQ bank9

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B9E2          \ Call subm_B9E2, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank9

 JMP subm_B9E2          \ Call subm_B9E2, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B673_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B673 routine in ROM bank 3
\
\ ******************************************************************************

.subm_B673_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B673          \ Call subm_B673, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B2BC_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B2BC routine in ROM bank 3
\
\ ******************************************************************************

.subm_B2BC_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B2BC          \ Call subm_B2BC, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B248_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B248 routine in ROM bank 3
\
\ ******************************************************************************

.subm_B248_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B248          \ Call subm_B248, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_BA17_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BA17 routine in ROM bank 6
\
\ ******************************************************************************

.subm_BA17_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_BA17          \ Call subm_BA17, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_AFCD_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_AFCD routine in ROM bank 3
\
\ ******************************************************************************

.subm_AFCD_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank10
 BEQ bank10

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_AFCD          \ Call subm_AFCD, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank10

 JMP subm_AFCD          \ Call subm_AFCD, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_BE52_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BE52 routine in ROM bank 6
\
\ ******************************************************************************

.subm_BE52_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_BE52          \ Call subm_BE52, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_BED2_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BED2 routine in ROM bank 6
\
\ ******************************************************************************

.subm_BED2_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_BED2          \ Call subm_BED2, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B0E1_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B0E1 routine in ROM bank 3
\
\ ******************************************************************************

.subm_B0E1_b3

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank11
 BEQ bank11

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_B0E1          \ Call subm_B0E1, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank11

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_B0E1          \ Call subm_B0E1, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B18E_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B18E routine in ROM bank 3
\
\ ******************************************************************************

.subm_B18E_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_B18E          \ Call subm_B18E, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: PAS1_b0
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Call the PAS1 routine in ROM bank 0
\
\ ******************************************************************************

.PAS1_b0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR PAS1               \ Call PAS1, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: SetSystemImage_b5
\       Type: Subroutine
\   Category: Drawing images
\    Summary: Call the SetSystemImage routine in ROM bank 5
\
\ ******************************************************************************

.SetSystemImage_b5

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #5                 \ Page ROM bank 5 into memory at &8000
 JSR SetBank

 JSR SetSystemImage     \ Call SetSystemImage, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: GetSystemImage_b5
\       Type: Subroutine
\   Category: Drawing images
\    Summary: Call the GetSystemImage routine in ROM bank 5
\
\ ******************************************************************************

.GetSystemImage_b5

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #5                 \ Page ROM bank 5 into memory at &8000
 JSR SetBank

 JSR GetSystemImage     \ Call GetSystemImage, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: SetCmdrImage_b4
\       Type: Subroutine
\   Category: Drawing images
\    Summary: Call the SetCmdrImage routine in ROM bank 4
\
\ ******************************************************************************

.SetCmdrImage_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR SetCmdrImage       \ Call SetCmdrImage, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: GetCmdrImage_b4
\       Type: Subroutine
\   Category: Drawing images
\    Summary: Call the GetCmdrImage routine in ROM bank 4
\
\ ******************************************************************************

.GetCmdrImage_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR GetCmdrImage       \ Call GetCmdrImage, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DIALS_b6
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Call the DIALS routine in ROM bank 6
\
\ ******************************************************************************

.DIALS_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR DIALS              \ Call DIALS, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_BA63_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BA63 routine in ROM bank 6
\
\ ******************************************************************************

.subm_BA63_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_BA63          \ Call subm_BA63, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B39D_b0
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B39D routine in ROM bank 0
\
\ ******************************************************************************

.subm_B39D_b0

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 0 is already paged into memory, jump to
 CMP #0                 \ bank12
 BEQ bank12

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_B39D          \ Call subm_B39D, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank12

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_B39D          \ Call subm_B39D, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: LL164_b6
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Call the LL164 routine in ROM bank 6
\
\ ******************************************************************************

.LL164_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR LL164              \ Call LL164, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B919_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B919 routine in ROM bank 6
\
\ ******************************************************************************

.subm_B919_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_B919          \ Call subm_B919, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A166_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A166 routine in ROM bank 6
\
\ ******************************************************************************

.subm_A166_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_A166          \ Call subm_A166, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: SetKeyLogger_b6
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Call the SetKeyLogger routine in ROM bank 6
\
\ ******************************************************************************

.SetKeyLogger_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR SetKeyLogger       \ Call SetKeyLogger, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ChangeCmdrName_b6
\       Type: Subroutine
\   Category: Save and load
\    Summary: Call the ChangeCmdrName routine in ROM bank 6
\
\ ******************************************************************************

.ChangeCmdrName_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR ChangeCmdrName     \ Call ChangeCmdrName, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B8FE_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B8FE routine in ROM bank 6
\
\ ******************************************************************************

.subm_B8FE_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_B8FE          \ Call subm_B8FE, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_B906_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_B90D routine in ROM bank 6
\
\ ******************************************************************************

.subm_B906_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR subm_B906          \ Call subm_B906, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A5AB_b6
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A5AB routine in ROM bank 6
\
\ ******************************************************************************

.subm_A5AB_b6

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 6 is already paged into memory, jump to
 CMP #6                 \ bank13
 BEQ bank13

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_A5AB          \ Call subm_A5AB, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank13

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_A5AB          \ Call subm_A5AB, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: BEEP_b7
\       Type: Subroutine
\   Category: Sound
\    Summary: Call the BEEP routine in ROM bank 7
\
\ ******************************************************************************

.BEEP_b7

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR BEEP               \ Call BEEP, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DETOK_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the DETOK routine in ROM bank 2
\
\ ******************************************************************************

.DETOK_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank14
 BEQ bank14

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR DETOK              \ Call DETOK, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank14

 LDA ASAV               \ Restore the value of A that we stored above

 JMP DETOK              \ Call DETOK, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DTS_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the DTS routine in ROM bank 2
\
\ ******************************************************************************

.DTS_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank15
 BEQ bank15

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR DTS                \ Call DTS, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank15

 LDA ASAV               \ Restore the value of A that we stored above

 JMP DTS                \ Call DTS, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: PDESC_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the PDESC routine in ROM bank 2
\
\ ******************************************************************************

.PDESC_b2

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 JSR PDESC              \ Call PDESC, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_AE18_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_AE18 routine in ROM bank 3
\
\ ******************************************************************************

.subm_AE18_b3

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank16
 BEQ bank16

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_AE18          \ Call subm_AE18, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank16

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_AE18          \ Call subm_AE18, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_AC1D_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_AC1D routine in ROM bank 3
\
\ ******************************************************************************

.subm_AC1D_b3

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank17
 BEQ bank17

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_AC1D          \ Call subm_AC1D, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank17

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_AC1D          \ Call subm_AC1D, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A730_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A730 routine in ROM bank 3
\
\ ******************************************************************************

.subm_A730_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_A730          \ Call subm_A730, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A775_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A775 routine in ROM bank 3
\
\ ******************************************************************************

.subm_A775_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_A775          \ Call subm_A775, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DrawTitleScreen_b3
\       Type: Subroutine
\   Category: Start and end
\    Summary: Call the DrawTitleScreen routine in ROM bank 3
\
\ ******************************************************************************

.DrawTitleScreen_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR DrawTitleScreen    \ Call DrawTitleScreen, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_F126
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F126

 LDA L0473
 BPL subm_F139

\ ******************************************************************************
\
\       Name: subm_A7B7_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A7B7 routine in ROM bank 3
\
\ ******************************************************************************

.subm_A7B7_b3

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_A7B7          \ Call subm_A7B7, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_F139
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F139

 LDA #116
 STA lastTileNumber
 STA lastTileNumber+1

\ ******************************************************************************
\
\       Name: subm_A9D1_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A9D1 routine in ROM bank 3
\
\ ******************************************************************************

.subm_A9D1_b3

 LDA #&C0               \ Set A = &C0 ???

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank18
 BEQ bank18

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR subm_A9D1          \ Call subm_A9D1, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank18

 LDA ASAV               \ Restore the value of A that we stored above

 JMP subm_A9D1          \ Call subm_A9D1, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_A972_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_A972 routine in ROM bank 3
\
\ ******************************************************************************

.subm_A972_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank19
 BEQ bank19

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_A972          \ Call subm_A972, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank19

 JMP subm_A972          \ Call subm_A972, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_AC5C_b3
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_AC5C routine in ROM bank 3
\
\ ******************************************************************************

.subm_AC5C_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank20
 BEQ bank20

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR subm_AC5C          \ Call subm_AC5C, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank20

 JMP subm_AC5C          \ Call subm_AC5C, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_8980_b0
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_8980 routine in ROM bank 0
\
\ ******************************************************************************

.subm_8980_b0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR subm_8980          \ Call subm_8980, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: SVE_b6
\       Type: Subroutine
\   Category: Save and load
\    Summary: Call the SVE routine in ROM bank 6
\
\ ******************************************************************************

.SVE_b6

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #6                 \ Page ROM bank 6 into memory at &8000
 JSR SetBank

 JSR SVE                \ Call SVE, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: MVS5_b0
\       Type: Subroutine
\   Category: Moving
\    Summary: Call the MVS5 routine in ROM bank 0
\
\ ******************************************************************************

.MVS5_b0

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 0 is already paged into memory, jump to
 CMP #0                 \ bank21
 BEQ bank21

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR MVS5               \ Call MVS5, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank21

 LDA ASAV               \ Restore the value of A that we stored above

 JMP MVS5               \ Call MVS5, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: HALL_b1
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Call the HALL routine in ROM bank 1
\
\ ******************************************************************************

.HALL_b1

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR HALL               \ Call HALL, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: CHPR_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the CHPR routine in ROM bank 2
\
\ ******************************************************************************

.CHPR_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank22
 BEQ bank22

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR CHPR               \ Call CHPR, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank22

 LDA ASAV               \ Restore the value of A that we stored above

 JMP CHPR               \ Call CHPR, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: DASC_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the DASC routine in ROM bank 2
\
\ ******************************************************************************

.DASC_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank23
 BEQ bank23

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR DASC               \ Call DASC, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank23

 LDA ASAV               \ Restore the value of A that we stored above

 JMP DASC               \ Call DASC, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: TT27_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the TT27 routine in ROM bank 2
\
\ ******************************************************************************

.TT27_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank24
 BEQ bank24

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR TT27               \ Call TT27, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank24

 LDA ASAV               \ Restore the value of A that we stored above

 JMP TT27               \ Call TT27, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ex_b2
\       Type: Subroutine
\   Category: Text
\    Summary: Call the ex routine in ROM bank 2
\
\ ******************************************************************************

.ex_b2

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ If ROM bank 2 is already paged into memory, jump to
 CMP #2                 \ bank25
 BEQ bank25

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #2                 \ Page ROM bank 2 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR ex                 \ Call ex, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank25

 LDA ASAV               \ Restore the value of A that we stored above

 JMP ex                 \ Call ex, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: PrintCtrlCode_b0
\       Type: Subroutine
\   Category: Text
\    Summary: Call the PrintCtrlCode routine in ROM bank 0
\
\ ******************************************************************************

.PrintCtrlCode_b0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR PrintCtrlCode      \ Call PrintCtrlCode, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: StartAfterLoad_b0
\       Type: Subroutine
\   Category: Start and end
\    Summary: Call the StartAfterLoad routine in ROM bank 0
\
\ ******************************************************************************

.StartAfterLoad_b0

 LDA currentBank        \ If ROM bank 0 is already paged into memory, jump to
 CMP #0                 \ bank26
 BEQ bank26

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR StartAfterLoad     \ Call StartAfterLoad, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank26

 JMP StartAfterLoad     \ Call StartAfterLoad, which is already paged into
                        \ memory, and return from the subroutine using a tail
                        \ call

\ ******************************************************************************
\
\       Name: subm_F25A
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F25A

 LDA #0
 LDY #&21
 STA (XX19),Y

\ ******************************************************************************
\
\       Name: subm_BAF3_b1
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_BAF3 routine in ROM bank 1
\
\ ******************************************************************************

.subm_BAF3_b1

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR subm_BAF3          \ Call subm_BAF3, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: TT66_b0
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Call the TT66 routine in ROM bank 0
\
\ ******************************************************************************

.TT66_b0

 STA ASAV               \ Store the value of A so we can retrieve it below

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 LDA ASAV               \ Restore the value of A that we stored above

 JSR TT66               \ Call TT66, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: CLIP_b1
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Call the CLIP routine in ROM bank 1, drawing the clipped line if
\             it fits on-screen
\
\ ******************************************************************************

.CLIP_b1

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR CLIP               \ Call CLIP, now that it is paged into memory

 BCS P%+5               \ If the C flag is set then the clipped line does not
                        \ fit on-screen, so skip the next instruction

 JSR LOIN               \ The clipped line fits on-screen, so draw it

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ClearTiles_b3
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Call the ClearTiles routine in ROM bank 3
\
\ ******************************************************************************

.ClearTiles_b3

 LDA currentBank        \ If ROM bank 3 is already paged into memory, jump to
 CMP #3                 \ bank27
 BEQ bank27

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #3                 \ Page ROM bank 3 into memory at &8000
 JSR SetBank

 JSR ClearTiles         \ Call ClearTiles, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank27

 JMP ClearTiles         \ Call ClearTiles, which is already paged into memory,
                        \ and return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: SCAN_b1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Call the SCAN routine in ROM bank 1
\
\ ******************************************************************************

.SCAN_b1

 LDA currentBank        \ If ROM bank 1 is already paged into memory, jump to
 CMP #1                 \ bank28
 BEQ bank28

 PHA                    \ Otherwise store the current bank number on the stack

 LDA #1                 \ Page ROM bank 1 into memory at &8000
 JSR SetBank

 JSR SCAN               \ Call SCAN, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

.bank28

 JMP SCAN               \ Call SCAN, which is already paged into memory, and
                        \ return from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_F2BD
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F2BD

 JSR subm_EB86

\ ******************************************************************************
\
\       Name: subm_8926_b0
\       Type: Subroutine
\   Category: ???
\    Summary: Call the subm_8926 routine in ROM bank 0
\
\ ******************************************************************************

.subm_8926_b0

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR subm_8926          \ Call subm_8926, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subm_F2CE
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F2CE

 LDA #0                 \ Page ROM bank 0 into memory at &8000
 JSR SetBank

 JSR CopyNameBuffer0To1

 JSR subm_F126          \ Call subm_F126, now that it is paged into memory

 LDX #1
 STX paletteBitplane
 RTS

\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Utility routines
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   CLYNS+8             Don't zero DLY and de
\
\ ******************************************************************************

.CLYNS

 LDA #0
 STA DLY
 STA de

 LDA #&FF
 STA DTW2
 LDA #&80
 STA QQ17
 LDA #&16
 STA YC
 LDA #1
 STA XC
 LDA pattTileNumber
 STA tileNumber
 LDA QQ11
 BPL CF332
 LDA #&72
 STA SC+1
 LDA #&E0
 STA SC
 LDA #&76
 STA SC2+1
 LDA #&E0
 STA SC2
 LDX #2

.loop_CF311

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #2
 LDA #0

.loop_CF318

 STA (SC),Y
 STA (SC2),Y
 INY
 CPY #&1F
 BNE loop_CF318
 LDA SC
 ADC #&1F
 STA SC
 STA SC2
 BCC CF32F
 INC SC+1
 INC SC2+1

.CF32F

 DEX
 BNE loop_CF311

.CF332

 RTS

\ ******************************************************************************
\
\       Name: LF333
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LF333

 EQUB &1C, &1A, &28, &16,   6                 ; F333: 1C 1A 28... ..(

\ ******************************************************************************
\
\       Name: GetStatusCondition
\       Type: Subroutine
\   Category: Status
\    Summary: ???
\
\ ******************************************************************************

.GetStatusCondition

 LDX #0
 LDY QQ12
 BNE CF355
 INX
 LDY JUNK
 LDA FRIN+2,Y
 BEQ CF355
 INX
 LDY L0472
 CPY #3
 BEQ subm_F359
 LDA ENERGY
 BMI CF355

.loop_CF354

 INX

.CF355

 STX L0472
 RTS

\ ******************************************************************************
\
\       Name: subm_F359
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F359

 LDA ENERGY
 CMP #&A0
 BCC loop_CF354
 BCS CF355

\ ******************************************************************************
\
\       Name: subm_F362
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F362

 LDY #&0C
 JSR DELAY
 LDA #0
 CLC
 ADC #0
 STA frameCounter
 STA nmiTimer
 STA nmiTimerLo
 STA nmiTimerHi
 STA paletteBitplane
 STA nmiBitplane
 STA drawingBitplane
 LDA #&FF
 STA L0307
 LDA #&80
 STA L0308
 LDA #&1B
 STA L0309
 LDA #&34
 STA L030A
 JSR subm_F3AB
 LDA #0
 STA K%+6
 STA K%

\ ******************************************************************************
\
\       Name: subm_F39A
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F39A

 LDA #&75
 STA RAND
 LDA #&0A
 STA RAND+1
 LDA #&2A
 STA RAND+2
 LDX #&E6
 STX RAND+3
 RTS

\ ******************************************************************************
\
\       Name: subm_F3AB
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F3AB

 LDA #0
 STA L03EB
 STA L03ED
 LDA #&FF
 STA L03EA
 STA L03EC
 RTS

\ ******************************************************************************
\
\       Name: subm_F3BC
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F3BC

 JSR subm_B63D_b3
 LDA #0
 JSR subm_8021_b6
 JSR HideSprites5To63
 LDA #&FF
 STA QQ11a
 LDA #1
 STA scanController2
 LDA #&32
 STA nmiTimer
 LDA #0
 STA nmiTimerLo
 STA nmiTimerHi

.loop_CF3DA

 LDY #0

.loop_CF3DC

 STY L03FC
 LDA LF415,Y
 BEQ loop_CF3DA
 TAX
 LDA LF422,Y
 TAY
 LDA #6
 JSR TITLE
 BCS CF411
 LDY L03FC
 INY
 LDA nmiTimerHi
 CMP #1
 BCC loop_CF3DC
 LSR scanController2
 JSR WaitResetSound
 JSR subm_B63D_b3
 LDA chosenLanguage
 STA K%
 LDA #5
 STA K%+1
 JMP CC035

.CF411

 JSR WaitResetSound
 RTS

\ ******************************************************************************
\
\       Name: LF415
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LF415

 EQUB &0B, &13, &14, &19, &1D, &15, &12, &1B  ; F415: 0B 13 14... ...
 EQUB &0A,   1, &11, &10,   0                 ; F41D: 0A 01 11... ...

\ ******************************************************************************
\
\       Name: LF422
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.LF422

 EQUB &64, &0A, &0A, &1E, &B4, &0A, &28, &5A  ; F422: 64 0A 0A... d..
 EQUB &0A, &46, &28, &0A

INCLUDE "library/common/main/subroutine/ze.asm"

\ ******************************************************************************
\
\       Name: subm_F454
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.subm_F454

 PHA
 LDA NAME+7
 BMI CF463
 CLC
 ADC #1
 CMP #&64
 BCC CF463
 LDA #0

.CF463

 ORA #&80
 STA NAME+7
 PLA
 RTS

INCLUDE "library/common/main/subroutine/nlin3.asm"
INCLUDE "library/common/main/subroutine/nlin4.asm"
INCLUDE "library/common/main/subroutine/nlin2.asm"

\ ******************************************************************************
\
\       Name: ResetDrawingPlane
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ResetDrawingPlane

 LDX #0
 JSR SetDrawingBitplane
 RTS

\ ******************************************************************************
\
\       Name: ResetBuffers
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.ResetBuffers

 LDA #&60
 STA SC2+1
 LDA #0
 STA SC2
 LDY #0
 LDX #&18
 LDA #0

.CF4A1

 STA (SC2),Y
 INY
 BNE CF4A1
 INC SC2+1
 DEX
 BNE CF4A1
 RTS

INCLUDE "library/common/main/subroutine/dornd.asm"
INCLUDE "library/common/main/subroutine/proj.asm"
INCLUDE "library/common/main/subroutine/pls6.asm"

\ ******************************************************************************
\
\       Name: UnpackToRAM
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Unpack compressed image data to RAM
\
\ ------------------------------------------------------------------------------
\
\ UnpackToRAM copies data from V(1 0) to SC(1 0)
\ Fetch byte from V(1 0) and increment V(1 0), say byte is &xx
\   >= &40 store byte as is and move on to next
\   = &x0 store byte as is and move on to next
\   = &3F stop and return from subroutine - end of decompression
\   >= &20, jump to CF572
\           >= &30 jump to CF589 to copy next &0x bytes from V(1 0) as they
\                  are, incrementing V(1 0) as we go
\           >= &20 fetch next byte and store it for &0x bytes
\   >= &10, jump to CF56E to store &FF for &0x bytes
\   < &10, store 0 for &0x bytes
\ 
\ &00 = unchanged
\ &0x = store 0 for &0x bytes
\ &10 = unchanged
\ &1x = store &FF for &0x bytes
\ &20 = unchanged
\ &2x = store next byte for &0x bytes
\ &30 = unchanged
\ &3x = store next &0x bytes unchanged
\ &40 and above = unchanged
\
\ ******************************************************************************

.UnpackToRAM

 LDY #0

.CF52F

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0
 LDA (V,X)
 INC V
 BNE CF546
 INC V+1

.CF546

 CMP #&40
 BCS CF5A4
 TAX
 AND #&0F
 BEQ CF5A3
 CPX #&3F
 BEQ CF5AE
 TXA
 CMP #&20
 BCS CF572
 CMP #&10
 AND #&0F
 TAX
 BCS CF56E
 LDA #0

.CF561

 STA (SC),Y
 INY
 BNE CF568
 INC SC+1

.CF568

 DEX
 BNE CF561
 JMP CF52F

.CF56E

 LDA #&FF
 BNE CF561

.CF572

 LDX #0
 CMP #&30
 BCS CF589
 AND #&0F
 STA T
 LDA (V,X)
 LDX T
 INC V
 BNE CF561
 INC V+1
 JMP CF561

.CF589

 AND #&0F
 STA T

.loop_CF58D

 LDA (V,X)
 INC V
 BNE CF595
 INC V+1

.CF595

 STA (SC),Y
 INY
 BNE CF59C
 INC SC+1

.CF59C

 DEC T
 BNE loop_CF58D
 JMP CF52F

.CF5A3

 TXA

.CF5A4

 STA (SC),Y
 INY
 BNE CF52F
 INC SC+1
 JMP CF52F

.CF5AE

 RTS

\ ******************************************************************************
\
\       Name: UnpackToPPU
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Unpack compressed image data and send it to the PPU
\
\ ******************************************************************************

.UnpackToPPU

 LDY #0

.CF5B1

 LDA (V),Y
 INY
 BNE CF5B8
 INC V+1

.CF5B8

 CMP #&40
 BCS CF605
 TAX
 AND #&0F
 BEQ CF604
 CPX #&3F
 BEQ CF60B
 TXA
 CMP #&20
 BCS CF5E0
 CMP #&10
 AND #&0F
 TAX
 BCS CF5DC
 LDA #0

.CF5D3

 STA PPU_DATA
 DEX
 BNE CF5D3
 JMP CF5B1

.CF5DC

 LDA #&FF
 BNE CF5D3

.CF5E0

 CMP #&30
 BCS CF5F1
 AND #&0F
 TAX
 LDA (V),Y
 INY
 BNE CF5D3
 INC V+1
 JMP CF5D3

.CF5F1

 AND #&0F
 TAX

.loop_CF5F4

 LDA (V),Y
 INY
 BNE CF5FB
 INC V+1

.CF5FB

 STA PPU_DATA
 DEX
 BNE loop_CF5F4
 JMP CF5B1

.CF604

 TXA

.CF605

 STA PPU_DATA
 JMP CF5B1

.CF60B

 RTS

\ ******************************************************************************
\
\       Name: FAROF2
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.FAROF2

 STA T

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA INWK+2
 ORA INWK+5
 ORA INWK+8
 ASL A
 BNE CF658
 LDA INWK+7
 LSR A
 STA K+2
 LDA INWK+1
 LSR A
 STA K
 LDA INWK+4
 LSR A
 STA K+1
 CMP K
 BCS CF639
 LDA K

.CF639

 CMP K+2
 BCS CF63F
 LDA K+2

.CF63F

 STA SC
 LDA K
 CLC
 ADC K+1
 ADC K+2
 SEC
 SBC SC
 LSR A
 LSR A
 STA SC+1
 LSR A
 LSR A
 ADC SC+1
 ADC SC
 CMP T
 RTS

.CF658

 SEC
 RTS

INCLUDE "library/common/main/subroutine/mu5.asm"
INCLUDE "library/common/main/subroutine/mult3.asm"
INCLUDE "library/common/main/subroutine/mls2.asm"
INCLUDE "library/common/main/subroutine/mls1.asm"
INCLUDE "library/common/main/subroutine/mu6.asm"
INCLUDE "library/common/main/subroutine/squa.asm"
INCLUDE "library/common/main/subroutine/squa2.asm"
INCLUDE "library/common/main/subroutine/mu1.asm"
INCLUDE "library/common/main/subroutine/mlu1.asm"
INCLUDE "library/common/main/subroutine/mlu2.asm"
INCLUDE "library/common/main/subroutine/multu.asm"
INCLUDE "library/common/main/subroutine/mu11.asm"
INCLUDE "library/common/main/subroutine/fmltu2.asm"
INCLUDE "library/common/main/subroutine/fmltu.asm"
INCLUDE "library/common/main/subroutine/mltu2.asm"
INCLUDE "library/common/main/subroutine/mut3.asm"
INCLUDE "library/common/main/subroutine/mut2.asm"
INCLUDE "library/common/main/subroutine/mut1.asm"
INCLUDE "library/common/main/subroutine/mult1.asm"
INCLUDE "library/common/main/subroutine/mult12.asm"
INCLUDE "library/common/main/subroutine/tas3.asm"
INCLUDE "library/common/main/subroutine/mad.asm"
INCLUDE "library/common/main/subroutine/add.asm"
INCLUDE "library/common/main/subroutine/tis1.asm"
INCLUDE "library/common/main/subroutine/dv42.asm"
INCLUDE "library/common/main/subroutine/dv41.asm"
INCLUDE "library/advanced/main/subroutine/dvid4.asm"
INCLUDE "library/common/main/subroutine/dvid3b2.asm"

\ ******************************************************************************
\
\       Name: cntr
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Apply damping to the pitch or roll dashboard indicator
\
\ ******************************************************************************

.CFA13

 LDX #&80

.loop_CFA15

 RTS

.cntr

 STA T
 LDA auto
 BNE CFA22
 LDA L03EA
 BEQ loop_CFA15

.CFA22

 TXA
 BMI CFA2C
 CLC
 ADC T
 BMI CFA13
 TAX
 RTS

.CFA2C

 SEC
 SBC T
 BPL CFA13
 TAX
 RTS

INCLUDE "library/common/main/subroutine/bump2.asm"
INCLUDE "library/common/main/subroutine/redu2.asm"
INCLUDE "library/common/main/subroutine/ll5.asm"
INCLUDE "library/common/main/subroutine/ll28.asm"
INCLUDE "library/common/main/subroutine/tis2.asm"
INCLUDE "library/common/main/subroutine/norm.asm"

\ ******************************************************************************
\
\       Name: SetupMMC1
\       Type: Subroutine
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

.SetupMMC1

 LDA #&0E
 STA &9FFF
 LSR A
 STA &9FFF
 LSR A
 STA &9FFF
 LSR A
 STA &9FFF
 LSR A
 STA &9FFF
 LDA #0
 STA &BFFF
 LSR A
 STA &BFFF
 LSR A
 STA &BFFF
 LSR A
 STA &BFFF
 LSR A
 STA &BFFF
 LDA #0
 STA &DFFF
 LSR A
 STA &DFFF
 LSR A
 STA &DFFF
 LSR A
 STA &DFFF
 LSR A
 STA &DFFF
 JMP SetBank0

\ ******************************************************************************
\
\       Name: LFBCB
\       Type: Variable
\   Category: ???
\    Summary: ???
\
\ ******************************************************************************

IF _NTSC

 EQUB &F5, &F5, &F5, &F5, &F6, &F6, &F6, &F6  ; FBCB: F5 F5 F5... ...
 EQUB &F7, &F7, &F7, &F7, &F7, &F8, &F8, &F8  ; FBD3: F7 F7 F7... ...
 EQUB &F8, &F9, &F9, &F9, &F9, &F9, &FA, &FA  ; FBDB: F8 F9 F9... ...
 EQUB &FA, &FA, &FA, &FB, &FB, &FB, &FB, &FB  ; FBE3: FA FA FA... ...
 EQUB &FC, &FC, &FC, &FC, &FC, &FD, &FD, &FD  ; FBEB: FC FC FC... ...
 EQUB &FD, &FD, &FD, &FE, &FE, &FE, &FE, &FE  ; FBF3: FD FD FD... ...
 EQUB &FF, &FF, &FF, &FF, &FF

ELIF _PAL

 EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
 EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
 EQUB &FF, &FF, &FF, &FF, &FF, &FF

ENDIF

\ ******************************************************************************
\
\       Name: lineImage
\       Type: Variable
\   Category: Drawing images
\    Summary: Image data for the horizontal line, vertical line and block images
\
\ ******************************************************************************

.lineImage

 EQUB &FF, &00, &00, &00, &00, &00, &00, &00  ; FC00: FF 00 00... ...
 EQUB &00, &FF, &00, &00, &00, &00, &00, &00  ; FC08: 00 FF 00... ...
 EQUB &00, &00, &FF, &00, &00, &00, &00, &00  ; FC10: 00 00 FF... ...
 EQUB &00, &00, &00, &FF, &00, &00, &00, &00  ; FC18: 00 00 00... ...
 EQUB &00, &00, &00, &00, &FF, &00, &00, &00  ; FC20: 00 00 00... ...
 EQUB &00, &00, &00, &00, &00, &FF, &00, &00  ; FC28: 00 00 00... ...
 EQUB &00, &00, &00, &00, &00, &00, &FF, &00  ; FC30: 00 00 00... ...
 EQUB &00, &00, &00, &00, &00, &00, &00, &FF  ; FC38: 00 00 00... ...
 EQUB &00, &00, &00, &00, &00, &00, &FF, &FF  ; FC40: 00 00 00... ...
 EQUB &00, &00, &00, &00, &00, &FF, &FF, &FF  ; FC48: 00 00 00... ...
 EQUB &00, &00, &00, &00, &FF, &FF, &FF, &FF  ; FC50: 00 00 00... ...
 EQUB &00, &00, &00, &FF, &FF, &FF, &FF, &FF  ; FC58: 00 00 00... ...
 EQUB &00, &00, &FF, &FF, &FF, &FF, &FF, &FF  ; FC60: 00 00 FF... ...
 EQUB &00, &FF, &FF, &FF, &FF, &FF, &FF, &FF  ; FC68: 00 FF FF... ...
 EQUB &FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF  ; FC70: FF FF FF... ...
 EQUB &80, &80, &80, &80, &80, &80, &80, &80  ; FC78: 80 80 80... ...
 EQUB &40, &40, &40, &40, &40, &40, &40, &40  ; FC80: 40 40 40... @@@
 EQUB &20, &20, &20, &20, &20, &20, &20, &20  ; FC88: 20 20 20...
 EQUB &10, &10, &10, &10, &10, &10, &10, &10  ; FC90: 10 10 10... ...
 EQUB &08, &08, &08, &08, &08, &08, &08, &08  ; FC98: 08 08 08... ...
 EQUB &04, &04, &04, &04, &04, &04, &04, &04  ; FCA0: 04 04 04... ...
 EQUB &02, &02, &02, &02, &02, &02, &02, &02  ; FCA8: 02 02 02... ...
 EQUB &01, &01, &01, &01, &01, &01, &01, &01  ; FCB0: 01 01 01... ...
 EQUB &00, &00, &00, &00, &00, &FF, &FF, &FF  ; FCB8: 00 00 00... ...
 EQUB &FF, &FF, &FF, &00, &00, &00, &00, &00  ; FCC0: FF FF FF... ...
 EQUB &00, &00, &00, &00, &00, &C0, &C0, &C0  ; FCC8: 00 00 00... ...
 EQUB &C0, &C0, &C0, &00, &00, &00, &00, &00  ; FCD0: C0 C0 C0... ...
 EQUB &00, &00, &00, &00, &00, &03, &03, &03  ; FCD8: 00 00 00... ...
 EQUB &03, &03, &03, &00, &00, &00, &00, &00  ; FCE0: 03 03 03... ...

\ ******************************************************************************
\
\       Name: fontImage
\       Type: Variable
\   Category: Text
\    Summary: Image data for the text font
\
\ ******************************************************************************

.fontImage

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &30, &30, &30, &30, &00, &30, &30, &00
 EQUB &7F, &63, &63, &63, &7F, &63, &63, &00
 EQUB &7F, &63, &63, &63, &63, &63, &7F, &00
 EQUB &78, &1E, &7F, &03, &7F, &63, &7F, &00
 EQUB &1F, &78, &7F, &63, &7F, &60, &7F, &00
 EQUB &7C, &CC, &78, &38, &6D, &C6, &7F, &00
 EQUB &30, &30, &30, &00, &00, &00, &00, &00
 EQUB &06, &0C, &18, &18, &18, &0C, &06, &00
 EQUB &60, &30, &18, &18, &18, &30, &60, &00
 EQUB &78, &1E, &7F, &63, &7F, &60, &7F, &00
 EQUB &1C, &36, &7F, &63, &7F, &60, &7F, &00
 EQUB &00, &00, &00, &00, &00, &30, &30, &60
 EQUB &00, &00, &00, &7E, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &30, &30, &00
 EQUB &1C, &36, &7F, &63, &63, &63, &7F, &00
 EQUB &7F, &63, &63, &63, &63, &63, &7F, &00
 EQUB &1C, &0C, &0C, &0C, &0C, &0C, &3F, &00
 EQUB &7F, &03, &03, &7F, &60, &60, &7F, &00
 EQUB &7F, &03, &03, &3F, &03, &03, &7F, &00
 EQUB &60, &60, &66, &66, &7F, &06, &06, &00
 EQUB &7F, &60, &60, &7F, &03, &03, &7F, &00
 EQUB &7F, &60, &60, &7F, &63, &63, &7F, &00
 EQUB &7F, &03, &03, &07, &03, &03, &03, &00
 EQUB &7F, &63, &63, &7F, &63, &63, &7F, &00
 EQUB &7F, &63, &63, &7F, &03, &03, &7F, &00
 EQUB &00, &00, &30, &30, &00, &30, &30, &00
 EQUB &00, &00, &7E, &66, &7F, &63, &7F, &60
 EQUB &7F, &60, &60, &7E, &60, &60, &7F, &00
 EQUB &7F, &60, &60, &7E, &60, &60, &7F, &00
 EQUB &18, &0C, &06, &03, &06, &0C, &18, &00
 EQUB &7F, &03, &1F, &18, &00, &18, &18, &00
 EQUB &7F, &60, &60, &60, &60, &7F, &0C, &3C
 EQUB &7F, &63, &63, &63, &7F, &63, &63, &00
 EQUB &7E, &66, &66, &7F, &63, &63, &7F, &00
 EQUB &7F, &60, &60, &60, &60, &60, &7F, &00
 EQUB &7F, &33, &33, &33, &33, &33, &7F, &00
 EQUB &7F, &60, &60, &7E, &60, &60, &7F, &00
 EQUB &7F, &60, &60, &7E, &60, &60, &60, &00
 EQUB &7F, &60, &60, &60, &63, &63, &7F, &00
 EQUB &63, &63, &63, &7F, &63, &63, &63, &00
 EQUB &3F, &0C, &0C, &0C, &0C, &0C, &3F, &00
 EQUB &7F, &0C, &0C, &0C, &0C, &0C, &7C, &00
 EQUB &66, &66, &66, &7F, &63, &63, &63, &00
 EQUB &60, &60, &60, &60, &60, &60, &7F, &00
 EQUB &63, &77, &7F, &6B, &63, &63, &63, &00
 EQUB &63, &73, &7B, &6F, &67, &63, &63, &00
 EQUB &7F, &63, &63, &63, &63, &63, &7F, &00
 EQUB &7F, &63, &63, &7F, &60, &60, &60, &00
 EQUB &7F, &63, &63, &63, &63, &67, &7F, &03
 EQUB &7F, &63, &63, &7F, &66, &66, &66, &00
 EQUB &7F, &60, &60, &7F, &03, &03, &7F, &00
 EQUB &7E, &18, &18, &18, &18, &18, &18, &00
 EQUB &63, &63, &63, &63, &63, &63, &7F, &00
 EQUB &63, &63, &66, &6C, &78, &70, &60, &00
 EQUB &63, &63, &63, &6B, &7F, &77, &63, &00
 EQUB &63, &36, &1C, &1C, &1C, &36, &63, &00
 EQUB &63, &33, &1B, &0F, &07, &03, &03, &00
 EQUB &7F, &06, &0C, &18, &30, &60, &7F, &00
 EQUB &63, &3E, &63, &63, &7F, &63, &63, &00
 EQUB &63, &3E, &63, &63, &63, &63, &7F, &00
 EQUB &63, &00, &63, &63, &63, &63, &7F, &00
 EQUB &7E, &66, &66, &7F, &63, &63, &7F, &60
 EQUB &7F, &60, &60, &7E, &60, &60, &7F, &00
 EQUB &00, &00, &7F, &60, &60, &7F, &0C, &3C
 EQUB &00, &00, &7F, &03, &7F, &63, &7F, &00
 EQUB &60, &60, &7F, &63, &63, &63, &7F, &00
 EQUB &00, &00, &7F, &60, &60, &60, &7F, &00
 EQUB &03, &03, &7F, &63, &63, &63, &7F, &00
 EQUB &00, &00, &7F, &63, &7F, &60, &7F, &00
 EQUB &3F, &30, &30, &7C, &30, &30, &30, &00
 EQUB &00, &00, &7F, &63, &63, &7F, &03, &7F
 EQUB &60, &60, &7F, &63, &63, &63, &63, &00
 EQUB &18, &00, &78, &18, &18, &18, &7E, &00
 EQUB &0C, &00, &3C, &0C, &0C, &0C, &0C, &7C
 EQUB &60, &60, &66, &66, &7F, &63, &63, &00
 EQUB &78, &18, &18, &18, &18, &18, &7E, &00
 EQUB &00, &00, &77, &7F, &6B, &63, &63, &00
 EQUB &00, &00, &7F, &63, &63, &63, &63, &00
 EQUB &00, &00, &7F, &63, &63, &63, &7F, &00
 EQUB &00, &00, &7F, &63, &63, &7F, &60, &60
 EQUB &00, &00, &7F, &63, &63, &7F, &03, &03
 EQUB &00, &00, &7F, &60, &60, &60, &60, &00
 EQUB &00, &00, &7F, &60, &7F, &03, &7F, &00
 EQUB &30, &30, &7C, &30, &30, &30, &3F, &00
 EQUB &00, &00, &63, &63, &63, &63, &7F, &00
 EQUB &00, &00, &63, &66, &6C, &78, &70, &00
 EQUB &00, &00, &63, &63, &6B, &7F, &7F, &00
 EQUB &00, &00, &63, &36, &1C, &36, &63, &00
 EQUB &00, &00, &63, &63, &63, &7F, &03, &7F
 EQUB &00, &00, &7F, &0C, &18, &30, &7F, &00
 EQUB &36, &00, &7F, &03, &7F, &63, &7F, &00
 EQUB &36, &00, &7F, &63, &63, &63, &7F, &00
 EQUB &36, &00, &63, &63, &63, &63, &7F, &00

IF _NTSC

 EQUB &00, &8D, &06, &20, &A9, &4C, &00, &C0

ELIF _PAL

 EQUB &FF, &FF, &FF, &FF, &FF, &4C, &00, &C0

ENDIF

 EQUB &45, &4C, &20, &20, &20, &20, &20, &20
 EQUB &20, &20, &20, &20, &20, &20, &20, &20
 EQUB &00, &00, &00, &00, &38, &04, &01, &07
 EQUB &9C, &2A

\ ******************************************************************************
\
\       Name: Vectors
\       Type: Variable
\   Category: Utility routines
\    Summary: Vectors at the end of the ROM bank
\
\ ******************************************************************************

 EQUW NMI               \ Vector to the NMI handler

 EQUW ResetMMC1_b7      \ Vector to the RESET handler

 EQUW IRQ               \ Vector to the IRQ/BRK handler

\ ******************************************************************************
\
\ Save bank7.bin
\
\ ******************************************************************************

IF _BANK = 7

 PRINT "S.bank7.bin ", ~CODE_BANK_7%, " ", ~P%, " ", ~LOAD_BANK_7%, " ", ~LOAD_BANK_7%
 SAVE "versions/nes/3-assembled-output/bank7.bin", CODE_BANK_7%, P%, LOAD_BANK_7%

ENDIF

\ ******************************************************************************
\
\ ELECTRON ELITE LOADER SOURCE
\
\ Electron Elite was written by Ian Bell and David Braben and is copyright
\ Acornsoft 1984
\
\ The code on this site has been disassembled from the version released on Ian
\ Bell's personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * output/ELITEDA.bin
\
\ ******************************************************************************

INCLUDE "versions/electron/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_MASTER_VERSION         = (_VERSION = 4)
_ELECTRON_VERSION       = (_VERSION = 5)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

N% = 17                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them in part 2 below

LEN = 506

CODE% = &4400
LOAD% = &4400

USERV = &0200           \ The address for the user vector
BRKV = &0202            \ The address for the break vector
IRQ1V = &0204           \ The address for the interrupt vector
WRCHV = &020E           \ The address for the write character vector
RDCHV = &0210           \ The address for the read character vector
KEYV = &0228            \ The address for the keyboard vector

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI routine

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

INCLUDE "library/cassette/loader/workspace/zp.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of ???)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for recursive tokens and images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 3 below.
\
\ There is one file containing code:
\
\   * WORDS9.bin contains the recursive token table, which is moved to &0400
\     before the main game is loaded
\
\ and four files containing images, which are all moved into screen memory by
\ the loader:
\
\   * P.A-SOFT.bin contains the "ACORNSOFT" title across the top of the loading
\     screen, which gets moved to screen address &5960, on the second character
\     row of the monochrome mode 4 screen
\
\   * P.ELITE.bin contains the "ELITE" title across the top of the loading
\     screen, which gets moved to screen address &5B00, on the fourth character
\     row of the monochrome mode 4 screen
\
\   * P.(C)ASFT.bin contains the "(C) Acornsoft 1984" title across the bottom
\     of the loading screen, which gets moved to screen address &73A0, the
\     penultimate character row of the monochrome mode 4 screen, just above the
\     dashboard
\
\   * P.DIALS.bin contains the dashboard, which gets moved to screen address
\     &7620, which is the starting point of the dashboard at the bottom of the
\     monochrome mode 4 screen
\
\ The routine ends with a jump to the start of the loader code at ENTRY.
\
\ ******************************************************************************

ORG CODE%

PRINT "WORDS9 = ",~P%
INCBIN "versions/electron/output/WORDS9.bin"

ALIGN 256

PRINT "P.DIALS = ",~P%
INCBIN "versions/electron/binaries/P.DIALS.bin"

PRINT "P.ELITE = ",~P%
INCBIN "versions/electron/binaries/P.ELITE.bin"

PRINT "P.A-SOFT = ",~P%
INCBIN "versions/electron/binaries/P.A-SOFT.bin"

PRINT "P.(C)ASFT = ",~P%
INCBIN "versions/electron/binaries/P.(C)ASFT.bin"

.run

 JMP ENTRY              \ Jump to ENTRY to start the loading process

INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/cassette/loader/subroutine/swine.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"
INCLUDE "library/cassette/loader/variable/authors_names.asm"
INCLUDE "library/cassette/loader/variable/oscliv.asm"
INCLUDE "library/cassette/loader/variable/david9.asm"
INCLUDE "library/cassette/loader/variable/david23.asm"
INCLUDE "library/cassette/loader/subroutine/doprot1.asm"
INCLUDE "library/cassette/loader/variable/mhca.asm"
INCLUDE "library/cassette/loader/subroutine/david7.asm"
INCLUDE "library/common/loader/macro/fne.asm"

\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of ???)
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ------------------------------------------------------------------------------
\
\ 4 pages from &4400-&47FF to &0400-&07FF - Text Tokens
\ 1 page from &4F00 to &5B00  - ELITE
\ 1 page from &5000 to &5960  - Acornsoft presents on row 2
\ 1 page from &5100 to &73A0  - (C) Acornsoft 1984
\ Saturn
\ Loop - Dashboard:
\     1 page from &4800 to &7620           = &7620
\     1 page from &4900 to &7720 + &40     = &7760
\     1 page from &4A00 to &7820 + 2 * &40 = &78A0
\     1 page from &4B00 to &7920 + 3 * &40 = &79E0
\     1 page from &4C00 to &7A20 + 4 * &40 = &7B20
\     1 page from &4D00 to &7B20 + 5 * &40 = &7C60
\     1 page from &4E00 to &7C20 + 6 * &40 = &7DA0
\ Standard mode 4 with &20 margin on each side, &5800 to &7FFF
\ Bottom row not used by dashboard, &7EC0 to &7FFF
\ 1 page from &5615 to &0B00
\
\ JMP &0B10 to load game at &2000 and move down to &0D00
\
\ JSR &0BC2 later, too
\
\ Then JMP (&0D08) starts game
\ &0D08 is in main game code so this jumps to &3FB6, DEATH2+2
\
\ ******************************************************************************

.ENTRY

 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 LDA #&60
 STA L0088
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP

 LDA #&20               \ Set A to the op code for a JSR call with absolute
                        \ addressing

 NOP

.Ian1

 NOP
 NOP
 NOP
 NOP
 NOP

 LSR A                  \ Set A = 16

 LDX #3                 \ Set the high bytes of BLPTR(1 0), BLN(1 0) and
 STX BLPTR+1            \ EXCN(1 0) to &3. We will fill in the high bytes in
 STX BLN+1              \ the PLL1 routine, and will then use these values in
 STX EXCN+1             \ the IRQ1 handler

 LDX #0                 \ Call OSBYTE with A = 16 and X = 0 to set the joystick
 LDY #0                 \ port to sample 0 channels (i.e. disable it)
 JSR OSBYTE

 LDX #255               \ Call doPROT1 to change an instruction in the PROT1
 LDA #&95               \ routine and set up another couple of variables
 JSR doPROT1

 LDA #144               \ Call OSBYTE with A = 144, X = 255 and Y = 0 to move
 JSR OSB                \ the screen down one line and turn screen interlace on

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &D0 &A1, or BIT &A1D0, which does nothing apart
                        \ from affect the flags ???

.FRED1

 BNE David7             \ This instruction is skipped if we came from above,
                        \ otherwise this is part of the multi-jump obfuscation
                        \ in PROT1

 LDA #247               \ Call OSBYTE with A = 247 and X = Y = 0 to disable the
 LDX #0                 \ BREAK intercept code by poking 0 into the first value
 JSR OSB

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&C                \ type &C with argument &FF, which is the "NMI claim"
 LDY #&FF               \ service call that asks the current user of the NMI
 JSR OSBYTE             \ space to clear it out

 LDA #13                \ Set A = 13 for the next OSBYTE call

.abrk

 LDX #0                 \ Call OSBYTE with A = 13, X = 0 and Y = 0 to disable
 JSR OSB                \ the "output buffer empty" event

 LDA #225               \ Call OSBYTE with A = 225, X = 128 and Y = 0 to set
 LDX #128               \ the function keys to return ASCII codes for SHIFT-fn
 JSR OSB                \ keys (i.e. add 128)

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #255
 JSR OSBYTE

 STX TRTB%              \ Store the address of the keyboard translation table in
 STY TRTB%+1            \ TRTB%(1 0)

 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP

 LDA #13                \ Call OSBYTE with A = 13, X = 2 and Y = 0 to disable
 LDX #2                 \ the "character entering keyboard buffer" event
 JSR OSB

.OS01

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 INX                    \ Set X = 0, to use as a counter in the following loop
 
 LDY #0

.David3

 LDA crunchit,Y

.PROT1

 STA TRTB%+2,X
 INX
 INY
 CPY #&21
 BNE David3

 LDA #&03
 STA ZP
 LDA #&95
 BIT PROT1
 LDA #&52
 STA ZP+1
 LDY #&00

.LOOP

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE LOOP               \ all (the number of bytes was set in N% above)

 LDA #1
 TAX
 TAY
 LDA abrk+1
 CMP (V219),Y

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 JSR OSB                \ cursor editing, so the cursor keys return ASCII values
                        \ and can therefore be used in-game

 LDA #9                 \ Call OSBYTE with A = 9, X = 0 and Y = 0 to disable
 LDX #0                 \ flashing colours
 JSR OSB

 LDA #&6C
 NOP
 NOP
 NOP
 BIT L544F

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #&04
 STX Q
 LDA #&44
 STA ZP+1
 LDY #&00
 LDA #&18
 CMP (SC,X)
 STY ZP
 STY P
 JSR crunchit

 LDX #&01
 LDA #&4F
 STA ZP+1
 LDA #&5B
 STA Q
 LDA #&E0
 STA P
 LDY #&00
 JSR crunchit

 LDX #&01
 LDA #&50
 STA ZP+1
 LDA #&59
 STA Q
 LDA #&60
 STA P
 LDY #&00
 JSR crunchit

 LDX #&01
 LDA #&51
 STA ZP+1
 LDA #&73
 STA Q
 LDA #&A0
 STA P
 LDY #&00
 JSR crunchit

 JSR PLL1

 LDA #&48
 STA ZP+1
 LDA #&76
 STA Q
 LDY #&00
 STY ZP
 LDX #&20
 STY BLCNT
 STX P

.L540B

 LDX #&01
 JSR crunchit

 CLC
 LDA P
 ADC #&40
 STA P
 LDA Q
 ADC #&00
 STA Q
 CMP #&7E
 BCC L540B

 LDX #&01
 LDA #&56
 STA ZP+1
 LDA #&15
 STA ZP
 LDA #&0B
 STA Q
 LDY #&00
 STY P
 JSR crunchit

 JMP &0B11

 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP

.L544F

 NOP
 NOP
 NOP

.RAND

 EQUD &6C785349         \ The random number seed used for drawing Saturn

 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP

.PLL1

 JSR DORND

 JSR SQUA2

 STA ZP+1
 LDA P
 STA ZP
 JSR DORND

 STA YY
 JSR SQUA2

 TAX
 LDA P
 ADC ZP
 STA ZP
 TXA
 ADC ZP+1
 BCS PLC1

 STA ZP+1
 LDA #&01
 SBC ZP
 STA ZP
 LDA #&40
 SBC ZP+1
 STA ZP+1
 BCC PLC1

 JSR ROOT

 LDA ZP
 LSR A
 TAX
 LDA YY
 CMP #&80
 ROR A
 JSR PIX

.PLC1

 DEC CNT
 BNE PLL1

 DEC L55B8
 BNE PLL1

 LDX #&C2
 STX EXCN
 LDX #&60
 STX L0087

.PLL2

 JSR DORND

 TAX
 JSR SQUA2

 STA ZP+1
 JSR DORND

 STA YY
 JSR SQUA2

 ADC ZP+1
 CMP #&11
 BCC PLC2

 LDA YY
 JSR PIX

.PLC2

 DEC CNT2
 BNE PLL2

 DEC L55BA
 BNE PLL2

 LDX #&CA
 NOP
 STX BLPTR
 LDX #&C6
 STX BLN

.PLL3

 JSR DORND

 STA ZP
 JSR SQUA2

 STA ZP+1
 JSR DORND

 STA YY
 JSR SQUA2

 STA T
 ADC ZP+1
 STA ZP+1
 LDA ZP
 CMP #&80
 ROR A
 CMP #&80
 ROR A
 ADC YY
 TAX
 JSR SQUA2

 TAY
 ADC ZP+1
 BCS PLC3

 CMP #&50
 BCS PLC3

 CMP #&20
 BCC PLC3

 TYA
 ADC T
 CMP #&10
 BCS PL1

 LDA ZP
 BPL PLC3

.PL1

 LDA YY
 JSR PIX

.PLC3

 DEC CNT3
 BNE PLL3

 DEC L55BC
 BNE PLL3

.DORND

 LDA RAND+1
 TAX
 ADC RAND+3
 STA RAND+1
 STX RAND+3
 LDA RAND
 TAX
 ADC RAND+2
 STA RAND
 STX RAND+2
 RTS

.SQUA2

 BPL SQUA

 EOR #&FF
 CLC
 ADC #&01

.SQUA

 STA Q
 STA P
 LDA #&00
 LDY #&08
 LSR P

.SQL1

 BCC SQ1

 CLC
 ADC Q

.SQ1

 ROR A
 ROR P
 DEY
 BNE SQL1

.L5575

 RTS

.PIX

 LDY #&80
 STY ZP
 TAY
 EOR #&80
 CMP #&F8
 BCS L5575

 LSR A
 LSR A
 LSR A
 STA ZP+1
 LSR A
 ROR ZP
 LSR A
 ROR ZP
 ADC ZP+1
 ADC #&58
 STA ZP+1
 TXA
 EOR #&80
 AND #&F8
 ADC ZP
 STA ZP
 BCC L559F

 INC ZP+1

.L559F

 TYA
 AND #&07
 TAY
 TXA
 AND #&07
 TAX
 LDA L55AF,X
 ORA (ZP),Y
 STA (ZP),Y
 RTS

.L55AF

 EQUB &80

 EQUB &40, &20, &10, &08, &04, &02, &01

.CNT

 EQUB &00

.L55B8

 EQUB &05

.CNT2

 EQUB &DD

.L55BA

 EQUB &01

.CNT3

 EQUB &00

.L55BC

 EQUB &05

.ROOT

 LDY ZP+1
 LDA ZP
 STA Q
 LDX #&00
 STX ZP
 LDA #&08

.L55C9

 STA P

.LL6

 CPX ZP
 BCC LL7

 BNE LL8

 CPY #&40
 BCC LL7

.LL8

 TYA
 SBC #&40
 TAY
 TXA
 SBC ZP
 TAX

.LL7

 ROL ZP
 ASL Q
 TYA
 ROL A
 TAY
 TXA
 ROL A
 TAX
 ASL Q
 TYA
 ROL A
 TAY
 TXA
 ROL A
 TAX
 DEC P
 BNE LL6

 RTS

.crunchit

 LDA (ZP),Y
 NOP
 NOP
 NOP
 STA (P),Y
 DEY
 BNE crunchit

 INC Q
 INC ZP+1
 DEX
 BNE crunchit

 RTS

 PLA
 PLA
 LDA &0C24,Y
 PHA
 EOR &0B3D,Y
 NOP
 NOP
 NOP
 JMP (David9)

.LOADcode

 org &0B00

.LOAD

 EQUB &10, &10, &10, &10, &10, &10, &10, &10
 EQUB &10, &10, &10, &10, &10, &10, &10, &10

.L0B10

 BPL &0AB4

 INY
 LDY #&0B
 JSR OSCLI

 LDA #&03
 STA &0258
 LDA #&8C
 LDX #&0C
 LDY #&00
 JSR OSBYTE

 LDA #&8F
 LDX #&0C
 LDY #&FF
 JSR OSBYTE

 LDA #&40
 STA &0D00
 LDX #&4A
 LDY #&00
 STY ZP
 STY P
 LDA #&20
 STA ZP+1
 LDA #&0D
 STA P+1

.L0B44

 LDA (ZP),Y
 STA (P),Y
 LDA #&00
 STA (ZP),Y
 INY
 BNE L0B44

 INC ZP+1
 INC P+1
 DEX
 BPL L0B44

 SEI
 TXS
 LDA RDCHV
 STA USERV
 LDA RDCHV+1
 STA USERV+1
 LDA KEYV
 STA &0D04
 LDA KEYV+1
 STA &0D05
 LDA #&10
 STA KEYV
 LDA #&0D
 STA KEYV+1
 LDA &0D0E
 STA BRKV
 LDA &0D0F
 STA BRKV+1
 LDA &0D0A
 STA WRCHV
 LDA &0D0B
 STA WRCHV+1
 LDA IRQ1V
 STA &0D02
 LDA IRQ1V+1
 STA &0D03
 LDA &0D0C
 STA IRQ1V
 LDA &0D0D
 STA IRQ1V+1
 LDA #&FC
 JSR L0BC2

 LDA #&08
 JSR L0BC2

 LDA #&60
 STA VIA+&02
 LDA #&3F
 STA VIA+&03
 CLI
 JMP (&0D08)

.L0BC2

 STA &00F4
 STA VIA+&05
 RTS

 EQUS "LOAD EliteCo FFFF2000"

 EQUB &0D, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00

COPYBLOCK LOAD, P%, LOADcode

ORG LOADcode + P% - LOAD


PRINT "S.ELITEDA ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/electron/output/ELITEDA.bin", CODE%, P%, LOAD%

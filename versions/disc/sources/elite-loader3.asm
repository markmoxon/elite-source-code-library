\ ******************************************************************************
\
\ DISC ELITE LOADER (PART 3) SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
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
\   * output/ELITE4.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE

CODE% = &1900
LOAD% = &1900

NETV = &224             \ The NETV vector that we intercept as part of the copy
                        \ protection

IRQ1V = &204            \ The IRQ1V vector that we intercept to implement the
                        \ split-sceen mode

INDV2 = &0232

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI vector

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

N% = 67                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them below

VEC = &7FFE             \ VEC is where we store the original value of the IRQ1
                        \ vector, and it matches the value in elite-source.asm

L0001   = $0001

ZP = &70                \ Temporary storage, used all over the place

P = &72                 \ Temporary storage, used all over the place

Q = &73                 \ Temporary storage, used all over the place

YY = &74                \ Temporary storage, used when drawing Saturn

T = &75                 \ Temporary storage, used all over the place

SC = &76                \ Used to store the screen address while plotting pixels

BLPTR = &78             \ Gets set as part of the obfuscation code

ORG CODE%

INCLUDE "library/common/loader/variable/b_per_cent.asm"

 EQUB &01, &01, &00, &6F, &F8
 EQUB &04, &01, &08, &08, &FE, &00, &FF, &7E
 EQUB &2C, &02, &01, &0E, &EE, &FF, &2C, &20
 EQUB &32, &06, &01, &00, &FE, &78, &7E, &03
 EQUB &01, &01, &FF, &FD, &11, &20, &80, &01
 EQUB &00, &00, &FF, &01, &01, &04, &01, &04
 EQUB &F8, &2C, &04, &06, &08, &16, &00, &00
 EQUB &81, &7E, &00

.L197B

 JSR L1B72

 LDA #144
 LDX #255
 JSR OSB

 LDA #LO(B%)            \ Set the low byte of ZP(1 0) to point to the VDU code
 STA ZP                 \ table at B%

 LDA #HI(B%)            \ Set the high byte of ZP(1 0) to point to the VDU code
 STA ZP+1               \ table at B%

 LDY #0                 \ We are now going to send the 67 VDU bytes in the table
                        \ at B% to OSWRCH to set up the special mode 4 screen
                        \ that forms the basis for the split-screen mode

.LOOP

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE LOOP               \ all (the number of bytes was set in N% above)

 JSR PLL1               \ Call PLL1 to draw Saturn

 LDA #16
 LDX #3
 JSR OSBYTE

 LDA #&60
 STA INDV2
 LDA #&02
 STA NETV+1
 LDA #&32
 STA NETV

 LDA #190
 LDX #8
 JSR OSB

 LDA #200
 LDX #0
 JSR OSB

 LDA #13
 LDX #0
 JSR OSB

 LDA #225
 LDX #128
 JSR OSB

 LDA #12
 LDX #0

.L19D2

 JSR OSB

 LDA #13
 LDX #2
 JSR OSB

 LDA #4
 LDX #1
 JSR OSB

 LDA #9
 LDX #0
 JSR OSB

 JSR L1CE2

 LDA #&00
 STA ZP
 LDA #&11
 STA ZP+1
 LDA #&62
 STA P
 LDA #&29
 STA P+1
 JSR MVPG

 LDA #&00
 STA ZP
 LDA #&78
 STA ZP+1
 LDA #&4B
 STA P
 LDA #&1D
 STA P+1
 LDX #&08
 JSR MVBL

 SEI
 LDA VIA+$44
 STA L0001
 LDA #&39
 STA VIA+$4E
 LDA #&7F
 STA VIA+&6E
 LDA IRQ1V
 STA VEC
 LDA IRQ1V+1
 STA VEC+1
 LDA #&4B
 STA IRQ1V
 LDA #&11
 STA IRQ1V+1
 LDA #&39
 STA VIA+&45
 CLI
 LDA #&00
 STA ZP
 LDA #&61
 STA ZP+1
 LDA #&62
 STA P
 LDA #&2B
 STA P+1
 JSR MVPG

 LDA #&63
 STA ZP+1
 LDA #&62
 STA P
 LDA #&2A
 STA P+1
 JSR MVPG

 LDA #&76
 STA ZP+1
 LDA #&62
 STA P
 LDA #&2C
 STA P+1
 JSR MVPG

 LDA #&00
 STA ZP
 LDA #&04
 STA ZP+1
 LDA #&4B
 STA P
 LDA #&25
 STA P+1
 LDX #&04
 JSR MVBL

 LDX #35

.L1A89

 LDA L1B4F,X
 STA L0D7A,X
 DEX
 BPL L1A89

 LDA SC
 STA L0D92

 LDX #&43
 LDY #&19
 LDA #8
 JSR OSWORD

 LDX #&51
 LDY #&19
 LDA #8
 JSR OSWORD

 LDX #&5F
 LDY #&19
 LDA #8
 JSR OSWORD

 LDX #&6D
 LDY #&19
 LDA #8
 JSR OSWORD

 LDX #&44
 LDY #&1D
 JSR OSCLI

 LDA #&00
 STA ZP
 LDA #&0B
 STA ZP+1
 LDA #&ED
 STA P
 LDA #&1A
 STA P+1

 LDY #&00

.L1AD4

 LDA (P),Y
 EOR #&18
 STA (ZP),Y
 DEY
 BNE L1AD4

 JMP &0B00

.L1AE0

 CLC
 LDY #&00

.L1AE3

 ADC PLL1,Y
 EOR L197B,Y
 DEY
 BNE L1AE3

 RTS

 EQUB &BA, &2F, &B8, &13, &38, &EF, &E7, &B1
 EQUB &F6, &95

 EQUB &1A, &1A, &B1, &09, &95, &1B, &1A, &B1
 EQUB &F1, &95, &16, &1A, &B1, &09, &95, &17
 EQUB &1A, &20, &B8, &18, &9C, &68, &BA, &09
 EQUB &92, &9E, &69, &69, &68, &90, &C8, &E1
 EQUB &F0, &F8, &4C, &88, &EC, &D5, &E7, &4D
 EQUB &C8, &E6, &54, &FE, &09, &54, &36, &4C
 EQUB &36, &5B, &57, &5C, &5D, &15, &5C, &77
 EQUB &7D, &6B, &38, &61, &77, &6D, &6A, &38
 EQUB &75, &77, &6C, &70, &7D, &6A, &38, &73
 EQUB &76, &77, &6F, &38, &61, &77, &6D, &38
 EQUB &7C, &77, &38, &6C, &70, &71, &6B, &27

\ Gets copied from &1B4F to &0D7A by loop at L1A89 (35 bytes),
\ is called by D and T to load from disc

.L1B4F

ORG &0D7A

.L0D7A

 DEC L0D92+8            \ Decrement sector number from 1 to 0
 DEC L0D92+2            \ Decrement load address from &0F00 to &0E00

 JSR L0D89

 INC L0D92+8            \ Increment sector number back to 1
 INC L0D92+2            \ Increment load address back to &0F00

.L0D89

 LDA #127
 LDX #LO(L0D92)
 LDY #HI(L0D92)
 JMP OSWORD

.L0D92

 EQUB 0                 \ 0 = Drive = 0
 EQUD &00000F00         \ 1 = Data address = &0F00
 EQUB 3                 \ 5 = Number of parameters = 3
 EQUB &53               \ 6 = Command = &53 (read data)
 EQUB 0                 \ 7 = Track = 0
 EQUB 1                 \ 8 = Sector = 1
 EQUB %00100001         \ 9 = Load 1 sector of 256 bytes
 EQUB 0

COPYBLOCK L0D7A, P%, L1B4F

ORG L1B4F + P% - L0D7A

.L1B72

 LDA #&55
 LDX #&40

.L1B76

 JSR L1AE0

 DEX
 BPL L1B76

 STA RAND+2
 ORA #&00
 BPL L1B85

 LSR BLPTR

.L1B85

 JMP L1CCF

 EQUB &AC

INCLUDE "library/common/loader/subroutine/pll1.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/6502sp/loader1/variable/rand.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"

.L1CCF

 LDA RAND+2
 EOR BLPTR
 ASL A
 CMP #&93
 ROR A
 STA BLPTR
 BCC out

INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"

.L1CE2

 LDA BLPTR
 AND BLPTR+1
 ORA #&0C
 ASL A
 STA BLPTR
 RTS

.L1CEC

 JMP L1CEC

INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"

 EQUB &0E

\ ******************************************************************************
\
\       Name: MVPG
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Move and decrypt a multi-page block of memory from one location to
\             another
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   P(1 0)              The source address of the block to move
\
\   ZP(1 0)             The destination address of the block to move
\
\   X                   Number of pages of memory to move (1 page = 256 bytes)
\
\ ******************************************************************************

.MVPG

                        \ This subroutine is called from below to copy one page
                        \ of memory from the address in P(1 0) to the address
                        \ in ZP(1 0)

 LDY #0                 \ We want to move one page of memory, so set Y as a byte
                        \ counter

.MPL

 LDA (P),Y              \ Fetch the Y-th byte of the P(1 0) memory block

 EOR #&A5               \ Decrypt it by EOR'ing with &A5

 STA (ZP),Y             \ Store the decrypted result in the Y-th byte of the
                        \ ZP(1 0) memory block

 DEY                    \ Decrement the byte counter

 BNE MPL                \ Loop back to copy the next byte until we have done a
                        \ whole page of 256 bytes

 RTS                    \ Return from the subroutine

 EQUB &0E

.MVBL

 JSR MVPG               \ Call MVPG above to copy one page of memory from the
                        \ address in P(1 0) to the address in ZP(1 0)

 INC ZP+1               \ Increment the high byte of the source address to point
                        \ to the next page

 INC P+1                \ Increment the high byte of the destination address to
                        \ point to the next page

 DEX                    \ Decrement the page counter

 BNE MVBL               \ Loop back to copy the next page until we have done X
                        \ pages

 RTS                    \ Return from the subroutine




 EQUB &2A, &44, &49, &52, &20
 EQUB &45, &0D, &55, &25, &22, &21, &22, &21
 EQUB &21, &25, &55, &A5, &A3, &A1, &A3, &A7
 EQUB &A3, &A5, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &5A, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &5A, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &5A, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &5A, &55, &33, &01, &65, &25, &25
 EQUB &25, &25, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &55, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &55

 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &55
 EQUB &33, &01, &65, &65, &65, &65, &25, &55
 EQUB &A7, &A5, &A3, &A5, &A3, &A5, &A3, &55
 EQUB &33, &F7, &D5, &95, &95, &B5, &B5, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &F0, &5A, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &F0, &5A, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &F0, &5A, &55
 EQUB &A5, &A5, &A5, &A5, &A5, &F0, &5A, &55
 EQUB &A5, &A3, &A1, &A3, &A7, &A3, &A5, &55
 EQUB &B5, &BB, &BF, &BB, &BD, &BD, &B5, &25
 EQUB &22, &20, &20, &22, &20, &25, &25, &A5
 EQUB &A3, &A1, &A3, &A7, &A3, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &25
 EQUB &25, &25, &25, &25, &25, &25, &25, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A4, &A3, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A3, &A5, &A5
 EQUB &A5, &A5, &A5, &A4, &A9, &A7, &A5, &A5
 EQUB &A5, &A5, &A5, &A3, &2D, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AE, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A2, &A5, &A7, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A8, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A1, &2F, &A7, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A9, &A4, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AD, &A6, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &25
 EQUB &25, &27, &25, &25, &25, &25, &65, &A5
 EQUB &A5, &AC, &A5, &A5, &A3, &A5, &A3, &B5
 EQUB &B5, &B1, &B5, &B5, &B5, &B5, &B5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &87, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &0F, &5A, &2D
 EQUB &2D, &A5, &A5, &A5, &2D, &0F, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &0F, &5A, &A5
 EQUB &A5, &A3, &A0, &A2, &A3, &A0, &A5, &B5
 EQUB &B5, &B1, &B1, &B1, &B1, &B3, &B5, &25
 EQUB &23, &21, &23, &21, &21, &25, &25, &A5
 EQUB &AF, &AF, &AF, &AF, &A1, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &3C, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &87, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &E1, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &3C, &5A, &25
 EQUB &25, &25, &25, &25, &25, &25, &25, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A4, &A7, &A5
 EQUB &A5, &A5, &A6, &A1, &AD, &A5, &A5, &A4
 EQUB &A3, &AD, &A7, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &AF, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &AF, &A4, &A5, &A7, &A5, &A1
 EQUB &A5, &AD, &AF, &A5, &A5, &A5, &A5, &87
 EQUB &A5, &A5, &AF, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &2F, &A5, &A5, &87, &A5, &A7
 EQUB &A5, &A7, &AD, &A7, &A5, &A7, &A5, &A5
 EQUB &A5, &A5, &AF, &A5, &A5, &87, &A5, &87
 EQUB &A5, &A5, &2F, &A5, &A5, &A5, &A5, &A4
 EQUB &A5, &A5, &AF, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &AD, &A7, &A1, &A5, &A7, &A5, &A5
 EQUB &A5, &A5, &AF, &A5, &A5, &A5, &A5, &AD
 EQUB &A6, &A5, &AF, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &AD, &A3, &A4, &A5, &A5, &A5, &E5
 EQUB &E5, &C5, &85, &95, &BD, &A1, &A7, &A5
 EQUB &A3, &A5, &A3, &A5, &55, &A5, &A5, &95
 EQUB &95, &F7, &F7, &33, &55, &B5, &B5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &87, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &E1, &5A, &2D
 EQUB &2D, &A5, &A5, &A5, &2D, &3C, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &87, &5A, &A5
 EQUB &A3, &A0, &A0, &A0, &A3, &A5, &A5, &B5
 EQUB &B3, &B1, &B1, &B1, &B3, &B5, &B5, &25
 EQUB &23, &21, &21, &21, &23, &25, &25, &A5
 EQUB &AB, &A1, &A1, &A1, &A1, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &2D, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &2D, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &2D, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &2D, &5A, &25
 EQUB &25, &25, &25, &25, &25, &25, &25, &A5
 EQUB &A1, &A1, &AD, &AF, &A5, &AD, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A7, &A5, &A1
 EQUB &A5, &AD, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A7
 EQUB &2D, &A7, &A5, &8D, &D5, &A7, &A5, &A5
 EQUB &2D, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A4
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &AD, &A5, &AF, &A5, &A7, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &AF, &A5, &A5, &A5, &A7
 EQUB &A4, &A4, &A5, &AF, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &AD, &A5, &AD, &A5, &AD, &B5
 EQUB &B5, &B5, &B5, &B5, &B5, &B5, &B5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A4, &A6, &A4, &A4, &A6, &A5, &A5, &B5
 EQUB &B5, &B5, &B5, &B5, &BD, &B5, &B5, &25
 EQUB &21, &21, &21, &21, &23, &25, &25, &A5
 EQUB &AB, &A1, &A1, &A1, &A1, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &3C, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &87, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &E1, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &2D, &5A, &25
 EQUB &25, &25, &25, &25, &25, &25, &25, &AD
 EQUB &A1, &A1, &A7, &A7, &A4, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &AD, &AF, &A1, &A5
 EQUB &A5, &A5, &A5, &A4, &A5, &AF, &A5, &A1
 EQUB &A5, &AD, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A7
 EQUB &A5, &A7, &A5, &A7, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A4
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &AD, &A5, &A1, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A4, &A5
 EQUB &A4, &A4, &A6, &A7, &A1, &AD, &A5, &AD
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &B5
 EQUB &B5, &B5, &B5, &B5, &B5, &B5, &B5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A6
 EQUB &A5, &A6, &A7, &A6, &A5, &A5, &A5, &BD
 EQUB &BD, &BD, &B5, &BD, &B5, &B5, &B5, &25
 EQUB &22, &20, &22, &20, &20, &25, &25, &A5
 EQUB &A1, &A1, &A1, &A1, &A3, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &3C, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &B4, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &B4, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &25
 EQUB &25, &25, &25, &25, &25, &25, &25, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A7
 EQUB &A4, &A5, &A5, &A5, &A5, &A5, &A5, &A1
 EQUB &AD, &A1, &A4, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &AD, &A3, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A9, &A4, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &AF, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A8, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A3, &A7
 EQUB &A5, &A7, &A5, &A7, &A5, &A7, &AE, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A0, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &AF, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A0, &AD, &A5
 EQUB &A5, &A5, &A5, &A5, &A6, &AD, &A5, &A5
 EQUB &A5, &A5, &A5, &A3, &A5, &A5, &A5, &A4
 EQUB &A5, &A6, &A9, &A5, &A5, &A5, &A5, &A7
 EQUB &AD, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &B5
 EQUB &B5, &B5, &B5, &B5, &B5, &B5, &B5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &5A, &A6
 EQUB &A5, &A6, &A5, &A6, &A5, &A5, &A7, &BD
 EQUB &BD, &BD, &BD, &BD, &B5, &B5, &B5, &25
 EQUB &25, &75, &22, &20, &25, &25, &55, &A5
 EQUB &A5, &65, &89, &A9, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &25
 EQUB &25, &25, &25, &65, &01, &33, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &96, &87, &96, &87, &96, &A5, &55, &A5
 EQUB &0F, &87, &87, &87, &1E, &A5, &55, &A5
 EQUB &87, &87, &87, &87, &0F, &A5, &55, &A5
 EQUB &4B, &E1, &E1, &E1, &E1, &A5, &55, &A5
 EQUB &4B, &2D, &69, &2D, &4B, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &B5
 EQUB &B5, &B5, &B5, &95, &F7, &33, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &55, &A7
 EQUB &A7, &A7, &A6, &A5, &A5, &A5, &55, &B5
 EQUB &BD, &BD, &BD, &BD, &B5, &B5, &55, &A5
 EQUB &E5, &A3, &DF, &7F, &F4, &A5, &AF, &C3
 EQUB &BD, &A5, &A5, &81, &AB, &A7, &89, &A5
 EQUB &A5, &A7, &A5, &A5, &A5, &E1, &BA, &B5
 EQUB &97, &AD, &AD, &81, &FA, &84, &F1, &AD
 EQUB &AD, &81, &BA, &97, &D1, &AD, &AD, &81
 EQUB &3A, &95, &D3, &AD, &AD, &81, &7A, &B5
 EQUB &C0, &AD, &AD, &89, &9A, &D1, &2D, &AD
 EQUB &AD, &89, &DA, &F1, &2D, &AD, &AD, &89
 EQUB &5A, &C0, &2D, &AD, &AD, &89, &1A, &D3
 EQUB &2D, &A9, &A9, &89, &8D, &D1, &2D, &A9
 EQUB &A9, &89, &CD, &F1, &2D, &A9, &A9, &89
 EQUB &4D, &C0, &2D, &A9, &A9, &89, &0D, &D3
 EQUB &2D, &AD, &AD, &A9, &0D, &D3, &D2, &AD
 EQUB &AD, &A9, &4D, &C0, &C3, &AD, &AD, &A9
 EQUB &8D, &D1, &D2, &AD, &AD, &A9, &CD, &F1
 EQUB &F0, &BA, &84, &A5, &A1, &BA, &97, &A5
 EQUB &AD, &BA, &95, &A5, &A9, &BA, &B5, &A5
 EQUB &B5, &BA, &81, &A1, &AD, &BA, &F4, &A1
 EQUB &B5, &BA, &C5, &A9, &B5, &BA, &D6, &AD
 EQUB &A9, &BA, &D1, &AD, &B1, &BA, &F1, &A1
 EQUB &BD, &BA, &C0, &B5, &B9, &BA, &D3, &A9
 EQUB &85, &BA, &23, &B9, &85, &BA, &22, &B1
 EQUB &85, &BA, &21, &B1, &BD, &BA, &20, &BD
 EQUB &B9, &AD, &20, &BD, &8D, &AD, &22, &B1
 EQUB &81, &AD, &22, &85, &95, &AD, &20, &B9
 EQUB &89, &AD, &D1, &81, &99, &AD, &F1, &8D
 EQUB &E5, &AD, &D3, &95, &91, &AD, &C0, &89
 EQUB &9D, &3A, &E5, &A5, &B5, &FA, &A5, &E5
 EQUB &B5, &BA, &E5, &A5, &B5, &BA, &A5, &E5
 EQUB &B5, &BA, &85, &A5, &A5, &FA, &A5, &85
 EQUB &A5, &3A, &85, &A5, &A5, &BA, &A5, &05
 EQUB &CB, &A5, &A5, &E5, &A1, &A1, &A5, &E9
 EQUB &97, &81, &A5, &A6, &C5, &CE, &0C, &D2
 EQUB &A5, &C1, &C9, &10, &D4, &C8, &CB, &14
 EQUB &D2, &A5, &C2, &17, &C7, &97, &85, &A5
 EQUB &0A, &10, &C8, &D2, &1F, &DF, &8A, &A5
 EQUB &D5, &DF, &D5, &1A, &CB, &A5, &D6, &18
 EQUB &03, &A5, &84, &A6, &0D, &D4, &CD, &C3
 EQUB &D2, &A6, &20, &D5, &A5, &0A, &C2, &0E
 EQUB &D2, &18, &06, &A5, &C7, &C1, &18, &C5
 EQUB &D3, &CA, &D2, &D3, &12, &CA, &A5, &18
 EQUB &C5, &CE, &A6, &A5, &C7, &10, &12, &05
 EQUB &A6, &A5, &D6, &C9, &1F, &A6, &A5, &0D
 EQUB &0A, &CA, &DF, &A6, &A5, &D3, &C8, &CF
 EQUB &D2, &A5, &D0, &CF, &C3, &D1, &A6, &A5
 EQUB &1C, &1D, &11, &D2, &DF, &A5, &1D, &0C
 EQUB &C5, &CE, &DF, &A5, &C0, &C3, &D3, &C2
 EQUB &06, &A5, &CB, &D3, &CA, &11, &AB, &24
 EQUB &A5, &0B, &C5, &D2, &17, &1F, &3F, &A5
 EQUB &7D, &CB, &D3, &C8, &1B, &D2, &A5, &C5
 EQUB &19, &C0, &1E, &16, &C7, &C5, &DF, &A5
 EQUB &C2, &C3, &CB, &C9, &C5, &12, &C5, &DF
 EQUB &A5, &C5, &1F, &D6, &1F, &17, &C3, &A6
 EQUB &4D, &17, &C3, &A5, &D5, &CE, &CF, &D6
 EQUB &A5, &D6, &78, &C2, &D3, &C5, &D2, &A5
 EQUB &A6, &13, &D5, &16, &A5, &CE, &D3, &CB
 EQUB &1D, &A6, &C5, &C9, &CA, &19, &CF, &06
 EQUB &A5, &CE, &DF, &D6, &16, &D5, &D6, &C7
 EQUB &03, &A6, &A5, &D5, &CE, &1F, &D2, &A6
 EQUB &4C, &27, &A5, &0B, &4D, &1D, &03, &A5
 EQUB &D6, &C9, &D6, &D3, &CA, &17, &CF, &19
 EQUB &A5, &C1, &78, &D5, &D5, &A6, &3C, &CF
 EQUB &D0, &CF, &D2, &DF, &A5, &C3, &C5, &19
 EQUB &C9, &CB, &DF, &A5, &A6, &CA, &CF, &C1
 EQUB &CE, &D2, &A6, &DF, &C3, &0C, &D5, &A5
 EQUB &1A, &C5, &CE, &A8, &07, &10, &CA, &A5
 EQUB &C5, &C7, &D5, &CE, &A5, &A6, &00, &89
 EQUB &CF, &19, &A5, &FC, &27, &87, &A5, &D2
 EQUB &0C, &05, &D2, &A6, &CA, &C9, &4D, &A5
 EQUB &EC, &A6, &CC, &C7, &CB, &CB, &1E, &A5
 EQUB &D4, &1D, &05, &A5, &D5, &D2, &A5, &36
 EQUB &A6, &C9, &C0, &A6, &A5, &D5, &C3, &89
 EQUB &A5, &A6, &C5, &0C, &C1, &C9, &80, &A5
 EQUB &C3, &1C, &CF, &D6, &A5, &C0, &C9, &C9
 EQUB &C2, &A5, &1A, &DE, &11, &CA, &0F, &A5
 EQUB &12, &0B, &C9, &C7, &C5, &11, &10, &D5
 EQUB &A5, &D5, &13, &10, &D5, &A5, &CA, &CF
 EQUB &1C, &1F, &A9, &D1, &0A, &0F, &A5, &CA
 EQUB &D3, &DE, &D3, &18, &0F, &A5, &C8, &0C
 EQUB &C5, &C9, &11, &C5, &D5, &A5, &7D, &D6
 EQUB &D3, &D2, &16, &D5, &A5, &0D, &C5, &CE
 EQUB &0A, &16, &DF, &A5, &C7, &CA, &CA, &C9
 EQUB &DF, &D5, &A5, &C0, &CF, &08, &0C, &CB
 EQUB &D5, &A5, &C0, &D3, &D4, &D5, &A5, &CB
 EQUB &0A, &16, &06, &D5, &A5, &C1, &C9, &CA
 EQUB &C2, &A5, &D6, &CA, &17, &0A, &D3, &CB
 EQUB &A5, &05, &CB, &AB, &4D, &19, &0F, &A5
 EQUB &06, &CF, &14, &A6, &F9, &D5, &A5, &8A
 EQUB &B7, &B6, &86, &B3, &86, &A5, &A6, &C5
 EQUB &D4, &A5, &CA, &0C, &05, &A5, &C0, &CF
 EQUB &16, &03, &A5, &D5, &0D, &89, &A5, &C1
 EQUB &08, &14, &A5, &D4, &1E, &A5, &DF, &C3
 EQUB &89, &C9, &D1, &A5, &C4, &CA, &D3, &C3
 EQUB &A5, &C4, &13, &C5, &CD, &A5, &90, &A5
 EQUB &D5, &CA, &CF, &CB, &DF, &A5, &C4, &D3
 EQUB &C1, &AB, &C3, &DF, &1E, &A5, &CE, &1F
 EQUB &C8, &1E, &A5, &C4, &19, &DF, &A5, &C0
 EQUB &17, &A5, &C0, &D3, &D4, &D4, &DF, &A5
 EQUB &78, &C2, &14, &D2, &A5, &C0, &78, &C1
 EQUB &A5, &CA, &CF, &02, &D4, &C2, &A5, &CA
 EQUB &C9, &C4, &4D, &16, &A5, &00, &D4, &C2
 EQUB &A5, &CE, &D3, &CB, &1D, &C9, &CF, &C2
 EQUB &A5, &C0, &C3, &CA, &0A, &C3, &A5, &0A
 EQUB &D5, &C3, &C5, &D2, &A5, &2D, &12, &0B
 EQUB &0E, &A5, &C5, &C9, &CB, &A5, &7D, &CB
 EQUB &1D, &C2, &16, &A5, &A6, &C2, &0F, &D2
 EQUB &78, &DF, &1E, &A5, &D4, &C9, &A5, &28
 EQUB &A6, &A6, &36, &8A, &A6, &3C, &A6, &A6
 EQUB &A6, &28, &A6, &20, &A6, &C0, &1F, &A6
 EQUB &D5, &C7, &07, &8A, &8C, &A5, &C0, &D4
 EQUB &19, &D2, &A5, &08, &0C, &A5, &07, &C0
 EQUB &D2, &A5, &18, &C1, &CE, &D2, &A5, &FF
 EQUB &CA, &C9, &D1, &81, &A5, &E5, &97, &7A
 EQUB &A7, &A5, &C3, &DE, &D2, &12, &A6, &A5
 EQUB &D6, &D3, &CA, &D5, &C3, &3D, &A5, &15
 EQUB &C7, &CB, &3D, &A5, &C0, &D3, &C3, &CA
 EQUB &A5, &CB, &1B, &D5, &CF, &07, &A5, &65
 EQUB &48, &A6, &C4, &C7, &DF, &A5, &C3, &A8
 EQUB &C5, &A8, &CB, &A8, &23, &A5, &E0, &E1
 EQUB &D5, &A5, &E0, &EE, &D5, &A5, &EF, &A6
 EQUB &D5, &C5, &C9, &C9, &D6, &D5, &A5, &0F
 EQUB &C5, &C7, &D6, &C3, &A6, &D6, &C9, &C2
 EQUB &A5, &FF, &C4, &C9, &CB, &C4, &A5, &FF
 EQUB &28, &A5, &C2, &C9, &C5, &CD, &0A, &C1
 EQUB &A6, &51, &A5, &FC, &A6, &3B, &A5, &CB
 EQUB &CF, &CA, &CF, &D2, &0C, &DF, &A6, &3D
 EQUB &A5, &CB, &0A, &0A, &C1, &A6, &3D, &A5
 EQUB &43, &BC, &86, &A5, &0A, &7D, &0A, &C1
 EQUB &A6, &EC, &A5, &14, &16, &C1, &DF, &A6
 EQUB &A5, &C1, &C7, &13, &C5, &11, &C5, &A5
 EQUB &F5, &A6, &C9, &C8, &A5, &C7, &89, &A5
 EQUB &83, &07, &C1, &06, &A6, &4D, &17, &0E
 EQUB &BC, &A5, &7A, &A6, &82, &8A, &8A, &8A
 EQUB &80, &99, &A6, &23, &8F, &84, &8A, &3B
 EQUB &23, &8F, &85, &8A, &C5, &19, &0B, &11
 EQUB &19, &8F, &A5, &CF, &1A, &CB, &A5, &A5
 EQUB &CA, &CA, &A5, &12, &11, &C8, &C1, &BC
 EQUB &A5, &A6, &19, &A6, &A5, &8A, &8E, &49
 EQUB &CB, &14, &D2, &BC, &80, &A5, &C5, &07
 EQUB &1D, &A5, &C9, &C0, &C0, &14, &C2, &16
 EQUB &A5, &C0, &D3, &C1, &CF, &11, &10, &A5
 EQUB &CE, &0C, &CB, &07, &D5, &D5, &A5, &CB
 EQUB &C9, &4D, &CA, &DF, &A6, &90, &A5, &2A
 EQUB &A5, &2D, &A5, &C7, &C4, &C9, &10, &A6
 EQUB &2D, &A5, &7D, &D6, &C3, &D2, &14, &D2
 EQUB &A5, &C2, &1D, &05, &78, &0E, &A5, &C2
 EQUB &C3, &C7, &C2, &CA, &DF, &A5, &AB, &AB
 EQUB &AB, &AB, &A6, &C3, &A6, &CA, &A6, &CF
 EQUB &A6, &D2, &A6, &C3, &A6, &AB, &AB, &AB
 EQUB &AB, &A5, &D6, &08, &D5, &14, &D2, &A5
 EQUB &8E, &C1, &C7, &CB, &C3, &A6, &C9, &10
 EQUB &D4, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &BC, &97, &EF, &C7, &DC, &2B, &07, &10
 EQUB &63, &70, &47, &48, &50, &5E, &5A, &5A
 EQUB &5A, &5E, &50, &48, &47, &70, &63, &10
 EQUB &07, &2B, &DC, &C7, &EF, &97, &BC, &A5
 EQUB &A4, &A6, &A1, &A0, &A3, &AD, &AC, &AF
 EQUB &AE, &A9, &A8, &AA, &B5, &B4, &B7, &B6
 EQUB &B1, &B0, &B3, &B2, &BD, &BC, &BC, &BF
 EQUB &BE, &B9, &B8, &B8, &BB, &BA, &BA, &38
 EQUB &A0, &00, &84, &70, &A9, &0F, &85, &71
 EQUB &71, &70, &C8, &D0, &FB, &C9, &CF, &EA
 EQUB &EA, &A9, &DB, &85

 EQUB &9F

 EQUB &60, &71, &61, &31, &21, &50, &40, &10
 EQUB &00, &D3, &C3, &93, &83, &44, &54, &14
 EQUB &04, &55, &45, &15, &05, &75, &65, &35
 EQUB &25, &D2, &C2, &92, &82, &0C, &BB, &20
 EQUB &2E, &28, &E1, &5B, &0C, &9C, &28, &E0
 EQUB &5B, &08, &ED, &A6, &75, &E7, &0C, &AD
 EQUB &28, &85, &5B, &1C, &B5, &B4, &28, &84
 EQUB &5B, &2D, &B5, &52, &08, &E3, &A6, &55
 EQUB &A6, &6B, &E3, &A6, &CD, &0D, &08, &E4
 EQUB &5B, &00, &59, &E5, &3D, &ED, &05, &AE
 EQUB &0C, &A7, &89, &E8, &5B, &75, &63, &F5
 EQUB &B7, &AF, &28, &85, &5B, &08, &23, &A6
 EQUB &75, &AB, &1C, &A5, &B4, &28, &84, &5B
 EQUB &2D, &B5, &52, &CD, &0D, &C9, &5B, &DA
 EQUB &05, &A2, &1C, &AD, &B4, &28, &84, &5B
 EQUB &2D, &B5, &52, &95, &4B, &9F, &95, &8B
 EQUB &E0, &8B, &EF, &E4, &E8, &E0, &F6, &EA
 EQUB &EB, &A8, &A5, &B1, &08, &EF, &FF, &ED
 EQUB &A7, &F6, &12, &A5, &A5, &A6, &4D, &E3
 EQUB &A5, &A5, &AA, &A5, &A5, &A5, &A5, &A5
 EQUB &B3, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A6, &A5, &B5
 EQUB &AA, &B4, &A5, &A6, &B9, &AB, &A5, &A5
 EQUB &AF, &A5, &B4, &9F, &A2, &AC, &AD, &A5
 EQUB &A5, &A5, &A5, &25, &0F, &A6, &05, &A5
 EQUB &0C, &A8, &85, &4B, &5A, &6D, &14, &58
 EQUB &75, &5D, &55, &5B, &C1, &FA, &C4, &D1
 EQUB &D1, &D7, &CC, &C7, &D0, &D1, &C0, &D6
 EQUB &A5, &61, &81, &CF, &E6, &C2, &C0, &D1
 EQUB &D7, &C1, &CC, &D6, &C6, &A5, &13, &99
 EQUB &63, &A5, &A5, &A5, &A5, &A5, &A5, &A2
 EQUB &9A, &A5, &A5, &A5, &A6, &BA, &5A, &5A
 EQUB &5A, &A5, &AA, &DA, &5A, &5A, &5A, &5A
 EQUB &5A, &A5, &5A, &5A, &5A, &5A, &45, &25
 EQUB &5A, &A5, &5A, &45, &A5, &5A, &A5, &A5
 EQUB &5A, &A5, &5A, &A5, &A5, &5B, &A5, &A5
 EQUB &5B, &A5, &5A, &A5, &A5, &A5, &A5, &A6
 EQUB &AA, &A5, &44, &A2, &AA, &9A, &5A, &5A
 EQUB &5A, &A5, &5A, &5A, &5A, &5A, &5A, &5A
 EQUB &5A, &A5, &5A, &5B, &59, &55, &45, &65
 EQUB &5A, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &5A, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &5A, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &26, &A5, &9A, &A5, &A5, &A5, &A5, &A5
 EQUB &5A, &A5, &5A, &AA, &AA, &AA, &AA, &BA
 EQUB &5A, &A5, &5A, &5A, &5A, &5A, &5A, &5A
 EQUB &5A, &A5, &5A, &59, &59, &59, &59, &5B
 EQUB &5A, &A5, &5A, &A5, &A5, &A5, &A5, &A5
 EQUB &5A, &A5, &22, &A5, &A5, &A5, &A5, &A5
 EQUB &45, &A5, &5A, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &5A, &DA, &DA, &9A, &BA, &AA
 EQUB &A2, &A5, &5A, &5A, &5A, &5A, &5A, &5A
 EQUB &5A, &A5, &5A, &65, &45, &5D, &59, &5B
 EQUB &5A, &A5, &45, &A5, &A5, &A5, &A5, &A5
 EQUB &25, &A5, &5A, &9A, &BA, &A2, &A4, &A5
 EQUB &A5, &A5, &5A, &5A, &5A, &5A, &5A, &DA
 EQUB &BA, &A5, &5A, &45, &5D, &5A, &5A, &5A
 EQUB &5A, &A5, &5A, &A5, &A5, &5A, &65, &55
 EQUB &5A, &A5, &59, &A5, &A5, &5A, &A5, &A5
 EQUB &5A, &A5, &A5, &A5, &A5, &25, &A5, &A5
 EQUB &5A, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &5B, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A2, &A5, &A5, &A5, &A5, &A6, &BA, &5D
 EQUB &66, &A5, &A5, &AA, &D9, &5A, &AA, &D9
 EQUB &55, &A5, &9A, &2A, &D9, &54, &2A, &9A
 EQUB &9A, &A5, &65, &2A, &D9, &55, &65, &BA
 EQUB &55, &A5, &5A, &3A, &A5, &A5, &A6, &2A
 EQUB &A2, &A5, &A4, &BA, &D9, &5D, &44, &62
 EQUB &5B, &A5, &5B, &BA, &D9, &5D, &54, &46
 EQUB &A2, &A5, &BA, &9B, &D9, &5A, &5E, &55
 EQUB &44, &A5, &59, &9B, &D9, &55, &45, &5D
 EQUB &5D, &A5, &9B, &9B, &DA, &DA, &D9, &D9
 EQUB &59, &A5, &D9, &D9, &1B, &5B, &5B, &9B
 EQUB &9A, &A5, &9A, &D9, &9B, &AA, &A5, &BA
 EQUB &A6, &A5, &45, &D9, &A5, &5D, &BA, &AA
 EQUB &5A, &A5, &DA, &5D, &9B, &BA, &2A, &62
 EQUB &A5, &A5, &26, &5D, &9B, &BA, &22, &46
 EQUB &DA, &A5, &5A, &5D, &9B, &AA, &62, &54
 EQUB &45, &A5, &6A, &A5, &A5, &5B, &45, &5D
 EQUB &DB, &A5, &5A, &BA, &A6, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &45, &D9, &BA, &A6
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &25, &55
 EQUB &DB, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A4, &A6
 EQUB &A2, &A5, &A5, &A4, &AB, &9D, &45, &66
 EQUB &22, &A5, &9D, &66, &AB, &9D, &45, &39
 EQUB &44, &A5, &D9, &1D, &A5, &A6, &A2, &9D
 EQUB &65, &A5, &D5, &D5, &45, &65, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A4, &A6, &AA, &B9
 EQUB &9C, &A5, &9A, &42, &7B, &58, &D6, &42
 EQUB &62, &A5, &A5, &A5, &DB, &6B, &24, &9C
 EQUB &44, &A5, &A5, &A5, &9A, &42, &4B, &7B
 EQUB &5D, &A5, &A5, &A5, &9A, &DA, &D5, &55
 EQUB &45, &A5, &A5, &A5, &3A, &38, &98, &98
 EQUB &9C, &A5, &A5, &A5, &62, &4B, &42, &65
 EQUB &6A, &A5, &A5, &A5, &56, &A2, &42, &D6
 EQUB &44, &A5, &A5, &A4, &54, &1C, &19, &19
 EQUB &5D, &A5, &54, &65, &44, &5D, &55, &D5
 EQUB &DD, &A5, &65, &45, &59, &D5, &9D, &99
 EQUB &AA, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &25, &A5, &D5, &D9, &AB, &A2, &A6, &A4
 EQUB &A6, &A5, &D9, &D2, &98, &A2, &25, &45
 EQUB &59, &A5, &DB, &1E, &7B, &56, &9C, &99
 EQUB &D9, &A5, &AB, &22, &46, &56, &7B, &52
 EQUB &BA, &A5, &A5, &25, &45, &5D, &5A, &26
 EQUB &25, &A5, &A5, &A5, &A5, &A5, &A5, &25
 EQUB &45, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &25, &25, &25, &25, &65, &01
 EQUB &33, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &96, &87, &96, &87, &96
 EQUB &A5, &55, &A5, &0F, &87, &87, &87, &1E
 EQUB &A5, &55, &A5, &87, &87, &87, &87, &0F
 EQUB &A5, &55, &A5, &4B, &E1, &E1, &E1, &E1
 EQUB &A5, &55, &A5, &4B, &2D, &69, &2D, &4B
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5, &A5
 EQUB &A5, &55, &A5, &A5, &A5, &A5, &A5

\ ******************************************************************************
\
\ Save output/ELITE4.bin
\
\ ******************************************************************************

PRINT "S.ELITE4 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/ELITE4.bin", CODE%, P%, LOAD%


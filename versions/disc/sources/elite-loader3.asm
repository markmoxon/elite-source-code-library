\ ******************************************************************************
\
\ DISC ELITE LOADER (PART 3) SOURCE
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
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
\   * output/ELITE4.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

NETV = &224             \ The NETV vector that we intercept as part of the copy
                        \ protection

IRQ1V = &204            \ The IRQ1V vector that we intercept to implement the
                        \ split-sceen mode

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI vector

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

N% = 67                 \ N% is set to the number of bytes in the VDU table, so
                        \ we can loop through them below

VSCAN = 57              \ Defines the split position in the split-screen mode

POW = 15                \ Pulse laser power

Mlas = 50               \ Mining laser power

Armlas = INT(128.5+1.5*POW) \ Military laser power

DL = &8B
LASCT = &0346
HFX = &0348
ESCP = &0386

VEC = &7FFE             \ VEC is where we store the original value of the IRQ1
                        \ vector, and it matches the value in elite-source.asm

ZP = &70                \ Temporary storage, used all over the place

P = &72                 \ Temporary storage, used all over the place

Q = &73                 \ Temporary storage, used all over the place

YY = &74                \ Temporary storage, used when drawing Saturn

T = &75                 \ Temporary storage, used all over the place

SC = &76                \ Used to store the screen address while plotting pixels

BLPTR = &78             \ Gets set as part of the obfuscation code

CODE% = &1900           \ The address where this file (the third loader) loads
LOAD% = &1900

ORG CODE%

INCLUDE "library/common/loader/variable/b_per_cent.asm"
INCLUDE "library/common/loader/variable/e_per_cent.asm"
INCLUDE "library/common/loader/macro/fne.asm"

\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ENTRY

 JSR PROT1              \ ???? Copy protection

 LDA #144               \ Call OSBYTE with A = 144 and Y = 255 to turn the
 LDX #255               \ screen interlace off (equivalent to a *TV 255, 255
 JSR OSB                \ command)

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

 LDA #16                \ Call OSBYTE with A = 16 and X = 3 to set the ADC to
 LDX #3                 \ sample 3 channels from the joystick/Bitstik
 JSR OSBYTE

 LDA #&60               \ Store an RTS instruction in location &232
 STA &232

 LDA #&2                \ Point the NETV vector to &232, which we just filled
 STA NETV+1             \ with an RTS
 LDA #&32
 STA NETV

 LDA #190               \ Call OSBYTE with A = 190, X = 8 and Y = 0 to set the
 LDX #8                 \ ADC conversion type to 8 bits, for the joystick
 JSR OSB

 LDA #200               \ Call OSBYTE with A = 200, X = 0 and Y = 0 to enable
 LDX #0                 \ the ESCAPE key and disable memory clearing if the
 JSR OSB                \ BREAK key is pressed

 LDA #13                \ Call OSBYTE with A = 13, X = 0 and Y = 0 to disable
 LDX #0                 \ the "output buffer empty" event
 JSR OSB

 LDA #225               \ Call OSBYTE with A = 225, X = 128 and Y = 0 to set
 LDX #128               \ the function keys to return ASCII codes for SHIFT-fn
 JSR OSB                \ keys (i.e. add 128)

 LDA #12                \ Set A = 12 and  X = 0 to pretend that this is an to
 LDX #0                 \ innocent call to OSBYTE to reset the keyboard delay
                        \ and auto-repeat rate to the default, when in reality
                        \ the OSB address in the next instruction gets modified
                        \ to point to OSBmod

.OSBjsr

 JSR OSB                \ This JSR gets modified by code inserted into PLL1 so
                        \ that it points to OSBmod instead of OSB, so this
                        \ actually calls OSBmod to calculate some checksums

 LDA #13                \ Call OSBYTE with A = 13, X = 2 and Y = 0 to disable
 LDX #2                 \ the "character entering buffer" event
 JSR OSB

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 LDX #1                 \ cursor editing, so the cursor keys return ASCII values
 JSR OSB                \ and can therefore be used in-game

 LDA #9                 \ Call OSBYTE with A = 9, X = 0 and Y = 0 to disable
 LDX #0                 \ flashing colours
 JSR OSB

 JSR PROT5              \ ???? Copy protection

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&11               \   ZP(1 0) = &1100
 STA ZP+1               \   P(1 0) = BEGIN
 LDA #LO(BEGIN)
 STA P
 LDA #HI(BEGIN)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ BEGIN to &1100-&11FF

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&78               \   ZP(1 0) = &7800
 STA ZP+1               \   P(1 0) = DIALS
 LDA #LO(DIALS)         \   X = 8
 STA P
 LDA #HI(DIALS)
 STA P+1
 LDX #8

 JSR MVBL               \ Call MVBL to move and decrypt 8 pages of memory from
                        \ DIALS to &7800-&7FFF

 SEI                    \ Disable interrupts while we set up our interrupt
                        \ handler to support the split-screen mode

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA &0001              \ counter (SHEILA &44), which increments 1000 times a
                        \ second so this will be pretty random, and store it in
                        \ &0001 among the random number seeds at &0000

 LDA #%00111001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bits 0 and 3-5 (i.e. disable the Timer1,
                        \ CB1, CB2 and CA2 interrupts from the System VIA)

 LDA #%01111111         \ Set 6522 User VIA interrupt enable register IER
 STA VIA+&6E            \ (SHEILA &6E) bits 0-7 (i.e. disable all hardware
                        \ interrupts from the User VIA)

 LDA IRQ1V              \ Copy the current IRQ1V vector address into VEC(1 0)
 STA VEC
 LDA IRQ1V+1
 STA VEC+1

 LDA #LO(IRQ1)          \ Set the IRQ1V vector to IRQ1, so IRQ1 is now the
 STA IRQ1V              \ interrupt handler
 LDA #HI(IRQ1)
 STA IRQ1V+1

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

 CLI                    \ Re-enable interrupts

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&61               \   ZP(1 0) = &6100
 STA ZP+1               \   P(1 0) = ASOFT
 LDA #LO(ASOFT)
 STA P
 LDA #HI(ASOFT)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ ASOFT to &6100-&61FF

 LDA #&63               \ Set the following:
 STA ZP+1               \
 LDA #LO(ELITE)         \   ZP(1 0) = &6300
 STA P                  \   P(1 0) = ELITE
 LDA #HI(ELITE)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ ELITE to &6300-&63FF

 LDA #&76               \ Set the following:
 STA ZP+1               \
 LDA #LO(CpASOFT)       \   ZP(1 0) = &7600
 STA P                  \   P(1 0) = CpASOFT
 LDA #HI(CpASOFT)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ CpASOFT to &7600-&76FF

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&04               \   ZP(1 0) = &0400
 STA ZP+1               \   P(1 0) = WORDS
 LDA #LO(WORDS)         \   X = 4
 STA P
 LDA #HI(WORDS)
 STA P+1
 LDX #4

 JSR MVBL               \ Call MVBL to move and decrypt 4 pages of memory from
                        \ WORDS to &0400-&07FF

 LDX #35                \ We now want to copy the disc catalogue routine from
                        \ CATDISC to CATD, so set a counter in X for the 36
                        \ bytes to copy

.LOOP2

 LDA CATDISC,X          \ Copy the X-th byte of CATDISC to the X-th byte of CATD
 STA CATD,X

 DEX                    \ Decrement the loop counter

 BPL LOOP2              \ Loop back to copy the next byte until they are all
                        \ done

 LDA SC                 \ ????
 STA CATBLOCK

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("DIR E")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which
                        \ changes the disc directory to E

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&0B               \   ZP(1 0) = &0B00
 STA ZP+1               \   P(1 0) = &1AED LOD2
 LDA #LO(LOD2)
 STA P
 LDA #HI(LOD2)
 STA P+1

 LDY #0                 \ We want to move one page of memory, so set Y as a byte
                        \ counter

.LOOP3

 LDA (P),Y              \ Fetch the Y-th byte of the P(1 0) memory block

 EOR #&18               \ Decrypt it by EOR'ing with &18

 STA (ZP),Y             \ Store the decrypted result in the Y-th byte of the
                        \ ZP(1 0) memory block

 DEY                    \ Decrement the byte counter

 BNE LOOP3              \ Loop back to copy the next byte until we have done a
                        \ whole page of 256 bytes

 JMP &0B00              \ Jump to the start of the routine we just decrypted

\ ******************************************************************************
\
\       Name: PROT2
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.PROT2

 CLC
 LDY #0

.PROT2a

 ADC PLL1,Y
 EOR ENTRY,Y
 DEY
 BNE PROT2a

 RTS

\ ******************************************************************************
\
\       Name: 
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.LOD2

IF FALSE

ORG &0B00

\ This block (LOD2 &1AED to &1B4E) needs EOR'ing with &18 by elite-checksum.py

\ code block, org &0B00, eor'd with &18, gets copied to &0B00 by above, called
\ at end of this loader

.LOADER2

 LDX #&37
 LDY #&0B
 JSR &FFF7
 LDA #&EE
 STA &0202
 LDA #&11
 STA &0203
 LDA #&E9
 STA &020E
 LDA #&11
 STA &020F
 SEC
 LDY #&00
 STY &70
 LDX #&11
 TXA

.l1

 STX &71
 ADC (&70),Y
 DEY
 BNE l1
 INX
 CPX #&54
 BCC l1
 CMP &55FF

.l2

 BNE l2
 JMP &11E6

.L0B37

 EQUB &4C, &2E, &54
 EQUB &2E, &43, &4F
 EQUB &44
 EQUB &45, &0D
 EQUB &44
 EQUB &6F
 EQUB &65, &73
 EQUB &20, &79, &6F
 EQUB &75, &72
 EQUB &20, &6D, &6F
 EQUB &74
 EQUB &68
 EQUB &65, &72
 EQUB &20, &6B, &6E
 EQUB &6F
 EQUB &77
 EQUB &20, &79, &6F
 EQUB &75, &20
 EQUB &64
 EQUB &6F
 EQUB &20, &74, &68
 EQUB &69, &73
 EQUB &3F

COPYBLOCK LOADER2, P%, LOD2

ORG LOD2 + P% - LOADER2

\ Used to generate the above disassembly

\ EQUB &BA EOR &18, &2F EOR &18, &B8 EOR &18, &13 EOR &18, &38 EOR &18, &EF EOR &18, &E7 EOR &18, &B1 EOR &18
\ EQUB &F6 EOR &18, &95 EOR &18
\ EQUB &1A EOR &18, &1A EOR &18, &B1 EOR &18, &09 EOR &18, &95 EOR &18, &1B EOR &18, &1A EOR &18, &B1 EOR &18
\ EQUB &F1 EOR &18, &95 EOR &18, &16 EOR &18, &1A EOR &18, &B1 EOR &18, &09 EOR &18, &95 EOR &18, &17 EOR &18
\ EQUB &1A EOR &18, &20 EOR &18, &B8 EOR &18, &18 EOR &18, &9C EOR &18, &68 EOR &18, &BA EOR &18, &09 EOR &18
\ EQUB &92 EOR &18, &9E EOR &18, &69 EOR &18, &69 EOR &18, &68 EOR &18, &90 EOR &18, &C8 EOR &18, &E1 EOR &18
\ EQUB &F0 EOR &18, &F8 EOR &18, &4C EOR &18, &88 EOR &18, &EC EOR &18, &D5 EOR &18, &E7 EOR &18, &4D EOR &18
\ EQUB &C8 EOR &18, &E6 EOR &18, &54 EOR &18, &FE EOR &18, &09 EOR &18, &54 EOR &18, &36 EOR &18, &4C EOR &18
\ EQUB &36 EOR &18, &5B EOR &18, &57 EOR &18, &5C EOR &18, &5D EOR &18, &15 EOR &18, &5C EOR &18, &77 EOR &18
\ EQUB &7D EOR &18, &6B EOR &18, &38 EOR &18, &61 EOR &18, &77 EOR &18, &6D EOR &18, &6A EOR &18, &38 EOR &18
\ EQUB &75 EOR &18, &77 EOR &18, &6C EOR &18, &70 EOR &18, &7D EOR &18, &6A EOR &18, &38 EOR &18, &73 EOR &18
\ EQUB &76 EOR &18, &77 EOR &18, &6F EOR &18, &38 EOR &18, &61 EOR &18, &77 EOR &18, &6D EOR &18, &38 EOR &18
\ EQUB &7C EOR &18, &77 EOR &18, &38 EOR &18, &6C EOR &18, &70 EOR &18, &71 EOR &18, &6B EOR &18, &27 EOR &18

ELSE

\ Original bytes from the binary

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

ENDIF

\ ******************************************************************************
\
\       Name: CATDISC
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Load disc sectors 0 and 1 to &0E00 and &0F00 respectively
\
\ ******************************************************************************

\ Gets copied from &1B4F to &0D7A by loop at L1A89 (35 bytes),
\ is called by D and T to load from disc

.CATDISC

ORG &0D7A

.CATD

 DEC CATBLOCK+8         \ Decrement sector number from 1 to 0
 DEC CATBLOCK+2         \ Decrement load address from &0F00 to &0E00

 JSR CATL               \ Call CATL to load disc sector 1 to &0E00

 INC CATBLOCK+8         \ Increment sector number back to 1
 INC CATBLOCK+2         \ Increment load address back to &0F00

.CATL

 LDA #127               \ Call OSWORD with A = 127 and (Y X) = CATBLOCK to
 LDX #LO(CATBLOCK)      \ load disc sector 1 to &0F00
 LDY #HI(CATBLOCK)
 JMP OSWORD

.CATBLOCK

 EQUB 0                 \ 0 = Drive = 0
 EQUD &00000F00         \ 1 = Data address = &0F00
 EQUB 3                 \ 5 = Number of parameters = 3
 EQUB &53               \ 6 = Command = &53 (read data)
 EQUB 0                 \ 7 = Track = 0
 EQUB 1                 \ 8 = Sector = 1
 EQUB %00100001         \ 9 = Load 1 sector of 256 bytes
 EQUB 0

COPYBLOCK CATD, P%, CATDISC

ORG CATDISC + P% - CATD

\ ******************************************************************************
\
\       Name: PROT1
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.PROT1

 LDA #&55
 LDX #&40

.PROT1a

 JSR PROT2

 DEX
 BPL PROT1a

 STA RAND+2
 ORA #&00
 BPL PROT1b

 LSR BLPTR

.PROT1b

 JMP PROT4

 EQUB &AC

INCLUDE "library/common/loader/subroutine/pll1.asm"
INCLUDE "library/common/loader/subroutine/dornd.asm"
INCLUDE "library/6502sp/loader1/variable/rand.asm"
INCLUDE "library/common/loader/subroutine/squa2.asm"
INCLUDE "library/common/loader/subroutine/pix.asm"
INCLUDE "library/common/loader/variable/twos.asm"

\ ******************************************************************************
\
\       Name: PROT4
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.PROT4

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

\ ******************************************************************************
\
\       Name: PROT5
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.PROT5

 LDA BLPTR
 AND BLPTR+1
 ORA #&0C
 ASL A
 STA BLPTR
 RTS

\ ******************************************************************************
\
\       Name: PROT6
\       Type: Subroutine
\   Category: Copy protection
\    Summary: 
\
\ ******************************************************************************

.PROT6

 JMP PROT6

INCLUDE "library/common/loader/subroutine/root.asm"
INCLUDE "library/common/loader/subroutine/osb.asm"

 EQUB &0E               \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: MVPG
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Decrypt and move a page of memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   P(1 0)              The source address of the page to move
\
\   ZP(1 0)             The destination address of the page to move
\
\ ******************************************************************************

.MVPG

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

 EQUB &0E               \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: MVBL
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Decrypt and move a multi-page block of memory
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

\ ******************************************************************************
\
\       Name: MESS1
\       Type: Variable
\   Category: Loader
\    Summary: The OS command string for changing the disc directory to E
\
\ ******************************************************************************

.MESS1

 EQUS "*DIR E"
 EQUB 13

\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for recursive tokens, Missile blueprint and
\             images
\
\ ******************************************************************************

.DIALS

\ &1D4B-&254A to &7800-&7FFF
\ INCBIN "binaries/P.DIALS.bin" \ &7800
\ INCBIN "output/MISSILE.bin" \ &7F00, or inline it as this is the loader
\ EOR with &A5

 EQUB &55, &25, &22, &21, &22, &21
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
 EQUB &CB, &A5, &A5, &E5, &A1, &A1, &A5

.WORDS

\ &254B-&294A to &0400-&07FF
\ INCBIN "output/WORDS.bin"
\ EOR with &A5

 EQUB &E9
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
 EQUB &BE, &B9, &B8, &B8, &BB, &BA, &BA

\ ******************************************************************************
\
\       Name: OSBmod
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

\ &294B, JSR OSB above gets modified to jump here, so disassemble

.OSBmod

IF FALSE

 SEC
 LDY #0
 STY &70
 LDA #$0F
 STA &71

.L2954

 ADC (&70),Y
 INY
 BNE L2954

 CMP #&CF

 NOP
 NOP

 LDA #219               \ Store 219 in location &9F. This gets checked by the
 STA &9F                \ TITLE routine in the main docked code as part of the
                        \ copy protection (the game hangs if it doesn't match)

 RTS

ELSE

 EQUB &38
 EQUB &A0, &00, &84, &70, &A9, &0F, &85, &71
 EQUB &71, &70, &C8, &D0, &FB, &C9, &CF, &EA
 EQUB &EA, &A9, &DB, &85, &9F, &60

ENDIF

\ ******************************************************************************
\
\       Name: BEGIN
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.BEGIN

IF FALSE

\ &2962-&2A61 to &1100-&11FF
\ IRQ1 etc. - this is code
\ Need to EOR this, commander file and BRBR1 with &A5 in elite-checksum.py

ORG &1100

INCLUDE "library/cassette/main/variable/tvt1.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"
INCLUDE "library/6502sp/main/variable/s1_per_cent.asm"
INCLUDE "library/common/main/variable/na_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"
\INCLUDE "library/6502sp/main/subroutine/brbr.asm"

\ ******************************************************************************
\
\       Name: BRBR1
\       Type: Subroutine
\   Category: Loader
\    Summary: Break handler: prints newline, error and hangs
\
\ ******************************************************************************

.BRBR1

 LDY #0

 LDA #13

.BRBRLOOP

 JSR OSWRCH
 INY
 LDA (&FD),Y
 BNE BRBRLOOP

.BRBR1a

 BEQ BRBR1a

COPYBLOCK TVT1, P%, BEGIN

ORG BEGIN + P% - TVT1

ELIF FALSE

ORG &1100

\ Palette data, change var names to TVT1 etc

.BEG

 EQUB &D4
 EQUB &C4, &94
 EQUB &84, &F5
 EQUB &E5, &B5
 EQUB &A5

.BEG2

 EQUB &76
 EQUB &66, &36
 EQUB &26, &E1
 EQUB &F1, &B1
 EQUB &A1

.BEG3

 EQUB &F0
 EQUB &E0, &B0
 EQUB &A0, &D0
 EQUB &C0, &90
 EQUB &80
 EQUB &77
 EQUB &67
 EQUB &37
 EQUB &27

.top

 LDA #30
 STA &8B
 STA VIA+&44
 LDA #&39
 STA VIA+&45
 LDA &0348
 BNE l1
 LDA #&08
 STA VIA+&20

.l2

 LDA BEG3,Y
 STA VIA+&21
 DEY
 BPL l2

 LDA &0346
 BEQ l3
 DEC &0346

.l3

 PLA
 TAY
 LDA &FE41
 LDA &FC
 RTI

.IRQ1

 TYA
 PHA
 LDY #&0B
 LDA #&02
 BIT &FE4D
 BNE top

 BVC l4
 ASL A
 STA VIA+&20
 LDA &0386
 BNE l1

.l6

 LDA BEG,Y
 STA VIA+&21
 DEY
 BPL l6

.l4

 PLA
 TAY
 JMP (&7FFE)

.l1

 LDY #&07

.l5

 LDA BEG2,Y
 STA VIA+&21
 DEY
 BPL l5
 BMI l4

\ Commander file

.S1%

 EQUB &3A
 EQUB &30, &2E
 EQUB &45, &2E

.NA%

 EQUB &4A
 EQUB &41, &4D
 EQUB &45, &53
 EQUB &4F
 EQUB &4E, &0D

 EQUB &00
 EQUB &14
 EQUB &AD, &4A, &5A
 EQUB &48
 EQUB &02
 EQUB &53
 EQUB &B7
 EQUB &00
 EQUB &00
 EQUB &03
 EQUB &E8
 EQUB &46, &00
 EQUB &00
 EQUB &0F
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &16, &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &03
 EQUB &00
 EQUB &10, &0F
 EQUB &11, &00
 EQUB &03
 EQUB &1C
 EQUB &0E, &00, &00
 EQUB &0A
 EQUB &00
 EQUB &11, &3A
 EQUB &07
 EQUB &09, &08
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &00
 EQUB &80

.CHK2

 EQUB &AA

.CHK

 EQUB &03

\ ******************************************************************************
\
\       Name: BRBR1
\       Type: Subroutine
\   Category: Loader
\    Summary: Break handler: prints newline, error and hangs
\
\ ******************************************************************************

.BRBR1

\DISASSEMBLE 11D5, EOR along with above

IF FALSE

 LDY #0

 LDA #13

.BRBRLOOP

 JSR OSWRCH
 INY
 LDA (&FD),Y
 BNE BRBRLOOP

.BRBR1a

 BEQ BRBR1a

ELSE

 EQUB &A0, &00
 EQUB &A9, &0D
 EQUB &20, &EE, &FF
 EQUB &C8
 EQUB &B1, &FD
 EQUB &D0, &F8
 EQUB &F0, &FE
 
ENDIF

 EQUB &64
 EQUB &5F
 EQUB &61, &74
 EQUB &74
 EQUB &72
 EQUB &69, &62
 EQUB &75, &74
 EQUB &65, &73
 EQUB &00
 EQUB &C4, &24
 EQUB &6A
 EQUB &43
 EQUB &67
 EQUB &65, &74
 EQUB &72
 EQUB &64
 EQUB &69, &73
 EQUB &63
 EQUB &00
 EQUB &B6, &3C
 EQUB &C6

\ END EORing in checksum.py

COPYBLOCK BEG, P%, BEGIN

ORG BEGIN + P% - BEG

ELIF FALSE

ORG &1100

.BEG

 EQUB &71 EOR &A5, &61 EOR &A5, &31 EOR &A5, &21 EOR &A5, &50 EOR &A5, &40 EOR &A5, &10 EOR &A5
 EQUB &00 EOR &A5, &D3 EOR &A5, &C3 EOR &A5, &93 EOR &A5, &83 EOR &A5, &44 EOR &A5, &54 EOR &A5, &14 EOR &A5
 EQUB &04 EOR &A5, &55 EOR &A5, &45 EOR &A5, &15 EOR &A5, &05 EOR &A5, &75 EOR &A5, &65 EOR &A5, &35 EOR &A5
 EQUB &25 EOR &A5, &D2 EOR &A5, &C2 EOR &A5, &92 EOR &A5, &82 EOR &A5, &0C EOR &A5, &BB EOR &A5, &20 EOR &A5
 EQUB &2E EOR &A5, &28 EOR &A5, &E1 EOR &A5, &5B EOR &A5, &0C EOR &A5, &9C EOR &A5, &28 EOR &A5, &E0 EOR &A5
 EQUB &5B EOR &A5, &08 EOR &A5, &ED EOR &A5, &A6 EOR &A5, &75 EOR &A5, &E7 EOR &A5, &0C EOR &A5, &AD EOR &A5
 EQUB &28 EOR &A5, &85 EOR &A5, &5B EOR &A5, &1C EOR &A5, &B5 EOR &A5, &B4 EOR &A5, &28 EOR &A5, &84 EOR &A5
 EQUB &5B EOR &A5, &2D EOR &A5, &B5 EOR &A5, &52 EOR &A5, &08 EOR &A5, &E3 EOR &A5, &A6 EOR &A5, &55 EOR &A5
 EQUB &A6 EOR &A5, &6B EOR &A5, &E3 EOR &A5, &A6 EOR &A5, &CD EOR &A5, &0D EOR &A5, &08 EOR &A5, &E4 EOR &A5
 EQUB &5B EOR &A5, &00 EOR &A5, &59 EOR &A5, &E5 EOR &A5, &3D EOR &A5, &ED EOR &A5, &05 EOR &A5, &AE EOR &A5
 EQUB &0C EOR &A5, &A7 EOR &A5, &89 EOR &A5, &E8 EOR &A5, &5B EOR &A5, &75 EOR &A5, &63 EOR &A5, &F5 EOR &A5
 EQUB &B7 EOR &A5, &AF EOR &A5, &28 EOR &A5, &85 EOR &A5, &5B EOR &A5, &08 EOR &A5, &23 EOR &A5, &A6 EOR &A5
 EQUB &75 EOR &A5, &AB EOR &A5, &1C EOR &A5, &A5 EOR &A5, &B4 EOR &A5, &28 EOR &A5, &84 EOR &A5, &5B EOR &A5
 EQUB &2D EOR &A5, &B5 EOR &A5, &52 EOR &A5, &CD EOR &A5, &0D EOR &A5, &C9 EOR &A5, &5B EOR &A5, &DA EOR &A5
 EQUB &05 EOR &A5, &A2 EOR &A5, &1C EOR &A5, &AD EOR &A5, &B4 EOR &A5, &28 EOR &A5, &84 EOR &A5, &5B EOR &A5
 EQUB &2D EOR &A5, &B5 EOR &A5, &52 EOR &A5, &95 EOR &A5, &4B EOR &A5, &9F EOR &A5, &95 EOR &A5, &8B EOR &A5
 EQUB &E0 EOR &A5, &8B EOR &A5, &EF EOR &A5, &E4 EOR &A5, &E8 EOR &A5, &E0 EOR &A5, &F6 EOR &A5, &EA EOR &A5
 EQUB &EB EOR &A5, &A8 EOR &A5, &A5 EOR &A5, &B1 EOR &A5, &08 EOR &A5, &EF EOR &A5, &FF EOR &A5, &ED EOR &A5
 EQUB &A7 EOR &A5, &F6 EOR &A5, &12 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A6 EOR &A5, &4D EOR &A5, &E3 EOR &A5
 EQUB &A5 EOR &A5, &A5 EOR &A5, &AA EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5
 EQUB &B3 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5
 EQUB &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5
 EQUB &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5
 EQUB &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &A6 EOR &A5, &A5 EOR &A5, &B5 EOR &A5
 EQUB &AA EOR &A5, &B4 EOR &A5, &A5 EOR &A5, &A6 EOR &A5, &B9 EOR &A5, &AB EOR &A5, &A5 EOR &A5, &A5 EOR &A5
 EQUB &AF EOR &A5, &A5 EOR &A5, &B4 EOR &A5, &9F EOR &A5, &A2 EOR &A5, &AC EOR &A5, &AD EOR &A5, &A5 EOR &A5
 EQUB &A5 EOR &A5, &A5 EOR &A5, &A5 EOR &A5, &25 EOR &A5, &0F EOR &A5, &A6 EOR &A5, &05 EOR &A5, &A5 EOR &A5
 EQUB &0C EOR &A5, &A8 EOR &A5, &85 EOR &A5, &4B EOR &A5, &5A EOR &A5, &6D EOR &A5, &14 EOR &A5, &58 EOR &A5
 EQUB &75 EOR &A5, &5D EOR &A5, &55 EOR &A5, &5B EOR &A5, &C1 EOR &A5, &FA EOR &A5, &C4 EOR &A5, &D1 EOR &A5
 EQUB &D1 EOR &A5, &D7 EOR &A5, &CC EOR &A5, &C7 EOR &A5, &D0 EOR &A5, &D1 EOR &A5, &C0 EOR &A5, &D6 EOR &A5
 EQUB &A5 EOR &A5, &61 EOR &A5, &81 EOR &A5, &CF EOR &A5, &E6 EOR &A5, &C2 EOR &A5, &C0 EOR &A5, &D1 EOR &A5
 EQUB &D7 EOR &A5, &C1 EOR &A5, &CC EOR &A5, &D6 EOR &A5, &C6 EOR &A5, &A5 EOR &A5, &13 EOR &A5, &99 EOR &A5
 EQUB &63 EOR &A5

COPYBLOCK BEG, P%, BEGIN

ORG BEGIN + P% - BEG

ELSE

IRQ1 = &114B

 EQUB &71, &61, &31, &21, &50, &40, &10
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
 EQUB &63

ENDIF

\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ELITE

\ &2A62-&2B61 to &6300-&63FF
\ INCBIN "binaries/P.ELITE.bin"
\ EOR with &A5

 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A2
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
 EQUB &A5

.ASOFT

\ &2B62-&2C61 to &6100-&61FF
\ INCBIN "binaries/P.A-SOFT.bin"
\ EOR with &A5

 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5
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
 EQUB &A5

.CpASOFT

\ &2C62-&2D61 to &7600-&76FF
\ INCBIN "binaries/P.(C)ASFT.bin"
\ EOR with &A5

 EQUB &A5, &A5, &A5, &A5, &A5, &A5, &A5
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


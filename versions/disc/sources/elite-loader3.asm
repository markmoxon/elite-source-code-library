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
 STA ZP+1               \   P(1 0) = COMMON
 LDA #LO(COMMON)
 STA P
 LDA #HI(COMMON)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ COMMON to &1100-&11FF

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
\ This block (LOD2 &1AED to &1B4E) needs EOR'ing with &18 by elite-checksum.py
\
\ code block, org &0B00, eor'd with &18, gets copied to &0B00 by above, called
\ at end of this loader
\
\ ******************************************************************************

.LOD2

ORG &0B00

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
 INCBIN "versions/disc/binaries/P.DIALS.bin" \ &7800
\ INCBIN "output/MISSILE.bin" \ &7F00, or inline it as this is the loader
\ EOR with &A5

INCLUDE "library/common/main/macro/vertex.asm"
INCLUDE "library/common/main/macro/edge.asm"
INCLUDE "library/common/main/macro/face.asm"
INCLUDE "library/common/main/variable/ship_missile.asm"

EQUB &04, &00

.WORDS

\ &254B-&294A to &0400-&07FF
\ INCBIN "versions/disc/output/WORDS.bin"
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
\       Name: COMMON
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ &2962-&2A61 to &1100-&11FF
\ IRQ1 etc. - this is code
\ Need to EOR this, commander file and BRBR1 with &A5 in elite-checksum.py
\
\ ******************************************************************************

.COMMON

ORG &1100

INCLUDE "library/cassette/main/variable/tvt1.asm"
INCLUDE "library/common/main/subroutine/irq1.asm"
INCLUDE "library/6502sp/main/variable/s1_per_cent.asm"
INCLUDE "library/common/main/variable/na_per_cent.asm"
INCLUDE "library/common/main/variable/chk2.asm"
INCLUDE "library/common/main/variable/chk.asm"

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

 EQUB &64, &5F, &61
 EQUB &74, &74, &72
 EQUB &69, &62, &75
 EQUB &74, &65, &73
 EQUB &00, &C4, &24
 EQUB &6A, &43, &67
 EQUB &65, &74, &72
 EQUB &64, &69, &73
 EQUB &63, &00, &B6
 EQUB &3C, &C6

COPYBLOCK TVT1, P%, COMMON

ORG COMMON + P% - TVT1

\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ELITE

 INCBIN "versions/disc/binaries/P.ELITE.bin"

.ASOFT

 INCBIN "versions/disc/binaries/P.A-SOFT.bin"

.CpASOFT

 INCBIN "versions/disc/binaries/P.(C)ASFT.bin"

\ Is the following EOR'd with &A5 too? Looks like it

 EQUB &55, &A5, &A5, &A5, &A5, &A5, &A5
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
\ Save output/ELITE4.unprot.bin
\
\ ******************************************************************************

PRINT "S.ELITE4 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/ELITE4.unprot.bin", CODE%, P%, LOAD%


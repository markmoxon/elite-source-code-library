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
_IB_DISC                = (_RELEASE = 1)
_STH_DISC               = (_RELEASE = 2)

Q% = _REMOVE_CHECKSUMS  \ Set Q% to TRUE to max out the default commander, FALSE
                        \ for the standard default commander (this is set to
                        \ TRUE if checksums are disabled, just for convenience)

NETV = &224             \ The NETV vector that we intercept as part of the copy
                        \ protection

BRKV = &202             \ The break vector that we intercept to enable us to
                        \ handle and display system errors

IRQ1V = &204            \ The IRQ1V vector that we intercept to implement the
                        \ split-sceen mode

WRCHV = &20E            \ The WRCHV vector that we intercept with our custom
                        \ text printing routine

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

VEC = &7FFE             \ VEC is where we store the original value of the IRQ1
                        \ vector, matching the address in the elite-missile.asm
                        \ source

ZP = &70                \ Temporary storage, used all over the place

P = &72                 \ Temporary storage, used all over the place

Q = &73                 \ Temporary storage, used all over the place

YY = &74                \ Temporary storage, used when drawing Saturn

T = &75                 \ Temporary storage, used all over the place

SC = &76                \ Used to store the screen address while plotting pixels

CHKSM = &78             \ Used in the copy protection code

DL = &8B                \ The vertical sync flag, matching the address in the
                        \ main game code

LASCT = &0346           \ The laser pulse count for the current laser, matching
                        \ the address in the main game code

HFX = &0348             \ A flag that toggles the hyperspace colour effect,
                        \ matching the address in the main game code

ESCP = &0386            \ The flag that determines whether we have an escape pod
                        \ fitted, matching the address in the main game code

S% = &11E3              \ The adress of the main entry point workspace in the
                        \ main game code

CODE% = &1900
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
\    Summary: Set up the split screen mode, move code around, set up the sound
\             envelopes and configure the system
\
\ ******************************************************************************

.ENTRY

 JSR PROT1              \ Call PROT1 to calculate checksums into CHKSM

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

.loop1

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE loop1              \ all (the number of bytes was set in N% above)

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

 JSR PROT5              \ Call PROT5 to do various copy protection checks

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&11               \   ZP(1 0) = &1100
 STA ZP+1               \   P(1 0) = TVT1code
 LDA #LO(TVT1code)
 STA P
 LDA #HI(TVT1code)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ TVT1code to &1100-&11FF

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
                        \ CATDcode to CATD, so set a counter in X for the 36
                        \ bytes to copy

.loop2

 LDA CATDcode,X         \ Copy the X-th byte of CATDcode to the X-th byte of
 STA CATD,X             \ CATD

 DEX                    \ Decrement the loop counter

 BPL loop2              \ Loop back to copy the next byte until they are all
                        \ done

 LDA SC                 \ Set the drive number in the CATD routine to SC, which
 STA CATBLOCK           \ gets set in ELITE3

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("DIR E")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which
                        \ changes the disc directory to E

 LDA #LO(LOAD)          \ Set the following:
 STA ZP                 \
 LDA #HI(LOAD)          \   ZP(1 0) = LOAD
 STA ZP+1               \   P(1 0) = LOADcode
 LDA #LO(LOADcode)
 STA P
 LDA #HI(LOADcode)
 STA P+1

 LDY #0                 \ We now want to move and decrypt one page of memory
                        \ from LOADcode to LOAD, so set Y as a byte counter

.loop3

 LDA (P),Y              \ Fetch the Y-th byte of the P(1 0) memory block

 EOR #&18               \ Decrypt it by EOR'ing with &18

 STA (ZP),Y             \ Store the decrypted result in the Y-th byte of the
                        \ ZP(1 0) memory block

 DEY                    \ Decrement the byte counter

 BNE loop3              \ Loop back to copy the next byte until we have done a
                        \ whole page of 256 bytes

 JMP LOAD               \ Jump to the start of the routine we just decrypted

\ ******************************************************************************
\
\       Name: PROT2
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Calculate a checksum on the loader code
\
\ ******************************************************************************

.PROT2

 CLC                    \ Clear the C flag for the addition below

 LDY #0                 \ We are going to loop through 256 bytes, so set a byte
                        \ counter in Y

.p2

 ADC PLL1,Y             \ Set A = A + Y-th byte of PLL1

 EOR ENTRY,Y            \ Set A = A EOR Y-th byte of ENTRY

 DEY                    \ Decrement the byte counter

 BNE p2                 \ Loop back to checksum the next byte

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: LOADcode
\       Type: Subroutine
\   Category: Loader
\    Summary: Encrypted LOAD routine, bundled up in the loader so it can be
\             moved to &0B00 to be run
\
\ ------------------------------------------------------------------------------
\
\ This section is encrypted by EOR'ing with &18. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as it is moved to &0B00.
\
\ ******************************************************************************

.LOADcode

ORG &0B00

\ ******************************************************************************
\
\       Name: LOAD
\       Type: Subroutine
\   Category: Loader
\    Summary: Load the main docked code, set up various vectors, run a checksum
\             and start the game
\
\ ******************************************************************************

.LOAD

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.T.CODE")
 LDY #HI(LTLI)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which loads
                        \ the T.CODE binary (the main docked code) to its load
                        \ address of &11E3

 LDA #LO(S%+11)         \ Point BRKV to the fifth entry in the main docked
 STA BRKV               \ code's S% workspace, which contains JMP BRBR1
 LDA #HI(S%+11)
 STA BRKV+1

 LDA #LO(S%+6)          \ Point BRKV to the third entry in the main docked
 STA WRCHV              \ code's S% workspace, which contains JMP CHPR
 LDA #HI(S%+6)
 STA WRCHV+1

 SEC                    \ Set the C flag so the checksum we calculate in A
                        \ starts with an initial value of 18 (17 plus carry)

 LDY #&00               \ Set Y = 0 to act as a byte pointer

 STY ZP                 \ Set the low byte of ZP(1 0) to 0, so ZP(1 0) always
                        \ points to the start of a page

 LDX #&11               \ Set X = &11, so ZP(1 0) will point to &1100 when we
                        \ stick X in ZP+1 below

 TXA                    \ Set A = &11 = 17, to set the intial value of the
                        \ checksum to 18 (17 plus carry)

.l1

 STX ZP+1               \ Set the high byte of ZP(1 0) to the page number in X

 ADC (ZP),Y             \ Set A = A + the Y-th byte of ZP(1 0)

 INY                    \ Increment the byte pointer

 BNE l1                 \ Loop back to add the next byte until we have added the
                        \ whole page

 INX                    \ Increment the page number in X

 CPX #&54               \ Loop back to checksum the next page until we have
 BCC l1                 \ checked up to (but not including) page &54

 CMP &55FF              \ Compare the checksum with the value in &55FF, which is
                        \ in the docked file we just loaded, in the byte before
                        \ the ship hanger blueprints at XX21

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, then ignore the result
 NOP

ELSE

 BNE P%                 \ If the checksums don't match then enter an infinite
                        \ loop, which hangs the computer

ENDIF

 JMP S%+3               \ Jump to the second entry in the main docked code's S%
                        \ workspace to start a new game

.LTLI

 EQUS "L.T.CODE"
 EQUB 13

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

COPYBLOCK LOAD, P%, LOADcode

ORG LOADcode + P% - LOAD

\ ******************************************************************************
\
\       Name: CATDcode
\       Type: Subroutine
\   Category: Save and load
\    Summary: CATD routine, bundled up in the loader so it can be moved to &0D7A
\             to be run
\
\ ******************************************************************************

.CATDcode

ORG &0D7A

\ ******************************************************************************
\
\       Name: CATD
\       Type: Subroutine
\   Category: Save and load
\    Summary: Load disc sectors 0 and 1 to &0E00 and &0F00 respectively
\
\ ------------------------------------------------------------------------------
\
\ This routine is copied to &0D7A in part 1 above. It is called by both the main
\ docked code and the main flight code, just before the docked code, flight code
\ or shup blueprint files are loaded.
\
\ ******************************************************************************

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
 EQUB 0                 \ 10 = The result of the OSWORD call is returned here

COPYBLOCK CATD, P%, CATDcode

ORG CATDcode + P% - CATD

\ ******************************************************************************
\
\       Name: PROT1
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Part of the CHKSM copy protection checksum calculation
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

 LSR CHKSM

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
\    Summary: Part of the CHKSM copy protection checks
\
\ ******************************************************************************

.PROT4

 LDA RAND+2             \ Fetch the checksum we calculated in PROT1

 EOR CHKSM              \ Set A = A EOR CHKSM

 ASL A                  \ Shift A left, moving bit 7 into the C flag and
                        \ clearing bit 0

 CMP #147               \ If A >= 147, set the C flag, otherwise clear it

 ROR A                  \ Shift A right, moving the C flag into bit 7 and
                        \ clearing the C flag

 STA CHKSM              \ Store the updated A in CHKSM

 BCC out                \ Return from the subroutine (as we cleared the C flag
                        \ above and out contains an RTS)

INCLUDE "library/common/loader/variable/cnt.asm"
INCLUDE "library/common/loader/variable/cnt2.asm"
INCLUDE "library/common/loader/variable/cnt3.asm"

\ ******************************************************************************
\
\       Name: PROT5
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Part of the CHKSM copy protection checks
\
\ ******************************************************************************

.PROT5

 LDA CHKSM              \ Update the checksum
 AND CHKSM+1
 ORA #&0C
 ASL A
 STA CHKSM

 RTS                    \ Return from the subroutine

 JMP P%                 \ This would hang the computer, but we never get here as
                        \ the checksum code has been disabled

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
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 1 above.
\
\ This section is encrypted by EOR'ing with &A5. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as each block is moved to its correct location.
\
\ There are two files containing code:
\
\   * WORDS.bin contains the recursive token table, which is moved to &0400
\     before the main game is loaded
\
\   * MISSILE.bin contains the missile ship blueprint, which gets moved to &7F00
\     before the main game is loaded
\
\ and one file containing an image, which is moved into screen memory by the
\ loader:
\
\   * P.DIALS.bin contains the dashboard, which gets moved to screen address
\     &7800, which is the starting point of the four-colour mode 5 portion at
\     the bottom of the split screen
\
\ There are three other image binaries bundled into the loader, which are
\ described in part 3 below.
\
\ ******************************************************************************

.DIALS

 INCBIN "versions/disc/binaries/P.DIALS.bin"

.SHIP_MISSILE

 INCBIN "versions/disc/output/MISSILE.bin"

.WORDS

 INCBIN "versions/disc/output/WORDS.bin"

\ ******************************************************************************
\
\       Name: OSBmod
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Calculate a checksum on &0F00 to &0FFF (the test is disabled in
\             this version)
\
\ ******************************************************************************

.OSBmod

 SEC                    \ Set the C flag so the checksum we calculate in A
                        \ starts with an initial value of 16 (15 plus carry)

 LDY #&00               \ Set ZP(1 0) = &0F00
 STY ZP                 \
 LDA #&0F               \ and at the same time set a byte counter in Y and set
 STA ZP+1               \ the intial value of the checksum to 16 (15 plus carry)

.osb1

 ADC (ZP),Y             \ Set A = A + the Y-th byte of ZP(1 0)

 INY                    \ Increment the byte pointer

 BNE osb1               \ Loop back to add the next byte until we have added the
                        \ whole page

 CMP #&CF               \ The checksum test has been disabled
 NOP
 NOP

 LDA #219               \ Store 219 in location &9F. This gets checked by the
 STA &9F                \ TITLE routine in the main docked code as part of the
                        \ copy protection (the game hangs if it doesn't match)

 RTS

\ ******************************************************************************
\
\       Name: TVT1code
\       Type: Subroutine
\   Category: Loader
\    Summary: Code block at &1100-&11E2 that remains resident in both docked and
\             flight mode (palettes, screen mode routine and commander data)
\
\ ------------------------------------------------------------------------------
\
\ This section is encrypted by EOR'ing with &A5. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as it is moved to &1000.
\
\ ******************************************************************************

.TVT1code

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
\    Summary: Loader break handler: print a newline and the error message, and
\             then hang the computer
\
\ ------------------------------------------------------------------------------
\
\ This break handler is only used until the docked code has loaded and the scram
\ routine has decrypted the code, at which point the break handler is changed to
\ the main game break handler (which doesn't hang the computer on an error).
\
\ ******************************************************************************

.BRBR1

                        \ The following loop prints out the null-terminated
                        \ message pointed to by (&FD &FE), which is the MOS
                        \ error message pointer - so this prints the error
                        \ message on the next line

 LDY #0                 \ Set Y = 0 to act as a character counter

 LDA #13                \ Set A = 13 so the first character printed is a
                        \ carriage return

.BRBRLOOP

 JSR OSWRCH             \ Print the character in A (which contains a carriage
                        \ return on the first loop iteration), and then any
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE BRBRLOOP           \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

 BEQ P%                 \ Hang the computer as something has gone wrong

 EQUB &64, &5F, &61     \ These bytes appear to be unused
 EQUB &74, &74, &72
 EQUB &69, &62, &75
 EQUB &74, &65, &73
 EQUB &00, &C4, &24
 EQUB &6A, &43, &67
 EQUB &65, &74, &72
 EQUB &64, &69, &73
 EQUB &63, &00, &B6
 EQUB &3C, &C6

COPYBLOCK TVT1, P%, TVT1code

ORG TVT1code + P% - TVT1

\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: Include binaries for the loading screen images
\
\ ------------------------------------------------------------------------------
\
\ The loader bundles a number of binary files in with the loader code, and moves
\ them to their correct memory locations in part 1 above.
\
\ This section is encrypted by EOR'ing with &A5. The encryption is done by the
\ elite-checksum.py script, and decryption is done in part 1 above, at the same
\ time as each block is moved to its correct location.
\
\ This part includes three files containing images, which are all moved into
\ screen memory by the loader:
\
\   * P.A-SOFT.bin contains the "ACORNSOFT" title across the top of the loading
\     screen, which gets moved to screen address &6100, on the second character
\     row of the monochrome mode 4 screen
\
\   * P.ELITE.bin contains the "ELITE" title across the top of the loading
\     screen, which gets moved to screen address &6300, on the fourth character
\     row of the monochrome mode 4 screen
\
\   * P.(C)ASFT.bin contains the "(C) Acornsoft 1984" title across the bottom
\     of the loading screen, which gets moved to screen address &7600, the
\     penultimate character row of the monochrome mode 4 screen, just above the
\     dashboard
\
\ There are three other binaries bundled into the loader, which are described in
\ part 2 above.
\
\ ******************************************************************************

.ELITE

 INCBIN "versions/disc/binaries/P.ELITE.bin"

.ASOFT

 INCBIN "versions/disc/binaries/P.A-SOFT.bin"

.CpASOFT

 INCBIN "versions/disc/binaries/P.(C)ASFT.bin"

IF _MATCH_EXTRACTED_BINARIES

IF _STH_DISC
 INCBIN "versions/disc/extracted/sth/workspaces/loader3.bin"
ELIF _IB_DISC
 SKIP 158
ENDIF

ELSE

 SKIP 158               \ These bytes are unused

ENDIF

\ ******************************************************************************
\
\ Save output/ELITE4.unprot.bin
\
\ ******************************************************************************

PRINT "S.ELITE4 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/ELITE4.unprot.bin", CODE%, P%, LOAD%


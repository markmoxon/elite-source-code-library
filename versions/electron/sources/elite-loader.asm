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

LE% = &0B00             \ LE% is the address to which the code from UU% onwards
                        \ is copied in part 3

C% = &0D00              \ C% is set to the location that the main game code gets
                        \ moved to after it is loaded

L% = &2000              \ L% is the load address of the main game code file

S% = C%                 \ S% points to the entry point for the main game code

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

CODE% = &4400
LOAD% = &4400

ORG CODE%

\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 5)
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
\     row of the space view
\
\   * P.ELITE.bin contains the "ELITE" title across the top of the loading
\     screen, which gets moved to screen address &5B00, on the fourth character
\     row of the space view
\
\   * P.(C)ASFT.bin contains the "(C) Acornsoft 1984" title across the bottom
\     of the loading screen, which gets moved to screen address &73A0, the
\     penultimate character row of the space view, just above the dashboard
\
\   * P.DIALS.bin contains the dashboard, which gets moved to screen address
\     &7620, which is the starting point of the dashboard, just below the space
\     view
\
\ The routine ends with a jump to the start of the loader code at ENTRY.
\
\ ******************************************************************************

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
\       Name: Elite loader (Part 2 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Perform a number of OS calls, set up sound, push routines on stack
\
\ ------------------------------------------------------------------------------
\
\ This part of the loader does a number of calls to OS routines, sets up the
\ sound envelopes, and pushes 33 bytes onto the stack. A lot of the code in this
\ routine has been removed or hobbled to remove the protection; for a full
\ picture of the protection that's missing, see the source code for the BBC
\ Micro cassette version, which contains almost exactly the same protection code
\ as the original Electron version.
\
\ ******************************************************************************

.ENTRY

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version NOP
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

 LDA #&60               \ This appears to be a lone instruction left over from
 STA &0088              \ the unprotected code, as this value is never used

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
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

 NOP                    \ This part of the loader has been disabled by the
                        \ crackers, as this is an unprotected version

.Ian1

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
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
                        \ &2C &D0 &92, or BIT &92D0, which does nothing apart
                        \ from affect the flags

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

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
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
 
                        \ The following loop copies the crunchit routine into
                        \ zero page, though this unprotected version of the
                        \ loader doesn't call it there, so this has no effect

 LDY #0                 \ Set a counter in Y for the copy

.David3

 LDA crunchit,Y         \ Copy the Y-th byte of crunchit

.PROT1

 STA TRTB%+2,X          \ And store it in the X-th byte of zero page after the
                        \ TRTB%(1 0) variable

 INX                    \ Increment both byte counters
 INY

 CPY #33                \ Loop back to copy the next byte until we have copied
 BNE David3             \ all 33 bytes

 LDA #LO(B%)            \ Set the low byte of ZP(1 0) to point to the VDU code
 STA ZP                 \ table at B%

 LDA #&95               \ This part of the loader has been disabled by the
 BIT PROT1              \ crackers, as this is an unprotected version (the BIT
                        \ instruction is an STA instruction in the full version,
                        \ but it has been hobbled here)

 LDA #HI(B%)            \ Set the high byte of ZP(1 0) to point to the VDU code
 STA ZP+1               \ table at B%

 LDY #0                 \ We are now going to send the N% VDU bytes in the table
                        \ at B% to OSWRCH to set up the screen mode

.LOOP

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE LOOP               \ all (the number of bytes was set in N% above)

 LDA #1                 \ This part of the loader has been disabled by the
 TAX                    \ crackers, as this is an unprotected version (the CMP
 TAY                    \ instruction is an STA instruction in the full version,
 LDA abrk+1             \ but it has been hobbled here)
 CMP (V219),Y

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 JSR OSB                \ cursor editing, so the cursor keys return ASCII values
                        \ and can therefore be used in-game

 LDA #9                 \ Call OSBYTE with A = 9, X = 0 and Y = 0 to disable
 LDX #0                 \ flashing colours
 JSR OSB

 LDA #&6C               \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version (the BIT
 NOP                    \ instruction is an STA instruction in the full version,
 NOP                    \ but it has been hobbled here)
 BIT &544F

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Move recursive tokens and images
\
\ ------------------------------------------------------------------------------
\
\ Move the following memory blocks:
\
\   * WORDS9: move 4 pages (1024 bytes) from &4400 (CODE%) to &0400
\
\   * P.ELITE: move 1 page (256 bytes) from &4F00 (CODE% + &B00) to &5BE0
\
\   * P.A-SOFT: move 1 page (256 bytes) from &5000 (CODE% + &C00) to &5960
\
\   * P.(C)ASFT: move 1 page (256 bytes) from &5100 (CODE% + &D00) to &73A0
\
\   * P.DIALS: move 7 pages (1792 bytes) from &4800 (CODE% + &400) to &7620
\
\   * Move 1 page (256 bytes) from &5615 (UU%) to &0B00-&0BFF
\
\ and call the routine to draw Saturn between P.(C)ASFT and P.DIALS.
\
\ The dashboard image (P.DIALS) is moved into screen memory one page at a time,
\ but not in a contiguous manner - it has to take into account the &20 bytes of
\ blank margin at each edge of the screen (see the description of the screen
\ mode in B% above). So the seven rows of the dashboard are actually moved into
\ screen memory like this:
\
\     1 page from &4800 to &7620           = &7620
\     1 page from &4900 to &7720 + &40     = &7760
\     1 page from &4A00 to &7820 + 2 * &40 = &78A0
\     1 page from &4B00 to &7920 + 3 * &40 = &79E0
\     1 page from &4C00 to &7A20 + 4 * &40 = &7B20
\     1 page from &4D00 to &7B20 + 5 * &40 = &7C60
\     1 page from &4E00 to &7C20 + 6 * &40 = &7DA0
\
\ See part 1 above for more details on the above files and the locations that
\ they are moved to.
\
\ The code at UU% (see below) forms part of the loader code and is moved before
\ being run, so it's tucked away safely while the main game code is loaded and
\ decrypted.
\
\ In the unprotected version of the loader, the images are encrypted and this
\ part also decrypts them, but this is an unprotected version of the game, so
\ the encryption part of the crunchit routine is disabled.
\
\ ******************************************************************************

 LDX #4                 \ Set the following:
 STX P+1                \
 LDA #HI(CODE%)         \   P(1 0) = &0400
 STA ZP+1               \   ZP(1 0) = CODE%
 LDY #0                 \   (X Y) = &400 = 1024
 LDA #256-232           \
 CMP (V219-4,X)         \ The CMP instruction is an STA instruction in the
 STY ZP                 \ protected version of the loader, but this version has
 STY P                  \ been hacked to remove the protection, and the crackers
                        \ just switched the STA to a CMP to disable this bit of
                        \ the protection code

 JSR crunchit           \ Call crunchit to move &400 bytes from CODE% to &0400.
                        \ We loaded WORDS9.bin to CODE% in part 1, so this moves
                        \ WORDS9

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&B)    \
 STA ZP+1               \   P(1 0) = &5BE0
 LDA #&5B               \   ZP(1 0) = CODE% + &B
 STA P+1                \   (X Y) = &100 = 256
 LDA #&E0
 STA P
 LDY #0

 JSR crunchit           \ Call crunchit to move &100 bytes from CODE% + &B to
                        \ &5BE0, so this moves P.ELITE

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&C)    \
 STA ZP+1               \   P(1 0) = &5960
 LDA #&59               \   ZP(1 0) = CODE% + &C
 STA P+1                \   (X Y) = &100 = 256
 LDA #&60
 STA P
 LDY #0

 JSR crunchit           \ Call crunchit to move &100 bytes from CODE% + &C to
                        \ &5960, so this moves P.A-SOFT

 LDX #1                 \ Set the following:
 LDA #(HI(CODE%)+&D)    \
 STA ZP+1               \   P(1 0) = &73A0
 LDA #&73               \   ZP(1 0) = CODE% + &D
 STA P+1                \   (X Y) = &100 = 256
 LDA #&A0
 STA P
 LDY #0

 JSR crunchit           \ Call crunchit to move &100 bytes from CODE% + &D to
                        \ &73A0, so this moves P.(C)ASFT

 JSR PLL1               \ Call PLL1 to draw Saturn

 LDA #(HI(CODE%)+4)     \ Set the following:
 STA ZP+1               \
 LDA #&76               \   P(1 0) = &7620
 STA P+1                \   ZP(1 0) = CODE% + &4
 LDY #0                 \   Y = 0
 STY ZP                 \
 LDX #&20               \ Also set BLCNT = 0
 STY BLCNT
 STX P

.dialsL

 LDX #1                 \ Set (X Y) = &100 = 256

 JSR crunchit           \ Call crunchit to move &100 bytes from ZP(1 0) to
                        \ P(1 0), so this moves P.DIALS one row at a time

 CLC                    \ Set P(1 0) = P(1 0) + &40 to skip the screen margins
 LDA P
 ADC #&40
 STA P
 LDA P+1
 ADC #0
 STA P+1

 CMP #&7E               \ Loop back to copy the next row of the dashboard until
 BCC dialsL             \ we have poked the last one into screen memory

 LDX #1                 \ Set the following:
 LDA #HI(UU%)           \
 STA ZP+1               \   P(1 0) = LE%
 LDA #LO(UU%)           \   ZP(1 0) = UU%
 STA ZP                 \   (X Y) = &100 = 256
 LDA #HI(LE%)
 STA P+1
 LDY #0
 STY P

 JSR crunchit           \ Call crunchit to move &100 bytes from UU% to LE%

\ ******************************************************************************
\
\       Name: Elite loader (Part 4 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Call part 5 of the loader now that is has been relocated
\
\ ------------------------------------------------------------------------------
\
\ In the protected version of the loader, this part copies more code onto the
\ stack and decrypts a chunk of loader code before calling part 5, but in the
\ unprotected version it's mostly NOPs.
\
\ ******************************************************************************

 JMP &0B11              \ Call relocated UU% routine to load the main game code
                        \ at &2000, move it down to &0D00 and run it

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
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

.RAND

 EQUD &6C785349         \ The random number seed used for drawing Saturn

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
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

 LDX #&C2               \ ???
 STX EXCN

 LDX #&60               \ ???
 STX &0087

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

 LDX #&CA               \ ???
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

\ ******************************************************************************
\
\       Name: crunchit
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Multi-byte decryption and copying routine
\
\ ------------------------------------------------------------------------------
\
\ In the unprotected version of the loader on this site, this routine just moves
\ data frommone location to another. In the protected version, it also decrypts
\ the data as it is moved, but that part is disabled in the following.
\
\ Arguments:
\
\   (X Y)               The number of bytes to copy
\
\   ZP(1 0)             The source address
\
\   P(1 0)              The destination address
\
\ ******************************************************************************

.crunchit

 LDA (ZP),Y             \ Copy the Y-th byte of ZP(1 0) to the Y-th byte of
 NOP                    \ P(1 0), without any decryption (hence the NOPs)
 NOP
 NOP
 STA (P),Y

 DEY                    \ Decrement the byte counter

 BNE crunchit           \ Loop back to crunchit to copy the next byte until we
                        \ have done a whole page

 INC P+1                \ Increment the high bytes of the source and destination
 INC ZP+1               \ addresses so we can copy the next page

 DEX                    \ Decrement the page counter

 BNE crunchit           \ Loop back to crunchit to copy the next page until we
                        \ have done X pages

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: BEGIN%
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Single-byte decryption and copying routine, run on the stack
\
\ ------------------------------------------------------------------------------
\
\ This code is not run in the unprotected version of the loader. In the full
\ version it is stored with the instructions reversed so it can be copied onto
\ the stack to be run, and it doesn't contain any NOPs, so this is presumably a
\ remnant of the cracking process.
\
\ ******************************************************************************

 PLA
 PLA
 LDA &0C24,Y
 PHA
 EOR &0B3D,Y
 NOP
 NOP
 NOP
 JMP (David9)

\ ******************************************************************************
\
\       Name: UU%
\       Type: Workspace
\    Address: &0B00
\   Category: Workspaces
\    Summary: Marker for a block that is moved as part of the obfuscation
\
\ ------------------------------------------------------------------------------
\
\ The code from here to the end of the file gets copied to &0B00 (LE%) by part
\ 3. It is called from part 4.
\
\ ******************************************************************************

.UU%

Q% = P% - LE%

ORG LE%

\ ******************************************************************************
\
\       Name: Elite loader (Part 5 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Set up interrupt vectors, calculate checksums, run main game code
\
\ ------------------------------------------------------------------------------
\
\ This is the final part of the loader. It sets up some of the main game's
\ interrupt vectors and calculates various checksums, before finally handing
\ over to the main game.
\
\ ******************************************************************************

 EQUD &10101010         \ This data appears to be unused
 EQUD &10101010
 EQUD &10101010
 EQUD &10101010
 EQUB &10

.ENTRY2

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("LOAD EliteCo FFFF2000")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which loads
                        \ the maon game code at location &2000

 LDA #3                 \ Directly update &0258, the memory location associated
 STA &0258              \ with OSBYTE 200, so this is the same as calling OSBYTE
                        \ with A = 200, X = 3 and Y = 0 to disable the ESCAPE
                        \ key and clear memory if the BREAK key is pressed

 LDA #140               \ Call OSBYTE with A = 140 and X = 12 to select the
 LDX #12                \ tape filing system (i.e. do a *TAPE command)
 LDY #0
 JSR OSBYTE

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&C                \ type &C with argument &FF, which is the "NMI claim"
 LDY #&FF               \ service call that asks the current user of the NMI
 JSR OSBYTE             \ space to clear it out

 LDA #&40               \ Set S%+0 to &40, though this gets overwritten in the
 STA S%                 \ following copy process, so I'm not entirely sure what
                        \ this does

 LDX #&4A               \ Set X = &4A, as we want to copy the &4A pages of main
                        \ game code from where we just loaded it at &2000, down
                        \ to &0D00 where we will run it

 LDY #0                 \ Set the source and destination addresses for the copy:
 STY ZP                 \
 STY P                  \   ZP(1 0) = L% = &2000
 LDA #HI(L%)            \   P(1 0) = C% = &0D00
 STA ZP+1               \
 LDA #HI(C%)            \ and set Y = 0 to act as a byte counter in the
 STA P+1                \ following loop

.MVDL

 LDA (ZP),Y             \ Copy the Y-th byte from the source to the Y-th byte of
 STA (P),Y              \ the destination

 LDA #0                 \ Zero the source byte we just copied, so that this loop
 STA (ZP),Y             \ moves the memory block rather than copying it

 INY                    \ Increment the byte counter

 BNE MVDL               \ Loop back until we have copied a whole page of bytes

 INC ZP+1               \ Increment the high bytes of ZP(1 0) and P(1 0) so we
 INC P+1                \ copy bytes from the next page in memory

 DEX                    \ Decrement the page counter in X

 BPL MVDL               \ Loop back to move the next page of bytes until we have
                        \ moved the number of pages in X (this also sets X to
                        \ &FF)

 SEI                    \ Disable all interrupts

 TXS                    \ Set the stack pointer to &01FF, which is the standard
                        \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDA RDCHV              \ Set the user vector USERV to the same value as the
 STA USERV              \ read character vector RDCHV
 LDA RDCHV+1
 STA USERV+1

 LDA KEYV               \ Store the current value of the keyboard vector KEYV
 STA S%+4               \ in S%+4
 LDA KEYV+1
 STA S%+5

 LDA #LO(S%+16)         \ Point the keyboard vector KEYV to S%+16 in the main
 STA KEYV               \ game code
 LDA #HI(S%+16)
 STA KEYV+1

 LDA S%+14              \ Point the break vector BRKV to the address stored in
 STA BRKV               \ S%+14 in the main game code
 LDA S%+15
 STA BRKV+1

 LDA S%+10              \ Point the write character vector WRCHV to the address
 STA WRCHV              \ stored in S%+10 in the main game code
 LDA S%+11
 STA WRCHV+1

 LDA IRQ1V              \ Store the current value of the interrupt vector IRQ1V
 STA S%+2               \ in S%+2
 LDA IRQ1V+1
 STA S%+3

 LDA S%+12              \ Point the interrupt vector IRQ1V to the address stored
 STA IRQ1V              \ in S%+12 in the main game code
 LDA S%+13
 STA IRQ1V+1

 LDA #%11111100         \ Clear all interrupts (bits 4-7) and select ROM 12
 JSR VIA05              \ (bits 0-3) by setting the interrupt clear and paging
                        \ register at SHEILA &05

 LDA #8                 \ Select ROM 8 (the keyboard) by setting the interrupt
 JSR VIA05              \ clear and paging register at SHEILA &05

 LDA #&60               \ Set the screen start address registers at SHEILA &02
 STA VIA+&02            \ and SHEILA &03 so screen memory starts at &7EC0 ???
 LDA #&3F
 STA VIA+&03

 CLI                    \ Re-enable interrupts

 JMP (S%+8)             \ Jump to the address in S%+8 in the main game code,
                        \ which points to TT170, so this starts the game

.VIA05

 STA &00F4              \ Store A in &00F4

 STA VIA+&05            \ Set the value of the interrupt clear and paging
                        \ register at SHEILA &05 to A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: MESS1
\       Type: Variable
\   Category: Utility routines
\    Summary: Contains an OS command string for loading the main game code
\
\ ******************************************************************************

.MESS1

 EQUS "LOAD EliteCo FFFF2000"

 EQUB 13
 
 SKIP 13                \ These bytes appear to be unused

\ ******************************************************************************
\
\ Save output/ELITE.unprot.bin
\
\ ******************************************************************************

COPYBLOCK LE%, P%, UU%  \ Copy the block that we assembled at LE% to UU%, which
                        \ is where it will actually run

PRINT "S.ELITEDA ", ~CODE%, " ", ~UU% + (P% - LE%), " ", ~run, " ", ~CODE%
SAVE "versions/electron/output/ELITEDA.bin", CODE%, UU% + (P% - LE%), run, CODE%

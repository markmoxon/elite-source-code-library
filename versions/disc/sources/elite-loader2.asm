\ ******************************************************************************
\
\ DISC ELITE LOADER (PART 2) SOURCE
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
\   * output/ELITE3.bin
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

_CASSETTE_VERSION       = (_VERSION = 1)
_DISC_VERSION           = (_VERSION = 2)
_6502SP_VERSION         = (_VERSION = 3)
_DISC_DOCKED            = FALSE
_DISC_FLIGHT            = TRUE

TRTB% = &04             \ TRTB%(1 0) points to the keyboard translation table
K1   = $0012
K2   = $0013
K3   = $0044
K4   = $004C
K5   = $004D
K6   = $004E
K7   = $004F
K8   = $0050
K9   = $0051

Q   = $0070
ZP   = $0071
P   = $0073
R   = $0075
T   = $0076
SC   = $0081

L0AC1   = $0AC1
L373D   = $373D
L4953   = $4953
L495C   = $495C
L499C   = $499C
L49D6   = $49D6
L4BBA   = $4BBA
L4BC3   = $4BC3
L4BCC   = $4BCC

OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine
OSCLI = &FFF7           \ The address for the OSCLI vector

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

CODE% = &5700           \ The address where this file (the third loader) loads
LOAD% = &5700

ORG CODE%

\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 4)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ENTRY

 LDA #0                 \ We start by deleting the first loader from memory, so
                        \ it doesn't leave any clues for the crackers, so set A
                        \ to 0 so we can zero the memory

 TAY                    \ Set Y to 0 to act as an index in the following loop

.LOOP1

 STA &2F00,Y            \ Zero the Y-th byte of &2F00, which is where the first
                        \ loader was running before it loaded this one

 INY                    \ Increment the loop counter

 BNE LOOP1              \ Loop back until we have zeroed all 256 bytes from
                        \ &2F00 to &2FFF, leaving Y = 0

 LDA #0                 \ Set &3FFF = 0
 STA &3FFF

 LDA #64                \ Set &7FFF = 64 
 STA &7FFF

 EOR &3FFF              \ Set A = 64 EOR &3FFF
                        \       = 64 EOR 0
                        \       = 64

 CLC                    \ Set A = A + 64
 ADC #64                \       = 64 + 64
                        \       = 128

 PHA                    \ Push 128 on the stack

 TAX                    \ Set X = 128

 LDA #254               \ Call OSBYTE with A = 254, X = 128 and Y = 0 to set
 LDY #0                 \ the available RAM to 32K
 JSR OSBYTE

 PLA                    \ Pull 128 from the stack into A

 AND &5973              \ &5973 contains 128, so set A = 128 AND 128 = 128

.LOOP2

 BEQ LOOP2              \ If A = 0 then enter an infinite loop with LOOP2,
                        \ which hangs the computer

 JSR PROT1

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #&FF
 JSR OSBYTE

 STX TRTB%              \ Store the address of the keyboard translation table in
 STY TRTB%+1            \ TRTB%(1 0)

 LDA #234               \ Call OSBYTE with A = 234, X = 0 and Y = &FF, which
 LDX #0                 \ detects whether Tube hardware is present, returning
 LDY #&FF               \ X = 0 (not present) or X = &FF (present)
 JSR OSBYTE

 CPX #&FF               \ If X is not &FF, i.e. we are not running this over the
 BNE notube             \ Tube, then jump to notube

 LDA &5A00              \ &5A00 contains 0, so set A = 0

.LOOP3

 BEQ LOOP3              \ If A = 0 then enter an infinite loop with LOOP3,
                        \ which hangs the computer

 JMP &5A00              \ Otherwise jump to &5A00, which will execute a BRK to
                        \ terminate the program

.notube

 LDA MPL                \ Set A = &A0, as MPL contains an LDY #0 instruction

 NOP
 NOP
 NOP

 JMP MPL                \ Jump to MPL to copy 512 bytes to &0400 and jump to
                        \ ENTRY2

 EQUB &00, &00, &00, &00, &00, &00, &00, &00

 NOP
 NOP

\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 4)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ENTRY2

 JMP ENTRY3

 NOP
 NOP
 NOP
 NOP

\ ******************************************************************************
\
\       Name: Elite loader (Part 4 of 4)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ENTRY4

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("LOAD Elite4")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which loads
                        \ the ELITE4 binary to its load address of &1900

 LDA #21                \ Call OSBYTE with A = 21 and X = 0 to flush the
 LDX #0                 \ keyboard buffer
 JSR OSBYTE

 LDA #201               \ Call OSBYTE with A = 201, X = 1 and Y = 1 to re-enable
 LDX #1                 \ the keyboard, which we disabled in the first loader
 LDY #1
 JSR OSBYTE

 JMP &197B              \ Jump to the start of the ELITE3 loader code at &197B

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: MESS1
\       Type: Variable
\   Category: Loader
\    Summary: The OS command string for loading the third loader
\
\ ******************************************************************************

.MESS1

 EQUS "LOAD Elite4"
 EQUB 13

 SKIP 4

\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 4)
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.ENTRY3

 LDA #129               \ Call OSBYTE with A = 129, X = &FF and Y = 2 to scan
 LDY #2                 \ the keyboard for &2FF centiseconds (7.67 seconds)
 LDX #&FF
 JSR OSBYTE

 LDA #15                \ Call OSBYTE with A = 129 and Y = 0 to flush the input
 LDY #0                 \ buffer
 JSR OSBYTE

 JMP ENTRY4             \ Jump to ENTRY4 to load and run the next part of the
                        \ loader

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00
 
 EQUB &32

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: MPL
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Move 512 bytes from &5819 to &0400 and jump to ENTRY2
\
\ ******************************************************************************

.MPL

 LDY #0                 \ Move &5819 onwards to &0400

 LDX #2                 \ 2 * 256 bytes

.MVBL

 LDA LOD,Y
 STA LOADER,Y

 INY

 BNE MVBL

 INC MVBL+2             \ High byte of LDA
 INC MVBL+5             \ High byte of STA

 DEX

 BNE MVBL

 JMP ENTRY2

\ ******************************************************************************
\
\       Name: LOD
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

\ Gets copied from &5819 to &0400 (512 bytes)

.LOD

ORG &0400

.LOADER                 \ Moved to &0400-&05FF from &5819-&5A18
                        \ Gets replaced by QQ18 tokens at some point

 JSR LOAD10

 PLA
 STA L0509
 PLA
 STA L050A
 PLA
 CLC
 ADC L0551
 STA L0557
 PLA
 STA L0559
 PLA
 STA L0558
 BEQ LOAD2

.LOAD1

 JSR LOAD7

 DEC L0558
 BNE LOAD1

.LOAD2

 LDA L0559
 BEQ LOAD3

 ORA #&20
 STA L0511
 JSR LOAD7

.LOAD3

 LDA L051A
 BEQ LOAD5

 LDY #&00

.LOAD4

 LDA &0700,Y
 STA &1000,Y
 INY
 BNE LOAD4

.LOAD5

 LDX L055B
 BEQ LOAD6

 LDX #&52
 LDY #&05
 JSR OSCLI

 LDX #&02

.LOAD6

 STX T
 LDA #&15
 LDX #&00
 JSR OSBYTE

 LDA #&C9
 LDX #&01
 LDY #&01
 JMP OSBYTE

.LOAD7

 JSR LOAD11

 LDA #&28
 SEC
 SBC L0557
 STA L0545
 STA L050F
 LDA #&01
 JSR LOAD13

 LDA L050A
 CMP #&0E
 BNE LOAD8

 LDA L050F
 STA L051A
 STA L0525
 STA L0530
 LDA #&04
 JSR LOAD13

 LDA #&05
 JSR LOAD13

 LDA #&06
 JSR LOAD13

 JMP LOAD9

.LOAD8

 LDA #&03
 JSR LOAD13

.LOAD9

 LDA L053B
 STA L0545
 LDA #&01
 JSR LOAD13

 LDA L050A
 CLC
 ADC #&0A
 STA L050A
 INC L0557
 RTS

.LOAD10

 JSR LOAD11

 LDA L053B
 STA L054E
 LDA #&02
 JSR LOAD13

 RTS

.LOAD11

 LDA L0557
 LDX L055B
 BEQ LOAD12

 ASL A

.LOAD12

 STA L053B
 LDA #&00

.LOAD13

 STA R

.LOAD14

 LDA R
 ASL A
 TAX
 LDA L04FA,X
 LDY L04FA+1,X
 TAX
 STX P
 STY P+1
 LDA #127
 JSR OSWORD

 LDA R
 CMP #&03
 BCC LOAD15

 LDY #&0A
 LDA (P),Y
 AND #&DF
 BNE LOAD14

.LOAD15

 RTS

.L04FA

 EQUB &34

 EQUB &05, &3D, &05, &47, &05, &08, &05, &13
 EQUB &05, &1E, &05, &29, &05, &FF

.L0509

 EQUB &00

.L050A

 EQUB &0A

 EQUB &FF, &FF, &03, &57

.L050F

 EQUB &00, &F6

.L0511

 EQUB &2A, &00
 EQUB &FF, &00, &0E, &FF, &FF, &03, &57

.L051A
 
 EQUB &00
 EQUB &F6, &22, &00, &FF, &00, &07, &FF, &FF
 EQUB &03, &57

.L0525

 EQUB &00, &F8, &21, &00, &FF, &00
 EQUB &11, &FF, &FF, &03, &57

.L0530

 EQUB &00, &F9, &27
 EQUB &00, &FF, &FF, &FF, &FF, &FF, &01, &69

.L053B

 EQUB &00, &00, &FF, &FF, &FF, &FF, &FF, &02
 EQUB &7A, &12

.L0545

 EQUB &00, &00, &FF, &00, &07, &FF
 EQUB &FF, &03, &5B

.L054E

 EQUB &00, &00, &0A

.L0551

 EQUB &00, &44
 EQUB &52, &2E, &32, &0D

.L0557

 EQUB &03

.L0558

 EQUB &00

.L0559

 EQUB &00

 EQUB &80 \ location &5973

.L055B

 EQUB &FF, &00, &00, &00, &00, &00, &00, &00

 EQUB &00, &00, &00, &00

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00

 EQUB &00 \ location &5A00

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00 \ 5A18

COPYBLOCK LOADER, P%, LOD

ORG LOD + P% - LOADER

\ ******************************************************************************
\
\       Name: 
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.L5A19

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &E0
 EQUB &E0, &00, &00, &00, &00, &00, &00, &0E
 EQUB &0E, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &0E, &0E, &E0
 EQUB &E0, &00, &E0, &E0, &00, &00, &00, &EE
 EQUB &EE, &00, &E0, &E0, &00, &00, &00, &EE
 EQUB &EE, &00, &0E, &0E, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &E0, &E0, &E0
 EQUB &E0, &00, &00, &00, &00, &E0, &E0, &00
 EQUB &00, &00, &E0, &E0, &00, &E0, &E0, &E0
 EQUB &E0, &00, &E0, &E0, &00, &E0, &E0, &EE
 EQUB &EE, &00, &E0, &E0, &00, &E0, &E0, &EE
 EQUB &EE, &00, &EE, &EE, &00, &E0, &E0, &EE
 EQUB &EE, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &0E, &0E, &00, &0E, &0E, &0E
 EQUB &0E, &00, &0E, &0E, &00, &0E, &0E, &EE
 EQUB &EE, &00, &0E, &0E, &00, &0E, &0E, &EE
 EQUB &EE, &00, &EE, &EE, &00, &0E, &0E, &00
 EQUB &00, &00, &00, &00, &00, &EE, &EE, &EE
 EQUB &EE

 EQUB &00

 EQUB &00, &00, &00, &EE, &EE, &00, &00, &00
 EQUB &E0, &E0, &00, &EE, &EE, &E0, &E0, &00
 EQUB &E0, &E0, &00, &EE, &EE, &00, &00, &00
 EQUB &0E, &0E, &00, &EE, &EE, &0E, &0E, &00
 EQUB &0E, &0E, &00, &EE, &EE, &00, &00, &00
 EQUB &EE, &EE, &00, &EE, &EE, &E0, &E0, &00
 EQUB &EE, &EE, &00, &EE, &EE, &0E, &0E, &00
 EQUB &EE, &EE, &00, &EE, &EE, &EE, &EE, &00
 EQUB &EE, &EE, &00, &EE, &EE, &A0, &A1, &A2
 EQUB &E0, &A5, &A7, &AB, &B0, &B1, &B4, &B5
 EQUB &B7, &BF, &A3, &E8, &EA, &EB, &EF, &F0
 EQUB &F3, &F4, &F5, &F8, &FA, &FC, &FD, &FE
 EQUB &FF, &00, &00, &00, &18, &09, &03, &18
 EQUB &18, &07, &00, &16, &18, &14, &00, &18
 EQUB &18, &18, &07, &0E, &14, &00, &0E, &09
 EQUB &16, &18, &18, &07, &00, &1A, &1B, &09
 EQUB &00, &18, &18, &18, &18, &18, &18, &00
 EQUB &00, &17, &1B, &0A, &1B, &05, &06, &1B
 EQUB &0F, &0C, &0D, &11, &0A, &1B, &0D, &10
 EQUB &0A, &0F, &1B, &09, &0F, &0A, &1B, &08
 EQUB &06, &04, &0F, &1B, &1B, &1B, &00, &1B
 EQUB &0D, &0D, &0D, &1B, &0D, &00, &0E, &0C
 EQUB &10, &0A, &1B, &00, &00, &00, &0F, &0A
 EQUB &00, &0F, &0A, &1B, &18, &1A, &04, &0F
 EQUB &0C, &1B, &17, &0A, &06, &1B, &19, &07
 EQUB &1B, &1B, &1B, &1B, &0A, &1B, &1B, &1B
 EQUB &00, &1B, &00, &03, &1B, &19, &1A, &0A
 EQUB &1B, &07, &03, &18, &0F, &15, &00, &17
 EQUB &0A, &1B, &06, &19, &00, &0F, &0A, &10
 EQUB &1B, &0A, &12, &00, &10, &1B, &13, &13
 EQUB &13, &13, &08, &1B, &00, &00, &00, &1B
 EQUB &00, &1A, &0B, &00, &0F, &0A, &06, &1B
 EQUB &1B, &05, &02, &11, &1B, &0C, &01, &1B
 EQUB &00, &10, &15, &0F, &0A, &00, &11, &0A
 EQUB &11, &1B, &1B, &04, &11, &1B, &1B, &1B
 EQUB &04, &1B, &00, &00, &00, &1B, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &02, &0D, &00, &00, &00
 EQUB &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: 
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.PROT1

 LDA #&68               \ Poke the following routine into &0100 to &0108:
 STA &0100              \
 STA &0103              \   0100 : &68            PLA
 LDA #&85               \   0101 : &85 &71        STA ZP
 STA &0101              \   0103 : &68            PLA
 STA &0104              \   0104 : &85 &72        STA ZP+1
 LDX #&71               \   0106 : &6C &71 &00    JMP (ZP)
 STX &0107              \
 STX &0102              \ This routine pulls an address off the stack into a
 INX                    \ location in zero page, and then jumps to that address
 STX &0105
 LDA #&6C
 STA &0106
 LDA #&00
 STA &0108

.do

 JSR &0100              \ Call the subroutine at &0100, which does the
 EQUB 0                 \ following:
                        \
                        \   * The JSR puts the address of the last byte of the
                        \     JSR instruction on the stack (i.e. the address of
                        \     the &01), pushing the high byte first
                        \
                        \   * It then jumps to &0100, which pulls the address
                        \     off the stack and puts it in ZP(1 0)
                        \
                        \   * The final instruction of the routine at &0100
                        \     jumps to the address in ZP(1 0), i.e. it jumps to
                        \     the &01 of the JSR instruction. The &01 byte is
                        \     followed by a &00 byte, and &01 &00 is the opcode
                        \     for ORA ($00,X), which doesn't do anything apart
                        \     from affect the value of the accumulator
                        \
                        \ In other words, this whole routine is a complicated
                        \ way of pointing ZP(1 0) to the &01 byte in the JSR
                        \ instruction above

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) - 40, so ZP now points to PROT1
 SEC
 SBC #(2 + do - PROT1)
 STA ZP
 LDA ZP+1
 SBC #&00
 STA ZP+1

 LDY #&63               \ Is this TABLE - PROT1? Looks close, if so this loop
                        \ works through the words in TABLE

.PROT2

 LDA (ZP),Y             \ Set SC(1 0) = ZP(1 0) + Y-th word from TABLE
 CLC                    \
 ADC ZP                 \ so the first table entry makes SC point to the &D0-th
 STA SC                 \ byte of PROT1
 INY
 LDA (ZP),Y
 ADC ZP+1
 STA SC+1

 LDX #0                 \ Add ZP(1 0), i.e. PROT1, to the word at SC(1 0)
 LDA (SC,X)             \
 CLC                    \ so the first table entry adds PROT1 to the address in
 ADC ZP                 \ PROT1+&D0
 STA (SC,X)

 INC SC

 BNE PROT3

 INC SC+1

.PROT3

 LDA (SC,X)
 ADC ZP+1
 STA (SC,X)

 INY                    \ Increment Y to point to the next word in TABLE

 CPY #&7D               \ Loop until we have done them all
 BNE PROT2

 BEQ PROT4              \ Jump to PROT4 (this BEQ is effectively a JMP as we
                        \ didn't just take the BNE branch)

.TABLE

 EQUB &D0, &00, &E2, &00, &E9, &00, &37, &01
 EQUB &64, &01

 EQUB &6D, &01, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: 
\       Type: Subroutine
\   Category: Loader
\    Summary: Show the mode 7 Acornsoft loading screen
\
\ ******************************************************************************

.PROT4

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) - &01E0
 SEC
 SBC #&E0
 STA ZP
 LDA ZP+1
 SBC #&01
 STA ZP+1

 LDX #0                 \ Set Q = 0
 STX Q
                        
 LDY #&FF               \ Call OSBYTE with A = 129, X = 0 and Y = &FF to detect
 LDA #129               \ the machine type. This call is undocumented and is not
 JSR OSBYTE             \ the recommended way to determine the machine type
                        \ (OSBYTE 0 is the correct way), but this call returns
                        \ the following:
                        \
                        \   * X = Y = 0   if this is a BBC Micro with MOS 0.1
                        \   * X = Y = 1   if this is an Acorn Electron
                        \   * X = Y = &FF if this is a BBC Micro with MOS 1.20

 CPX #1                 \ If X is not 1, then this is not an Acorn Electron,
 BNE bbc                \ so jump to bbc

 DEC Q                  \ Decrement Q to &FF

 LDY #0

.LOOP4

 LDX #7

 LDA #&17               \ VDU 23
 JSR OSWRCH

 TYA                    \ VDU Y/8 EOR &E0
 LSR A
 LSR A
 LSR A
 ORA #&E0
 JSR OSWRCH

.LOOP5

 LDA (ZP),Y
 JSR OSWRCH

 INY
 DEX
 BPL LOOP5

 CPY #&E0
 BNE LOOP4

.bbc

 LDA ZP                 \ Set ZP(1 0) = ZP(1 0) + &E0
 CLC
 ADC #&E0
 STA ZP

 BCC mode7

 INC ZP+1

.mode7

 LDA #22                \ Switch to mode 7 using a VDU 22, 7 command
 JSR OSWRCH
 LDA #7
 JSR OSWRCH

 JSR &01B7

\ ******************************************************************************
\
\       Name: 
\       Type: Variable
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

 EQUB &17, &00, &0A, &20, &00, &00, &00, &00
 EQUB &00, &00

 EQUB &EA, &A9, &91, &85, &76, &20, &63, &01
 EQUB &24, &70, &30, &4E, &20, &B7, &01, &1C
 EQUB &0D, &0D, &19, &0A, &0C, &0A, &87, &8D
 EQUB &45, &20, &4C, &20, &49, &20, &54, &20
 EQUB &45, &8C, &92, &87, &8D, &45, &20, &4C
 EQUB &20, &49, &20, &54, &20, &45, &EA, &60
 EQUB &20, &20, &20, &20, &20, &20, &8C, &92
 EQUB &87, &8D, &20, &20, &20, &20, &20, &20
 EQUB &20, &20, &20, &20, &20, &20, &20, &20
 EQUB &20, &20, &20, &20, &20, &20, &20, &20
 EQUB &20, &20, &20, &20, &20, &20, &20, &20
 EQUB &EA, &60, &20, &B7, &01, &1C, &0D, &0C
 EQUB &19, &0A, &0C, &1A, &1F, &0F, &0B, &45
 EQUB &20, &4C, &20, &49, &20, &54, &20, &45
 EQUB &EA, &60, &20, &20, &20, &20, &20, &20
 EQUB &20, &20, &20, &20, &20, &20, &20, &20
 EQUB &20, &20, &20, &20, &20, &EA, &60, &20
 EQUB &6C, &01, &20, &E7, &FF, &20, &E7, &FF
 EQUB &20, &72, &01, &20, &E7, &FF, &A0, &1C
 EQUB &A2, &26, &24, &70, &30, &0D, &A5, &76
 EQUB &20, &EE, &FF, &A9, &9A, &20, &EE, &FF
 EQUB &18, &90, &05, &A9, &20, &20, &EE, &FF
 EQUB &B1, &71, &24, &70, &30, &09, &84, &73
 EQUB &A8, &B1, &71, &A4, &73, &D0, &02, &09
 EQUB &E0, &20, &EE, &FF, &C8, &C0, &FF, &F0
 EQUB &0F, &CA, &D0, &E4, &24, &70, &10, &05
 EQUB &A9, &20, &20, &EE, &FF, &18, &90, &C0
 EQUB &E6, &76, &60, &68, &85, &74, &68, &85
 EQUB &75, &E6, &74, &D0, &02, &E6, &75, &A0
 EQUB &00, &B1, &74, &C9, &EA, &F0, &06, &20
 EQUB &EE, &FF, &18, &90, &EC, &6C

 EQUB &74

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &FF, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00

 EQUB &00

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: 
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.L6100

 BNE L6106

 LDA K8
 CMP K6

.L6106

 BNE L6113

 LDA #&00
 STA K6
 LDA #&00
 STA K7
 JMP L4953

.L6113

 BIT L495C
 BPL L6119

 RTS

.L6119

 LDA K7
 BNE L6120

 JSR L4BBA

.L6120

 LDA K5
 BNE L6132

 JSR L4BC3

 LDA #&00
 STA K6
 LDA #&00
 STA K7
 JMP L4953

.L6132

 LDA K5
 CMP K7
 BCC L613E

 BNE L613E

 LDA K4
 CMP K6

.L613E

 BCC L6153

 LDA K4
 STA K1
 LDA K5
 STA K2
 JSR L4BC3

 LDA K1
 STA K6
 LDA K2
 STA K7

.L6153

 BIT L495C
 BMI L615B

 JSR L373D

.L615B

 RTS

 EQUB &00

\ ******************************************************************************
\
\       Name: 
\       Type: Subroutine
\   Category: Loader
\    Summary: 
\
\ ******************************************************************************

.L615D

 LDA K7
 BEQ L6172

 LDA K7
 CMP K9
 BCC L616D

 BNE L616D

 LDA K6
 CMP K8

.L616D

 BCS L6172

 JMP L49D6

.L6172

 LDA K5
 BEQ L6187

 LDA K5
 CMP K9
 BCC L6182

 BNE L6182

 LDA K4
 CMP K8

.L6182

 BCS L6187

 JMP L499C

.L6187

 RTS

 LDA K5
 BEQ L61C2

 LDA K5
 CMP K9
 BCC L6198

 BNE L6198

 LDA K4
 CMP K8

.L6198

 BEQ L61C2

 BCC L61C2

 BIT L0AC1
 BEQ L61BB

 LDA K7
 CMP K9
 BCC L61AD

 BNE L61AD

 LDA K6
 CMP K8

.L61AD

 BEQ L61BA

 LDA K8
 STA K4
 LDA K9
 STA K5
 JSR L373D

.L61BA

 RTS

.L61BB

 JSR L4BCC

 JSR L373D

 RTS

.L61C2

 LDA K7
 BEQ L61FB

 LDA K7
 CMP K9
 BCC L61D2

 BNE L61D2

 LDA K6
 CMP K8

.L61D2

 BEQ L61FB

 BCC L61FB

 BIT L0AC1
 BEQ L61F0

 LDA K5
 CMP K9
 BCC L61E7

 BNE L61E7

 LDA K4
 CMP K8

.L61E7

 BEQ L61EF

 JSR L4BBA

 JSR L373D

.L61EF

 RTS

.L61F0

 LDA K6
 STA K8
 LDA K7
 STA K9
 JSR L373D

.L61FB  

 RTS

 LDA K3
 STA K4

\ ******************************************************************************
\
\ Save output/ELITE2.bin
\
\ ******************************************************************************

PRINT "S.ELITE3 ", ~CODE%, " ", ~P%, " ", ~LOAD%, " ", ~LOAD%
SAVE "versions/disc/output/ELITE3.bin", CODE%, P%, LOAD%


\ ******************************************************************************
\
\ APPLE II ELITE LOADER SOURCE
\
\ Apple II Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1986
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
\ This source file contains code to move binaries in memory during the loading
\ process.
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * SEC3.bin
\
\ ******************************************************************************

 INCLUDE "versions/apple/1-source-files/main-sources/elite-build-options.asm"

 _CASSETTE_VERSION      = (_VERSION = 1)
 _DISC_VERSION          = (_VERSION = 2)
 _6502SP_VERSION        = (_VERSION = 3)
 _MASTER_VERSION        = (_VERSION = 4)
 _ELECTRON_VERSION      = (_VERSION = 5)
 _ELITE_A_VERSION       = (_VERSION = 6)
 _NES_VERSION           = (_VERSION = 7)
 _C64_VERSION           = (_VERSION = 8)
 _APPLE_VERSION         = (_VERSION = 9)
 _IB_DISK                   = (_VARIANT = 1)
 _SOURCE_DISK_BUILD         = (_VARIANT = 2)
 _SOURCE_DISK_CODE_FILES    = (_VARIANT = 3)
 _SOURCE_DISK_ELT_FILES     = (_VARIANT = 4)
 _4AM_CRACK                 = (_VARIANT = 5)
 _SOURCE_DISK               = (_VARIANT = 2) OR (_VARIANT = 3) OR (_VARIANT = 4)

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 CODE% = &2000          \ The address where the code will be run

 LOAD% = &2000          \ The address where the code will be loaded

 startGame = &4000      \ ???

 phsoff = &C080         \ Disk controller I/O soft switch for turning the
                        \ stepper motor phase 0 off (PHASEOFF)

 mtroff = &C088         \ Disk controller I/O soft switch for turning the motor
                        \ off (MOTOROFF)

 mtron = &C089          \ Disk controller I/O soft switch for turning the motor
                        \ on (MOTORON)

 drv1en = &C08A         \ Disk controller I/O soft switch for enabling drive 1
                        \ (DRV0EN)

 drv2en = &C08B         \ Disk controller I/O soft switch for enabling drive 2
                        \ (DRV1EN)

 Q6L = &C08C            \ Disk controller I/O soft switch for strobing the data
                        \ latch for I/O (Q6L)

 Q6H = &C08D            \ Disk controller I/O soft switch for loading the data
                        \ latch (Q6H)

 Q7L = &C08E            \ Disk controller I/O soft switch for preparing the
                        \ latch for input (Q7L)

 Q7H = &C08F            \ Disk controller I/O soft switch for preparing the
                        \ latch for output (Q7H)

\ ******************************************************************************
\
\       Name: ZP
\       Type: Workspace
\    Address: &00F0 to &00F3
\   Category: Workspaces
\    Summary: Important variables used by the loader
\
\ ******************************************************************************

 ORG &00F0

.ztemp0

 SKIP 1                 \ Temporary storage used by the disk routines

.ztemp1

 SKIP 1                 \ Temporary storage used by the disk routines

.ztemp2

 SKIP 1                 \ Temporary storage used by the disk routines

.ztemp3

 SKIP 1                 \ Temporary storage used by the disk routines

INCLUDE "library/apple/loader/workspace/disk_operations.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%

\ ******************************************************************************
\
\       Name: Elite loader
\       Type: Subroutine
\   Category: Loader
\    Summary: C???
\
\ ******************************************************************************

.ENTRY

 JSR L24D7              \ ???

 JSR L247C              \ ???

 JSR L23DC              \ ???

 JSR L249B              \ ???

 JSR L245D              \ ???

 JSR L23DC              \ ???

 JMP startGame          \ ???

\ ******************************************************************************
\
\       Name: filename
\       Type: Variable
\   Category: Save and load
\    Summary: ???
\
\ ******************************************************************************

.filename

EQUS "ELB1"

\ ******************************************************************************
\
\       Name: comnam
\       Type: Variable
\   Category: Save and load
\    Summary: Storage for the commander filename, padded out with spaces to a
\             fixed size of 30 characters, for the rfile and wfile routines
\
\ ******************************************************************************

.comnam

EQUS "SCRN                          "

INCLUDE "library/apple/main/subroutine/findf.asm"
INCLUDE "library/apple/main/subroutine/rentry.asm"
INCLUDE "library/apple/main/subroutine/getsct.asm"
INCLUDE "library/apple/main/subroutine/gettsl.asm"
INCLUDE "library/apple/main/subroutine/rvtoc.asm"
INCLUDE "library/apple/main/subroutine/rsect.asm"
INCLUDE "library/apple/main/subroutine/wsect.asm"
INCLUDE "library/apple/main/subroutine/rwts.asm"
INCLUDE "library/apple/main/subroutine/trytrk.asm"
INCLUDE "library/apple/main/subroutine/rdrght.asm"

\ ******************************************************************************
\
\       Name: drverr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Return from the RWTS code with a "Disk I/O error"
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The error number for the Disk I/O error (4)
\
\   C flag              The C flag is set
\
\ ******************************************************************************

.drverr

 PLP                    \ ??? 

 LDY mtroff,X           \ Read the disk controller I/O soft switch at MOTOROFF
                        \ for slot X to turn the disk motor off

 SEC                    \ Set the C flag to denote that an error has occurred

 LDA #4                 \ Set A = 4 to return as the error number for the "Disk
                        \ I/O error"

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: rttrk
\       Type: Subroutine
\   Category: Save and load
\    Summary: Read or write a sector on the current track
\
\ ******************************************************************************

.rttrk

 LDY sector             \ Use the scttab lookup table to set A to the physical
 LDA scttab,Y           \ sector number of logical sector Y

 CMP idfld+1            \ If the physical sector number doesn't match the sector
 BNE trytr4             \ ID, jump to trytr4 to try reading the track again

 PLP                    \ Fetch the read/write status into the C flag from the
                        \ stack

 BCS rttrk2             \ If the C flag is set then we are writing a sector, so
                        \ jump to rttrk2 to write the sector to the disk

 JSR read               \ Otherwise we are reading a sector, so call the read
                        \ routine to read the current sector into the buffer at
                        \ buffr2, which will load the entire commander file as
                        \ it fits into one sector
                        \
                        \ Note that this loads the file straight from disk, so
                        \ it is in the 6-bit nibble format

 PHP                    \ Store the status flags on the stack, so if we take the
                        \ following branch, the stack will be in the correct
                        \ state, with the read/write status on top

 BCS trytr4             \ If there was an error then the read routine will have
                        \ set the C flag, so if this is the case, jump to trytr4
                        \ to try reading the track again

 PLP                    \ Otherwise there was no error, so pull the status flags
                        \ back off the stack as we don't need them there any
                        \ more

 JSR pstnib             \ Call pstnib to convert the sector data that we just
                        \ read into 8-bit bytes, processing the 6-bit nibbles in
                        \ buffr2 into 8-bit bytes in buffer

 JMP rttrk3             \ Jump to rttrk3 to return from the RWTS code with no
                        \ error reported

.rttrk2

 JSR write              \ This does nothing except clear the C flag, as we do
                        \ not need to write anything to disk in the game loader

 LDA #1                 \ Set A = 1 to return as the error number for the "Disk
                        \ write protected" error

 BCS rttrk4             \ This beanch is never taken as the call to write clears
                        \ the C flag

                        \ Fall through into rttrk3 to successfully return from
                        \ the RWTS code with no error reported

\ ******************************************************************************
\
\       Name: rttrk3
\       Type: Subroutine
\   Category: Save and load
\    Summary: Successfully return from the RWTS code with no error reported
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The error number for no error (0)
\
\   C flag              The C flag is clear
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   rttrk4              Turn off the disk motor and return from the RWTS code
\                       with the error number in A and the error status in the
\                       C flag
\
\ ******************************************************************************

.rttrk3

 LDA #0                 \ Set A = 0 to indicate there is no error

 CLC                    \ Clear the C flag to indicate there is no disk error

.rttrk4

 PHA                    \ Store A on the stack so we can retrieve it below,
                        \ though this has no effect as A is not changed in the
                        \ following

 LDX slot16             \ Set X to the disk controller card slot number * 16

 LDY mtroff,X           \ Read the disk controller I/O soft switch at MOTOROFF
                        \ for slot X to turn the disk motor off

 PLA                    \ Retrieve A from the stack

 RTS                    \ Return from the subroutine

INCLUDE "library/apple/main/subroutine/read.asm"

\ ******************************************************************************
\
\       Name: write
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write a sector's worth of data from the buffr2 buffer to the
\             current track and sector
\
\ ------------------------------------------------------------------------------
\
\ This routine does nothing except clear the C flag to indicate success, as we
\ do not need to write to disk in the game loader.
\
\ ******************************************************************************

.write

 CLC                    \ Clear the C flag to indicate success

 RTS                    \ Return from the subroutine

INCLUDE "library/apple/main/subroutine/rdaddr.asm"
INCLUDE "library/apple/main/subroutine/seek.asm"
INCLUDE "library/apple/main/subroutine/armwat.asm"
INCLUDE "library/apple/main/variable/armtab.asm"
INCLUDE "library/apple/main/variable/armtb2.asm"

\ ******************************************************************************
\
\       Name: prenib
\       Type: Subroutine
\   Category: Save and load
\    Summary: Convert 256 8-bit bytes in buffer into 342 6-bit nibbles in buffr2
\
\ ------------------------------------------------------------------------------
\
\ This routine does nothing, as we do not need to write to disk in the game
\ loader.
\
\ ******************************************************************************

.prenib

 RTS                    \ Return from the subroutine

INCLUDE "library/apple/main/subroutine/pstnib.asm"

\ ******************************************************************************
\
\       Name: wbyte
\       Type: Subroutine
\   Category: Save and load
\    Summary: Write one byte to disk
\
\ ------------------------------------------------------------------------------
\
\ This routine does nothing, as we do not need to write to disk in the game
\ loader.
\
\ ******************************************************************************

.wbyte

 RTS

 RTS                    \ These instructions are not used
 RTS

INCLUDE "library/apple/main/variable/scttab.asm"

 NOP                    \ This instruction is not used

INCLUDE "library/apple/main/variable/rtable.asm"

\ ******************************************************************************
\
\       Name: L23DC
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L23DC

 LDA #&0C
 STA &24D5
 JSR findf
 BCS L243E
 JSR gettsl
 JSR L243F

.L23EC

 JSR rsect
 LDY &24D4
 LDX #&00

.L23F4

 LDA &25D6,Y
 STA &4000,X
 JSR L244B
 BMI L243E
 INX
 INY
 BNE L23F4
 INC &23F9
 LDA &23F8
 SEC
 SBC &24D4
 STA &23F8
 LDA &23F9
 SBC #&00
 STA &23F9
 LDA &24D4
 BEQ L2422
 LDA #&00
 STA &24D4

.L2422

 INC &24D5
 INC &24D5
 LDY &24D5
 LDA &24D6,Y
 STA &0300
 LDA L24D7,Y
 STA &0301
 BNE L23EC
 LDA &0300
 BNE L23EC

.L243E

 RTS

\ ******************************************************************************
\
\       Name: L243F
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L243F

 LDY #&00

.L2441

 LDA &25D6,Y
 STA &24D6,Y
 INY
 BNE L2441
 RTS

\ ******************************************************************************
\
\       Name: L244B
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L244B

 LDA &24D2
 SEC
 SBC #&01
 STA &24D2
 LDA &24D3
 SBC #&00
 STA &24D3
 RTS

\ ******************************************************************************
\
\       Name: L245D
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L245D

 LDA #&04
 STA &24D4
 LDA #&FF
 STA &24D2
 LDA #&4F
 STA &24D3
 LDA #&00
 STA &24D6
 LDA #&00
 STA &23F8
 LDA #&40
 STA &23F9
 RTS

\ ******************************************************************************
\
\       Name: L247C
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L247C

 LDA #&04
 STA &24D4
 LDA #&80
 STA &24D2
 LDA #&08
 STA &24D3
 LDA #&00
 STA &24D6
 LDA #&00
 STA &23F8
 LDA #&02
 STA &23F9
 RTS

\ ******************************************************************************
\
\       Name: L249B
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L249B

 LDY #&00

.L249D

 LDA filename,Y
 STA &2019,Y
 INY
 CPY #&04
 BNE L249D
 RTS
 LDA #&00
 STA &4562
 LDA &C064
 CMP #&FF
 BNE L24CF
 LDA &C065
 CMP #&FF
 BNE L24CF
 LDA &C066
 CMP #&FF
 BNE L24CF
 LDA &C067
 CMP #&FF
 BNE L24CF
 LDA #&FF
 STA &4562

.L24CF

 JMP startGame

\ ******************************************************************************
\
\       Name: L24D2
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L24D2

 EQUB &FF

\ ******************************************************************************
\
\       Name: L24D3
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L24D3

 EQUB &4F

\ ******************************************************************************
\
\       Name: L24D4
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L24D4

 EQUB &04

\ ******************************************************************************
\
\       Name: L24D5
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L24D5

 EQUB &00

\ ******************************************************************************
\
\       Name: L24D6
\       Type: Variable
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L24D6

 EQUB &00

\ ******************************************************************************
\
\       Name: L24D7
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

.L24D7

 LDA #&00
 STA &F4
 LDA #&40
 STA &F5
 LDA #&00
 STA &F6
 LDA #&90
 STA &F7
 LDX #&30
 LDY #&00

.L24EB

 LDA (&F4),Y
 STA (&F6),Y
 INY
 BNE L24EB
 INC &F5
 INC &F7
 DEX
 BNE L24EB
 RTS

\ ******************************************************************************
\
\ Save SEC3.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 SAVE "versions/apple/3-assembled-output/SEC3.bin", CODE%, P%, LOAD%

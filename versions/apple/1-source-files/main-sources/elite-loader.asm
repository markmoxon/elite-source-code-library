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

 startGame = &4000      \ The entry point for the main game binary

 fireButtonMask = &4562 \ The address of the variable that controls the
                        \ joystick selection on the title screen

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

INCLUDE "library/apple/loader/workspace/zp.asm"
INCLUDE "library/apple/loader/workspace/disk_operations.asm"

\ ******************************************************************************
\
\ ELITE LOADER
\
\ ******************************************************************************

 ORG CODE%              \ Set the assembly address to CODE%

INCLUDE "library/apple/loader/subroutine/elite_loader.asm"
INCLUDE "library/apple/loader/variable/filename.asm"
INCLUDE "library/apple/loader/variable/comnam.asm"
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
INCLUDE "library/apple/loader/subroutine/drverr.asm"
INCLUDE "library/apple/loader/subroutine/rttrk.asm"
INCLUDE "library/apple/loader/subroutine/rttrk3.asm"
INCLUDE "library/apple/main/subroutine/read.asm"
INCLUDE "library/apple/loader/subroutine/write.asm"
INCLUDE "library/apple/main/subroutine/rdaddr.asm"
INCLUDE "library/apple/main/subroutine/seek.asm"
INCLUDE "library/apple/main/subroutine/armwat.asm"
INCLUDE "library/apple/main/variable/armtab.asm"
INCLUDE "library/apple/main/variable/armtb2.asm"
INCLUDE "library/apple/loader/subroutine/prenib.asm"
INCLUDE "library/apple/main/subroutine/pstnib.asm"
INCLUDE "library/apple/loader/subroutine/wbyte.asm"

 RTS                    \ These instructions are not used
 RTS

INCLUDE "library/apple/main/variable/scttab.asm"

 NOP                    \ This instruction is not used

INCLUDE "library/apple/main/variable/rtable.asm"
INCLUDE "library/apple/loader/subroutine/loadfile.asm"
INCLUDE "library/apple/loader/subroutine/copytracksector.asm"
INCLUDE "library/apple/loader/subroutine/decrementfilesize.asm"
INCLUDE "library/apple/loader/subroutine/setloadvariables2.asm"
INCLUDE "library/apple/loader/subroutine/setloadvariables1.asm"
INCLUDE "library/apple/loader/subroutine/setfilename.asm"
INCLUDE "library/apple/loader/subroutine/allowjoystick.asm"
INCLUDE "library/apple/loader/variable/filesize.asm"
INCLUDE "library/apple/loader/variable/skipbytes.asm"
INCLUDE "library/apple/loader/variable/tslindex.asm"
INCLUDE "library/apple/loader/variable/tracksector.asm"
INCLUDE "library/apple/loader/subroutine/copycode2.asm"

\ ******************************************************************************
\
\ Save SEC3.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 SAVE "versions/apple/3-assembled-output/SEC3.bin", CODE%, P%, LOAD%

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
\    Address: &00F0 to &00F7
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

.fromAddr

 SKIP 2                 \ The address to copy from in the CopyMemory routine

.toAddr

 SKIP 2                 \ The address to copy to in the CopyMemory routine

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

                        \ The ELITE BASIC program has already run by this point,
                        \ which loads the ELA file into memory at &0A00 to &7210
                        \ before running the SEC3 loader (this file) at &2000

 JSR CopyMemory         \ Copy memory from &4000-&6FFF to &9000-&BFFF
                        \
                        \ This copies the CODE2 block that was loaded as part of
                        \ the ELA file into &9000 to &BFFF

 JSR SetLoadVariables1  \ Configure the file load variables as follows:
                        \
                        \   * skipBytes = 4
                        \
                        \   * fileSize(1 0) = &0880
                        \
                        \   * trackSector = 0
                        \
                        \   * loadAddr = STA &0200,X

 JSR LoadFile           \ Load the SCRN file of size &0880 at &0200 (though this
                        \ isn't actually used)

 JSR SetFilename        \ Set the filename in comnam to ELB1

 JSR SetLoadVariables2  \ Configure the file load variables as follows:
                        \
                        \   * skipBytes = 4
                        \
                        \   * fileSize(1 0) = &4FFF
                        \
                        \   * trackSector = 0
                        \
                        \   * loadAddr = STA &4000,X

 JSR LoadFile           \ Load the ELB1 file of size &4FFF at &4000, so that's
                        \ from &4000 to &8FFF
                        \
                        \ ELB1 contains the CODE1 block of the main game binary,
                        \ so the end result of all this loading is:
                        \
                        \   * CODE1 from &4000 to &8FFF
                        \
                        \   * CODE2 from &9000 to &BFFF
                        \
                        \ In other words the game binary is now loaded and in
                        \ the correct location for the game to run

 JMP startGame          \ Jump to startGame to start the game

\ ******************************************************************************
\
\       Name: filename
\       Type: Variable
\   Category: Save and load
\    Summary: The filename of the second file to load
\
\ ******************************************************************************

.filename

EQUS "ELB1"

\ ******************************************************************************
\
\       Name: comnam
\       Type: Variable
\   Category: Save and load
\    Summary: The filename of the first file to load, padded out with spaces to
\             a fixed size of 30 characters for the rfile routine
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
\       Name: LoadFile
\       Type: Subroutine
\   Category: Loader
\    Summary: Load a multi-sector file
\
\ ******************************************************************************

.LoadFile

 LDA #12                \ Set tslIndex = 12, so we can use this as an index into
 STA tslIndex           \ the track/sector list for the file we want to load,
                        \ starting with the index of the first track/sector pair
                        \ in byte #12

 JSR findf              \ Search the disk catalog for a file with the filename
                        \ in comnam

 BCS L243E              \ If no file is found with this name then findf will
                        \ set the C flag, so jump to rfile3 to return from the
                        \ subroutine as the file cannot be found

 JSR gettsl             \ Get the track/sector list of the file and populate the
                        \ track and sector variables with the track and sector
                        \ of the file's contents, to pass to the call to rsect

 JSR CopyTrackSector    \ Copy the track/sector list from the buffer into
                        \ trackSector so we can work our way through it to load
                        \ the file one sector at a time

.load1

 JSR rsect              \ Read the first sector of the file's data into the
                        \ buffer (or the next sector if we loop back from below)

 LDY skipBytes          \ Set Y to the number of bytes to skip from the start of
                        \ the file, so we can use it as a starting index into
                        \ the first sector that we copy

 LDX #0                 \ Set X = 0 to act as a byte index into the destination
                        \ address for the file

.load2

 LDA buffer,Y           \ Set A to the Y-th byte in the buffer

.loadAddr

 STA &4000,X            \ And copy it to the X-th byte of the load address,
                        \ which by this point has been modified to the correct
                        \ load address by the SetLoadVariables1 or
                        \ SetLoadVariables2 routine

 JSR DecrementFileSize  \ Decrement the file size in fileSize(1 0) by 1 as we
                        \ have just loaded one more byte of the file

 BMI L243E              \ If the result is negative then we have copied all
                        \ fileSize(1 0) bytes, so jump to L243E to return from the
                        \ subroutine

 INX                    \ Increment the destination index in X

 INY                    \ Increment the source index in Y

 BNE load2              \ Loop back until we have reached the end of the page
                        \ page in the source index

 INC loadAddr+2         \ Modify the loadAddr address above by incrementing
                        \ the high byte to point to the next page

 LDA loadAddr+1         \ Subtract skipBytes from the loadAddr address ???
 SEC
 SBC skipBytes
 STA loadAddr+1
 LDA loadAddr+2
 SBC #0
 STA loadAddr+2

 LDA skipBytes          \ Set skipBytes = 0 so we don't skip any bytes from the
 BEQ load3              \ remaining sectors (as we only want to skip bytes from
 LDA #0                 \ the first sector)
 STA skipBytes

.load3

 INC tslIndex           \ Set tslIndex = tslIndex + 2 to point to the next track
 INC tslIndex           \ and sector pair in the track/sector list

 LDY tslIndex           \ Set track to the track number from the next pair in
 LDA trackSector,Y      \ the track/sector list
 STA track

 LDA trackSector+1,Y    \ Set sector to the sector number from the next pair in
 STA sector             \ the track/sector list

 BNE load1              \ If either the track or sector number is non-zero, loop
 LDA track              \ back to load1 to load the next sector
 BNE load1

.L243E

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: CopyTrackSector
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy the track/sector list from the disk buffer to trackSector
\
\ ******************************************************************************

.CopyTrackSector

 LDY #0                 \ Set Y = 0 to use as a byte counter

.L2441

 LDA buffer,Y           \ Copy the Y-th byte of buffer to the Y-th byte of
 STA trackSector,Y      \ trackSector

 INY                    \ Increment the byte counter

 BNE L2441              \ Loop back until we have copied a whole page of data

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DecrementFileSize
\       Type: Subroutine
\   Category: Loader
\    Summary: Decrement the file size in fileSize(1 0) by 1
\
\ ******************************************************************************

.DecrementFileSize

 LDA fileSize           \ Set fileSize(1 0) = fileSize(1 0) - 1
 SEC
 SBC #1
 STA fileSize
 LDA fileSize+1
 SBC #0
 STA fileSize+1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetLoadVariables2
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure the file load variables for loading the ELB1 file
\
\ ******************************************************************************

.SetLoadVariables2

 LDA #4                 \ Set skipBytes = 4 so we skip the first four bytes of
 STA skipBytes          \ the file (as these contain the program start address
                        \ and file length)

 LDA #&FF               \ Set fileSize(1 0) = &4FFF
 STA fileSize
 LDA #&4F
 STA fileSize+1

 LDA #0                 \ Set trackSector = 0
 STA trackSector

 LDA #&00               \ Modify the instruction at loadAddr to STA &4000,X
 STA loadAddr+1
 LDA #&40
 STA loadAddr+2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetLoadVariables1
\       Type: Subroutine
\   Category: Loader
\    Summary: Configure the file load variables for loading the SCRN file
\
\ ******************************************************************************

.SetLoadVariables1

 LDA #4                 \ Set skipBytes = 4 so we skip the first four bytes of
 STA skipBytes          \ the file (as these contain the program start address
                        \ and file length)

 LDA #&80               \ Set fileSize(1 0) = &0880
 STA fileSize
 LDA #&08
 STA fileSize+1

 LDA #0                 \ Set trackSector = 0
 STA trackSector

 LDA #&00               \ Modify the instruction at loadAddr to STA &0200,X
 STA loadAddr+1
 LDA #&02
 STA loadAddr+2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetFilename
\       Type: Subroutine
\   Category: Loader
\    Summary: Set the filename in comnam to ELB1
\
\ ******************************************************************************

.SetFilename

 LDY #0                 \ Set Y = 0 to use as a character counter

.name1

 LDA filename,Y         \ Copy the Y-th character of filename to the Y-th
 STA comnam,Y           \ character of comnam

 INY                    \ Increment the character counter

 CPY #4                 \ Loop back until we have copied all four characters of
 BNE name1              \ filename to comnam

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ???
\       Type: Subroutine
\   Category: Loader
\    Summary: ???
\
\ ******************************************************************************

 LDA #0                 \ These instructions are not used ???
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

 JMP startGame          \ This instruction is not used

\ ******************************************************************************
\
\       Name: fileSize
\       Type: Variable
\   Category: Loader
\    Summary: The file size of the file we are loading
\
\ ******************************************************************************

.fileSize

 EQUW &4FFF

\ ******************************************************************************
\
\       Name: skipBytes
\       Type: Variable
\   Category: Loader
\    Summary: The number of bytes to skip at the start of the file that we are
\             loading
\
\ ******************************************************************************

.skipBytes

 EQUB 4

\ ******************************************************************************
\
\       Name: tslIndex
\       Type: Variable
\   Category: Loader
\    Summary: The index of the current entry in the track/sector list, as we
\             work our way through the list
\
\ ******************************************************************************

.tslIndex

 EQUB 0

\ ******************************************************************************
\
\       Name: trackSector
\       Type: Variable
\   Category: Loader
\    Summary: The track/sector list for the file we are loading
\
\ ******************************************************************************

.trackSector

 EQUB 0

\ ******************************************************************************
\
\       Name: CopyMemory
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy memory from &4000-&6FFF to &9000-&BFFF
\
\ ******************************************************************************

.CopyMemory

 LDA #&00               \ Set fromAddr(1 0) = &4000
 STA fromAddr
 LDA #&40
 STA fromAddr+1

 LDA #&00               \ Set toAddr(1 0) = &9000
 STA toAddr
 LDA #&90
 STA toAddr+1

 LDX #&30               \ Set X = &30 to use as a page counter, so we copy
                        \ &4000-&6FFF to &9000-&BFFF

 LDY #0                 \ Set Y = 0 to use as a byte counter

.copy1

 LDA (fromAddr),Y       \ Copy the Y-th byte of fromAddr(1 0) to the Y-th byte
 STA (toAddr),Y         \ of toAddr(1 0)

 INY                    \ Increment the byte counter

 BNE copy1              \ Loop back until we have copied a whole page of bytes

 INC fromAddr+1         \ Increment the high bytes of fromAddr(1 0) and
 INC toAddr+1           \ toAddr(1 0) so they point to the next page in memory

 DEX                    \ Decrement the page counter

 BNE copy1              \ Loop back until we have copied X pages

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\ Save SEC3.bin
\
\ ******************************************************************************

 PRINT "P% = ", ~P%
 SAVE "versions/apple/3-assembled-output/SEC3.bin", CODE%, P%, LOAD%

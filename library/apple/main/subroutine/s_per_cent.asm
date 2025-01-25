\ ******************************************************************************
\
\       Name: S%
\       Type: Subroutine
\   Category: Loader
\    Summary: Checksum, decrypt and unscramble the main game code, and start the
\             game
\
\ ******************************************************************************

 RTS                    \ The checksum byte goes here, at S%-1. In the original
                        \ source this byte is set by the first call to ZP in the
                        \ Big Code File, though in the BeebAsm version this is
                        \ populated by elite-checksum.py

.S%

IF _SOURCE_DISK

 CLD                    \ Clear the D flag to make sure we are in binary mode

ENDIF

 LDA #LO(STORE)         \ Set SC(1 0) = STORE
 STA SC                 \
 LDA #HI(STORE)         \ So SC(1 0) contains the address where the dashboard
 STA SC+1               \ image was loaded

 LDA #LO(CODE2)         \ Set P(1 0) = CODE2
 STA P                  \
 LDA #HI(CODE2)         \ So P(1 0) contains the address where we want to store
 STA P+1                \ the dashboard image in screen memory

IF _IB_DISK OR _4AM_CRACK

 LDX #7                 \ Set X = 7 so we copy eight pages of memory from
                        \ SC(1 0) to P(1 0) in the following loop

ELIF _SOURCE_DISK

                        \ On the source disk, there is a transfer program that
                        \ packs the entire game binary into memory, ready to be
                        \ transmitted to a connected Apple II computer
                        \
                        \ The transfer program copies the second block of the
                        \ game binary (from CODE2 onwards) into bank-switched
                        \ RAM at &D000, so the following copies it back to the
                        \ correct address of &9000
                        \
                        \ See the transfer source code in elite-transfer.asm

 LDA &C08B              \ Set RAM bank 1 to read RAM and write RAM by reading
                        \ the RDWRBSR1 soft switch, with bit 3 set (bank 1),
                        \ bit 1 set (read RAM) and bit 0 set (write RAM)
                        \
                        \ So this enables bank-switched RAM at &D000

 LDX #(&C0-&90)         \ We want to copy all the data from &D000 into main
                        \ memory between &9000 and &C000, so set X to the number
                        \ of pages to copy from SC(1 0) to P(1 0) in the
                        \ following loop

ENDIF

 LDY #0                 \ Set Y = 0 to use as a byte counter

.Sept3

 LDA (SC),Y             \ Copy the Y-th byte of SC(1 0) to the Y-th byte of
 STA (P),Y              \ P(1 0)

 INY                    \ Increment the byte counter

 BNE Sept3              \ Loop back until we have copied a whole page of bytes

 INC SC+1               \ Increment the high bytes of SC(1 0) and P(1 0) so they
 INC P+1                \ point to the next page in memory

 DEX                    \ Decrement the page counter

IF _IB_DISK OR _4AM_CRACK

 BPL Sept3              \ Loop back until we have copied X + 1 pages

ELIF _SOURCE_DISK

 BNE Sept3              \ Loop back until we have copied X pages

ENDIF

IF _SOURCE_DISK

 LDA &C081              \ Set ROM bank 2 to read ROM and write RAM by reading
                        \ the WRITEBSR2 soft switch, with bit 3 clear (bank 2),
                        \ bit 1 clear (read ROM) and bit 0 set (write RAM)

ENDIF

 JSR DEEOR              \ Decrypt the main game code between &1300 and &9FFF

\JSR Checksum           \ This instruction is commented out in the original
                        \ source

IF _IB_DISK OR _4AM_CRACK

 LDA #&30               \ This modifies the RDKEY routine so the BPL at nokeys2
 STA nokeys2+4          \ jumps to nofast+2 rather than nojoyst (though this has
 NOP                    \ no effect as the binary has already been modified,
 NOP                    \ perhaps because the version on Ian Bell's site is a
                        \ hacked version that may have been extracted from
                        \ memory)

ENDIF

 JSR COLD               \ Initialise the screen mode, clear memory and set up
                        \ interrupt handlers

 JMP BEGIN              \ Jump to BEGIN to start the game


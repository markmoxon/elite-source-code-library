\ ******************************************************************************
\
\       Name: scramble
\       Type: Subroutine
\   Category: Loader
IF _DISC_FLIGHT \ Comment
\    Summary: Decrypt the main flight code between &1300 and &55FF and jump into
\             the main game loop
ELIF _DISC_DOCKED
\    Summary: Decrypt the main docked code between &1300 and &5FFF and
\             the main game loop
ENDIF
\
\ ******************************************************************************

.scramble

 LDY #0                 \ We're going to work our way through a large number of
                        \ encrypted bytes, so we set Y to 0 to be the index of
                        \ the current byte within its page in memory

 STY SC                 \ Set the low byte of SC(1 0) to 0

 LDX #&13               \ Set X to &13 to be the page number of the current
                        \ byte, so we start the decryption with the first byte
                        \ of page &13

.scrl

 STX SCH                \ Set the high byte of SC(1 0) to X, so SC(1 0) now
                        \ points to the first byte of page X

 TYA                    \ Set A to Y, so A now contains the index of the current
                        \ byte within its page

 EOR (SC),Y             \ EOR the current byte with its index within the page

 EOR #&33               \ EOR the current byte with &33

 STA (SC),Y             \ Update the current byte

                        \ The current byte is in page X at offset Y, and SC(1 0)
                        \ points to the first byte of page X, so we just did
                        \  this:
                        \
                        \   (X Y) = (X Y) EOR Y EOR &33

 DEY                    \ Decrement the index in Y to point to the next byte

 BNE scrl               \ Loop back to scrl to decrypt the next byte until we
                        \ have done the whole page

 INX                    \ Increment X to point to the next page in memory

IF _DISC_FLIGHT \ Platform

 CPX #&56               \ Loop back to scrl to decrypt the next page until we
 BNE scrl               \ reach the start of page &56

 JMP RSHIPS             \ Call RSHIPS to launch from the station, load a new set
                        \ of ship blueprints and jump into the main game loop

ELIF _DISC_DOCKED

 CPX #&60               \ Loop back to scrl to decrypt the next page until we
 BNE scrl               \ reach the start of page &60

 JMP BRKBK              \ Call BRKBK to set BRKV to point to the BRBR routine
                        \ and return from the subroutine using a tail call
ENDIF


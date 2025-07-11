\ ******************************************************************************
\
\       Name: RDKEY
\       Type: Subroutine
\   Category: Keyboard
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\    Summary: Scan the keyboard for key presses
ELIF _MASTER_VERSION
\    Summary: Scan the keyboard for key presses and update the key logger
ELIF _6502SP_VERSION
\    Summary: Scan the keyboard for key presses by sending an OSWORD 240 command
\             to the I/O processor
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Scan the keyboard, starting with internal key number 16 ("Q") and working
\ through the set of internal key numbers (see page 142 of the "Advanced User
\ Guide for the BBC Micro" by Bray, Dickens and Holmes for a list of internal
\ key numbers).
ELIF _ELECTRON_VERSION
\ Scan the keyboard, starting with internal key number 16 ("Q") and working
\ through the set of internal key numbers (see page 40 of the "Acorn Electron
\ Advanced User Guide" by Holmes and Dickens for a list of internal key
\ numbers).
ELIF _MASTER_VERSION
\ Scan the keyboard, starting with internal key number 16 ("Q") and working
\ through the set of internal key numbers, returning the resulting key press in
\ ASCII. The key logger is also updated.
ELIF _6502SP_VERSION
\ This routine sends an OSWORD 240 command to the I/O processor to ask it to
\ scan the keyboard, starting with internal key number 16 ("Q") and working
\ through the set of internal key numbers (see page 142 of the "Advanced User
\ Guide for the BBC Micro" by Bray, Dickens and Holmes for a list of internal
\ key numbers). The results are copied from the I/O processor into the key
\ logger buffer at KTRAN.
ENDIF
\
\ This routine is effectively the same as OSBYTE 122, though the OSBYTE call
\ preserves A, unlike this routine.
\
IF _ELITE_A_6502SP_IO
\ If CTRL-P is pressed, then the routine calls the printer routine to print the
\ screen, and returns 0 in A and X.
\
ENDIF
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
ELIF _MASTER_VERSION
\   X                   If a key is being pressed, X contains the ASCII code
\                       of the key pressed, otherwise it contains 0
ENDIF
IF NOT(_ELITE_A_6502SP_IO)
\
\   A                   Contains the same as X
ENDIF
\
IF _MASTER_VERSION \ Comment
\   Y                   Y is preserved
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RDKEY-1             Only scan the keyboard for valid BCD key numbers
\
ENDIF
\ ******************************************************************************

IF _MASTER_VERSION \ Platform

 SED                    \ Set the D flag to enter decimal mode. Because
                        \ internal key numbers are all valid BCD (Binary Coded
                        \ Decimal) numbers, setting this flag ensures we only
                        \ loop through valid key numbers

ENDIF

.RDKEY

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform

 LDX #16                \ Start the scan with internal key number 16 ("Q")

.Rd1

 JSR DKS4               \ Scan the keyboard to see if the key in X is currently
                        \ being pressed, returning the result in A and X

 BMI Rd2                \ Jump to Rd2 if this key is being pressed (in which
                        \ case DKS4 will have returned the key number with bit
                        \ 7 set, which is negative)

 INX                    \ Increment the key number, which was unchanged by the
                        \ above call to DKS4

 BPL Rd1                \ Loop back to test the next key, ending the loop when
                        \ X is negative (i.e. 128)

 TXA                    \ If we get here, nothing is being pressed, so copy X
                        \ into A so that X = A = 128 = %10000000

.Rd2

 EOR #%10000000         \ EOR A with #%10000000 to flip bit 7, so A now contains
                        \ 0 if no key has been pressed, or the internal key
                        \ number if a key has been pressed

ELIF _6502SP_VERSION

 LDA #240               \ Set A in preparation for sending an OSWORD 240 command

 LDY #HI(buf)           \ Set (Y X) to point to the parameter block at buf
 LDX #LO(buf)

 JSR OSWORD             \ Send an OSWORD 240 command to the I/O processor to
                        \ scan the keyboard and joysticks, and populate the key
                        \ logger buffer in KTRAN, which is the part of the buf
                        \ buffer just after the two OSWORD size bytes

 LDX KTRAN              \ Set X to the first byte of the updated KTRAN, which
                        \ contains the internal key number of the key being
                        \ pressed, or 0 if there is no key press

 TXA                    \ Copy X into A

ELIF _MASTER_VERSION

 TYA                    \ Store Y on the stack so we can retrieve it later
 PHA

 JSR FILLKL             \ Call FILLKL to scan the keyboard, update the key
                        \ logger and return any non-logger key presses in X

 PLA                    \ Retrieve the value of Y we stored above
 TAY

 LDA TRTB%,X            \ Fetch the internal key number for the key pressed

 STA KL                 \ Store the key pressed in KL

 TAX                    \ Copy the key value into X

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA \ Platform

 TAX                    \ Copy A into X

ELIF _ELECTRON_VERSION

 TAY                    \ Store A in Y so we can preserve it through the call to
                        \ CAPSL below

 JSR CAPSL              \ Call CAPSL to check whether CAPS LOCK is being pressed
                        \ (if it is, the return value in A is the key number of
                        \ CAPS LOCK, but with bit 7 set)

 PHP                    \ Retrieve the value of A we stored in Y, but making
 TYA                    \ sure the retrieval doesn't affect the flags
 PLP

 BPL P%+4               \ If the result of the call to CAPSL was positive, then
                        \ CAPS LOCK isn't being pressed, so skip the next
                        \ instruction

 ORA #%10000000         \ CAPS LOCK is being pressed, so set bit 7 of A

 TAX                    \ Copy the key value into X

ELIF _ELITE_A_6502SP_IO

 CMP #&37               \ If "P" was not pressed, jump to scan_test to return
 BNE scan_test          \ the key press

 LDX #1                 \ Set X to the internal key number for CTRL

 JSR DKS4               \ Scan the keyboard to see if the key in X (i.e. CTRL)
                        \ is currently pressed

 BPL scan_p             \ If it is not being pressed, jump to scan_p to return
                        \ "P" as the key press

 JSR printer            \ CTRL-P was pressed, so call printer to output the
                        \ screen to the printer

 LDA #0                 \ Set A to 0 to return no key press from the routine, as
                        \ we already acted on it

ENDIF

 RTS                    \ Return from the subroutine

IF _ELITE_A_6502SP_IO

.scan_p

 LDA #&37               \ Set A to the internal key number for "P", to return as
                        \ the result

.scan_test

 TAX                    \ Copy the key value into X

 RTS                    \ Return from the subroutine

ENDIF


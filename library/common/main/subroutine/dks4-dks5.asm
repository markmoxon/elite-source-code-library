\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Comment
\       Name: DKS4
ELIF _MASTER_VERSION
\       Name: DKS5
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION \ Comment
\       Type: Subroutine
ELIF _6502SP_VERSION
\       Type: Macro
ENDIF
\   Category: Keyboard
\    Summary: Scan the keyboard to see if a specific key is being pressed
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\   X                   The internal number of the key to check (see p.142 of
\                       the Advanced User Guide for a list of internal key
\                       numbers)
ELIF _ELECTRON_VERSION
\   X                   The internal number of the key to check (see p.40 of the
\                       Electron Advanced User Guide for a list of internal key
\                       numbers)
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   A                   The internal number of the key to check (see p.142 of
\                       the Advanced User Guide for a list of internal key
\                       numbers)
ELIF _C64_VERSION
\   X                   The internal number of the key to check
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF NOT(_C64_VERSION)
\   A                   If the key in A is being pressed, A contains the
\                       original argument A, but with bit 7 set (i.e. A + 128).
\                       If the key in A is not being pressed, the value in A is
\                       unchanged
\
ELIF _C64_VERSION
\   A                   &FF if the key is being pressed, 0 otherwise
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment
\   X                   Contains the same as A
\
ENDIF
IF _ELECTRON_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   CAPSL               Scan the keyboard to see if CAPS LOCK is being pressed
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

.DKS4

 LDA #%00000011         \ Set A to %00000011, so it's ready to send to SHEILA
                        \ once interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STA VIA+&40            \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDA #%01111111         \ Set 6522 System VIA data direction register DDRA
 STA VIA+&43            \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STX VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to X, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDX VIA+&4F            \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into X; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set,
                        \ otherwise it will be clear

 LDA #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STA VIA+&40            \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

 TXA                    \ Transfer X into A

 RTS                    \ Return from the subroutine

ELIF _ELECTRON_VERSION

.KSCAN

                        \ This routine is called from below, and performs the
                        \ actual keyboard scan

 SEC                    \ Set the C flag and clear the V flag, so when we call
 CLV                    \ KEYV, it scans the keyboard just like OSBYTE 121

 SEI                    \ Disable interrupts

 JMP (S%+4)             \ Jump to the original value of KEYV, which is stored in
                        \ S%+4. Because we set the C and V flags as above, this
                        \ will scan the keyboard like OSBYTE 121, which expects
                        \ X to be set to the internal key number to scan for,
                        \ EOR'd with %10000000. Unlike OSBYTE 121, a direct call
                        \ to KEYV will return negative value in both A and X if
                        \ that key is being pressed

.CAPSL

 LDX #&40               \ Set X to the internal key number for CAPS LOCK, and
                        \ fall through into DKS4 to check whether it is being
                        \ pressed

.DKS4

 TYA                    \ Store Y on the stack so we can retrieve it when we
 PHA                    \ return from the subroutine, thus preserving Y

 TXA                    \ Store the key number to check in X on the stack so
 PHA                    \ we can retrieve it below

 ORA #%10000000         \ Set bit 7 of the key to check for and transfer the
 TAX                    \ value to X

 JSR KSCAN              \ Call KSCAN to check whether the key in X is being
                        \ pressed, which returns a negative value in A and X
                        \ if it is

 CLI                    \ Enable interrupts again (as they are disabled in
                        \ KSCAN)

 TAX                    \ Set X to the result of the key press call above

 PLA                    \ Fetch the original argument value of X from the stack
 AND #%01111111         \ into A, and clear bit 7

 CPX #%10000000         \ If bit 7 of the result of the key press check above is
 BCC P%+4               \ set, then the key in X is being pressed, so skip the
                        \ next instruction

 ORA #%10000000         \ The key in X isn't being pressed, so set bit 7 of A

 TAX                    \ By this point, A contains the key number we wanted to
                        \ check for, with bit 7 set if the key is being pressed
                        \ and clear otherwise, which is what we want to return
                        \ from the subroutine, but first we need to restore the
                        \ value of Y from the stack, so we store the result A in
                        \ X while we do that

 PLA                    \ Restore the value Y that we stored on the stack, so it
 TAY                    \ gets preserved across calls to the subroutine

 TXA                    \ And we now retrieve the result that we stored in X
                        \ back into A, so we can return it

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

MACRO DKS4

 LDX #3                 \ Set X to 3, so it's ready to send to SHEILA once
                        \ interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STX VIA+&40            \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDX #%01111111         \ Set 6522 System VIA data direction register DDRA
 STX VIA+&43            \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STA VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to A, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDA VIA+&4F            \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into A; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set,
                        \ otherwise it will be clear

 LDX #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STX VIA+&40            \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

ENDMACRO

ELIF _MASTER_VERSION

IF _SNG47

.DKS5

 LDX #3                 \ Set X to 3, so it's ready to send to SHEILA once
                        \ interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STX VIA+&40            \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDX #%01111111         \ Set 6522 System VIA data direction register DDRA
 STX VIA+&43            \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STA VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to A, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDX VIA+&4F            \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into X; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set,
                        \ otherwise it will be clear

 LDA #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STA VIA+&40            \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

 TXA                    \ Transfer X into A

 RTS                    \ Return from the subroutine

ENDIF

ELIF _C64_VERSION

.DKS4

 LDA KEYLOOK,X          \ Fetch the entry from the key logger for the key in X

 TAX                    \ Copy A to X

 RTS                    \ Return from the subroutine

ENDIF


\ ******************************************************************************
\
\       Name: DKS4
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
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
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\   X                   The internal number of the key to check (see p.142 of
ELIF _6502SP_VERSION
\   A                   The internal number of the key to check (see p.142 of
ENDIF
\                       the Advanced User Guide for a list of internal key
\                       numbers)
\
\ Returns:
\
\   A                   If the key in A is being pressed, A contains the
\                       original argument A, but with bit 7 set (i.e. A + 128).
\                       If the key in A is not being pressed, the value in A is
\                       unchanged
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\   X                   Contains the same as A
\
\ Other entry points:
\
\   DKS2-1              Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION \ Minor

.DKS4

 LDA #3                 \ Set A to 3, so it's ready to send to SHEILA once
                        \ interrupts have been disabled

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
                        \ to X, the key we want to scan for; bits 0-6 will be
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

ENDIF


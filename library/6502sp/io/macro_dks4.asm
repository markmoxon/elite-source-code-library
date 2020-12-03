\ ******************************************************************************
\
\       Name: DKS4
\       Type: Macro
\   Category: Keyboard
\    Summary: Scan the keyboard to see if a specific key is being pressed
\
\ ------------------------------------------------------------------------------
\
\ Scan the keyboard to see if the key specified in A is currently being
\ pressed.
\
\ Arguments:
\
\   A                   The internal number of the key to check (see p.142 of
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
\ ******************************************************************************

MACRO DKS4

 LDX #3                 \ Set X to 3, so it's ready to send to SHEILA once
                        \ interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STX SHEILA+&40         \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDX #%01111111         \ Set 6522 System VIA data direction register DDRA
 STX SHEILA+&43         \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STA SHEILA+&4F         \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to X, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDA SHEILA+&4F         \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into A; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set (so A
                        \ will contain 128 + A), otherwise it will be clear (so
                        \ A will be unchanged)

 LDX #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STX SHEILA+&40         \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

ENDMACRO


\ ******************************************************************************
\
\       Name: scan_y
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the scan_y command (scan for a specific flight key or
\             Delta 14B button press)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a scan_y command. If the game is
\ configured to use the keyboard or standard joystick, then it scans the
\ keyboard for a specified flight key (given as an offset into the KYTB table),
\ or if the game is configured to use the Delta 14B joystick, it scans the
\ Delta 14B keyboard for the relevant button press. It returns 0 to the parasite
\ if the key is not being pressed, or &FF if it is.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   b_quit              Contains an RTS
\
\ ******************************************************************************

.scan_y

 JSR tube_get           \ Get the parameters from the parasite for the command:
 TAY                    \
 JSR tube_get           \   =scan_y(key_offset, delta_14b)
                        \
                        \ and store them as follows:
                        \
                        \   * Y = the KYTB offset of the key to scan for (1 for
                        \         the first key, 2 for the second etc.)
                        \
                        \   * A = the configuration byte for the Delta 14B
                        \         joystick

 BMI b_14               \ If bit 7 of A is set, then the configuration byte for
                        \ the Delta 14B joystick in BTSK must be &FF and the
                        \ Delta 14B stick is configured for use, so jump to b_14
                        \ to scan the Delta 14B joystick buttons

                        \ If we get here then we know A = 0, as BTSK is either
                        \ 0 or &FF, and we just confirmed that it's not the
                        \ latter

 LDX KYTB-1,Y           \ Set X to the relevant internal key number from the
                        \ KYTB table (we add Y to KYTB-1 rather than KYTB as Y
                        \ is 1 for the first key in KYTB, 2 for the second key
                        \ and so on)

 JSR DKS4               \ Scan the keyboard to see if the key in X is currently
                        \ being pressed, returning the result in A and X

 BPL b_quit             \ If the key is being pressed then bit 7 will be set, so
                        \ this jumps to b_quit if the key is not being pressed,
                        \ in which case A = 0 will be returned to the parasite

.b_pressed

 LDA #&FF               \ The key is being pressed, so set A to &FF so we can
                        \ return it to the parasite

.b_quit

 JMP tube_put           \ Send A back to the parasite and return from the
                        \ subroutine using a tail call


\ ******************************************************************************
\
\       Name: DKS3
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Toggle a configuration setting and emit a beep
\
\ ------------------------------------------------------------------------------
\
\ This is called when the game is paused and a key is pressed that changes the
\ game's configuration.
\
\ Specifically, this routine toggles the configuration settings for the
\ following keys:
\
\   * Caps Lock toggles keyboard flight damping (&40)
\   * A toggles keyboard auto-recentre (&41)
\   * X toggles author names on start-up screen (&42)
\   * F toggles flashing console bars (&43)
\   * Y toggles reverse joystick Y channel (&44)
\   * J toggles reverse both joystick channels (&45)
\   * K toggles keyboard and joystick (&46)
\
\ The numbers in brackets are the internal key numbers (see p.142 of the
\ Advanced User Guide for a list of internal key numbers). We pass the key that
\ has been pressed in X, and the configuration option to check it against in Y,
\ so this routine is typically called in a loop that loops through the various
\ configuration options.
\
\ Arguments:
\
\   X                   The internal number of the key that's been pressed
\
\   Y                   The internal number of the configuration key to check
\                       against, from the list above (i.e. Y must be from &40 to
\                       &46)
\
\ ******************************************************************************

.DKS3

 STY T                  \ Store the configuration key argument in T

 CPX T                  \ If X <> Y, jump to Dk3 to return from the subroutine
 BNE Dk3

                        \ We have a match between X and Y, so now to toggle
                        \ the relevant configuration byte. Caps Lock has a key
                        \ value of &40 and has its configuration byte at
                        \ location DAMP, A has a value of &41 and has its byte
                        \ at location DJD, which is DAMP+1, and so on. So we
                        \ can toggle the configuration byte by changing the
                        \ byte at DAMP + (X - &40), or to put it in indexing
                        \ terms, DAMP-&40,X. It's no coincidence that the
                        \ game's configuration bytes are set up in this order
                        \ and with these keys (and this is also why the sound
                        \ on/off keys are dealt with elsewhere, as the internal
                        \ key for S and Q are &51 and &10, which don't fit
                        \ nicely into this approach)

 LDA DAMP-&40,X         \ Fetch the byte from DAMP + (X - &40), invert it and
 EOR #&FF               \ put it back (0 means no and &FF means yes in the
 STA DAMP-&40,X         \ configuration bytes, so this toggles the setting)

 JSR BELL               \ Make a beep sound so we know something has happened

 JSR DELAY              \ Wait for Y vertical syncs (Y is between 64 and 70, so
                        \ this is always a bit longer than a second)

 LDY T                  \ Restore the configuration key argument into Y

.Dk3

 RTS                    \ Return from the subroutine


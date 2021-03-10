\ ******************************************************************************
\
\       Name: BR1 (Part 2 of 2)
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the "Load New Commander (Y/N)?" screen and start the game
\
\ ------------------------------------------------------------------------------
\
\ BRKV is set to point to BR1 by elite-loader.asm.
\
\ ******************************************************************************

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

IF _CASSETTE_VERSION \ Standard: On the second title page (the one that says "Press Space Or Fire,Commander"), the cassette version shows a rotating Mamba, the disc version shows a rotating Krait, and the 6502SP version shows a rotating Asp Mk II

 LDA #147               \ Call TITLE to show a rotating Mamba (#3) and token
 LDX #3                 \ 147 ("PRESS FIRE OR SPACE,COMMANDER.{crlf}{crlf}"),
 JSR TITLE              \ returning with the internal number of the key pressed
                        \ in A

ELIF _DISC_DOCKED

 LDA #7                 \ Call TITLE to show a rotating Krait (#KRA) and token
 LDX #KRA               \ 7 ("PRESS SPACE OR FIRE,{single cap}COMMANDER.{cr}
 JSR TITLE              \ {cr}"), returning with the internal number of the key
                        \ pressed in A

ELIF _6502SP_VERSION

 LDA #7                 \ Call TITLE to show a rotating Asp Mk II (#ASP) and
 LDX #ASP               \ token 7 ("LOAD NEW {single cap}COMMANDER {all caps}
 JSR TITLE              \ (Y/N)?{sentence case}{cr}{cr}""), returning with the
                        \ internal number of the key pressed in A

ENDIF

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Platform: The 6502SP version inlines the code from the hyp1 routine here, instead of calling it (though it could just as easily call it, as the hyp1 routine is included in the 6502SP version and contains the same code)

 JSR hyp1               \ Arrive in the system closest to (QQ9, QQ10) and then
                        \ and then fall through into the docking bay routine
                        \ below

ELIF _6502SP_VERSION

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR jmp                \ Set the current system to the selected system

 LDX #5                 \ We now want to copy the seeds for the selected system
                        \ in QQ15 into QQ2, where we store the seeds for the
                        \ current system, so set up a counter in X for copying
                        \ 6 bytes (for three 16-bit seeds)

                        \ The label below is called likeTT112 because this code
                        \ is almost identical to the TT112 loop in the hyp1
                        \ routine

.likeTT112

 LDA QQ15,X             \ Copy the X-th byte in QQ15 to the X-th byte in QQ2,
 STA QQ2,X

 DEX                    \ Decrement the counter

 BPL likeTT112          \ Loop back to likeTT112 if we still have more bytes to
                        \ copy

 INX                    \ Set X = 0 (as we ended the above loop with X = &FF)

 STX EV                 \ Set EV, the extra vessels spawning counter, to 0, as
                        \ we are entering a new system with no extra vessels
                        \ spawned

 LDA QQ3                \ Set the current system's economy in QQ28 to the
 STA QQ28               \ selected system's economy from QQ3

 LDA QQ5                \ Set the current system's tech level in tek to the
 STA tek                \ selected system's economy from QQ5

 LDA QQ4                \ Set the current system's government in gov to the
 STA gov                \ selected system's government from QQ4

                        \ Fall through into the docking bay routine below

ENDIF


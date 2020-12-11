\ ******************************************************************************
\
\       Name: LL164
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Make the hyperspace sound and draw the hyperspace tunnel
\
\ ------------------------------------------------------------------------------
\
\ See the IRQ1 routine for details on the multi-coloured effect that's used.
\
\ ******************************************************************************

.LL164

 LDA #56                \ Call the NOISE routine with A = 56 to make the sound
 JSR NOISE              \ of the hyperspace drive being engaged

IF _CASSETTE_VERSION

 LDA #1                 \ Set HFX to 1, which switches the screen mode to a full
 STA HFX                \ mode 5 screen, therefore making the hyperspace rings
                        \ multi-coloured and all zig-zaggy (see the IRQ1 routine
                        \ for details)

ELIF _6502SP_VERSION

 LDA #DOhfx             \ Send a #DOhfx 1 command to the I/O processor to tell
 JSR OSWRCH             \ it to show hyperspace colours in the top part of the
 LDA #1                 \ screen
 JSR OSWRCH

ENDIF

 LDA #4                 \ Set the step size for the hyperspace rings to 4, so
                        \ there are more sections in the rings and they are
                        \ quite round (compared to the step size of 8 used in
                        \ the much more polygonal launch rings)

 JSR HFS2               \ Call HFS2 to draw the hyperspace tunnel rings

IF _CASSETTE_VERSION

 DEC HFX                \ Set HFX back to 0, so we switch back to the normal
                        \ split-screen mode

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA #DOhfx             \ Send a #DOhfx 0 command to the I/O processor to tell
 JSR OSWRCH             \ it to show normal colours in the top part of the
 LDA #0                 \ screen, returning from the subroutine using a tail
 JMP OSWRCH             \ call

ENDIF

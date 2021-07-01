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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The Master version has a unique hyperdrive sound

 LDA #56                \ Call the NOISE routine with A = 56 to make the sound
 JSR NOISE              \ of the hyperspace drive being engaged

ELIF _MASTER_VERSION

 LDY #10                \ Call the NOISE routine with Y = 10 to make the first
 JSR NOISE              \ sound of the hyperspace drive being engaged

 LDY #11                \ Call the NOISE routine with Y = 11 to make the second
 JSR NOISE              \ sound of the hyperspace drive being engaged

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDA #1                 \ Set HFX to 1, which switches the screen mode to a full
 STA HFX                \ mode 5 screen, therefore making the hyperspace rings
                        \ multi-coloured and all zig-zaggy (see the IRQ1 routine
                        \ for details)

ELIF _ELECTRON_VERSION

 LDA #1                 \ Set HFX to 1. In the other versions, this makes the
 STA HFX                \ hyperspace rings multi-coloured, but the Electron
                        \ version is monochrome, so this has no effect

ELIF _6502SP_VERSION

 LDA #DOhfx             \ Send a #DOhfx 1 command to the I/O processor to tell
 JSR OSWRCH             \ it to show hyperspace colours in the top part of the
 LDA #1                 \ screen
 JSR OSWRCH

ENDIF

IF _ELITE_A_6502SP_PARA

 JSR update_pod         \ Update the dashboard colours to reflect whether we
                        \ have an escape pod, as the hyperspace process resets
                        \ this aspect of the palette

ENDIF

 LDA #4                 \ Set the step size for the hyperspace rings to 4, so
                        \ there are more sections in the rings and they are
                        \ quite round (compared to the step size of 8 used in
                        \ the much more polygonal launch rings)

IF _MASTER_VERSION \ Platform

 STA HFX                \ Set HFX to 4, which switches the screen mode to a full
                        \ mode 2 screen, therefore making the hyperspace rings
                        \ multi-coloured and all zig-zaggy (see the IRQ1 routine
                        \ for details)

ENDIF

 JSR HFS2               \ Call HFS2 to draw the hyperspace tunnel rings

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT \ Tube

 DEC HFX                \ Set HFX back to 0, so we switch back to the normal
                        \ split-screen mode

 RTS                    \ Return from the subroutine

ELIF _ELECTRON_VERSION

 DEC HFX                \ Set HFX back to 0, which has no effect in the Electron
                        \ version

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA #DOhfx             \ Send a #DOhfx 0 command to the I/O processor to tell
 JSR OSWRCH             \ it to show normal colours in the top part of the
 LDA #0                 \ screen, returning from the subroutine using a tail
 JMP OSWRCH             \ call

ELIF _MASTER_VERSION

 STZ HFX                \ Set HFX back to 0, so we switch back to the normal
                        \ split-screen mode

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_6502SP_PARA

 DEC HFX                \ Set HFX back to 0, so we switch back to the normal
                        \ split-screen mode

 JMP update_pod         \ Update the dashboard colours to reflect whether we
                        \ have an escape pod, as the hyperspace process resets
                        \ this aspect of the palette

ENDIF


\ ******************************************************************************
\
\       Name: TT128
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Draw a circle on a chart
\  Deep dive: Drawing circles
\
\ ------------------------------------------------------------------------------
\
\ Draw a circle with the centre at (QQ19, QQ19+1) and radius K.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   QQ19                The x-coordinate of the centre of the circle
\
\   QQ19+1              The y-coordinate of the centre of the circle
\
\   K                   The radius of the circle
\
\ ******************************************************************************

.TT128

 LDA QQ19               \ Set K3 = the x-coordinate of the centre
 STA K3

 LDA QQ19+1             \ Set K4 = the y-coordinate of the centre
 STA K4

IF _CASSETTE_VERSION \ Minor

 LDX #0                 \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STX K4+1
 STX K3+1

\STX LSX                \ This instruction is commented out in the original
                        \ source

 INX                    \ Set LSP = 1 to reset the ball line heap
 STX LSP

 LDX #2                 \ Set STP = 2, the step size for the circle
 STX STP

ELIF _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _ELITE_A_ENCYCLOPEDIA

 LDX #0                 \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STX K4+1
 STX K3+1

 INX                    \ Set LSP = 1 to reset the ball line heap
 STX LSP

 LDX #2                 \ Set STP = 2, the step size for the circle
 STX STP

ELIF _MASTER_VERSION

 STZ K4+1               \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STZ K3+1

 LDX #1                 \ Set LSP = 1 to reset the ball line heap
 STX LSP

 INX                    \ Set STP = 2, the step size for the circle
 STX STP

ELIF _NES_VERSION

 LDX #0                 \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STX K4+1
 STX K3+1

 LDX #2                 \ Set STP = 2, the step size for the circle
 STX STP

ELIF _ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED

 LDX #0                 \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STX K4+1
 STX K3+1

 INX                    \ Set LSP = 1 to reset the ball line heap
 STX LSP

 INX                    \ Set STP = 2, the step size for the circle
 STX STP

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is red in the chart view

ELIF _MASTER_VERSION

 LDA #RED               \ Switch to colour 2, which is red in the chart view
 STA COL

ENDIF

IF _CASSETTE_VERSION \ Minor

 JSR CIRCLE2            \ Call CIRCLE2 to draw a circle with the centre at
                        \ (K3(1 0), K4(1 0)) and radius K

\LDA #&FF               \ These instructions are commented out in the original
\STA LSX                \ source

 RTS                    \ Return from the subroutine

ELIF _ELECTRON_VERSION OR _DISC_FLIGHT

 JSR CIRCLE2            \ Call CIRCLE2 to draw a circle with the centre at
                        \ (K3(1 0), K4(1 0)) and radius K

 RTS                    \ Return from the subroutine

ELIF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION

 JMP CIRCLE2            \ Jump to CIRCLE2 to draw a circle with the centre at
                        \ (K3(1 0), K4(1 0)) and radius K, returning from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

 LDX #1                 \ Set the high byte of the pattern buffer address
 JSR SetPatternBuffer   \ variables to that of pattern buffer 1, so the circle
                        \ gets drawn into bitplane 1 only, giving a circle of
                        \ colour %10 (2), which is green

 JMP CIRCLE2_b1         \ Jump to CIRCLE2 to draw a circle with the centre at
                        \ (K3(1 0), K4(1 0)) and radius K, returning from the
                        \ subroutine using a tail call

ENDIF


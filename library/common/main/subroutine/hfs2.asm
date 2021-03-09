\ ******************************************************************************
\
\       Name: HFS2
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Draw the launch or hyperspace tunnel
\
\ ------------------------------------------------------------------------------
\
\ The animation gets drawn like this. First, we draw a circle of radius 8 at the
\ centre, and then double the radius, draw another circle, double the radius
\ again and draw a circle, and we keep doing this until the radius is bigger
\ than 160 (which goes beyond the edge of the screen, which is 256 pixels wide,
\ equivalent to a radius of 128). We then repeat this whole process for an
\ initial circle of radius 9, then radius 10, all the way up to radius 15.
\
\ This has the effect of making the tunnel appear to be racing towards us as we
\ hurtle out into hyperspace or through the space station's docking tunnel.
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\ The hyperspace effect is done in a full mode 5 screen, which makes the rings
\ all coloured and zig-zaggy, while the launch screen is in the normal
\ monochrome mode 4 screen.
ELIF _6502SP_VERSION
\ The hyperspace effect is done in a full mode 2 screen, which makes the rings
\ all coloured and zig-zaggy, while the launch screen is in the normal
\ four-colour mode 1 screen.
ENDIF
\
\ Arguments:
\
\   A                   The step size of the straight lines making up the rings
\                       (4 for launch, 8 for hyperspace)
\
IF _6502SP_VERSION \ Comment
\ Other entry points:
\
\   HFS1                Don't clear the screen, and draw 8 concentric rings
\                       with the step size in STP
\
ENDIF
\ ******************************************************************************

.HFS2

 STA STP                \ Store the step size in A

 JSR TTX66              \ Clear the screen and draw a white border

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Advanced: The original versions of Elite draw 16 concentric rings for hyperspace, while the 6502SP version draws 8

 JSR HFS1               \ Call HFS1 below and then fall through into the same
                        \ routine, so this effectively runs HFS1 twice, and as
                        \ HFS1 draws 8 concentric rings, this means we draw 16
                        \ of them in all

ENDIF

.HFS1

IF _CASSETTE_VERSION \ Minor

 LDA #128               \ Set K3 = 128 (the x-coordinate of the centre of the
 STA K3                 \ screen)

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDX #X                 \ Set K3 = #X (the x-coordinate of the centre of the
 STX K3                 \ screen)

ENDIF

 LDX #Y                 \ Set K4 = #Y (the y-coordinate of the centre of the
 STX K4                 \ screen)

IF _CASSETTE_VERSION \ Minor

 ASL A                  \ Set A = 0

 STA XX4                \ Set XX4 = 0, which we will use as a counter for
                        \ drawing 8 concentric rings

 STA K3+1               \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STA K4+1

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDX #0                 \ Set X = 0

 STX XX4                \ Set XX4 = 0, which we will use as a counter for
                        \ drawing 8 concentric rings

 STX K3+1               \ Set the high bytes of K3(1 0) and K4(1 0) to 0
 STX K4+1

ENDIF

.HFL5

 JSR HFL1               \ Call HFL1 below to draw a set of rings, with each one
                        \ twice the radius of the previous one, until they won't
                        \ fit on-screen

 INC XX4                \ Increment the counter and fetch it into X
 LDX XX4

 CPX #8                 \ If we haven't drawn 8 sets of rings yet, loop back to
 BNE HFL5               \ HFL5 to draw the next ring

 RTS                    \ Return from the subroutine

.HFL1

 LDA XX4                \ Set K to the ring number in XX4 (0-7) + 8, so K has
 AND #7                 \ a value of 8 to 15, which we will use as the starting
 CLC                    \ radius for our next set of rings
 ADC #8
 STA K

.HFL2

 LDA #1                 \ Set LSP = 1 to reset the ball line heap
 STA LSP

 JSR CIRCLE2            \ Call CIRCLE2 to draw a circle with the centre at
                        \ (K3(1 0), K4(1 0)) and radius K

 ASL K                  \ Double the radius in K

 BCS HF8                \ If the radius had a 1 in bit 7 before the above shift,
                        \ then doubling K will means the circle will no longer
                        \ fit on the screen (which is width 256), so jump to
                        \ HF8 to stop drawing circles

 LDA K                  \ If the radius in K <= 160, loop back to HFL2 to draw
 CMP #160               \ another one
 BCC HFL2

.HF8

 RTS                    \ Return from the subroutine


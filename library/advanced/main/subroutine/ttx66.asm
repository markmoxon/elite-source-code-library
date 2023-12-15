\ ******************************************************************************
\
\       Name: TTX66
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the top part of the screen and draw a white border
\
\ ------------------------------------------------------------------------------
\
\ Clear the top part of the screen (the space view) and draw a white border
\ along the top and sides.
\
\ Other entry points:
\
\   BOX                 Just draw the white border along the top and sides
\
\ ******************************************************************************

.TTX66

IF _MASTER_VERSION \ Platform

 LDX #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STX VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

ENDIF

 LDX #&40               \ Set X to point to page &40, which is the start of the
                        \ screen memory at &4000

.BOL1

 JSR ZES1               \ Call ZES1 to zero-fill the page in X, which will clear
                        \ half a character row

 INX                    \ Increment X to point to the next page in screen
                        \ memory

 CPX #&70               \ Loop back to keep clearing character rows until we
 BNE BOL1               \ have cleared up to &7000, which is where the dashboard
                        \ starts

.BOX

IF _MASTER_VERSION \ Platform

 LDX #%00001111         \ Set bits 1 and 2 of the Access Control Register at
 STX VIA+&34            \ SHEILA &34 to switch screen memory into &3000-&7FFF

 LDA COL                \ Store the current colour on the stack, so we can
 PHA                    \ restore it once we have drawn the border

ENDIF

 LDA #%00001111         \ Set COL = %00001111 to act as a four-pixel yellow
 STA COL                \ character byte (i.e. set the line colour to yellow)

 LDY #1                 \ Move the text cursor to row 1
 STY YC

IF _6502SP_VERSION \ Platform

 LDY #11                \ Move the text cursor to column 11
 STY XC

 LDX #0                 \ Set X1 = Y1 = Y2 = 0
 STX X1
 STX Y1
 STX Y2

\STX QQ17               \ This instruction is commented out in the original
                        \ source

 DEX                    \ Set X2 = 255
 STX X2

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2), so that's from
                        \ (0, 0) to (255, 0), along the very top of the screen

ELIF _MASTER_VERSION

 STY XC                 \ Move the text cursor to column 1

IF _SNG47

 LDX #0                 \ Set X1 = Y1 = Y2 = 0
 STX Y1
 STX Y2
 STX X1

 DEX                    \ Set X2 = 255
 STX X2

ELIF _COMPACT

 STZ Y1                 \ Set X1 = Y1 = Y2 = 0
 STZ Y2
 STZ X1

 LDX #255               \ Set X2 = 255
 STX X2

ENDIF

 JSR LOINQ              \ Draw a line from (X1, Y1) to (X2, Y2), so that's from
                        \ (0, 0) to (255, 0), along the very top of the screen

ENDIF

 LDA #2                 \ Set X1 = X2 = 2
 STA X1
 STA X2

IF _6502SP_VERSION \ Platform

 JSR BOS2               \ Call BOS2 below, which will call BOS1 twice, and then
                        \ fall through into BOS2 again, so we effectively do
                        \ BOS1 four times, decrementing X1 and X2 each time
                        \ before calling LOIN, so this whole loop-within-a-loop
                        \ mind-bender ends up drawing these four lines:
                        \
                        \   (1, 0)   to (1, 191)
                        \   (0, 0)   to (0, 191)
                        \   (255, 0) to (255, 191)
                        \   (254, 0) to (254, 191)
                        \
                        \ So that's a 2-pixel wide vertical border along the
                        \ left edge of the upper part of the screen, and a
                        \ 2-pixel wide vertical border along the right edge

ELIF _MASTER_VERSION

 JSR BOS2               \ Call BOS2 below, which will call BOS1 twice, and then
 JSR BOS2               \ call BOS2 again, so we effectively do BOS1 four times,
                        \ decrementing X1 and X2 each time before calling LOIN,
                        \ so this whole loop-within-a-loop mind-bender ends up
                        \ drawing these four lines:
                        \
                        \   (1, 0)   to (1, 191)
                        \   (0, 0)   to (0, 191)
                        \   (255, 0) to (255, 191)
                        \   (254, 0) to (254, 191)
                        \
                        \ So that's a 2-pixel wide vertical border along the
                        \ left edge of the upper part of the screen, and a
                        \ 2-pixel wide vertical border along the right edge
 LDA COL                \ Set locations &4000 &41F8 to %00001111, as otherwise
 STA &4000              \ the top-left and top-right corners will be black (as
 STA &41F8              \ the lines overlap at the corners, and the EOR logic
                        \ used by LOIN will otherwise make them black)

 PLA                    \ Restore the original colour that we stored above
 STA COL

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

 RTS                    \ Return from the subroutine

ENDIF

.BOS2

 JSR BOS1               \ Call BOS1 below and then fall through into it, which
                        \ ends up running BOS1 twice. This is all part of the
                        \ loop-the-loop border-drawing mind-bender explained
                        \ above

.BOS1

IF _6502SP_VERSION \ Minor

 LDA #0                 \ Set Y1 = 0
 STA Y1

ELIF _MASTER_VERSION

 STZ Y1                 \ Set Y1 = 0

ENDIF

 LDA #2*Y-1             \ Set Y2 = 2 * #Y - 1. The constant #Y is 96, the
 STA Y2                 \ y-coordinate of the mid-point of the space view, so
                        \ this sets Y2 to 191, the y-coordinate of the bottom
                        \ pixel row of the space view

 DEC X1                 \ Decrement X1 and X2
 DEC X2

IF _6502SP_VERSION \ Platform

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

 LDA #%00001111         \ Set locations &4000 &41F8 to %00001111, as otherwise
 STA &4000              \ the top-left and top-right corners will be black (as
 STA &41F8              \ the lines overlap at the corners, and the EOR logic
                        \ used by LOIN will otherwise make them black)

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 JMP LOINQ              \ Draw a line from (X1, Y1) to (X2, Y2) and return from
                        \ the subroutine using a tail call

ENDIF


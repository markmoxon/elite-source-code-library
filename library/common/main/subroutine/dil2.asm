\ ******************************************************************************
\
\       Name: DIL2
\       Type: Subroutine
\   Category: Dashboard
IF NOT(_ELITE_A_6502SP_IO)
\    Summary: Update the roll or pitch indicator on the dashboard
ELIF _ELITE_A_6502SP_IO
\    Summary: Implement the draw_angle command (update the roll or pitch
\             indicator on the dashboard)
ENDIF
\  Deep dive: The dashboard indicators
\
\ ------------------------------------------------------------------------------
\
IF _ELITE_A_6502SP_IO
\ This routine is run when the parasite sends a draw_angle command. It updates
\ the roll or pitch indicator on the dashboard.
\
ENDIF
\ The indicator can show a vertical bar in 16 positions, with a value of 8
\ showing the bar in the middle of the indicator.
\
\ In practice this routine is only ever called with A in the range 1 to 15, so
\ the vertical bar never appears in the leftmost position (though it does appear
\ in the rightmost).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The offset of the vertical bar to show in the indicator,
\                       from 0 at the far left, to 8 in the middle, and 15 at
\                       the far right
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is set
\
\ ******************************************************************************

.DIL2

IF _ELITE_A_6502SP_IO

 JSR tube_get           \ Get the parameters from the parasite for the command:
 STA angle_1            \
 JSR tube_get           \   draw_angle(value, screen_low, screen_high)
 STA SC                 \
 JSR tube_get           \ and store them as follows:
 STA SC+1               \
                        \   * angle_1 = the value to display in the indicator
                        \
                        \   * SC(1 0) = the screen address of the indicator

ENDIF

 LDY #1                 \ We want to start drawing the vertical indicator bar on
                        \ the second line in the indicator's character block, so
                        \ set Y to point to that row's offset

IF NOT(_ELITE_A_6502SP_IO)

 STA Q                  \ Store the offset of the vertical bar to draw in Q

ENDIF

                        \ We are now going to work our way along the indicator
                        \ on the dashboard, from left to right, working our way
                        \ along one character block at a time. Y will be used as
                        \ a pixel row counter to work our way through the
                        \ character blocks, so each time we draw a character
                        \ block, we will increment Y by 8 to move on to the next
                        \ block (as each character block contains 8 rows)

.DLL10

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Screen

 SEC                    \ Set A = Q - 4, so that A contains the offset of the
 LDA Q                  \ vertical bar from the start of this character block
 SBC #4

 BCS DLL11              \ If Q >= 4 then the character block we are drawing does
                        \ not contain the vertical indicator bar, so jump to
                        \ DLL11 to draw a blank character block

ELIF _6502SP_VERSION OR _MASTER_VERSION

 SEC                    \ Set A = Q - 2, so that A contains the offset of the
 LDA Q                  \ vertical bar from the start of this character block
 SBC #2

 BCS DLL11              \ If Q >= 2 then the character block we are drawing does
                        \ not contain the vertical indicator bar, so jump to
                        \ DLL11 to draw a blank character block

ELIF _ELITE_A_6502SP_IO

 SEC                    \ Set A = angle_1 - 4, so that A contains the offset of
 LDA angle_1            \ the vertical bar from the start of this character
 SBC #4                 \ block

 BCS DLL11              \ If angle_1 >= 4 then the character block we are
                        \ drawing does not contain the vertical indicator bar,
                        \ so jump to DLL11 to draw a blank character block

ENDIF

 LDA #&FF               \ Set A to a high number (and &FF is as high as they go)

IF NOT(_ELITE_A_6502SP_IO)

 LDX Q                  \ Set X to the offset of the vertical bar, which we know
                        \ is within this character block

 STA Q                  \ Set Q to a high number (&FF, why not) so we will keep
                        \ drawing blank characters after this one until we reach
                        \ the end of the indicator row

ELIF _ELITE_A_6502SP_IO

 LDX angle_1            \ Set X to the offset of the vertical bar, which we know
                        \ is within this character block

 STA angle_1            \ Set angle_1 to a high number (&FF, why not) so we will
                        \ keep drawing blank characters after this one until we
                        \ reach the end of the indicator row

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA CTWOS,X            \ CTWOS is a table of ready-made one-pixel mode 5 bytes,
                        \ just like the TWOS and TWOS2 tables for mode 4 (see
                        \ the PIXEL routine for details of how they work). This
                        \ fetches a mode 5 one-pixel byte with the pixel
                        \ position at X, so the pixel is at the offset that we
                        \ want for our vertical bar

 AND #&F0               \ The four-pixel mode 5 colour byte &F0 represents four
                        \ pixels of colour %10 (3), which is yellow in the
                        \ normal dashboard palette and white if we have an
                        \ escape pod fitted. We AND this with A so that we only
                        \ keep the pixel that matches the position of the
                        \ vertical bar (i.e. A is acting as a mask on the
                        \ four-pixel colour byte)

ELIF _ELECTRON_VERSION

 LDA CTWOS,X            \ CTWOS is a table of ready-made two-pixel mode 4 bytes,
                        \ similar to the TWOS and TWOS2 tables, but laid out in
                        \ a similar way to the mode 5 pixel bytes in the other
                        \ versions (see the PIXEL routine for details of how
                        \ they work). This fetches a two-pixel mode 4 byte with
                        \ the pixel position at 2 * X, so the pixel is at the
                        \ offset that we want for our vertical bar

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA CTWOS,X            \ CTWOS is a table of ready-made one-pixel mode 2 bytes,
                        \ just like the TWOS and TWOS2 tables for mode 1 (see
                        \ the PIXEL routine for details of how they work). This
                        \ fetches a mode 2 one-pixel byte with the pixel
                        \ position at X, so the pixel is at the offset that we
                        \ want for our vertical bar

 AND #WHITE2            \ The two-pixel mode 2 byte in #WHITE2 represents two
                        \ pixels of colour %0111 (7), which is white in both
                        \ dashboard palettes. We AND this with A so that we only
                        \ keep the pixel that matches the position of the
                        \ vertical bar (i.e. A is acting as a mask on the
                        \ two-pixel colour byte)

ELIF _C64_VERSION

 LDA CTWOS,X            \ CTWOS is a table of ready-made two-pixel multicolour
                        \ bitmap mode bytes
                        \
                        \ This fetches a two-pixel multicolour bitmap mode byte
                        \ with the pixel position at 2 * X, so the pixel is at
                        \ the offset that we want for our vertical bar

 AND #YELLOW            \ The four-pixel multicolour bitmap mode colour byte in
                        \ YELLOW represents four pixels of colour %10 (3), which
                        \ is yellow in the dashboard palette. We AND this with A
                        \ so that we only keep the pixel that matches the
                        \ position of the vertical bar (i.e. A is acting as a
                        \ mask on the four-pixel colour byte)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Minor

 BNE DLL12              \ Jump to DLL12 to skip the code for drawing a blank,
                        \ and move on to drawing the indicator (this BNE is
                        \ effectively a JMP as A is always non-zero)

ELIF _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION

 JMP DLL12              \ Jump to DLL12 to skip the code for drawing a blank,
                        \ and move on to drawing the indicator

ENDIF

.DLL11

                        \ If we get here then we want to draw a blank for this
                        \ character block

IF NOT(_ELITE_A_6502SP_IO)

 STA Q                  \ Update Q with the new offset of the vertical bar, so
                        \ it becomes the offset after the character block we
                        \ are about to draw

ELIF _ELITE_A_6502SP_IO

 STA angle_1            \ Update angle_1 with the new offset of the vertical
                        \ bar, so it becomes the offset after the character
                        \ block we are about to draw

ENDIF

 LDA #0                 \ Change the mask so no bits are set, so all of the
                        \ character blocks we display from now on will be blank
.DLL12

 STA (SC),Y             \ Draw the shape of the mask on pixel row Y of the
                        \ character block we are processing

 INY                    \ Draw the next pixel row, incrementing Y
 STA (SC),Y

 INY                    \ And draw the third pixel row, incrementing Y
 STA (SC),Y

 INY                    \ And draw the fourth pixel row, incrementing Y
 STA (SC),Y

 TYA                    \ Add 5 to Y, so Y is now 8 more than when we started
 CLC                    \ this loop iteration, so Y now points to the address
 ADC #5                 \ of the first line of the indicator bar in the next
 TAY                    \ character block (as each character is 8 bytes of
                        \ screen memory)

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Screen

 CPY #30                \ If Y < 30 then we still have some more character
 BCC DLL10              \ blocks to draw, so loop back to DLL10 to display the
                        \ next one along

 INC SC+1               \ Increment the high byte of SC to point to the next
                        \ character row on-screen (as each row takes up exactly
                        \ one page of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

 RTS                    \ Return from the subroutine

ELIF _ELECTRON_VERSION

 CPY #30                \ If Y < 30 then we still have some more character
 BCC DLL10              \ blocks to draw, so loop back to DLL10 to display the
                        \ next one along

 JMP NEXTR              \ Jump to NEXTR with the C flag set to move the screen
                        \ address in SC(1 0) down by one character row,
                        \ returning from the subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CPY #60                \ If Y < 60 then we still have some more character
 BCC DLL10              \ blocks to draw, so loop back to DLL10 to display the
                        \ next one along

 INC SC+1               \ Increment the high byte of SC to point to the next
 INC SC+1               \ character row on-screen (as each row takes up exactly
                        \ two pages of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_6502SP_IO

 CPY #30                \ If Y < 30 then we still have some more character
 BCC DLL10              \ blocks to draw, so loop back to DLL10 to display the
                        \ next one along

 RTS                    \ Return from the subroutine

ELIF _C64_VERSION

 CPY #30                \ If Y < 30 then we still have some more character
 BCC DLL10              \ blocks to draw, so loop back to DLL10 to display the
                        \ next one along

                        \ We now need to move down into the character block
                        \ below, and each character row in screen memory takes
                        \ up &140 bytes (&100 for the visible part and &20 for
                        \ each of the blank borders on the side of the screen),
                        \ so that's what we need to add to SC(1 0)
                        \
                        \ We also know the C flag is set, as we didn't take the
                        \ BCC above, so we can add &13F in order to get the
                        \ correct result

 LDA SC                 \ Set SC(1 0) = SC(1 0) + &140
 ADC #&3F               \
 STA SC                 \ Starting with the low bytes

 LDA SC+1               \ And then adding the high bytes
 ADC #&01
 STA SC+1

 RTS                    \ Return from the subroutine

ENDIF


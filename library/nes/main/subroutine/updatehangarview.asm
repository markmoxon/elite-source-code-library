\ ******************************************************************************
\
\       Name: UpdateHangarView
\       Type: Subroutine
\   Category: PPU
\    Summary: Update the hangar view on-screen by sending the data to the PPU,
\             either immediately or during VBlank
\  Deep dive: Views and view types in NES Elite
\
\ ******************************************************************************

.UpdateHangarView

 LDA #0                 \ Page ROM bank 0 into memory at &8000 (this isn't
 JSR SetBank            \ strictly necessarily as this routine gets jumped to
                        \ from the end of the HALL routine in bank 1, which
                        \ itself is only called via HALL_b1, so the latter will
                        \ revert to bank 0 following the RTS below and none of
                        \ the following calls are to bank 0)

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer

 JSR UpdateScreen       \ Update the screen by sending data to the PPU, either
                        \ immediately or during VBlank, depending on whether
                        \ the screen is visible

 LDX #1                 \ Hide bitplane 1, so:
 STX hiddenBitplane     \
                        \   * Colour %01 (1) is the visible colour (cyan)
                        \   * Colour %10 (2) is the hidden colour (black)

 RTS                    \ Return from the subroutine


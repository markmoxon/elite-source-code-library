\ ******************************************************************************
\
\       Name: SendSpaceViewToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Set a new space view, clear the screen, copy the nametable buffers
\             and configure the PPU for the new view
\  Deep dive: Views and view types in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The space view to set:
\
\                         * 0 = front
\
\                         * 1 = rear
\
\                         * 2 = left
\
\                         * 3 = right
\
\                         * 4 = generating a new space view
\
\ ******************************************************************************

.SendSpaceViewToPPU

 LDA #72                \ Set the screen height variables for a screen height of
 JSR SetScreenHeight    \ 144 (i.e. 2 * 72)

 STX VIEW               \ Set the current space view to X

 LDA #&00               \ Clear the screen and set the view type in QQ11 to &00
 JSR TT66               \ (Space view with no fonts loaded)

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer

 JSR SendViewToPPU_b3   \ Configure the PPU for the view type in QQ11

 JMP ResetStardust      \ Hide the sprites for the stardust and return from the
                        \ subroutine using a tail call


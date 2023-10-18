\ ******************************************************************************
\
\       Name: SetIconBarButtonsS
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set the correct list of button numbers for the icon bar (this is a
\             jump so we can call this routine using a branch instruction)
\
\ ******************************************************************************

.SetIconBarButtonsS

 JMP SetIconBarButtons  \ Jump to SetIconBarButtons to set the barButtons
                        \ variable to point to the correct list of button
                        \ numbers for the icon bar we are setting up, returning
                        \ from the subroutine using a tail call


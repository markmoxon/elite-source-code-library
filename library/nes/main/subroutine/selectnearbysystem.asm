\ ******************************************************************************
\
\       Name: SelectNearbySystem
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the current system to the nearest system and update the
\             selected system flags accordingly
\
\ ******************************************************************************

.SelectNearbySystem

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JMP SetSelectionFlags  \ Jump to SetSelectionFlags to set the selected system
                        \ flags for the new system and update the icon bar if
                        \ required


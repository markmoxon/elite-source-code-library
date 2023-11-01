\ ******************************************************************************
\
\       Name: HideShip_b1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the current ship so it is no longer shown on the scanner
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.HideShip_b1

 LDA #0                 \ Zero byte #33 in the current ship's data block at K%,
 LDY #33                \ so it is not shown on the scanner (a non-zero byte #33
 STA (INF),Y            \ represents the ship's number on the scanner, with a
                        \ ship number of zero indicating that the ship is not
                        \ shown on the scanner)

                        \ Fall through into HideFromScanner to hide the scanner
                        \ sprites for this ship and reset byte #33 in the INWK
                        \ workspace


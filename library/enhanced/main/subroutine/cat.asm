\ ******************************************************************************
\
\       Name: CAT
\       Type: Subroutine
\   Category: Save and load
\    Summary: Catalogue a disc, wait for a key press and display the disc access
\             menu
\
\ ******************************************************************************

.CAT

 JSR CATS               \ Call CATS to ask for a drive number, catalogue that
                        \ disc and update the catalogue command at CTLI

                        \ Fall through into retry to wait for a key press and
                        \ display the disc access menu


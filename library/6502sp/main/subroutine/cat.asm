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

 JSR CATS               \ Call CATS to catalogue a disc

                        \ Fall through into retry to wait for a key press and
                        \ display the disc access menu
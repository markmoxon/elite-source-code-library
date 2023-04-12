\ ******************************************************************************
\
\       Name: launch
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the main docked code in 1.D
\
\ ******************************************************************************

.launch

 LDA #'R'               \ Set the first byte of LTLI to "R", so it changes from
 STA LTLI               \ "L.1.D" into "R.1.D", so when we fall through into
                        \ escape, we load and run the docked code in 1.D

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &52, or BIT &52A9, which does nothing apart
                        \ from affect the flags

                        \ Fall through into escape to set KL+1 to the non-zero
                        \ value in A before running the docking code (which will
                        \ not show the docking tunnel and ship hangar, as KL+1
                        \ is now non-zero)


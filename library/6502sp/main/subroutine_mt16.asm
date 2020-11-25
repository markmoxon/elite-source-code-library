\ ******************************************************************************
\
\       Name: MT16
\       Type: Subroutine
\   Category: Text
\    Summary: Print the character given in DTW7
\
\ ******************************************************************************

.MT16

 LDA #'A'               \ Set A to the contents of DTW7, as DTW7 points to the
                        \ second byte of this instruction (the default value is
                        \ to print an "A")

DTW7 = MT16 + 1         \ Point DTW7 to the second byte of the instruction above
                        \ so that modifying DTW7 changes the value loaded into A


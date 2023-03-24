\ ******************************************************************************
\
\       Name: MT16
\       Type: Subroutine
\   Category: Text
\    Summary: Print the character in variable DTW7
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.MT16

 LDA #'A'               \ Set A to the contents of DTW7, as DTW7 points to the
                        \ second byte of this instruction, so updating DTW7 will
                        \ modify this instruction (the default value of DTW7 is
                        \ an "A")

 DTW7 = MT16 + 1        \ Point DTW7 to the second byte of the instruction above
                        \ so that modifying DTW7 changes the value loaded into A

                        \ Fall through into TT26 to print the character in A


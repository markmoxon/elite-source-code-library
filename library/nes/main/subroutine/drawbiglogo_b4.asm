\ ******************************************************************************
\
\       Name: DrawBigLogo_b4
\       Type: Subroutine
\   Category: Start and end
\    Summary: Call the DrawBigLogo routine in ROM bank 4
\
\ ******************************************************************************

.DrawBigLogo_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR DrawBigLogo        \ Call DrawBigLogo, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call


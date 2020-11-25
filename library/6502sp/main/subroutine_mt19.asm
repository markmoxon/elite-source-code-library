\ ******************************************************************************
\
\       Name: MT19
\       Type: Subroutine
\   Category: Text
\    Summary: Clear bit 5 of DTW8 (only)
\
\ ******************************************************************************

.MT19

 LDA #%11011111         \ Clear bit 5 of DTW8 (only) so it can be used as a mask
 STA DTW8               \ to make letters upper case

 RTS                    \ Return from the subroutine


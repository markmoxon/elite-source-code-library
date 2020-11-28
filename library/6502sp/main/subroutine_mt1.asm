\ ******************************************************************************
\
\       Name: MT1
\       Type: Subroutine
\   Category: Text
\    Summary: Clear all bits of DTW1 and DTW6
\
\ ******************************************************************************

.MT1

 LDA #0                 \ Set A = 0, so when we fall through into MT2, DTW1 gets
                        \ set to 0

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &20, or BIT &20A9, which does nothing apart
                        \ from affect the flags


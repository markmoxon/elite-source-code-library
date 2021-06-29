\ ******************************************************************************
\
\       Name: clr_vdustat
\       Type: Subroutine
\   Category: Text
\    Summary: AJD
\
\ ******************************************************************************

.clr_vdustat

 LDA #%00000001         

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &80, or BIT &80A9, which does nothing apart
                        \ from affect the flags

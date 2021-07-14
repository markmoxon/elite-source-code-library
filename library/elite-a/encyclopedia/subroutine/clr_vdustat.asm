\ ******************************************************************************
\
\       Name: clr_vdustat
\       Type: Subroutine
\   Category: Text
\    Summary: Switch to standard tokens in lower case
\
\ ******************************************************************************

.clr_vdustat

 LDA #%00000001         \ Set A to %00000001 so when we fall through into MT6 we
                        \ set QQ17 to %00000001 instead of %10000000, so we
                        \ switch to lower case instead of Sentence Case

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &80, or BIT &80A9, which does nothing apart
                        \ from affect the flags

                        \ Fall through into MT6 to switch to standard tokens in
                        \ lower case


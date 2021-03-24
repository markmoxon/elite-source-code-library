\ ******************************************************************************
\
\       Name: PZW2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Fetch the current dashboard colours for non-striped indicators, to
\             support flashing
\
\ ******************************************************************************

.PZW2

 LDX #WHITE2            \ Set X to white, so we can return that as the safe
                        \ colour in PZW below

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &23, or BIT &23A9, which does nothing apart
                        \ from affect the flags

                        \ Fall through into PZW to fetch the current dashboard
                        \ colours, returning white for safe colours rather than
                        \ stripes


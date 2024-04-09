\ ******************************************************************************
\
\       Name: TestPro
\       Type: Subroutine
\   Category: Loader
\    Summary: Test whether we are running this on a co-processor
\
\ ******************************************************************************

.TestPro

 LDA #0                 \ If this is a co-processor, then the DEC A instruction
 DEC A                  \ will be supported and will decrement A to &FF, but if
                        \ this is not a co-processor, the DEC A instruction will
                        \ have no effect

 STA proflag%           \ Set proflag% to A, which will be &FF if this is a
                        \ co-processor, 0 otherwise

 RTS                    \ Return from the subroutine


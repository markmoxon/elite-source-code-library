\ ******************************************************************************
\
\       Name: VEC
\       Type: Variable
\   Category: Screen mode
\    Summary: The original value of the IRQ1 vector
\
\ ******************************************************************************

.VEC

 EQUW 0                 \ VEC = &7FFE
                        \
                        \ Set to the original IRQ1 vector by elite-loader.asm


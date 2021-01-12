IF _CASSETTE_VERSION OR _DISC_VERSION

\ ******************************************************************************
\
\       Name: VEC
\       Type: Variable
\   Category: Screen mode
\    Summary: The original value of the IRQ1 vector
\
\ ******************************************************************************

ENDIF

.VEC

 SKIP 2                 \ VEC = &7FFE
                        \
                        \ Set to the original IRQ1 vector by elite-loader.asm


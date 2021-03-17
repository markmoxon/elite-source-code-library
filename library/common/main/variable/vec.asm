IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
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

IF _CASSETTE_VERSION OR _6502SP_VERSION \ Minor

 SKIP 2                 \ VEC = &7FFE
                        \
                        \ This gets set to the value of the original IRQ1 vector
                        \ by elite-loader.asm

ELIF _DISC_VERSION

 EQUW &0004             \ VEC = &7FFE
                        \
                        \ This gets set to the value of the original IRQ1 vector
                        \ by elite-loader3.asm
                        \
                        \ This default value is presumably noise included at the
                        \ time of compilation, as it gets overwritten

ELIF _MASTER_VERSION

 EQUW &8888             \ This gets set to the value of the original IRQ1 vector
                        \ by the STARTUP routine

ENDIF


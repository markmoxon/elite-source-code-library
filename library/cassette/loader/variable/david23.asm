\ ******************************************************************************
\
\       Name: David23
\       Type: Variable
\   Category: Copy protection
\    Summary: Address pointer to the start of the 6502 stack
\
\ ------------------------------------------------------------------------------
\
\ This two-byte address points to the start of the 6502 stack, which descends
\ from the end of page 2, less LEN bytes, which comes out as &01DF. So when we
\ push 33 bytes onto the stack (LEN being 33), this address will point to the
\ start of those bytes, which means we can push executable code onto the stack
\ and run it by calling this address with a JMP (David23) instruction. Sneaky
\ stuff!
\
\ ******************************************************************************

.David23

IF _CASSETTE_VERSION

 EQUW (512-LEN)         \ The address of LEN bytes before the start of the stack

ELIF _ELECTRON_VERSION

 EQUW 6                 \ This value is not used in this unprotected version of
                        \ the loader, though why the crackers set it to 6 is a
                        \ mystery

ENDIF


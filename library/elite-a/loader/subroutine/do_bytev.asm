\ ******************************************************************************
\
\       Name: do_BYTEV
\       Type: Subroutine
\   Category: Loader
\    Summary: The custom handler for OSBYTE calls in the BBC Master version
\
\ ******************************************************************************

.do_BYTEV

 CMP #143               \ If this is not OSBYTE 143, the paged ROM service call,
 BNE old_BYTEV          \ then jump to old_BYTEV to pass the call onto the
                        \ default handler

 CPX #&F                \ If the value of X is not &F ("vectors changed"), jump
 BNE old_BYTEV          \ to old_BYTEV to pass the call onto the default
                        \ handler

 JSR old_BYTEV          \ This is OSBYTE 143 with X = &F (the "vectors changed"
                        \ service call), so first of all call old_BYTEV so the
                        \ service call can be processed by the default handler

                        \ And then fall through into set_vectors to set the
                        \ FILEV, FSCV and BYTEV vectors to point to our custom
                        \ handlers


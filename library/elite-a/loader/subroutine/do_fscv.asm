\ ******************************************************************************
\
\       Name: do_FSCV
\       Type: Subroutine
\   Category: Loader
\    Summary: The custom handler for filing system calls in the BBC Master
\             version
\
\ ******************************************************************************

.do_FSCV

 JSR restorews          \ Call restorews to restore the filing system workspace,
                        \ so we can use the filing system

.old_FSCV

 JSR &100               \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it calls the existing FSCV handler

 JMP savews             \ Call savews to save the filing system workspace in a
                        \ safe place and replace it with the MOS character set,
                        \ so that character printing will work once again


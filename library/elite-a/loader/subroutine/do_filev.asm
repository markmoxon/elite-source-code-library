\ ******************************************************************************
\
\       Name: do_FILEV
\       Type: Subroutine
\   Category: Loader
\    Summary: The custom handler for OSFILE calls in the BBC Master version
\
\ ******************************************************************************

.do_FILEV

 JSR restorews          \ Call restorews to restore the filing system workspace,
                        \ so we can use the filing system

.old_FILEV

 JSR &100               \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it calls the existing FILEV handler

                        \ Fall through into savews to save the filing system
                        \ workspace in a safe place and replace it with the MOS
                        \ character set, so that character printing will work
                        \ once again


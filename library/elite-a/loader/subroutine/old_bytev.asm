\ ******************************************************************************
\
\       Name: old_BYTEV
\       Type: Subroutine
\   Category: Loader
\    Summary: Call the default OSBYTE handler
\
\ ******************************************************************************

.old_BYTEV

 JMP &100               \ This address is modified by the Master-specific code
                        \ in part 1 of the loader (just after the cpmaster
                        \ loop), so it calls the existing BYTEV handler and
                        \ returns from the subroutine using a tail call


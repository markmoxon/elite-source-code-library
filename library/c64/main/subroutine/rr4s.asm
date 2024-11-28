\ ******************************************************************************
\
\       Name: RR4S
\       Type: Subroutine
\   Category: Text
\    Summary: A jump point that restores the registers and returns from the CHPR
\             subroutine (so we can use a branch instruction to jump to RR4)
\
\ ******************************************************************************

.RR4S

 JMP RR4                \ Jump to RR4 to restore the registers and return from
                        \ the subroutine using a tail call (this JMP enables us
                        \ to jump to RR4 using a branch to RR4S though this
                        \ isn't actually done anywhere)


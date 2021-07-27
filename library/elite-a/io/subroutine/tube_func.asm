\ ******************************************************************************
\
\       Name: tube_func
\       Type: Subroutine
\   Category: Tube
\    Summary: Call the corresponding routine for a Tube command
\
\ ------------------------------------------------------------------------------
\
\ This routine calls the routine given in the tube_table lookup table for the
\ Tube command specified in A.
\
\ Arguments:
\
\   A                   The command number (&80-&FF)
\
\ ******************************************************************************

.tube_func

 CMP #&9D               \ If A >= &9D then there isn't a corresponding command,
 BCS return             \ so jump to return to return from the subroutine

 ASL A                  \ Set Y = A * 2, so we can use it as an index into the
 TAY                    \ lookup table, which has two bytes per entry
                        \
                        \ Note that this also shifts bit 7 off the end, so the
                        \ result is actually ((A - 128) * 2), which means if A
                        \ starts out at &80, then Y = 0, if A is &81, Y = 2,
                        \ and so on

 LDA tube_table,Y       \ Copy the Y-th address from tube_table over the &FFFF
 STA tube_jump+1        \ address of the JMP instruction below, so this modifies
 LDA tube_table+1,Y     \ the instruction so that it jumps to the coresponding
 STA tube_jump+2        \ address from the lookup table

.tube_jump

 JMP &FFFF              \ Jump to the routine whose address we just copied from
                        \ the tube_table, which will be the routine that
                        \ corresponds to this Tube command, and return from the
                        \ subroutine using a tail call

.return

 RTS                    \ Return from the subroutine


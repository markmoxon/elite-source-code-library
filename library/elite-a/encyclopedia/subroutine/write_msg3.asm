\ ******************************************************************************
\
\       Name: write_msg3
\       Type: Subroutine
\   Category: Elite-A
\    Summary: Print an extended recursive token from the msg_3 token table
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The recursive token to be printed, in the range 0-255
\
\ Returns:
\
\   A                   A is preserved
\
\   Y                   Y is preserved
\
\   V(1 0)              V(1 0) is preserved
\
\ ******************************************************************************

.write_msg3

 PHA                    \ Store A on the stack, so we can retrieve it later

 TAX                    \ Copy the token number from A into X

 TYA                    \ Store Y on the stack
 PHA

 LDA V                  \ Store V(1 0) on the stack
 PHA
 LDA V+1
 PHA

 LDA #LO(msg_3)         \ Set V to the low byte of RUTOK
 STA V

 LDA #HI(msg_3)         \ Set A to the high byte of RUTOK

 BNE DTEN               \ Call DTEN to print token number X from the RUTOK
                        \ table and restore the values of A, Y and V(1 0) from
                        \ the stack, returning from the subroutine using a tail
                        \ call (this BNE is effectively a JMP as A is never
                        \ zero)


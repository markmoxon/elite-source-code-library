\ ******************************************************************************
\
\       Name: DVID4
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (P R) = 256 * A / Q
\  Deep dive: Shift-and-subtract division
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division and remainder:
\
\   P = A / Q
\
\   R = remainder as a fraction of Q, where 1.0 = 255
\
\ Another way of saying the above is this:
\
\   (P R) = 256 * A / Q
\
\ This uses the same shift-and-subtract algorithm as TIS2, but this time we
\ keep the remainder and the loop is unrolled.
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.DVID4

 ASL A                  \ Shift A left and store in P (we will build the result
 STA P                  \ in P)

 LDA #0                 \ Set A = 0 for us to build a remainder

                        \ We now repeat the following five instruction block
                        \ eight times, one for each bit in P. In the cassette
                        \ and disc versions of Elite the following is done with
                        \ a loop, but it is marginally faster to unroll the loop
                        \ and have eight copies of the code, though it does take
                        \ up a bit more memory (though that isn't a concern when
                        \ you have a 6502 Second Processor)

 ROL A                  \ Shift A to the left

 CMP Q                  \ If A < Q skip the following subtraction
 BCC P%+4

 SBC Q                  \ A >= Q, so set A = A - Q

 ROL P                  \ Shift P to the left, pulling the C flag into bit 0

 ROL A                  \ Repeat for the second time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 ROL A                  \ Repeat for the third time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 ROL A                  \ Repeat for the fourth time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 ROL A                  \ Repeat for the fifth time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 ROL A                  \ Repeat for the sixth time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 ROL A                  \ Repeat for the seventh time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 ROL A                  \ Repeat for the eighth time
 CMP Q
 BCC P%+4
 SBC Q
 ROL P

 LDX #0                 \ Set X = 0 so this unrolled version of DVID4 also
                        \ returns X = 0

IF _6502SP_VERSION \ Platform

 JMP LL28+4             \ Jump to LL28+4 to convert the remainder in A into an
                        \ integer representation of the fractional value A / Q,
                        \ in R, where 1.0 = 255. LL28+4 always returns with the
                        \ C flag cleared, and we return from the subroutine
                        \ using a tail call

ELIF _MASTER_VERSION

{
 STA widget             \ This contains the code from the LL28+4 routine, so
 TAX                    \ this section is exactly equivalent to a JMP LL28+4
 BEQ LLfix              \ call, but is slightly faster as it's been inlined
 LDA logL,X             \ (so it converts the remainder in A into an integer
 LDX Q                  \ representation of the fractional value A / Q, in R,
 SEC                    \ where 1.0 = 255, and it also clears the C flag
 SBC logL,X             \
 LDX widget             \ The routine is surrounded by braces as BeebAsm
 LDA log,X              \ doesn't allow us to redefine labels, unlike BBC BASIC
 LDX Q
 SBC log,X
 BCS LL2
 TAX
 LDA antilog,X

.LLfix

 STA R
 RTS

.LL2

 LDA #255
 STA R
 RTS
}

ENDIF


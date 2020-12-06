\ ******************************************************************************
\
\       Name: DVID4
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (P R) = 256 * A / Q
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
\ keep the remainder.
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

 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\7
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\6
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\5
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\4
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\3
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\2
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
\1
 ROL A
 CMP Q
 BCC P%+4
 SBC Q
 ROL P
 LDX #0

 JMP LL28+4             \ Jump to LL28+4 to convert the remainder in A into an
                        \ integer representation of the fractional value A / Q,
                        \ in R, where 1.0 = 255. LL28+4 always returns with the
                        \ C flag cleared, and we return from the subroutine
                        \ using a tail call


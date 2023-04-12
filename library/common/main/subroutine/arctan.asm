\ ******************************************************************************
\
\       Name: ARCTAN
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Calculate A = arctan(P / Q)
\  Deep dive: The sine, cosine and arctan tables
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   A = arctan(P / Q)
\
\ In other words, this finds the angle in the right-angled triangle where the
\ opposite side to angle A is length P and the adjacent side to angle A has
\ length Q, so:
\
\   tan(A) = P / Q
\
\ The result in A is an integer representing the angle in radians. The routine
\ returns values in the range 0 to 128, which covers 0 to 180 degrees (or 0 to
\ PI radians).
\
IF _MASTER_VERSION \ Comment
\ Other entry points:
\
\   ARSR1               Contains an RTS
\
ENDIF
\ ******************************************************************************

.ARCTAN

 LDA P                  \ Set T1 = P EOR Q, which will have the sign of P * Q
 EOR Q
 STA T1

 LDA Q                  \ If Q = 0, jump to AR2 to return a right angle
 BEQ AR2

 ASL A                  \ Set Q = |Q| * 2 (this is a quick way of clearing the
 STA Q                  \ sign bit, and we don't need to shift right again as we
                        \ only ever use this value in the division with |P| * 2,
                        \ which we set next)

 LDA P                  \ Set A = |P| * 2
 ASL A

 CMP Q                  \ If A >= Q, i.e. |P| > |Q|, jump to AR1 to swap P
 BCS AR1                \ and Q around, so we can still use the lookup table

 JSR ARS1               \ Call ARS1 to set the following from the lookup table:
                        \
                        \   A = arctan(A / Q)
                        \     = arctan(|P / Q|)

 SEC                    \ Set the C flag so the SBC instruction in AR3 will be
                        \ correct, should we jump there

.AR4

 LDX T1                 \ If T1 is negative, i.e. P and Q have different signs,
 BMI AR3                \ jump down to AR3 to return arctan(-|P / Q|)

 RTS                    \ Otherwise P and Q have the same sign, so our result is
                        \ correct and we can return from the subroutine

.AR1

                        \ We want to calculate arctan(t) where |t| > 1, so we
                        \ can use the calculation described in the documentation
                        \ for the ACT table, i.e. 64 - arctan(1 / t)

 LDX Q                  \ Swap the values in Q and P, using the fact that we
 STA Q                  \ called AR1 with A = P
 STX P                  \
 TXA                    \ This also sets A = P (which now contains the original
                        \ argument |Q|)

 JSR ARS1               \ Call ARS1 to set the following from the lookup table:
                        \
                        \   A = arctan(A / Q)
                        \     = arctan(|Q / P|)
                        \     = arctan(1 / |P / Q|)

 STA T                  \ Set T = 64 - T
 LDA #64
 SBC T

 BCS AR4                \ Jump to AR4 to continue the calculation (this BCS is
                        \ effectively a JMP as the subtraction will never
                        \ underflow, as ARS1 returns values in the range 0-31)

.AR2

                        \ If we get here then Q = 0, so tan(A) = infinity and
                        \ A is a right angle, or 0.25 of a circle. We allocate
                        \ 255 to a full circle, so we should return 63 for a
                        \ right angle

 LDA #63                \ Set A to 63, to represent a right angle

 RTS                    \ Return from the subroutine

.AR3

                        \ A contains arctan(|P / Q|) but P and Q have different
                        \ signs, so we need to return arctan(-|P / Q|), using
                        \ the calculation described in the documentation for the
                        \ ACT table, i.e. 128 - A

IF _CASSETTE_VERSION \ Comment

 STA T                  \ Set A = 128 - A
 LDA #128               \
\SEC                    \ The SEC instruction is commented out in the original
 SBC T                  \ source, and isn't required as we did a SEC before
                        \ calling AR3

ELIF _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION

 STA T                  \ Set A = 128 - A
 LDA #128               \
 SBC T                  \ The subtraction will work because we did a SEC before
                        \ calling AR3

ENDIF

 RTS                    \ Return from the subroutine


.ARS1

                        \ This routine fetches arctan(A / Q) from the ACT table,
                        \ so A will be set to an integer in the range 0 to 31
                        \ that represents an angle from 0 to 45 degrees (or 0 to
                        \ PI / 4 radians)

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q

 LDA R                  \ Set X = R / 8
 LSR A                  \       = 32 * A / Q
 LSR A                  \
 LSR A                  \ so X has the value t * 32 where t = A / Q, which is
 TAX                    \ what we need to look up values in the ACT table

 LDA ACT,X              \ Fetch ACT+X from the ACT table into A, so now:
                        \
                        \   A = value in ACT + X
                        \     = value in ACT + (32 * A / Q)
                        \     = arctan(A / Q)

IF _MASTER_VERSION \ Label

.ARSR1

ENDIF

 RTS                    \ Return from the subroutine


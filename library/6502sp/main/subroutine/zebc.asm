\ ******************************************************************************
\
\       Name: ZEBC
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill pages &B and &C
\
\ ******************************************************************************

.ZEBC

 LDX #&C                \ Call ZES1 with X = &C to zero-fill page &C
 JSR ZES1

 DEX                    \ Decrement X to &B

                        \ Fall through into ZES1 to zero-fill page &B


\ ******************************************************************************
\
\       Name: ZEBC
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill pages &B and &C
\
\ ******************************************************************************

.ZEBC

IF _C64_VERSION OR _APPLE_VERSION

 RTS                    \ Return from the subroutine, as ZEBC does nothing in
                        \ this version of Elite (it is left over from the BBC
                        \ Micro version)

ENDIF

 LDX #&C                \ Call ZES1 with X = &C to zero-fill page &C
 JSR ZES1

 DEX                    \ Decrement X to &B

                        \ Fall through into ZES1 to zero-fill page &B


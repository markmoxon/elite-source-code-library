\ ******************************************************************************
\
\       Name: EXNO3
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of a collision, or an exploding cargo canister or
\             missile
\  Deep dive: Sound effects in Apple II Elite
\
\ ******************************************************************************

.EXNO3

 LDY #40                \ Set Y = 40 and fall through into SOEXPL to make the
                        \ sound of a collision, or an exploding cargo canister
                        \ or missile


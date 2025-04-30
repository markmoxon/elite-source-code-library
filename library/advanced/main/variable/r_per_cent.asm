\ ******************************************************************************
\
\       Name: R%
\       Type: Variable
\   Category: Utility routines
\    Summary: Denotes the end of the first part of the main game code (CODE1),
\             from ELITE A to ELITE C
\
\ ******************************************************************************

.R%

 SKIP 0

 ASSERT R% < SCBASE     \ Make sure that CODE1 doesn't spill over into screen
                        \ memory at SCBASE


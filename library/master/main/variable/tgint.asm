\ ******************************************************************************
\
\       Name: TGINT
\       Type: Variable
\   Category: Keyboard
\    Summary: The keys used to toggle configuration settings when the game is
\             paused
\
\ ******************************************************************************

.TGINT

 EQUB 1                 \ The configuration keys in the same order as their
 EQUS "AXFYJKUT"        \ configuration bytes (starting from DAMP). The 1 is
                        \ for CAPS LOCK, and although "U" and "T" still toggle
                        \ the relevant configuration bytes, those values ar not
                        \ used, so those keys have no effect


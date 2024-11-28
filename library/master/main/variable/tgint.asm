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

IF _MASTER_VERSION

 EQUB 1                 \ The configuration keys in the same order as their
 EQUS "AXFYJKUT"        \ configuration bytes (starting from DAMP). The 1 is
                        \ for CAPS LOCK, and although "U" and "T" still toggle
                        \ the relevant configuration bytes, those values are not
                        \ used, so those keys have no effect

ELIF _APPLE_VERSION

 EQUS "DAXFYJKUT"       \ The configuration keys in the same order as their
                        \ configuration bytes (starting from DAMP)

ELIF _C64_VERSION

                        \ The configuration keys in the same order as their
                        \ configuration bytes (starting from DAMP), using their
                        \ internal key numbers as returned by the RDKEY routine

 EQUB &01               \ RUN/STOP
 EQUB &36               \ A
 EQUB &29               \ X
 EQUB &2B               \ F
 EQUB &27               \ Y
 EQUB &1E               \ J
 EQUB &1B               \ K
 EQUB &1C               \ M
 EQUB &2E               \ D
 EQUB &17               \ P
 EQUB &2C               \ C

IF _GMA_RELEASE

 EQUB &32               \ E

ENDIF

 EQUB &24               \ B

ENDIF


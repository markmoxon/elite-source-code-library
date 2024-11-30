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

 EQUB &01               \ Keyboard damping (RUN/STOP)

 EQUB &36               \ Keyboard auto-recentre ("A")

 EQUB &29               \ Author names and manual mis-jump ("X")

 EQUB &2B               \ Flashing console bars ("F")

 EQUB &27               \ Reverse joystick Y-channel ("Y")

 EQUB &1E               \ Reverse both joystick channels ("J")

 EQUB &1B               \ Keyboard or joystick ("K")

 EQUB &1C               \ Docking music toggle ("M")

 EQUB &2E               \ Current media ("D")

 EQUB &17               \ Planetary details ("P")

 EQUB &2C               \ Allow docking music to be toggled ("C")

IF _GMA_RELEASE

 EQUB &32               \ Docking music tune ("E")

ENDIF

 EQUB &24               \ Allow sounds during music ("B")

ENDIF


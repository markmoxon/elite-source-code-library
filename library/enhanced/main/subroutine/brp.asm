\ ******************************************************************************
\
\       Name: BRP
\       Type: Subroutine
\   Category: Missions
\    Summary: Print an extended token and show the Status Mode screen
\
IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BAYSTEP             Go to the docking bay (i.e. show the Status Mode screen)
\
ENDIF
\ ******************************************************************************

.BRP

IF _MASTER_VERSION \ Advanced: The Master version shows the mission briefings in cyan, while the 6502SP version shows the text in white and rotating ship in cyan, and the disc version shows the whole thing in white

 LDX #CYAN              \ Switch to colour 3, which is white or cyan
 STX COL

ENDIF

IF NOT(_NES_VERSION)

 JSR DETOK              \ Print the extended token in A

ELIF _NES_VERSION

 JSR DETOK_b2           \ Print the extended token in A

 JSR FadeToBlack_b3     \ Fade the screen to black over the next four VBlanks

ENDIF

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Label

.BAYSTEP

ENDIF

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen) and return from the subroutine
                        \ using a tail call


\ ******************************************************************************
\
\       Name: BRP
\       Type: Subroutine
\   Category: Missions
\    Summary: Print an extended token and show the Status Mode screen
\
\ ******************************************************************************

.BRP

IF _MASTER_VERSION \ Advanced: The Master version shows the mission briefings in cyan, while the 6502SP version shows the text in white and rotating ship in cyan, and the disc version shows the whole thing in white

 LDX #CYAN              \ Switch to colour 3, which is white or cyan
 STX COL

ENDIF

 JSR DETOK              \ Print the extended token in A

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen) and return from the subroutine
                        \ using a tail call


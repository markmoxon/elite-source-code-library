\ ******************************************************************************
\
\       Name: BlankButtons6To11
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Blank from the sixth to the eleventh button on the icon bar
\
\ ******************************************************************************

.BlankButtons6To11

 LDY #14                \ Blank the sixth button on the icon bar
 JSR DrawBlankButton3x2

 LDY #17                \ Blank the seventh button on the icon bar
 JSR DrawBlankButton2x2


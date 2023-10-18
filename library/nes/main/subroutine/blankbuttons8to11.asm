\ ******************************************************************************
\
\       Name: BlankButtons8To11
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Blank from the eighth to the eleventh button on the icon bar
\
\ ******************************************************************************

.BlankButtons8To11

 LDY #19                \ Blank the eighth button on the icon bar
 JSR DrawBlankButton3x2

 LDY #22                \ Blank the ninth button on the icon bar
 JSR DrawBlankButton2x2

 LDY #24                \ Blank the tenth button on the icon bar
 JSR DrawBlankButton3x2

 LDY #27                \ Blank the eleventh button on the icon bar and return
 JMP DrawBlankButton2x2 \ from the subroutine using a tail call


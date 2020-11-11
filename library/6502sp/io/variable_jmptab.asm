\ ******************************************************************************
\       Name: JMPTAB
\ ******************************************************************************

\ Vectors for OSWRCH - routine should end with JMPPUTBACK once it has had its fill of data

.JMPTAB

\Vector lookup table
 EQUW USOSWRCH
 EQUW BEGINLIN
 EQUW ADDBYT
 EQUW DOFE21 \3
 EQUW DOHFX
 EQUW SETXC \5
 EQUW SETYC \6
 EQUW CLYNS \7
 EQUW RDPARAMS \8-GAME PARAMETERS
 EQUW ADPARAMS \9
 EQUW DODIALS\10
 EQUW DOVIAE\11
 EQUW DOBULB\12
 EQUW DOCATF\13
 EQUW DOCOL \14
 EQUW SETVDU19 \15
 EQUW DOSVN \16
 EQUW DOBRK \17
 EQUW printer
 EQUW prilf


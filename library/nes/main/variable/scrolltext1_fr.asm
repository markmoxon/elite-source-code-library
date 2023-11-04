\ ******************************************************************************
\
\       Name: scrollText1_FR
\       Type: Variable
\   Category: Combat demo
\    Summary: Text for the first scroll text in French
\  Deep dive: Multi-language support in NES Elite
\
\ ******************************************************************************

.scrollText1_FR

IF _NTSC

 EQUS "   NTSC EMULATION    "
 EQUS "  --- E L # T E ---  "
 EQUS "(C)BELL & BRABEN 1991"

ELIF _PAL

 EQUS " IMAGINEER PRESENTE  "
 EQUS "  --- E L # T E ---  "
 EQUS "(C)BRABEN & BELL 1991"

ENDIF

 EQUS "                     "
 EQUS " PREPAREZ-VOUS  A  LA"
 EQUS "SIMULATION DU COMBAT!"


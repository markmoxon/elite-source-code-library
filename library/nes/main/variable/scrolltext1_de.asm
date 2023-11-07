\ ******************************************************************************
\
\       Name: scrollText1_DE
\       Type: Variable
\   Category: Combat demo
\    Summary: Text for the first scroll text in German
\  Deep dive: Multi-language support in NES Elite
\             The NES combat demo
\
\ ******************************************************************************

.scrollText1_DE

IF _NTSC

 EQUS "   NTSC EMULATION    "
 EQUS "  --- E L # T E ---  "
 EQUS "(C)BELL & BRABEN 1991"

ELIF _PAL

 EQUS "   IMAGINEER ZEIGT   "
 EQUS "  --- E L # T E ---  "
 EQUS "(C)BRABEN & BELL 1991"

ENDIF

 EQUS "                     "
 EQUS "RUSTEN  SIE  SICH ZUM"
 EQUS "PROBEKAMPF..........."


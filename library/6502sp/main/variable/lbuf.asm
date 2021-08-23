\ ******************************************************************************
\
\       Name: LBUF
\       Type: Variable
\   Category: Drawing lines
\    Summary: The multi-segment line buffer used by LOIN
\
\ ------------------------------------------------------------------------------
\
\ This buffer contains a hidden message containing the authors' names, which is
\ overwritten when the buffer is used.
\
\ ******************************************************************************

.LBUF

IF _MATCH_EXTRACTED_BINARIES

 IF _SNG45

  EQUS "By Ian Bell & David Braben"
  EQUB 10
  EQUB 13
  INCBIN "versions/6502sp/4-reference-binaries/sng45/workspaces/ELTB-LBUF.bin"

 ELIF _EXECUTIVE

  EQUS "- By Ian Bell & David Braben"
  EQUB 10
  EQUB 13
  INCBIN "versions/6502sp/4-reference-binaries/executive/workspaces/ELTB-LBUF.bin"

 ELIF _SOURCE_DISC

  EQUS "By Ian Bell & David Braben"
  EQUB 10
  EQUB 13
  INCBIN "versions/6502sp/4-reference-binaries/source-disc/workspaces/ELTB-LBUF.bin"

 ENDIF

ELSE

 SKIP 256

ENDIF


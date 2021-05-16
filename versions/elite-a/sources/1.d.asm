INCLUDE "versions/elite-a/sources/elite-header.h.asm"

_RELEASED               = (_RELEASE = 1)
_SOURCE_DISC            = (_RELEASE = 2)

ORG &11E3

INCBIN "versions/elite-a/output/tcode.bin"

IF _RELEASED
 INCBIN "versions/elite-a/extracted/released/workspaces/1.D.bin"
ELIF _SOURCE_DISC
 INCBIN "versions/elite-a/extracted/source-disc/workspaces/1.D.bin"
ENDIF

ORG &5600

IF _RELEASED
 INCBIN "versions/elite-a/extracted/released/S.T.bin"
ELIF _SOURCE_DISC
 INCBIN "versions/elite-a/extracted/source-disc/S.T.bin"
ENDIF

SAVE "versions/elite-a/output/1.D.bin", &11E3, &6000

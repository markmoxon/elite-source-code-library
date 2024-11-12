\ ******************************************************************************
\
\       Name: SPMASK
\       Type: Variable
\   Category: Missions
\    Summary: ???
\
\ ******************************************************************************

.SPMASK

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

 EQUW &04FB             \ These bytes are unused and are left over from the
 EQUW &08F7             \ Commodore 64 version
 EQUW &10EF
 EQUW &20DF
 EQUW &40BF
 EQUW &807F

ELIF _C64_VERSION

 EQUW &04FB             \ ???
 EQUW &08F7
 EQUW &10EF
 EQUW &20DF
 EQUW &40BF
 EQUW &807F

ENDIF


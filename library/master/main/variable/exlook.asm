\ ******************************************************************************
\
\       Name: exlook
\       Type: Variable
\   Category: Drawing ships
IF _MASTER_VERSION OR _APPLE_VERSION
\    Summary: An unused block of explosion data
ELIF _C64_VERSION
\    Summary: ???
ENDIF
\
\ ******************************************************************************

.exlook

IF _MASTER_VERSION OR _APPLE_VERSION

 EQUB 0                 \ These bytes appear to be unused, and are left over
 EQUB 2                 \ from the Commodore 64 version of Elite

ELIF _C64_VERSION

 EQUB 0                 \ ???
 EQUB 2

ENDIF


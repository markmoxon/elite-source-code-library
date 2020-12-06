IF _CASSETTE_VERSION

\ ******************************************************************************
\
\       Name: SVN
\       Type: Variable
\   Category: Save and load
\    Summary: The "saving in progress" flag
\
\ ******************************************************************************

.SVN

ELIF _6502SP_VERSION

.svn

ENDIF

 EQUB 0                 \ "Saving in progress" flag
                        \
                        \ Set to 1 while we are saving a commander, 0 otherwise


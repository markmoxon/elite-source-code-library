IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\ ******************************************************************************
\
\       Name: SVN
\       Type: Variable
\   Category: Save and load
\    Summary: The "saving in progress" flag
\
\ ******************************************************************************

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

.SVN

ELIF _6502SP_VERSION

.svn

ENDIF

 SKIP 1                 \ "Saving in progress" flag
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
                        \   * Non-zero while we are saving a commander
ELIF _6502SP_VERSION
                        \   * Non-zero while the disc is being accessed (so this
                        \     is also the case for cataloguing, loading etc.)
ENDIF
                        \
                        \   * 0 otherwise


\ ******************************************************************************
\
\       Name: TABLE
\       Type: Variable
\   Category: Drawing lines
\    Summary: The line buffer for line data transmited from the parasite
\
\ ------------------------------------------------------------------------------
\
\ Lines are drawn by sending the line coordinates one byte at a time from the
\ parasite, using the OSWRCH 129 and 130 commands. As they are sent, they are
\ stored in the TABLE buffer, until all the points have been received, at which
\ point the line is drawn.
\
\ LINTAB points to the offset of the first free byte within TABLE, so the table
\ can be reset by setting LINTAB to 0.
\
\ ******************************************************************************

ORG &2300

.TABLE

 SKIP 256


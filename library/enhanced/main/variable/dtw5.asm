IF NOT(_NES_VERSION)
\ ******************************************************************************
\
\       Name: DTW5
\       Type: Variable
\   Category: Text
\    Summary: The size of the justified text buffer at BUF
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ When justified text is enabled by jump token 14, {justify}, during printing of
\ extended text tokens, text is fed into a buffer at BUF instead of being
\ printed straight away, so it can be padded out with spaces to justify the
\ text. DTW5 contains the size of the buffer, so BUF + DTW5 points to the first
\ free byte after the end of the buffer.
\
\ ******************************************************************************

.DTW5

 EQUB 0

ELIF _NES_VERSION

.DTW5

 SKIP 1                 \ The size of the justified text buffer at BUF

ENDIF


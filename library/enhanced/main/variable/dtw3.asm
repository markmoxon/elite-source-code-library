IF NOT(_NES_VERSION)
\ ******************************************************************************
\
\       Name: DTW3
\       Type: Variable
\   Category: Text
\    Summary: A flag for switching between standard and extended text tokens
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This variable is used to indicate whether standard or extended text tokens
\ should be printed by calls to DETOK. It allows us to mix standard tokens in
\ with extended tokens. It has two values:
\
\   * %00000000 = print extended tokens (i.e. those in TKN1 and RUTOK)
\
\   * %11111111 = print standard tokens (i.e. those in QQ18)
\
\ The default value is %00000000 (extended tokens).
\
\ Standard tokens are set by jump token {6}, which calls routine MT6 to change
\ the value of DTW3 to %11111111.
\
\ Extended tokens are set by jump token {5}, which calls routine MT5 to change
\ the value of DTW3 to %00000000.
\
\ ******************************************************************************

.DTW3

 EQUB %00000000

ELIF _NES_VERSION

.DTW3

 SKIP 1                 \ A flag for switching between standard and extended
                        \ text tokens
                        \
                        \   * %00000000 = print extended tokens (i.e. those in
                        \                 TKN1 and RUTOK)
                        \
                        \   * %11111111 = print standard tokens (i.e. those in
                        \                 QQ18)

ENDIF


\ ******************************************************************************
\
\       Name: Dashboard image
\       Type: Variable
\   Category: Loader
\    Summary: The binary for the dashboard image
\
\ ------------------------------------------------------------------------------
\
\ The data file contains the dashboard binary, which gets moved into screen
\ memory by the loader:
\
\   * P.DIALS2P.bin contains the dashboard, which gets moved to screen address
\     &7000, which is the starting point of the eight-colour mode 2 portion at
\     the bottom of the split screen
\
\ ******************************************************************************

.DIALS

INCBIN "versions/master/1-source-files/images/P.DIALS2P.bin"


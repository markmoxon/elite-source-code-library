\ ******************************************************************************
\
\       Name: VSCAN
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Defines the split position in the split-screen mode
\
\ ******************************************************************************

.VSCAN

 EQUB 57                \ Defines the split position in the split-screen mode

 EQUB 30                \ The line scan counter in DL gets reset to this value
                        \ at each vertical sync, before decrementing with each
                        \ line scan

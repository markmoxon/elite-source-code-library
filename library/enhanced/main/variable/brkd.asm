\ ******************************************************************************
\
\       Name: brkd
\       Type: Variable
\   Category: Utility routines
\    Summary: The brkd counter for error handling
\
\ ------------------------------------------------------------------------------
\
\ This counter starts at zero, and is decremented whenever the BRKV handler at
\ BRBR prints an error message. It is incremented every time an error message
\ is printed out as part of the TITLE routine.
\
\ ******************************************************************************

.brkd

 EQUB 0


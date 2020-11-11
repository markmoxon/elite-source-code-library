\ ******************************************************************************
\
\       Name: Authors' names
\       Type: Variable
\   Category: Copy protection
\    Summary: The authors' names, buried in the code
\
\ ------------------------------------------------------------------------------
\
\ Contains the authors' names, plus an unused OS command string that would
\ *RUN the main game code, which isn't what actually happens (so presumably
\ this is to throw the crackers off the scent).
\
\ ******************************************************************************

 EQUS "R.ELITEcode"
 EQUB 13
 EQUS "By D.Braben/I.Bell"
 EQUB 13
 EQUB &B0


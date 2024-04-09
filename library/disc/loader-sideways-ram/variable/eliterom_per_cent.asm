\ ******************************************************************************
\
\       Name: eliterom%
\       Type: Variable
\   Category: Loader
\    Summary: The number of the bank containing the Elite ROM
\
\ ******************************************************************************

.eliterom%

 EQUB &FF               \ Gets set to the bank number containing the Elite ROM
                        \ (or &FF if the ROM is not present)


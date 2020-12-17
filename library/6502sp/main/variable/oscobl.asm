\ ******************************************************************************
\
\       Name: oscobl
\       Type: Variable
\   Category: Save and load
\    Summary: OSFILE configuration block for saving a screenshot
\
\ ------------------------------------------------------------------------------
\
\ This OSFILE configuration block is overwritten by the block at oscobl2 before
\ being passed to OSFILE to save a screenshot.
\
\ ******************************************************************************

.oscobl

 EQUW scname            \ The address of the filename to save

 EQUD &FFFF4000         \ Load address of the saved file

 EQUD &FFFF4000         \ Execution address of the saved file

 EQUD &FFFF4000         \ Start address of the memory block to save

 EQUD &FFFF8000         \ End address of the memory block to save


\ ******************************************************************************
\
\       Name: oscobl2
\       Type: Variable
\   Category: Save and load
\    Summary: Master OSFILE configuration block for saving a screenshot
\
\ ------------------------------------------------------------------------------
\
\ This OSFILE configuration block is copied from oscobl2 to oscobl in order to
\ save a screenshot.
\
\ ******************************************************************************

.oscobl2

 EQUW scname            \ The address of the filename to save

 EQUD &FFFF4000         \ Load address of the saved file

 EQUD &FFFF4000         \ Execution address of the saved file

 EQUD &FFFF4000         \ Start address of the memory block to save

 EQUD &FFFF8000         \ End address of the memory block to save


\ ******************************************************************************
\
\       Name: osfileBlock
\       Type: Variable
\   Category: Loader
\    Summary: OSFILE configuration block for loading a ship blueprint file
\
\ ******************************************************************************

.osfileBlock

 EQUW shipFilename      \ The address of the filename to load

 EQUD &FFFF0000 + XX21  \ Load address of the file

 EQUD &00000000         \ Execution address (not used when loading a file)

 EQUD &00000000         \ Start address (not used when loading a file)

 EQUD &00000000         \ End address (not used when loading a file)


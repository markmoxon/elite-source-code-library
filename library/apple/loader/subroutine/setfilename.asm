\ ******************************************************************************
\
\       Name: SetFilename
\       Type: Subroutine
\   Category: Loader
\    Summary: Set the filename in comnam to ELB1
\
\ ******************************************************************************

.SetFilename

 LDY #0                 \ Set Y = 0 to use as a character counter

.name1

 LDA filename,Y         \ Copy the Y-th character of filename to the Y-th
 STA comnam,Y           \ character of comnam

 INY                    \ Increment the character counter

 CPY #4                 \ Loop back until we have copied all four characters of
 BNE name1              \ filename to comnam

 RTS                    \ Return from the subroutine


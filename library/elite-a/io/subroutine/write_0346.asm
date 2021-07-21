\ ******************************************************************************
\
\       Name: write_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Receive a new value of LASCT from the parasite
\
\ ******************************************************************************

.write_0346

 JSR tube_get           \ Get the new value for LASCT from the parasite

 STA LASCT              \ Update the value in LASCT

 RTS                    \ Return from the subroutine


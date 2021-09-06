\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 2)
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the ELITE4 loader
\
\ ******************************************************************************

.ENTRY2

 LDA #15                \ Call OSBYTE with A = 129 and Y = 0 to flush the input
 LDY #0                 \ buffer
 JSR OSBYTE

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("LOAD Elite4")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which loads
                        \ the ELITE4 binary to its load address of &1900

 LDA #21                \ Call OSBYTE with A = 21 and X = 0 to flush the
 LDX #0                 \ keyboard buffer
 JSR OSBYTE

 LDA #201               \ Call OSBYTE with A = 201, X = 1 and Y = 1 to re-enable
 LDX #1                 \ the keyboard, which we disabled in the first loader
 LDY #1
 JSR OSBYTE

 JMP &197B              \ Jump to the start of the ELITE4 loader code at &197B

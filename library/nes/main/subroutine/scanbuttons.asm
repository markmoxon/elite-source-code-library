\ ******************************************************************************
\
\       Name: ScanButtons
\       Type: Subroutine
\   Category: Controllers
\    Summary: Scan a specific controller and update the control variables
\  Deep dive: Bolting NES controllers onto the key logger
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The controller to scan:
\
\                         * 0 = scan controller 1
\
\                         * 1 = scan controller 2
\
\ Other entry points:
\
\   RTS3                Contains an RTS
\
\ ******************************************************************************

.ScanButtons

 LDA JOY1,X             \ Read the status of the A button on controller X, and
 AND #%00000011         \ if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1A (as A = 1), otherwise shift a 0
 ROR controller1A,X

 LDA JOY1,X             \ Read the status of the B button on controller X, and
 AND #%00000011         \ if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1B (as A = 1), otherwise shift a 0
 ROR controller1B,X

 LDA JOY1,X             \ Read the status of the Select button on controller
 AND #%00000011         \ X, and if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1Select (as A = 1), otherwise shift a 0
 ROR controller1Select,X

 LDA JOY1,X             \ Read the status of the Start button on controller
 AND #%00000011         \ X, and if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1Start (as A = 1), otherwise shift a 0
 ROR controller1Start,X

 LDA JOY1,X             \ Read the status of the up button on controller X,
 AND #%00000011         \ and if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1Up (as A = 1), otherwise shift a 0
 ROR controller1Up,X

 LDA JOY1,X             \ Read the status of the down button on controller
 AND #%00000011         \ X, and if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1Down (as A = 1), otherwise shift a 0
 ROR controller1Down,X

 LDA JOY1,X             \ Read the status of the left button on controller
 AND #%00000011         \ X, and if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1Left (as A = 1), otherwise shift a 0
 ROR controller1Left,X

 LDA JOY1,X             \ Read the status of the right button on controller
 AND #%00000011         \ X, and if it is being pressed, shift a 1 into bit 7 of
 CMP #%00000001         \ controller1Right (as A = 1), otherwise shift a 0
 ROR controller1Right,X

.RTS3

 RTS                    \ Return from the subroutine


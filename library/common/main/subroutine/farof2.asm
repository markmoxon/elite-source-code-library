\ ******************************************************************************
\
\       Name: FAROF2
\       Type: Subroutine
\   Category: Maths (Geometry)
\    Summary: Compare x_hi, y_hi and z_hi with A
\
\ ------------------------------------------------------------------------------
\
\ Compare x_hi, y_hi and z_hi with A, and set the C flag if all three <= A,
\ otherwise clear the C flag.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if x_hi <= A and y_hi <= A and z_hi <= A
\
\                       Clear otherwise (i.e. if any one of them are bigger than
\                       A)
\
\ ******************************************************************************

.FAROF2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 CMP INWK+1             \ If A < x_hi, C will be clear so jump to MA34 to
 BCC MA34               \ return from the subroutine with C clear, otherwise
                        \ C will be set so move on to the next one

 CMP INWK+4             \ If A < y_hi, C will be clear so jump to MA34 to
 BCC MA34               \ return from the subroutine with C clear, otherwise
                        \ C will be set so move on to the next one

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

 CMP INWK+1             \ If A < x_hi, C will be clear so jump to FA1 to
 BCC FA1                \ return from the subroutine with C clear, otherwise
                        \ C will be set so move on to the next one

 CMP INWK+4             \ If A < y_hi, C will be clear so jump to FA1 to
 BCC FA1                \ return from the subroutine with C clear, otherwise
                        \ C will be set so move on to the next one

ENDIF

 CMP INWK+7             \ If A < z_hi, C will be clear, otherwise C will be set

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

.MA34

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION

.FA1

ENDIF

 RTS                    \ Return from the subroutine


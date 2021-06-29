\ ******************************************************************************
\
\       Name: eq
\       Type: Subroutine
\   Category: Equipment
\    Summary: Subtract the price of equipment from the cash pot
\
\ ------------------------------------------------------------------------------
\
\ If we have enough cash, subtract the price of a specified piece of equipment
\ from our cash pot and return from the subroutine. If we don't have enough
\ cash, exit to the docking bay (i.e. show the Status Mode screen).
\
\ Arguments:
\
\   A                   The item number of the piece of equipment (0-11) as
\                       shown in the table at PRXS
\
IF _ELITE_A_VERSION
\ Other entry points:
\
\   query_beep          Print the recursive token given in A followed by a
\                       question mark, then make a beep, pause and go to the
\                       docking bay (i.e. show the Status Mode screen)
\
ENDIF
\ ******************************************************************************

.eq

 JSR prx                \ Call prx to set (Y X) to the price of equipment item
                        \ number A

 JSR LCASH              \ Subtract (Y X) cash from the cash pot, but only if
                        \ we have enough cash

 BCS c                  \ If the C flag is set then we did have enough cash for
                        \ the transaction, so jump to c to return from the
                        \ subroutine (as c contains an RTS)

IF NOT(_ELITE_A_VERSION)

 LDA #197               \ Otherwise we don't have enough cash to buy this piece
 JSR prq                \ of equipment, so print recursive token 37 ("CASH")
                        \ followed by a question mark

ELIF _ELITE_A_VERSION

 LDA #197               \ Otherwise we don't have enough cash to buy this piece
                        \ of equipment, so set A to the value for recursive
                        \ token 37 ("CASH")

.query_beep

 JSR prq                \ Print the recursive token in A followed by a question
                        \ mark

ENDIF

 JMP err                \ Jump to err to beep, pause and go to the docking bay
                        \ (i.e. show the Status Mode screen)


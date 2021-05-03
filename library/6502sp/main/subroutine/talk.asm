\ ******************************************************************************
\
\       Name: TALK
\       Type: Subroutine
\   Category: Sound
\    Summary: Speak using the Watford Electronics Beeb Speech Synthesiser
\  Deep dive: Secrets of the Executive version
\
\ ------------------------------------------------------------------------------
\
\ In the Executive version, if you have a Watford Electronics Beeb Speech
\ Synthesiser fitted and enable speech by presing ":" while the game is paused,
\ then the game will speak to you at various points.
\
\ ******************************************************************************

.TALK

IF _6502SP_VERSION \ 6502SP: The Executive version supports speech, via the TALK routine. Speech will work only if you have a Watford Electronics Beeb Speech Synthesiser fitted and enable speech in the configuration options

IF _EXECUTIVE

 TYA                    \ Store Y on the stack to we can retrieve it later
 PHA

 BIT SPEAK              \ If SPEAK is 0, then speech is not enabled, so jump
 BPL TALK4              \ to TALK4 to restore Y from the stack and return
                        \ from the subroutine

 LDA #0                 \ Set SC = 0
 STA SC

 LDY #LO(SPEECH)        \ Set Y to point to the low byte of SPEECH

 LDA #HI(SPEECH)        \ Set SC(1 0) so it points to the start of the page
 STA SC+1               \ containing SPEECH, so by this point, so SC+Y points
                        \ to the first byte of SPEECH

.TALKL

 LDA (SC),Y             \ Fetch the next byte from the SPEECH block

 CMP #13                \ If it not 13 (which is the terminator for each speech
 BNE TALK1              \ command), jump to TALK1 to skip to the next byte

 DEX                    \ We just reached a terminator, so decrement the phrase
                        \ number in X

 BEQ TALK2              \ If X is now 0, we have now found the terminator just
                        \ before the phrase we want (the X-th phrase), so jump
                        \ to TALK2 to speak it

.TALK1

 INY                    \ Increment the byte counter in Y to point to the next
                        \ byte in the SPEECH table

 BNE TALKL              \ If Y is non-zero, loop back to TALKL to process the
                        \ next byte

 INC SC+1               \ Y is 0, which means SC+Y has just crossed a page
                        \ boundary, so increment the high byte in SC+1 so that
                        \ SC+Y points to the next page

 BNE TALKL              \ Loop back to TALKL to process the next byte (this BNE
                        \ is effectively a JMP as SC+1 is never zero)

.TALK2

 INY                    \ If we get here then SC+Y points to the terminator
                        \ before the phrase we want, so increment Y to point to
                        \ the start of the phrase we want

 BNE TALK3              \ If Y is non-zero, then SC+Y points to the phrase we
                        \ want to speak, so jump to TALK3 to do the speaking

 INC SC+1               \ Y is 0, which means SC+Y has just crossed a page
                        \ boundary, so increment the high byte in SC+1 so that
                        \ SC+Y points to the next page

.TALK3

 TYA                    \ Set (Y X) to point to (SC+1 Y), i.e. SC+Y
 TAX
 LDY SC+1

 JSR OSCLI              \ Call OSCLI to run the OS command in SC+Y, which will
                        \ be of the form "*TALK xx", a command for making the
                        \ Watford Electronics Beeb Speech Synthesiser talk

.TALK4

 PLA                    \ Restore the value of Y we stored on the stack, so it
 TAY                    \ gets preserved across the call to the subroutine

 RTS                    \ Return from the subroutine

ENDIF

ENDIF


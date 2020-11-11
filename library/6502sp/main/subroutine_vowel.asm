\ ******************************************************************************
\       Name: VOWEL
\ ******************************************************************************

.VOWEL

 ORA #32
 CMP #'a'
 BEQ VRTS
 CMP #'e'
 BEQ VRTS
 CMP #'i'
 BEQ VRTS
 CMP #'o'
 BEQ VRTS
 CMP #'u'
 BEQ VRTS
 CLC

.VRTS

 RTS


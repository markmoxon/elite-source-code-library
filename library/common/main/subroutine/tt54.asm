\ ******************************************************************************
\
\       Name: TT54
\       Type: Subroutine
\   Category: Universe
\    Summary: Twist the selected system's seeds
\  Deep dive: Twisting the system seeds
\             Galaxy and system seeds
\
\ ------------------------------------------------------------------------------
\
\ This routine twists the three 16-bit seeds in QQ15 once.
\
\ If we start with seeds s0, s1 and s2 and we want to work out their new values
\ after we perform a twist (let's call the new values s0´, s1´ and s2´), then:
\
\  s0´ = s1
\  s1´ = s2
\  s2´ = s0 + s1 + s2
\
\ So given an existing set of seeds in s0, s1 and s2, we can get the new values
\ s0´, s1´ and s2´ simply by doing the above sums. And if we want to do the
\ above in-place without creating three new w´ variables, then we can do the
\ following:
\
\  tmp = s0 + s1
\  s0 = s1
\  s1 = s2
\  s2 = tmp + s1
\
\ So this is what we do in this routine, where each seed is a 16-bit number.
\
\ ******************************************************************************

.TT54

 LDA QQ15               \ X = tmp_lo = s0_lo + s1_lo
 CLC
 ADC QQ15+2
 TAX

 LDA QQ15+1             \ Y = tmp_hi = s1_hi + s1_hi + C
 ADC QQ15+3
 TAY

 LDA QQ15+2             \ s0_lo = s1_lo
 STA QQ15

 LDA QQ15+3             \ s0_hi = s1_hi
 STA QQ15+1

 LDA QQ15+5             \ s1_hi = s2_hi
 STA QQ15+3

 LDA QQ15+4             \ s1_lo = s2_lo
 STA QQ15+2

 CLC                    \ s2_lo = X + s1_lo
 TXA
 ADC QQ15+2
 STA QQ15+4

 TYA                    \ s2_hi = Y + s1_hi + C
 ADC QQ15+3
 STA QQ15+5

 RTS                    \ The twist is complete so return from the subroutine


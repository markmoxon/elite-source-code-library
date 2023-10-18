\ ******************************************************************************
\
\       Name: SetViewAttrs
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set up attribute buffer 0 for the chosen view
\
\ ******************************************************************************

.SetViewAttrs

 LDX languageIndex      \ Set X to the index of the chosen language

 LDA viewAttributesLo,X \ Set V(1 0) = viewAttributes_EN, _FR or _DE, according
 STA V                  \ to the chosen language
 LDA viewAttributesHi,X
 STA V+1

 LDA QQ11               \ Set Y to the low nibble of the view type, which is
 AND #&0F               \ the view type with the flags stripped off (so it's
 TAY                    \ in the range 0 to 15)

 LDA (V),Y              \ Set X to the Y-th entry from the viewAttributes_XX
 ASL A                  \ table for the chosen language, which contains the
 TAX                    \ number of the set of view attributes that we need to
                        \ apply to this view

 LDA viewAttrOffset,X   \ Set V(1 0) viewAttrOffset for set X + viewAttrCount
 ADC #LO(viewAttrCount) \
 STA V                  \ So V(1 0) points to viewAttrributes0 when X = 0,
 LDA viewAttrOffset+1,X \ viewAttrributes1 when X = 1, and so on up to
 ADC #HI(viewAttrCount) \ viewAttrributes23 when X = 23
 STA V+1

 LDA #HI(attrBuffer0)   \ Set SC(1 0) to the address of attribute buffer 0
 STA SC+1
 LDA #LO(attrBuffer0)
 STA SC

 JMP UnpackToRAM        \ Unpack the data at V(1 0) into SC(1 0), updating
                        \ V(1 0) as we go
                        \
                        \ SC(1 0) is attribute buffer 0, so this unpacks the set
                        \ of view attributes for the view in QQ11 into attribute
                        \ buffer 0
                        \
                        \ We then return from the subroutine using a tail call


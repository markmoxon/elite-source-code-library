\ ******************************************************************************
\
\       Name: JMTB
\       Type: Variable
\   Category: Text
\    Summary: The extended token table for jump tokens 1-32 (DETOK)
\
\ ******************************************************************************

.JMTB

 EQUW MT1               \ Token  1: Switch to ALL CAPS
 EQUW MT2               \ Token  2: Switch to Sentence Case
 EQUW TT27              \ Token  3: Print selected system name
 EQUW TT27              \ Token  4: Print commander's name
 EQUW MT5               \ Token  5: Switch to extended tokens
 EQUW MT6               \ Token  6: Switch to standard tokens, in Sentence Case
 EQUW DASC              \ Token  7: Beep
 EQUW MT8               \ Token  8: ??? Tab to column 6, apply lower case
 EQUW MT9               \ Token  9: Tab to column 1, current view type to 1
 EQUW DASC              \ Token 10: Line feed
 EQUW NLIN4             \ Token 11: Draw a horizontal line at pixel row 19
 EQUW DASC              \ Token 12: ??? Newline
 EQUW MT13              \ Token 13: Switch to lower case
 EQUW MT14              \ Token 14: Switch to justified text
 EQUW MT15              \ Token 15: Switch to left-aligned text
 EQUW MT16              \ Token 16: Print the character in DTW7 (drive number)
 EQUW MT17              \ Token 17: 
 EQUW MT18              \ Token 18: Randomly print 1 to 4 two-letter tokens
 EQUW MT19              \ Token 19: Capitalise first letter of next word only
 EQUW DASC              \ Token 20: 
 EQUW CLYNS             \ Token 21: 
 EQUW PAUSE             \ Token 22: 
 EQUW MT23              \ Token 23: 
 EQUW PAUSE2            \ Token 24: 
 EQUW BRIS              \ Token 25: 
 EQUW MT26              \ Token 26: 
 EQUW MT27              \ Token 27: Print mission 1 captain's name (217-219)
 EQUW MT28              \ Token 28: Print mission 1 location hint (220-221)
 EQUW MT29              \ Token 29: 
 EQUW WHITETEXT         \ Token 30: 
 EQUW DASC              \ Token 31: 
 EQUW DASC              \ Token 32: 


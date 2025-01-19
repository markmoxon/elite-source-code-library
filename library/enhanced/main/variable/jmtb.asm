\ ******************************************************************************
\
\       Name: JMTB
\       Type: Variable
\   Category: Text
\    Summary: The extended token table for jump tokens 1-32 (DETOK)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.JMTB

 EQUW MT1               \ Token  1: Switch to ALL CAPS
 EQUW MT2               \ Token  2: Switch to Sentence Case
 EQUW TT27              \ Token  3: Print the selected system name
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EQUW TT27              \ Token  4: Print the commander's name
 EQUW MT5               \ Token  5: Switch to extended tokens
 EQUW MT6               \ Token  6: Switch to standard tokens, in Sentence Case
ELIF _ELITE_A_ENCYCLOPEDIA
 EQUW MT6               \ Token  4: Switch to standard tokens, in Sentence Case
 EQUW MT5               \ Token  5: Switch to extended tokens
 EQUW set_token         \ Token  6: Start a new word
ENDIF
 EQUW DASC              \ Token  7: Beep
 EQUW MT8               \ Token  8: Tab to column 6
 EQUW MT9               \ Token  9: Clear screen, tab to column 1, view type = 1
 EQUW DASC              \ Token 10: Line feed
 EQUW NLIN4             \ Token 11: Draw box around title (line at pixel row 19)
 EQUW DASC              \ Token 12: Carriage return
 EQUW MT13              \ Token 13: Switch to lower case
 EQUW MT14              \ Token 14: Switch to justified text
 EQUW MT15              \ Token 15: Switch to left-aligned text
 EQUW MT16              \ Token 16: Print the character in DTW7 (drive number)
 EQUW MT17              \ Token 17: Print system name adjective in Sentence Case
 EQUW MT18              \ Token 18: Randomly print 1 to 4 two-letter tokens
 EQUW MT19              \ Token 19: Capitalise first letter of next word only
 EQUW DASC              \ Token 20: Unused
IF NOT(_APPLE_VERSION)
 EQUW CLYNS             \ Token 21: Clear the bottom few lines of the space view
ELIF _APPLE_VERSION
 EQUW CLYNS             \ Token 21: Clear a space near the bottom of the screen
ENDIF
IF NOT(_ELITE_A_ENCYCLOPEDIA)
 EQUW PAUSE             \ Token 22: Display ship and wait for key press
 EQUW MT23              \ Token 23: Move to row 10, white text, set lower case
 EQUW PAUSE2            \ Token 24: Wait for a key press
 EQUW BRIS              \ Token 25: Show incoming message screen, wait 2 seconds
ELIF _ELITE_A_ENCYCLOPEDIA
 EQUW column_16         \ Token 22: Tab to column 16
 EQUW MT23              \ Token 23: Move to row 10, white text, set lower case
 EQUW clr_vdustat       \ Token 24: Switch to standard tokens in lower case
 EQUW DASC              \ Token 25: Unused
ENDIF
IF NOT(_NES_VERSION)
 EQUW MT26              \ Token 26: Fetch line input from keyboard (filename)
ELIF _NES_VERSION
 EQUW MT26              \ Token 26: Print a space and capitalise the next letter
ENDIF
 EQUW MT27              \ Token 27: Print mission captain's name (217-219)
 EQUW MT28              \ Token 28: Print mission 1 location hint (220-221)
 EQUW MT29              \ Token 29: Column 6, white text, lower case in words
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Advanced: The 6502SP version has an extended jump token for switching to white text, while the Master version uses the same token for displaying the currently selected file system (though this token isn't actually used in the Master version, as this is unused code from the Commodore 64 version)
 EQUW DASC              \ Token 30: Unused
ELIF _6502SP_VERSION
 EQUW WHITETEXT         \ Token 30: White text
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUW FILEPR            \ Token 30: Display currently selected media (disk/tape)
ENDIF
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The Master version has an extended jump token for displaying the non-selected file system, though this token isn't actually used as the file system can't be changed from disc
 EQUW DASC              \ Token 31: Unused
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUW OTHERFILEPR       \ Token 31: Display the non-selected media (disk/tape)
ENDIF
 EQUW DASC              \ Token 32: Unused


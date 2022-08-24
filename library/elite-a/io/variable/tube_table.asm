\ ******************************************************************************
\
\       Name: tube_table
\       Type: Variable
\   Category: Tube
\    Summary: Lookup table for Tube commands sent from the parasite to the I/O
\             processor
\  Deep dive: Tube communication in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ This table lists all the commands that can be sent from the parasite to the
\ I/O processor.
\
\ The hexadecimal number is the number of that command, and is the first byte to
\ be sent over the Tube. The parameters shown in brackets are sent next, in the
\ order shown, and if the command returns a result (denoted by a leading = sign
\ in the command name), then this is then sent back to the parasite.
\
\ Consider the following command, which scans the keyboard or Delta 14B keypad
\ for a specific flight key:
\
\   =scan_y(key_offset, delta_14b)
\
\ To run this command, the parasite would first send a value of &96 to the I/O
\ processor (using the tube_write routine), then it would send the key_offset
\ and delta_14b parameters (in that order), and finally it would wait for the
\ result to be returned by calling the tube_read routine.
\
\ Meanwhile, at the other end, the receipt of the &96 value would trigger a call
\ to the routine in WRCHV, which is the tube_wrch routine. This routine sees
\ that the received value is greater than 127, so it calls the tube_func
\ routine, which then looks up the corresponding routine from this table
\ (routine scan_y in this case) and calls it to implement the command. The
\ scan_y routine then fetches the parameter values using the tube_get routine,
\ performs the keyboard or keypad scan according to the command's parameters,
\ and finally sends the result back to the parasite using the tube_put routine.
\
\ ******************************************************************************

.tube_table

 EQUW LL30              \ &80   draw_line(x1, y1, x2, y2)
 EQUW HLOIN             \ &81   draw_hline(x1, y1, x2)
 EQUW PIXEL             \ &82   draw_pixel(x, y, distance)
 EQUW clr_scrn          \ &83   clr_scrn()
 EQUW CLYNS             \ &84   clr_line()
 EQUW sync_in           \ &85   =sync_in()
 EQUW DILX              \ &86   draw_bar(value, colour, screen_low, screen_high)
 EQUW DIL2              \ &87   draw_angle(value, screen_low, screen_high)
 EQUW MSBAR             \ &88   put_missle(number, colour)
 EQUW scan_fire         \ &89   =scan_fire()
 EQUW write_fe4e        \ &8A   =write_fe4e(value)
 EQUW scan_xin          \ &8B   =scan_xin(key_number)
 EQUW scan_10in         \ &8C   =scan_10in()
 EQUW get_key           \ &8D   =get_key()
 EQUW CHPR              \ &8E   write_xyc(x, y, char)
 EQUW write_pod         \ &8F   write_pod(escp, hfx)
 EQUW draw_blob         \ &90   draw_blob(x, y, colour)
 EQUW draw_tail         \ &91   draw_tail(x, y, base_colour, alt_colour, height)
 EQUW SPBLB             \ &92   draw_S()
 EQUW ECBLB             \ &93   draw_E()
 EQUW UNWISE            \ &94   draw_mode()
 EQUW DET1              \ &95   write_crtc(rows)
 EQUW scan_y            \ &96   =scan_y(key_offset, delta_14b)
 EQUW write_0346        \ &97   write_0346(value)
 EQUW read_0346         \ &98   =read_0346()
 EQUW return            \ &99   return()
 EQUW HANGER            \ &9A   picture_h(line_count, multiple_ships)
 EQUW HA2               \ &9B   picture_v(line_count)


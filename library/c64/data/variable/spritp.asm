\ ******************************************************************************
\
\       Name: spritp
\       Type: Variable
\   Category: Sprites
\    Summary: Sprite definitions for four laser sights, the explosion sprite and
\             two Trumbles
\  Deep dive: Sprite usage in Commodore 64 Elite
\
\ ******************************************************************************

.spritp

 SPRITE2 "........................"     \ The laser sights for a pulse laser
 SPRITE2 "........................"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "..XXXXX....+....XXXXX..."
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "........................"
 SPRITE2 "........................"

 EQUB &3A               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 SPRITE2 "........................"     \ The laser sights for a beam laser
 SPRITE2 "........................"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 ".....XXXXXXXXXXXXX......"
 SPRITE2 ".....X...........X......"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "...........+............"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 ".....X...........X......"
 SPRITE2 ".....XXXXXXXXXXXXX......"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "...........X............"
 SPRITE2 "........................"
 SPRITE2 "........................"

 EQUB &31               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 SPRITE2 "........................"     \ The laser sights for a military laser
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "........XXXXXXX........."
 SPRITE2 ".........X...X.........."
 SPRITE2 "..........X.X..........."
 SPRITE2 "...........X............"
 SPRITE2 "..XX...............XX..."
 SPRITE2 "..X.X.............X.X..."
 SPRITE2 "..X..X...........X..X..."
 SPRITE2 "..X...X....+....X...X..."
 SPRITE2 "..X..X...........X..X..."
 SPRITE2 "..X.X.............X.X..."
 SPRITE2 "..XX...............XX..."
 SPRITE2 "...........X............"
 SPRITE2 "..........X.X..........."
 SPRITE2 ".........X...X.........."
 SPRITE2 "........XXXXXXX........."
 SPRITE2 "........................"
 SPRITE2 "........................"
 SPRITE2 "........................"

 EQUB &45               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 SPRITE2 "..XXXXXXXXXXXXXXXXXXX..."     \ The laser sights for a mining laser
 SPRITE2 "..X........X........X..."
 SPRITE2 "..X.......XXX.......X..."
 SPRITE2 "....X......X......X....."
 SPRITE2 "XX...X....XXX....X...XX."
 SPRITE2 "X.....X....X....X.....X."
 SPRITE2 "X......X..XXX..X......X."
 SPRITE2 "X..........X..........X."
 SPRITE2 "X........XXXXX........X."
 SPRITE2 "X.X..XX..X...X..XX..X.X."
 SPRITE2 "XXXXXX.....X.....XXXXXX."
 SPRITE2 "X.X..XX..X...X..XX..X.X."
 SPRITE2 "X........XXXXX........X."
 SPRITE2 "X..........X..........X."
 SPRITE2 "X......X..XXX..X......X."
 SPRITE2 "X.....X....X....X.....X."
 SPRITE2 "XX...X....XXX....X...XX."
 SPRITE2 "....X......X......X....."
 SPRITE2 "..X.......XXX.......X..."
 SPRITE2 "..X........X........X..."
 SPRITE2 "..XXXXXXXXXXXXXXXXXXX..."

 EQUB &A3               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 SPRITE2 "........................"     \ The explosion cloud sprite
 SPRITE2 ".........X....XX........"
 SPRITE2 "...X....XX..X...X......."
 SPRITE2 ".....X....XX...XXX......"
 SPRITE2 "...X..XX.....X..XX..X..."
 SPRITE2 "....X.....X.XX....X..X.."
 SPRITE2 ".X.XX..X..X.XX.XXX..XX.."
 SPRITE2 "...X..XX.X.X.XX...XXX..."
 SPRITE2 "XX..X.X..XX.XXX....X.XX."
 SPRITE2 "....XXX..XX.XX.XX...X.XX"
 SPRITE2 "..X.....XX.XX.XXX..XX..."
 SPRITE2 ".....XX.XX..X.XXX.XX...."
 SPRITE2 "..X...XXX.X.X..XX...X.X."
 SPRITE2 "X...XXX..XX.XX.XX...X.XX"
 SPRITE2 "...X..XX..X..X..XX..X..."
 SPRITE2 "..XX..XX..X.XX.XX..X.X.."
 SPRITE2 "....X....XX...XXX...X..."
 SPRITE2 "...XX........X....X....."
 SPRITE2 "...XX...XX....X.....XX.."
 SPRITE2 "........XX..X...X......."
 SPRITE2 ".............XX........."

 EQUB &44               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 SPRITE4 ".....***...."     \ A Trumble looking to the right
 SPRITE4 "..*.*****..."
 SPRITE4 "..***/*/**.."
 SPRITE4 ".**********."
 SPRITE4 "..**********"
 SPRITE4 ".*/***/****."
 SPRITE4 "****/*******"
 SPRITE4 ".********/*."
 SPRITE4 "************"
 SPRITE4 "************"
 SPRITE4 ".**********."
 SPRITE4 "***@@***@@**"
 SPRITE4 "**@@@@*@@@@*"
 SPRITE4 "**@@*@*@@*@*"
 SPRITE4 "***@@***@@**"
 SPRITE4 ".**********."
 SPRITE4 "..********.."
 SPRITE4 "...******..."
 SPRITE4 "....*//*...."
 SPRITE4 ".....//....."
 SPRITE4 "............"

 EQUB &44               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 SPRITE4 "............"     \ A Trumble looking to the left
 SPRITE4 "............"
 SPRITE4 "......**...."
 SPRITE4 "..**.****..."
 SPRITE4 ".*****/***.."
 SPRITE4 ".**********."
 SPRITE4 "****/******."
 SPRITE4 ".**********."
 SPRITE4 "************"
 SPRITE4 "************"
 SPRITE4 ".**********."
 SPRITE4 "***@@***@@**"
 SPRITE4 "**@@@@*@@@@*"
 SPRITE4 "**@*@@*@*@@*"
 SPRITE4 "***@@***@@**"
 SPRITE4 ".**********."
 SPRITE4 "..********.."
 SPRITE4 ".../****/..."
 SPRITE4 "....*//*...."
 SPRITE4 ".....//....."
 SPRITE4 "............"

 EQUB &54               \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process


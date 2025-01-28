\ ******************************************************************************
\
\       Name: Elite loader
\       Type: Subroutine
\   Category: Loader
\    Summary: Load the SCRN and ELB1 binaries and run the game
\
\ ------------------------------------------------------------------------------
\
\ This game loader is only used by the official Firebird release (i.e. the 4am
\ crack variant).
\
\ The loader's aim is to load the game code and data into memory as follows:
\
\   * The game's data is from &0B60 to &1C99.
\
\   * The loading screen (including the dashboard) is from &2000 to &3FFF.
\
\   * The first block of the main game binary (CODE1) is &4000 to &8FFF.
\
\   * The second block of the main game binary (CODE2) is from &9000 to &BFFF.
\
\ These blocks of code and data are packaged up into two large files - ELA and
\ ELB - by the elite-transfer.asm source. Note that the ELB file is called ELB1
\ on the 4am crack disk, but the source files refer to it as ELB, so I'll stick
\ with that name here.
\
\ For the Firebird release, the loading process is as follows:
\
\   * The ELITE BASIC file is run. This does BRUN ELA, followed by BRUN SEC3.
\     Let's see what those commands do.
\
\   * ELA (which includes this routine) is run first with a load address of
\     &0A00, so that loads the game data at &0B60, the loading screen at &2000
\     and CODE2 at &4000 to &8FFF. This means that the game data and dashboard
\     are now in the correct places for running the game (though the latter will
\     soon get corrupted, see below).
\
\   * Because the ELA file is run with a BRUN command, it calls its own ENTRY
\     routine after loading, which switches to the high-resolution screen mode.
\     It also copies some data into bank-switched RAM, but this has no effect in
\     the released game; it's a remnant of the transfer process used by the
\     source disk variant, as described in the elite-transfer.asm source.
\
\   * The game loader in SEC3 is then run, which starts by copying CODE2 from
\     &4000-&8FFF to &9000-&BFFF. This means that CODE2 is now in the correct
\     place for running the game. SEC3 itself loads at &2000, which means it
\     corrupts the loading screen (as &2000 is the start of screen memory).
\
\   * SEC3 then loads ELB (called ELB1 on disk) with a load address of &4000,
\     which loads CODE1 from &4000 to &8FFF. This means that CODE1 is now in
\     the correct place for running the game. 
\
\   * Finally, we start the game by calling the main game's S% routine at &4000,
\     which starts by restoring the loading screen (in particular the dashboard,
\     which is needed for the game to work), and then the game itself starts.
\
\ So this loads the complete game binary into memory, and it's ready to run.
\
\ ******************************************************************************

.ENTRY

 JSR CopyCode2          \ The ELITE BASIC program has already run by this point,
                        \ so the following step has already been done:
                        \
                        \   * ELA has been loaded and run, so CODE2 is in memory
                        \     from &4000 to &8FFF
                        \
                        \ The first step is therefore to copy the CODE2 block
                        \ from &4000-&6FFF to &9000-&BFFF

 JSR SetLoadVariables1  \ Configure the file load variables as follows:
                        \
                        \   * skipBytes = 4
                        \
                        \   * fileSize(1 0) = &0880
                        \
                        \   * trackSector = 0
                        \
                        \   * loadAddr = STA &0200,X

 JSR LoadFile           \ Load the SCRN file of size &0880 at &0200 (though this
                        \ isn't actually used)

 JSR SetFilename        \ Set the filename in comnam to ELB1

 JSR SetLoadVariables2  \ Configure the file load variables as follows:
                        \
                        \   * skipBytes = 4
                        \
                        \   * fileSize(1 0) = &4FFF
                        \
                        \   * trackSector = 0
                        \
                        \   * loadAddr = STA &4000,X

 JSR LoadFile           \ Load the ELB1 file of size &4FFF at &4000, so that's
                        \ from &4000 to &8FFF
                        \
                        \ ELB1 contains the CODE1 block of the main game binary,
                        \ so the end result of all this loading is:
                        \
                        \   * CODE1 from &4000 to &8FFF
                        \
                        \   * CODE2 from &9000 to &BFFF
                        \
                        \ In other words the game binary is now loaded and in
                        \ the correct location for the game to run

 JMP startGame          \ Jump to startGame to start the game


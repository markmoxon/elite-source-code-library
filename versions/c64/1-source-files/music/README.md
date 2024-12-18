# Music binaries for the Commodore 64 version of Elite

This folder contains the music binaries from the original game disk for the Commodore 64 version of Elite on Ian Bell's personal website.

* [gma/C.COMUDAT.bin](gma/C.COMUDAT.bin) and [source-disk/C.COMUDAT.bin](source-disk/C.COMUDAT.bin) contain the processed music data for the Blue Danube docking music; this is a compressed version of the C.MUSDAT music file (the compression is done by the S.MUCOMPR program on the source disk), and the last byte contains workspace noise, so if you run the build process, the last byte will be set fairly randomly (it is set to $EC in the binary file on the source disk, for example)

* [C.MUSDAT.bin](C.MUSDAT.bin) contains the original music data for the Blue Danube docking music

* [gma/C.THEME.bin](gma/C.THEME.bin) and [source-disk/C.THEME.bin](source-disk/C.THEME.bin) contain the music data for the Elite Theme that plays on the title screen

---

Right on, Commanders!

_Mark Moxon_
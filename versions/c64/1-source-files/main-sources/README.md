# Annotated source code for the Commodore 64 version of Elite

This folder contains the annotated source code for the Commodore 64 version of Elite.

* Main source files:

  * [elite-source.asm](elite-source.asm) contains the main source for the game

  * [elite-data.asm](elite-data.asm) contains source for the game data, including the game text and ship blueprints

  * [elite-sprites.asm](elite-sprites.asm) contains the sprite definitions

* Other source files:

  * [elite-firebird.asm](elite-firebird.asm) contains the source for the BASIC autoboot program that loads at the very start

  * [elite-gma1.asm](elite-gma1.asm) contains the source for the disk loader, which includes the fast loader

  * [elite-gma2.asm](elite-gma2.asm) contains the source for an unused stage of the disk loader (this file is empty)

  * [elite-gma3.asm](elite-gma3.asm) contains the source for the disk protection code (which is disabled in this version)

  * [elite-loader.asm](elite-loader.asm) contains the source for the game loader

  * [elite-send.asm](elite-send.asm) contains the source for the SEND binary, which was used to send the assembled game binaries to a connected Commodore 64 as part of the PDS (Programmers' Development System)

  * [elite-checksum.asm](elite-checksum.asm) contains 6502 source code for the checksum routines that are implemented in the elite-checksum.py script (and which were implemented by the S.BCODES and S.COMLODS BBC BASIC programs in the original source discs); this file is purely for reference and is not used in the build process

  * [elite-readme.asm](elite-readme.asm) generates a README file for inclusion on the d64 disk image

* Files that are generated during the build process:

  * [elite-build-options.asm](elite-build-options.asm) stores the make options in BeebAsm format so they can be included in the assembly process

---

Right on, Commanders!

_Mark Moxon_
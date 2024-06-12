# Source code library for every version of Elite on bbcelite.com

This repository contains a library that is used as a single source of truth when building the following repositories:

* [BBC Micro (cassette) Elite source code](https://github.com/markmoxon/cassette-elite-beebasm)
* [BBC Micro (disc) Elite source code](https://github.com/markmoxon/disc-elite-beebasm)
* [6502 Second Processor Elite source code](https://github.com/markmoxon/6502sp-elite-beebasm)
* [BBC Master Elite source code](https://github.com/markmoxon/master-elite-beebasm)
* [Acorn Electron Elite source code](https://github.com/markmoxon/electron-elite-beebasm)
* [Elite-A source code](https://github.com/markmoxon/elite-a-beebasm)
* [NES Elite source code](https://github.com/markmoxon/nes-elite-beebasm)

It is also used when building the compare section of the [bbcelite.com website](https://www.bbcelite.com).

The scripts that use this library can be found in the [bbcelite-scripts](https://github.com/markmoxon/bbcelite-scripts) repository.

# Building Elite from the library

As well as being a code library, this repository is also fully buildable, and is able to produce all variants of all the different versions of Elite listed above, in exactly the same way as the repositories that it generates. This repository is therefore the master repository for managing the commentary for all versions of Elite, and can be built as updates are made to the commentary, to ensure that the code still compiles correctly as changes are made.

The build process is as follows:

* A simple `make` will build the default variants for all seven versions of Elite. This is equivalent to `make all`.

* To build a single version, add the version name to the `make` command, so `make master` will only build the BBC Master version, for example.

* To build a specific variant, add `variant-<version>=xxx` to the `make` command, so `make master variant-master=compact` will build the Compact variant of the BBC Master version, for example.

* To build a specific version and run it in the b2 emulator, add `b2-<version>` to the `make` command, so `make master b2-master` will build and load the BBC Master version into b2, for example.

# Notes on version-specific markup in the library

* In the conditional statements that control which code is used in which versions ("version-ifs"), any `ELIF`s that solely contain `_ELITE_A_*` directives must be the last `ELIF`s in the version-if block.

* A commented-out `INCLUDE` file in Elite-A, commented out with a single `\` character, denotes a section that was removed by Angus when creating Elite-A:

```
\INCLUDE "library/disc/main/subroutine/deeor.asm"
```

* A commented-out INCLUDE file in Elite-A, commented out with double `\\` characters, denotes a section that was moved by Angus when creating Elite-A:

```
\\INCLUDE "library/enhanced/main/subroutine/detok3.asm"
```

---

Right on, Commanders!

_Mark Moxon_
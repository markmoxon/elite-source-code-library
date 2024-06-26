# Source code library for every version of Elite on bbcelite.com

[Scripts for generating bbcelite.com](https://github.com/markmoxon/bbcelite-scripts) | [Static content for bbcelite.com](https://github.com/markmoxon/bbcelite-websites) | **Elite source code library**

This repository contains a source code library that is used as a single source of truth when building the following repositories:

* [BBC Micro (cassette) Elite source code](https://github.com/markmoxon/cassette-elite-beebasm)
* [BBC Micro (disc) Elite source code](https://github.com/markmoxon/disc-elite-beebasm)
* [6502 Second Processor Elite source code](https://github.com/markmoxon/6502sp-elite-beebasm)
* [BBC Master Elite source code](https://github.com/markmoxon/master-elite-beebasm)
* [Acorn Electron Elite source code](https://github.com/markmoxon/electron-elite-beebasm)
* [Elite-A source code](https://github.com/markmoxon/elite-a-beebasm)
* [NES Elite source code](https://github.com/markmoxon/nes-elite-beebasm)

It is also used when building the [elite.bbcelite.com website](https://elite.bbcelite.com).

For details of how the site and source code repositories are built, see the [bbcelite.com website](https://www.bbcelite.com/disassembly_websites/).

# Building Elite from the library

As well as being a source code library, this repository is fully buildable in its own right, and is able to produce all variants of all the different versions of Elite listed above, in exactly the same way as the repositories that it generates. The library is the core resource for managing the commentary across all the documented versions of Elite, and it can be built regularly as updates are made to the commentary, to ensure that the code still compiles correctly as those changes are made.

The build process is as follows:

* A simple `make` will build the default variants for all seven versions of Elite. This is equivalent to `make all`.

* To build a single version, add the version name to the `make` command, so `make master` will only build the BBC Master version, for example.

* To build a specific variant, add `variant-<version>=xxx` to the `make` command, so `make master variant-master=compact` will build the Compact variant of the BBC Master version, while `make variant-master=compact variant-6502sp=executive` will build all seven versions of Elite, with the Master and 6502 Second Processor versions building the Compact and Executive variants respectively.

* To build a specific version and automatically run it in the b2 emulator, add `b2-<version>` to the `make` command, so `make master b2-master` will build and load the BBC Master version into b2, for example.

# A note on licences, copyright etc.

This repository is _not_ provided with a licence, and there is intentionally no `LICENSE` file provided.

According to [GitHub's licensing documentation](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/licensing-a-repository), this means that "the default copyright laws apply, meaning that you retain all rights to your source code and no one may reproduce, distribute, or create derivative works from your work".

The reason for this is that my commentary is intertwined with the original Elite source code, and the original source code is copyright. The whole site is therefore covered by default copyright law, to ensure that this copyright is respected.

Under GitHub's rules, you have the right to read and fork this repository... but that's it. No other use is permitted, I'm afraid.

My hope is that the educational and non-profit intentions of this repository will enable it to stay hosted and available, but the original copyright holders do have the right to ask for it to be taken down, in which case I will comply without hesitation. I do hope, though, that along with the various other disassemblies and commentaries of this source, it will remain viable.

---

Right on, Commanders!

_Mark Moxon_
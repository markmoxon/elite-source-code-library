BEEBASM?=beebasm
PYTHON?=python

.PHONY:all
all: cassette disc 6502sp master electron elite-a nes c64 apple
ifneq ($(verify), no)
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries/$(folder_cassette) versions/cassette/3-assembled-output
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries/$(folder_disc) versions/disc/3-assembled-output
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries/$(folder_6502sp) versions/6502sp/3-assembled-output
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries/$(folder_master) versions/master/3-assembled-output
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries/$(folder_electron) versions/electron/3-assembled-output
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries/$(folder_elite-a) versions/elite-a/3-assembled-output
	@$(PYTHON) versions/nes/2-build-files/crc32.py versions/nes/4-reference-binaries/$(folder_nes) versions/nes/3-assembled-output
	@$(PYTHON) versions/c64/2-build-files/crc32.py versions/c64/4-reference-binaries/$(folder_c64) versions/c64/3-assembled-output
	@$(PYTHON) versions/apple/2-build-files/crc32.py versions/apple/4-reference-binaries/$(folder_apple) versions/apple/3-assembled-output
endif

include versions/cassette/Makefile
include versions/disc/Makefile
include versions/6502sp/Makefile
include versions/master/Makefile
include versions/electron/Makefile
include versions/elite-a/Makefile
include versions/nes/Makefile
include versions/c64/Makefile
include versions/apple/Makefile

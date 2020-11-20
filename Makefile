BEEBASM?=beebasm
PYTHON?=python

.PHONY:build
build:
	echo _VERSION=1 > cassette/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> cassette/sources/elite-header.h.asm
	$(BEEBASM) -i cassette/sources/elite-source.asm -v > cassette/output/compile.txt
	$(BEEBASM) -i cassette/sources/elite-bcfs.asm -v >> cassette/output/compile.txt
	$(BEEBASM) -i cassette/sources/elite-loader.asm -v >> cassette/output/compile.txt
	$(PYTHON) cassette/sources/elite-checksum.py -u
	$(BEEBASM) -i cassette/sources/elite-disc.asm -do elite-cassette.ssd -boot ELTdata

	echo _VERSION=3 > 6502sp/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> 6502sp/sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=FALSE >> 6502sp/sources/elite-header.h.asm
	$(BEEBASM) -i 6502sp/sources/elite-source.asm -v > 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-bcfs.asm -v >> 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-z.asm -v >> 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-loader1.asm -v >> 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-loader2.asm -v >> 6502sp/output/compile.txt
	$(PYTHON) 6502sp/sources/elite-checksum.py -u
	$(BEEBASM) -i 6502sp/sources/elite-disc.asm -do elite-6502sp.ssd -boot ELITE

.PHONY:encrypt
encrypt:
	echo _VERSION=1 > cassette/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> cassette/sources/elite-header.h.asm
	$(BEEBASM) -i cassette/sources/elite-source.asm -v > cassette/output/compile.txt
	$(BEEBASM) -i cassette/sources/elite-bcfs.asm -v >> cassette/output/compile.txt
	$(BEEBASM) -i cassette/sources/elite-loader.asm -v >> cassette/output/compile.txt
	$(PYTHON) cassette/sources/elite-checksum.py
	$(BEEBASM) -i cassette/sources/elite-disc.asm -do elite-cassette.ssd -boot ELTdata

	echo _VERSION=3 > 6502sp/sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> 6502sp/sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> 6502sp/sources/elite-header.h.asm
	$(BEEBASM) -i 6502sp/sources/elite-source.asm -v > 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-bcfs.asm -v >> 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-z.asm -v >> 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-loader1.asm -v >> 6502sp/output/compile.txt
	$(BEEBASM) -i 6502sp/sources/elite-loader2.asm -v >> 6502sp/output/compile.txt
	$(PYTHON) 6502sp/sources/elite-checksum.py
	$(BEEBASM) -i 6502sp/sources/elite-disc.asm -do elite-6502sp.ssd -boot ELITE

.PHONY:verify
verify:
	@$(PYTHON) cassette/sources/crc32.py cassette/extracted cassette/output
	@$(PYTHON) 6502sp/sources/crc32.py 6502sp/extracted 6502sp/output

#!/usr/bin/env python
#
# ******************************************************************************
#
# BBC MASTER ELITE CHECKSUM SCRIPT
#
# Written by Mark Moxon, and inspired by Kieran Connell's version for the
# cassette version of Elite
#
# This script applies encryption and checksums to the compiled binary for the
# main parasite game code. It reads the unencrypted "BCODE.unprot.bin" binary
# and generates an encrypted version as "BCODE.bin"
#
# ******************************************************************************

from __future__ import print_function
import sys

argv = sys.argv
Encrypt = True

for arg in argv[1:]:
    if arg == "-u":
        Encrypt = False

print("Elite Big Code File")
print("Encryption = ", Encrypt)

# Configuration variables for BCODE

load_address = 0x1300
seed = 0x19
scramble_from = 0x2cc1
scramble_to = 0x7f47

data_block = bytearray()

# Load assembled code file

elite_file = open("versions/master/output/BCODE.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

for n in range(scramble_from, scramble_to):
    data_block[n - load_address] = (data_block[n - load_address] + data_block[n + 1 - load_address]) % 256

data_block[scramble_to - load_address] = (data_block[scramble_to - load_address] + seed) % 256

# Write output file for BCODE

output_file = open("versions/master/output/BCODE.bin", "wb")
output_file.write(data_block)
output_file.close()

print("output/BCODE.bin file saved")

# Configuration variables for BDATA

load_address = 0x1300 + 0x5D00
seed = 0x62
scramble_from = 0x8000
scramble_to = 0xB1FF

data_block = bytearray()

# Load assembled code file

elite_file = open("versions/master/output/BDATA.unprot.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

for n in range(scramble_from, scramble_to):
    data_block[n - load_address] = (data_block[n - load_address] + data_block[n + 1 - load_address]) % 256

data_block[scramble_to - load_address] = (data_block[scramble_to - load_address] + seed) % 256

# Write output file for BDATA

output_file = open("versions/master/output/BDATA.bin", "wb")
output_file.write(data_block)
output_file.close()

print("output/BDATA.bin file saved")
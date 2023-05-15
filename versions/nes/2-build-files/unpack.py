#!/usr/bin/env python
#
# ******************************************************************************
#
# NES ELITE IMAGE EXTRACTOR
#
# Written by Mark Moxon
#
# ******************************************************************************

import png


def fetch_byte(input_data):
    global index
    if index < len(input_data):
        byte = input_data[index]
        index += 1
        return byte
    else:
        print("End of file reached at index " + str(index))
        return -1


def unpack(input_data, unpacked_data):
    global index
    read_file = True
    while read_file:
        if index < len(input_data):
            byte = input_data[index]
            index += 1
            if byte >= 0x40 or byte == 0x30 or byte == 0x20 or byte == 0x10 or byte == 0x00:
                unpacked_data.append(byte)
            elif byte == 0x3F:
                print("End of section found at index " + str(index))
                read_file = False
            elif byte >= 0x01 and byte <= 0x0F:
                for i in range(0, byte):
                    unpacked_data.append(0)
            elif byte >= 0x11 and byte <= 0x1F:
                for i in range(0, byte - 0x10):
                    unpacked_data.append(0xFF)
            elif byte >= 0x21 and byte <= 0x2F:
                byte2 = fetch_byte(input_data)
                if byte2 != -1:
                    for i in range(0, byte - 0x20):
                        unpacked_data.append(byte2)
                else:
                    read_file = False
            elif byte >= 0x31 and byte < 0x3F:
                for i in range(0, byte - 0x30):
                    byte2 = fetch_byte(input_data)
                    if byte2 != -1:
                        unpacked_data.append(byte2)
                    else:
                        read_file = False
        else:
            print("End of file reached at index " + str(index))
            read_file = False


def png_pixel(colour):
    if colour == 1:
        return [255, 0, 0]
    elif colour == 2:
        return [0, 255, 0]
    elif colour == 3:
        return [0, 0, 255]
    return [0, 0, 0]


def png_8_pixel_row(byte_0, byte_1):
    row = []
    for i in range(0, 8):
        pixel = ((byte_0 & (1 << i)) + ((byte_1 & (1 << i)) << 1)) >> i
        row = png_pixel(pixel) + row
    return row


def png_full_pixel_row_ram(y, pixel_width, data_0, data_1):
    row = []
    start_byte = (y // 8) * pixel_width + (y % 8)
    for i in range(start_byte, start_byte + pixel_width, 8):
        row = row + png_8_pixel_row(data_0[i], data_1[i])
    return row


def png_full_pixel_row_ppu(y, pixel_width, data):
    row = []
    start_byte = (y // 8) * pixel_width * 2 + (y % 8)
    for i in range(start_byte, start_byte + (pixel_width * 2), 16):
        row = row + png_8_pixel_row(data[i], data[i + 8])
    return row


def extract_image(input_data, sections, output_folder, input_file):
    global index

    # image0
    pixel_width = 64

    if sections == 1:
        # image0_1
        pixel_width = 40
    elif sections == 2:
        # image0_2
        pixel_width = 48

    index = 0

    output_path = output_folder + "pngs/" + input_file
    output_path_binaries = output_folder + "binaries/" + input_file

    unpacked_data_0 = bytearray()
    unpack(input_data, unpacked_data_0)
    output_file = open(output_path_binaries + "_pattern_0.bin", "wb")
    output_file.write(unpacked_data_0)
    output_file.close()

    if sections >= 2:
        unpacked_data_1 = bytearray()
        unpack(input_data, unpacked_data_1)
        output_file = open(output_path_binaries + "_pattern_1.bin", "wb")
        output_file.write(unpacked_data_1)
        output_file.close()

    if sections >= 4:
        unpacked_data_2 = bytearray()
        unpack(input_data, unpacked_data_2)
        output_file = open(output_path_binaries + "_sprite_0.bin", "wb")
        output_file.write(unpacked_data_2)
        output_file.close()

        unpacked_data_3 = bytearray()
        unpack(input_data, unpacked_data_3)
        output_file = open(output_path_binaries + "_sprite_1.bin", "wb")
        output_file.write(unpacked_data_3)
        output_file.close()

    print("End index is " + str(index))
    print("File size " + str(len(input_data)))

    if (index == len(input_data)):
        print("All sections extracted")
    else:
        print("More sections detected")

    if sections == 1:
        # Convert unpacked_data_0 into PNG
        pixel_height = int(0.5 * len(unpacked_data_0) / (pixel_width / 8))
        print("Image dimensions " + str(pixel_width) + "px wide x " + str(pixel_height) + "px high")

        png_array = []
        for i in range(0, pixel_height):
            pixel_row = png_full_pixel_row_ppu(i, pixel_width, unpacked_data_0)
            png_array.append(pixel_row)

        png.from_array(png_array, 'RGB').save(output_path + "_ppu.png")

    if sections >= 2:
        # Convert unpacked_data_0/unpacked_data_1 into PNG
        pixel_height = int(len(unpacked_data_0) / (pixel_width / 8))
        print("Image dimensions 0/1 " + str(pixel_width) + "px wide x " + str(pixel_height) + "px high")

        png_array = []
        for i in range(0, pixel_height):
            pixel_row = png_full_pixel_row_ram(i, pixel_width, unpacked_data_0, unpacked_data_1)
            png_array.append(pixel_row)

        png.from_array(png_array, 'RGB').save(output_path + "_ram.png")

    if sections >= 4:
        # Convert unpacked_data2/unpacked_data3 into PNG
        unpacked_data = unpacked_data_2 + unpacked_data_3

        pixel_height = int(len(unpacked_data_2) / (pixel_width / 8))
        print("Image dimensions 2/3 " + str(pixel_width) + "px wide x " + str(pixel_height) + "px high")

        png_array = []
        for i in range(0, pixel_height):
            pixel_row = png_full_pixel_row_ppu(i, pixel_width, unpacked_data)
            png_array.append(pixel_row)

        png.from_array(png_array, 'RGB').save(output_path + "_ppu.png")


# Main loop

bank4_offsets_1 = [
    0x001E,
    0x0195,
    0x0305,
    0x0473,
    0x05F9,
    0x0783,
    0x0904,
    0x0A87,
    0x0C09,
    0x0D7C,
    0x0EFC,
    0x108E,
    0x1205,
    0x1387,
    0x150E
]

bank4_offsets_2 = [
    0x001E,
    0x0195,
    0x0310,
    0x047D,
    0x0611,
    0x07A4,
    0x092C,
    0x0AAC,
    0x0C28,
    0x0D9F,
    0x0F27,
    0x10C9,
    0x1240,
    0x13D6,
    0x1585
]

bank5_offsets = [
    0x0020,
    0x0458,
    0x0847,
    0x0E08,
    0x12E0,
    0x166C,
    0x1A90,
    0x1E90,
    0x22E8,
    0x2611,
    0x29D8,
    0x2E20,
    0x3232,
    0x36C5,
    0x3B07,
    0x3E82
]

bank_data = bytearray()
bank_file = open("../4-reference-binaries/ntsc/bank5.bin", "rb")
bank_data.extend(bank_file.read())
bank_file.close()

for i in range(0, 15):
    start = bank5_offsets[i] + 0x0C
    end = bank5_offsets[i + 1] + 0x0C
    extract_image(bank_data[start: end], 4, "../1-source-files/images/systems/", "image" + str(i))

bank_data = bytearray()
bank_file = open("../4-reference-binaries/ntsc/bank4.bin", "rb")
bank_data.extend(bank_file.read())
bank_file.close()

for i in range(0, 14):
    start = bank4_offsets_1[i] + 0x0C
    end = bank4_offsets_1[i + 1] + 0x0C
    extract_image(bank_data[start: end], 1, "../1-source-files/images/faces/", "image1_" + str(i))

for i in range(0, 14):
    start = bank4_offsets_2[i] + 0x151A
    end = bank4_offsets_2[i + 1] + 0x151A
    extract_image(bank_data[start: end], 2, "../1-source-files/images/headshots/", "image2_" + str(i))

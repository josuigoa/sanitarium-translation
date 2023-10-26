import os
import encoding.hex

fn main() {
	translated_text := os.read_file('strings.txt') or {
		eprintln('Error reading [strings.txt] file: ${err}')
		return
	}

	separator := hex.decode('00') or { panic('Error decoding 00 to hex') }.bytestr()

	lines := translated_text.split_into_lines()

	mut content := [lines.len, 0]
	mut offset := 0
	mut l_sep := ''

	for l in lines {
		l_sep = l + separator
		for r in l_sep.runes() {
			offset += r.length_in_bytes()
		}
		content << offset
	}

	mut out := []u8{}
	offset = content.len * 4
	for i, c in content {
		write_int_32(mut out, if i == 0 { c } else { offset + c })
	}
	for l in lines {
		l_sep = l + separator
		for r in l_sep.runes() {
			for rb in r.bytes() {
				out << rb
			}
		}
	}

	mut file := os.open_file('./RES.000', 'w') or {
		eprintln('Error opening RES.000: ${err}')
		return
	}

	file.write(out) or {
		eprintln('Error writing RES.000: ${err}')
		return
	}
	file.close()
}

fn write_int_32(mut out []u8, x int) {
	out << u8(x & 0xFF)
	out << u8((x >> 8) & 0xFF)
	out << u8((x >> 16) & 0xFF)
	out << u8(x >>> 24)
}

import os
import encoding.hex
import json

struct Entry {
	offset int
	size   int
}

fn main() {
	translated_text := os.read_file('strings.txt') or {
		eprintln('Error reading [strings.txt] file: ${err}')
		return
	}

	script_entries_data := $embed_file('script_entries.json').to_string()
	script_entries := json.decode([]Entry, script_entries_data) or {
		eprintln('Failed to decode json, error: ${err}')
		return
	}
	ending_01_data := $embed_file('ending_01.json').to_string()
	ending_01 := json.decode([]bool, ending_01_data) or {
		eprintln('Failed to decode json, error: ${err}')
		return
	}
	script_bytes := $embed_file('script_bytes').to_bytes()

	separator_00 := hex.decode('00') or { panic('Error decoding 00 to hex') }.bytestr()
	separator_01 := hex.decode('01') or { panic('Error decoding 01 to hex') }.bytestr()

	mut lines := translated_text.split_into_lines()

	mut content := [lines.len + script_entries.len, 0]
	mut offset := 0
	mut l_sep := ''

	mut last_word_len := 0

	// lines offsets
	for i, l in lines {
		l_sep = l
		if ending_01[i] {
			l_sep += separator_01
		}
		l_sep += separator_00
		for r in l_sep.runes() {
			offset += r.length_in_bytes()
		}
		if i < lines.len - 1 {
			content << offset
		} else {
			for r in l_sep.runes() {
				last_word_len += r.length_in_bytes()
			}
		}
	}

	prev_len := content.len

	// script offsets
	for se in script_entries {
		content << se.offset
	}

	mut out := []u8{}
	offset = content.len * 4
	mut last_offset := 0
	for i, c in content {
		write_int_32(mut out, if i == 0 {
			c
		} else if i < prev_len {
			offset + c
		} else {
			c
		})
		if i == prev_len - 1 {
			last_offset = offset + c
		}
	}

	last_offset += last_word_len

	mut huts := ''
	for _ in 0 .. script_entries[0].offset - last_offset - 1 {
		huts += separator_00
	}

	lines << huts
	for i, l in lines {
		l_sep = l
		if ending_01[i] {
			l_sep += separator_01
		}
		l_sep += separator_00
		for r in l_sep.runes() {
			for rb in r.bytes() {
				out << rb
			}
		}
	}

	for sb in script_bytes {
		out << sb
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

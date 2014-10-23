/* posix.vapi – a vapi file for libc
 * Copyright (C) 2008-2009  Jürg Billeter
 * Copyright (C) 2010 Marco Trevisan (Treviño)
 * Copyright (C) 2013 Nikolay Orliuk
 * Copyright (C) 2014 Johan Mattsson
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 *  Johan Mattsson <johan.mattsson.m@gmail.com>
 * 	Jürg Billeter <j@bitron.ch>
 *  Marco Trevisan (Treviño) <mail@3v1n0.net>
 *  Nikolay Orliuk <virkony@gmail.com>
 */

[SimpleType]
[CCode (cname = "bool", default_value = "false", cheader_filename="stdbool.h")]
[BooleanType (true = "true", false = "false")]
public struct bool {
	public string to_string () {
		if (this) {
			return "true";
		}
		return "false";	
	}

	public static bool parse (string str) {
		if (str == "true") {
			return true;
		}
		return false;
	}
	
	public static bool try_parse (string str, out bool result = null) {
		if (str == "true") {
			result = true;
			return true;
		} else if (str == "false") {
			result = false;
			return true;
		} else {
			result = false;
			return false;
		}
	}
}

[SimpleType]
[CCode (cname = "unsigned long", default_value = "0U")]
[IntegerType (rank = 7)]
public struct unichar {
}

[SimpleType]
[CCode (cname = "char")]
[IntegerType (rank = 2)]
public struct int8 {
}

[SimpleType]
[CCode (cname = "unsigned char", default_value = "0")]
[IntegerType (rank = 3)]
public struct uint8 {
}

[SimpleType]
[CCode (cname = "char", default_value = "\'\\0\'")]
[IntegerType (rank = 2)]
public struct char {
}

[SimpleType]
[CCode (cname = "unsigned char", default_value = "\'\\0\'")]
[IntegerType (rank = 3)]
public struct uchar {
}

[SimpleType]
[CCode (cname = "int", default_value = "0")]
[IntegerType (rank = 6)]
public struct int {
	[CCode (cname = "abs", cheader_filename = "stdlib.h")]
	public int abs ();

	[CCode (cname = "atoi", cheader_filename = "stdlib.h")]
	public static int parse (string str);
}

[SimpleType]
[CCode (cname = "unsigned int", default_value = "0U")]
[IntegerType (rank = 7)]
public struct uint {
}

[SimpleType]
[CCode (cname = "long", default_value = "0L")]
[IntegerType (rank = 8)]
public struct long {
	[CCode (cname = "labs", cheader_filename = "stdlib.h")]
	public long abs ();

	[CCode (cname = "atol", cheader_filename = "stdlib.h")]
	public static long parse (string str);
}

[SimpleType]
[CCode (cname = "unsigned long", default_value = "0UL")]
[IntegerType (rank = 9)]
public struct ulong {
}

[SimpleType]
[CCode (cname = "size_t", default_value = "0UL")]
[IntegerType (rank = 9)]
public struct size_t {
}

[SimpleType]
[CCode (cname = "ssize_t", default_value = "0L")]
[IntegerType (rank = 8)]
public struct ssize_t {
}

[SimpleType]
[CCode (cname = "short")]
[IntegerType (rank = 4)]
public struct short {
	[CCode (cname = "abs", cheader_filename = "stdlib.h")]
	public short abs ();
}

[SimpleType]
[CCode (cname = "unsigned short", default_value = "0U")]
[IntegerType (rank = 5)]
public struct ushort {
}

[SimpleType]
[CCode (cname = "int16_t", cheader_filename = "stdint.h", default_value = "0")]
[IntegerType (rank = 4, min = -32768, max = 32767)]
public struct int16 {
}

[SimpleType]
[CCode (cname = "uint16_t", cheader_filename = "stdint.h", default_value = "0U")]
[IntegerType (rank = 5, min = 0, max = 65535)]
public struct uint16 {
}

[SimpleType]
[CCode (cname = "int32_t", cheader_filename = "stdint.h")]
[IntegerType (rank = 6, min = -2147483648, max = 2147483647)]
public struct int32 {
}

[SimpleType]
[CCode (cname = "uint32_t", cheader_filename = "stdint.h")]
[IntegerType (rank = 7, min = 0, max = 4294967295)]
public struct uint32 {
}

[SimpleType]
[CCode (cname = "int64_t", cheader_filename = "stdint.h")]
[IntegerType (rank = 10, min = -9223372036854775808, max = 9223372036854775807)]
public struct int64 {
	[CCode (cname = "llabs", cheader_filename = "stdlib.h")]
	public int64 abs ();
}

[SimpleType]
[CCode (cname = "uint64_t", cheader_filename = "stdint.h")]
[IntegerType (rank = 11, min = 0, max = 18446744073709551615)]
public struct uint64 {
}

[SimpleType]
[CCode (cname = "float", cheader_filename = "float.h,math.h", default_value = "0.0F")]
[FloatingType (rank = 1)]
public struct float {
	[CCode (cname = "isnan")]
	public bool is_nan ();
	[CCode (cname = "isfinite")]
	public bool is_finite ();
	[CCode (cname = "isnormal")]
	public bool is_normal ();
	[CCode (cname = "isinf")]
	public int is_infinity ();
	[CCode (cname = "fabsf", cheader_filename = "math.h")]
	public float abs ();
}

[SimpleType]
[CCode (cname = "double", cheader_filename = "float.h,math.h", default_value = "0.0")]
[FloatingType (rank = 2)]
public struct double {
	[CCode (cname = "isnan")]
	public bool is_nan ();
	[CCode (cname = "isfinite")]
	public bool is_finite ();
	[CCode (cname = "isnormal")]
	public bool is_normal ();
	[CCode (cname = "isinf")]
	public int is_infinity ();
	[CCode (cname = "fabs", cheader_filename = "math.h")]
	public float abs ();
}

[CCode (cheader_filename = "time.h", has_type_id = false, default_value = "0")]
[IntegerType (rank = 8)]
public struct time_t {
	[CCode (cname = "time")]
	public time_t (out time_t result = null);
}

[SimpleType]
[CCode (cheader_filename="stdarg.h", cprefix="va_", has_type_id = false, destroy_function = "va_end", lvalue_access = false)]
public struct va_list {
	[CCode (cname = "va_start")]
	public va_list ();
	[CCode (cname = "va_copy")]
	public va_list.copy (va_list src);
	[CCode (generic_type_pos = 1.1)]
	public unowned G arg<G> ();
}


[Compact]
[Immutable]
[CCode (cname = "char", const_cname = "const char", copy_function = "strdup", free_function = "free", cheader_filename = "stdlib.h,string.h")]
public class string {
	[CCode (cname = "strstr")]
	static char* strstr (char* haystack, char* needle);

	public int index_of (string needle, int start_index = 0) {
		char* result = strstr ((char*) this + start_index, (char*) needle);

		if (result != null) {
			return (int) (result - (char*) this);
		} else {
			return -1;
		}
	}

	/**
	 * Skip one character in a _valid_ unicode string.
	 * @param s a valid UTF-8 string
	 * @return a pointer to the next unicode point in a string or null if s points to the null character
	 */
	static char* utf8_next_char (char* s) {	
		if (s[0] == '\0') {
			return null;
		}

		if (s[0] < 0x80) {
			return s + 1;
		} else if (s[0] < 0xE0) {
			return s + 2;
		} else if (s[0] < 0xF0) {
			return s + 3;
		}

		return s + 4;
	 }

	/**
	 * Convert the first chracter in a string to unichar.
	 * @param s a valid UTF-8 string
	 * @return the first character in the string. 
	 */
	static unichar utf8_get_char (char *s) {
		unichar u = '\0';
		
		if (s[0] < 0x80) {
			u = s[0];
		} else if (s[0] < 0xE0) {
			u = (s[0] << 6) + s[1] - 0x3080;
		} else if (s[0] < 0xF0) {
			u = (s[0] << 12) | (s[1] << 6) | s[2] - 0xE2080;
		} else if (s[0] < 0xF5) {
			u = (s[0] << 18) | (s[1] << 12) | (s[2] << 6) | s[3] - 0x3C82080;
		}
		
		return u;
	 }

	/** Valide a UTF-8 encoded string.
	 * @param length length of the string if does not have a terminating nu character.
	 * @param end a pointer to the first invalid character or the null character if it is a valid string.
	 * @return true if the string is valid UTF-8.
	 */
	public bool validate (ssize_t length = -1, out char* end = null) {
		const char BIT8 = (1 << 8);
		const char BIT7 = (1 << 7);
		char mask;
		int bytes;

		long len = length == -1 ? this.length : length;
		char* d = (char*)this;
	
		for (int i = 0; i < len; i += bytes) {
			end = (char*) this + i;
			if (d[i] == '\0') {
				return len == length;
			}
			
			// count the number of bytes for the current character
			mask = BIT8;
			for (bytes = 1; bytes <= 8; bytes++) {
				if ((d[i] & mask) == 0) {
					break;
				}
				mask >>= 1;		
			}
			
			if (bytes > 4) {
				return false;
			}
			
			if (i + bytes > len) {
				return false;
			}
			
			for (int j = i; j < i + bytes - 1; j++) {
				if ((d[j] & BIT8) != 1 && (d[j] & BIT7) != 0) {
					return false;
				}
			}
		}
		
		return true;				
	}

	public bool get_next_char (ref int index, out unichar c) {
		c = utf8_get_char ((char*) this + index);
		if (c != 0) {
			index = (int) (utf8_next_char ((char*) this + index) - (char*) this);
			return true;
		} else {
			return false;
		}
	}

	[CCode (cname = "strdup")]
	public string dup ();

	[CCode (cname = "strndup")]
	public string ndup (size_t n);

	[CCode (cname = "memchr")]
	static char* memchr (char* s, int c, size_t n);

	// strnlen is not available on all systems
	static long strnlen (char* str, long maxlen) {
		char* end = memchr (str, 0, maxlen);
		if (end == null) {
			return maxlen;
		} else {
			return (long) (end - str);
		}
	}

	public string substring (long offset, long len = -1) {
		string n;
		long string_length;
		if (offset >= 0 && len >= 0) {
			// avoid scanning whole string
			string_length = strnlen ((char*) this, offset + len);
		} else {
			string_length = this.length;
		}

		if (offset < 0) {
			offset = string_length + offset;
			Posix.assert (offset >= 0);

		} else {
			Posix.assert (offset <= string_length);
		}
		
		if (len < 0) {
			len = string_length - offset;
		}
		
		Posix.assert (offset + len <= string_length);
		n = (string) ((char*) this + offset);
		return n.ndup (len);
	}

	public int length {
		[CCode (cname = "strlen")]
		get;
	}

	public unowned string to_string () {
		return this;
	}
	
	public string concat (string string2, ...) {
		char* buffer;
		char* start_position;
		int buffer_size;
		string? s;
		va_list input = va_list ();
		va_list input_count = input.copy (input);
		int this_length, string2_length;

		// determine the size of the new string
		this_length = this.length;
		string2_length = string2.length;
		buffer_size = this_length + string2_length;
		s = input_count.arg<string?> ();
		while (s != null) {
			buffer_size += ((!) s).length;
			s = input_count.arg<string?> ();
		}
		buffer_size += 1;
		buffer = new char[buffer_size];
		
		// copy the strings
		Posix.strcpy ((string) buffer, this);
		start_position = (char*) this + this_length;
		
		Posix.strcpy ((string) start_position, string2);
		start_position += string2_length;
		
		s = input.arg<string?> ();	
		while (s != null) {
			Posix.strcpy ((string) start_position, (!) s);
			start_position += ((!) s).length;
			s = input.arg<string?> ();
		}
		
		buffer[buffer_size - 1] = '\0';
		return (string) buffer;
	}
	
	public bool has_prefix (string prefix) {
		return Posix.strncmp (this, prefix, prefix.length) == 0;
	}
	
	public bool has_suffix (string suffix) {
		int this_length;
		int suffix_length;
		char* buffer;

		buffer = (char*) this;
		this_length = this.length;
		suffix_length = suffix.length;

		if (this_length < suffix_length) {
			return false;
		}
		
		return Posix.strcmp ((string) (buffer + this_length - suffix_length), suffix) == 0;
	}	
}

[CCode (cheader_filename = "stdio.h", cname = "printf")]
[PrintfFormat]
public static void print (string format, ...);

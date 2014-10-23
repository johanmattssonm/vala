/* valaccodefunctiontypedef.vala
 * Copyright (C) 2006-2008  Jürg Billeter
 * Copyright (C) 2014  Johan Mattsson
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 * 	Johan Mattsson <johan.mattsson.m@gmail.com>
 */

using GLib;

/**
 * Type definition for function pointers.
 */
public class Vala.CCodeFunctionTypeDefinition : CCodeNode {

	/**
	 * The function type declarator.
	 */
	public CCodeDeclarator declarator { get; set; }

	public CCodeFunctionTypeDefinition (CCodeFunctionDeclarator declarator) {
		this.declarator = declarator;
	}
	
	public override void write (CCodeWriter writer) {
	}
	
	public override void write_declaration (CCodeWriter writer) {
		writer.write_indent ();
		writer.write_string ("typedef ");
		
		declarator.write_declaration (writer);
		
		writer.write_string (";");
		writer.write_newline ();
	}
}

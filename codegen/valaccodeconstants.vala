/* valaccodeconstants.vala
 *
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
 *	Johan Mattsson <johan.mattsson.m@gmail.com>
 */

using GLib;

public class Vala.CCodeConstants {
	
	public static CCodeConstant @true {
		get {
			if (true_literal == null) {
				BooleanType bool_type = new Vala.BooleanType ((Vala.Struct) CodeContext.get ().root.scope.lookup ("bool"));
				true_literal = new CCodeConstant (bool_type.true);
			}
			
			return true_literal;
		}
	}

	public static CCodeConstant @false {
		get {
			if (false_literal == null) {
				BooleanType bool_type = new BooleanType ((Struct) CodeContext.get ().root.scope.lookup ("bool"));
				false_literal = new CCodeConstant (bool_type.false);
			}
			
			return false_literal;
		}
	}
	
	static CCodeConstant? true_literal = null;
	static CCodeConstant? false_literal = null;
}

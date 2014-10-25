/* valaccodeprofile.vala
 *
 * Copyright (C) 2014 Johan Mattsson
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
 *     Johan Mattsson <johan.mattsson.m@gmail.com>
 */

using GLib;

/** 
 * A class for parsing profiles and generating profile specific c code.
 * The profile specific code can be found in the profile directory.
 */
public class Vala.CCodeProfile : GLib.Object {
	Definitions defs;
	
	public CCodeProfile (Profile profile) {
		string profile_definitions;
		CodeContext context = CodeContext.get ();
		
		if (profile == Profile.GOBJECT) {
			profile_definitions = context.get_profile_path ("glib");
		} else if (profile == Profile.POSIX) {
			profile_definitions = context.get_profile_path ("posix");
		} else {
			Report.error (null, "No profile");
			return;
		}
		
		if (profile_definitions == null) {
			Report.error (null, "Profile not found.");
			return;
		} 
		
		defs = new Definitions (profile_definitions);
	}
	
	public CCodeNode slice_new (CCodeNode type, CCodeNode variable) {
		return get_cstatement ("slice_new", type, variable);
	}

	public CCodeNode slice_free (CCodeNode type, CCodeNode variable) {
		return get_cstatement ("slice_free", type, variable);
	}
	
	public CCodeNode allocate (CCodeNode type, CCodeNode variable, CCodeNode elements) {
		return get_cstatement ("allocate", type, variable, elements);
	}

	public CCodeNode free (CCodeNode variable) {
		return get_cstatement ("free", variable);
	}
	
	public bool has_definitions () {
		return defs != null && defs.definitions.size > 0;
	}
	
	ProfileStatement? get_cstatement (string profile_definition, ...) {
		var profile_statement = new ProfileStatement (profile_definition);	
		var args = va_list();
		var arguments = new ArrayList<CCodeNode> ();
		Definition d = get_definition (profile_definition);
		
		CCodeNode arg = args.arg();
		while (arg != null) {
			arguments.add (arg);
			arg = args.arg();
		}
 
		if (arguments.size != d.parameters.size) {
			Report.error (null, @"Profile statement $(d.name) need exactly $(arguments.size) arguments, found $(d.parameters.size)");
			d.print_statements ();
			return null;
		}
			   
		foreach (ProfileToken t in d.c_statements) {
			ProfileToken statement = t.copy_token ();
			
			for (int i = 0; i < d.parameters.size; i++) {
				if (t.token == d.parameters.get (i)) {
					statement.replace (arguments.get (i));
				}
			}
			
			profile_statement.add_token (statement);
		}
		
		return profile_statement;
	}

	Definition? get_definition (string name) {
		foreach (Definition d in defs.definitions) {
			if (d.name == name) {
				return d;
			}
		}
		
		Report.error (null, @"$name is not implemented in this profile.");
		return null;
	}
	
	/** 
	 * A parser for vala profile statements
	 */
	class ProfileParser : GLib.Object {
		
		Vala.ArrayList<ProfileToken> tokens;
		
		public ProfileParser () {
			tokens = new Vala.ArrayList<ProfileToken> ();
		}
		
		// TODO: complete c lexer, parser and analyzer for the profile definitions.
		public Vala.List<ProfileToken> parse (string ccode) {
			string token;
			unichar c;
			int index = 0;
			bool new_line = true;
			token = "";
			
			while (ccode.get_next_char (ref index, out c)) {
				if (c == '\t' && new_line) {
					// skip first tab on each line
				} else if (is_profile_separator (c)) {
					add_token (token);
					add_token (c.to_string ());
					token = "";
				} else {
					token += c.to_string ();
				}
				
				new_line = (c == '\n');
			}
			
			add_token (token);
			return tokens;
		}
		
		bool is_profile_separator (unichar c) {
			return c == ' ' || c == ',' || c == '(' || c == '*'
				|| c == ')' || c == '{' || c == '}' || c == '-'
				|| c == ';' || c == '[' || c == ']' || c == '|'
				|| c == '&' || c == '/' || c == '+' || c == '>'
				|| c == '!' || c == '%' || c == '^' || c == '"'
				|| c == '=' || c == '?' || c == '<' || c == '\t'
				|| c == '\n';
		}
		
		void add_token (string token) {
			if (token != "") {
				tokens.add (new ProfileToken (token));
			}
		}
	}

	class ProfileToken : GLib.Object {
		public string token;
		public CCodeNode? replacement;
		
		public ProfileToken (string token) {
			this.token = token;
			replacement = null;
		}
		
		public void replace (CCodeNode statemet) {
			replacement = statemet;
		}
		
		public ProfileToken copy_token () {
			return new ProfileToken (token);
		}
	}
	
	class ProfileStatement : CCodeNode {
		string name {get; set;}
		ArrayList<ProfileToken> statements;
		
		public ProfileStatement (string name) {
			this.name = name;
			statements = new ArrayList<ProfileToken> ();
		}

		public void add_token (ProfileToken statement) {
			statements.add (statement);
		}

		public override void write (CCodeWriter writer) {
			bool new_line = true;

			foreach (ProfileToken statement in statements) {

				if (new_line) {
					writer.write_indent ();
				}
				
				if (statement.replacement != null) {
					statement.replacement.write (writer);
				} else if (statement.token != "\n") {
					writer.write_string (statement.token);
				}
				
				new_line = (statement.token == "\n");
			}
		}
	}
	
	class Definition : GLib.Object {
		public string name;
		public Vala.List<string> parameters;
		public Vala.List<ProfileToken> c_statements;
		
		public Definition (string definition) {
			string parameter_declaration;
			ProfileParser parser;
			
			parameters = new ArrayList<string> ();
			c_statements = new ArrayList<ProfileToken> ();
			
			// remove decoration
			int line_break = definition.index_of ("\n");
			if (line_break == -1) {
				Report.error (null, @"Invalid profile definition: $definition");
				return;
			}
			
			parameter_declaration = definition.substring (0, line_break);
			parameter_declaration = parameter_declaration.replace ("(", "");
			parameter_declaration = parameter_declaration.replace (")", "");
			parameter_declaration = parameter_declaration.replace (",", "");
			
			parser = new ProfileParser ();
			c_statements = parser.parse (definition.substring (line_break));
			
			var declaration_statements = parameter_declaration.split (" ");
			name = declaration_statements[0];
			for (int i = 1; i < declaration_statements.length; i++) {
				parameters.add (declaration_statements[i]);
			}
		}

		public void print_statements () {
			foreach (var t in c_statements) {
				print (t.token);
			}
		}
	}
	
	class Definitions : GLib.Object {
		public Vala.List<Definition> definitions;
		
		public Definitions (string profile_file) {
			parse (profile_file);
		}
		
		public void parse (string profile_file) {
			string profile_data;
			string[] definition_blocks;
			
			definitions = new ArrayList<Definition> ();

			try {
				FileUtils.get_contents(profile_file, out profile_data);
			} catch (Error e) {
				Report.error (null, "Can't read profile.");
				critical (e.message);
			}
			
			profile_data = remove_comments (profile_data);
			definition_blocks = profile_data.split ("definition ");
			
			foreach (string block in definition_blocks) {
				definitions.add (new Definition (block));
			}
		}
		
		string remove_comments (string data) {
			string result;
			int start; 
			int end;
			
			result = data;
			start = -1;
			while (start != -1) {
				start = data.index_of ("/*");
				end = data.index_of ("*/", start) + "*/".length;
				result = result.substring (0, start) + result.substring (end);
			}
			
			return data;
		}
	}
}

/* valadovavaluemodule.vala
 *
 * Copyright (C) 2009-2010  Jürg Billeter
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
 */

internal class Vala.DovaValueModule : DovaObjectModule {
	public DovaValueModule (CCodeGenerator codegen, CCodeModule? next) {
		base (codegen, next);
	}

	public override void generate_class_declaration (Class cl, CCodeDeclarationSpace decl_space) {
		if (cl.base_class == null ||
		    cl.base_class.get_full_name () != "Dova.Value") {
			base.generate_class_declaration (cl, decl_space);
			return;
		}

		if (decl_space.add_symbol_declaration (cl, cl.get_cname ())) {
			return;
		}

		var type_fun = new CCodeFunction ("%s_type_get".printf (cl.get_lower_case_cname ()), "DovaType *");
		if (cl.access == SymbolAccessibility.PRIVATE) {
			type_fun.modifiers = CCodeModifiers.STATIC;
		}
		decl_space.add_type_member_declaration (type_fun);

		var type_init_fun = new CCodeFunction ("%s_type_init".printf (cl.get_lower_case_cname ()));
		type_init_fun.add_parameter (new CCodeFormalParameter ("type", "DovaType *"));
		if (cl.access == SymbolAccessibility.PRIVATE) {
			type_init_fun.modifiers = CCodeModifiers.STATIC;
		}
		decl_space.add_type_member_declaration (type_init_fun);

		var instance_struct = new CCodeStruct ("_%s".printf (cl.get_cname ()));

		foreach (Field f in cl.get_fields ()) {
			if (f.binding == MemberBinding.INSTANCE)  {
				generate_type_declaration (f.field_type, decl_space);

				string field_ctype = f.field_type.get_cname ();
				if (f.is_volatile) {
					field_ctype = "volatile " + field_ctype;
				}

				string cname = f.get_cname ();
				var array_type = f.field_type as ArrayType;
				if (array_type != null && array_type.inline_allocated) {
					cname += "[]";
				}

				instance_struct.add_field (field_ctype, cname);
			}
		}

		decl_space.add_type_declaration (new CCodeTypeDefinition ("struct _%s".printf (cl.get_cname ()), new CCodeVariableDeclarator (cl.get_cname ())));
		decl_space.add_type_definition (instance_struct);

		if (cl.get_full_name () == "string") {
			generate_method_declaration ((Method) cl.scope.lookup ("ref"), decl_space);
			generate_method_declaration ((Method) cl.scope.lookup ("unref"), decl_space);
		}
	}

	public override void visit_class (Class cl) {
		if (cl.base_class == null ||
		    cl.base_class.get_full_name () != "Dova.Value") {
			base.visit_class (cl);
			return;
		}

		var old_symbol = current_symbol;
		current_symbol = cl;

		generate_class_declaration (cl, source_declarations);

		if (!cl.is_internal_symbol ()) {
			generate_class_declaration (cl, header_declarations);
		}
		generate_class_declaration (cl, internal_header_declarations);


		var cdecl = new CCodeDeclaration ("DovaType *");
		cdecl.add_declarator (new CCodeVariableDeclarator ("%s_type".printf (cl.get_lower_case_cname ()), new CCodeConstant ("NULL")));
		cdecl.modifiers = CCodeModifiers.STATIC;
		source_declarations.add_type_member_declaration (cdecl);

		var type_fun = new CCodeFunction ("%s_type_get".printf (cl.get_lower_case_cname ()), "DovaType *");
		type_fun.block = new CCodeBlock ();

		var type_init_block = new CCodeBlock ();

		generate_method_declaration ((Method) object_class.scope.lookup ("alloc"), source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("base_type")).set_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("type_size")).get_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("type_size")).set_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("value_size")).set_accessor, source_declarations);

		generate_class_declaration ((Class) context.root.scope.lookup ("Dova").scope.lookup ("Value"), source_declarations);

		var base_type = new CCodeFunctionCall (new CCodeIdentifier ("dova_value_type_get"));

		var base_type_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_get_type_size"));
		base_type_size.add_argument (base_type);

		var calloc_call = new CCodeFunctionCall (new CCodeIdentifier ("calloc"));
		calloc_call.add_argument (new CCodeConstant ("1"));
		calloc_call.add_argument (base_type_size);

		type_init_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ())), calloc_call)));

		generate_class_declaration ((Class) object_class, source_declarations);

		type_init_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeMemberAccess.pointer (new CCodeCastExpression (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ())), "DovaObject *"), "type"), new CCodeFunctionCall (new CCodeIdentifier ("dova_type_type_get")))));

		var set_base_type = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_base_type"));
		set_base_type.add_argument (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ())));
		set_base_type.add_argument (base_type);
		type_init_block.add_statement (new CCodeExpressionStatement (set_base_type));

		var set_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_type_size"));
		set_size.add_argument (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ())));
		set_size.add_argument (base_type_size);
		type_init_block.add_statement (new CCodeExpressionStatement (set_size));

		var type_init_call = new CCodeFunctionCall (new CCodeIdentifier ("%s_type_init".printf (cl.get_lower_case_cname ())));
		type_init_call.add_argument (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ())));
		type_init_block.add_statement (new CCodeExpressionStatement (type_init_call));

		type_fun.block.add_statement (new CCodeIfStatement (new CCodeUnaryExpression (CCodeUnaryOperator.LOGICAL_NEGATION, new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ()))), type_init_block));

		type_fun.block.add_statement (new CCodeReturnStatement (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ()))));

		source_type_member_definition.append (type_fun);

		var type_init_fun = new CCodeFunction ("%s_type_init".printf (cl.get_lower_case_cname ()));
		type_init_fun.add_parameter (new CCodeFormalParameter ("type", "DovaType *"));
		type_init_fun.block = new CCodeBlock ();

		type_init_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_value_type_init"));
		type_init_call.add_argument (new CCodeIdentifier ("type"));
		type_init_fun.block.add_statement (new CCodeExpressionStatement (type_init_call));

		declare_set_value_copy_function (source_declarations);

		var value_copy_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_copy"));
		value_copy_call.add_argument (new CCodeIdentifier ("%s_type".printf (cl.get_lower_case_cname ())));
		value_copy_call.add_argument (new CCodeCastExpression (new CCodeIdentifier ("string_copy"), "void (*)(void *, int32_t,  void *, int32_t)"));
		type_init_fun.block.add_statement (new CCodeExpressionStatement (value_copy_call));

		var function = new CCodeFunction ("string_copy", "void");
		function.modifiers = CCodeModifiers.STATIC;
		function.add_parameter (new CCodeFormalParameter ("dest", "string **"));
		function.add_parameter (new CCodeFormalParameter ("dest_index", "int32_t"));
		function.add_parameter (new CCodeFormalParameter ("src", "string **"));
		function.add_parameter (new CCodeFormalParameter ("src_index", "int32_t"));

		function.block = new CCodeBlock ();
		var cfrag = new CCodeFragment ();
		function.block.add_statement (cfrag);

		var dest = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("dest"), new CCodeIdentifier ("dest_index"));
		var src = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("src"), new CCodeIdentifier ("src_index"));

		var unref_call = new CCodeFunctionCall (new CCodeIdentifier ("string_unref"));
		unref_call.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, dest));
		var unref_block = new CCodeBlock ();
		unref_block.add_statement (new CCodeExpressionStatement (unref_call));
		unref_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, dest), new CCodeConstant ("NULL"))));
		function.block.add_statement (new CCodeIfStatement (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, dest), unref_block));

		var ref_call = new CCodeFunctionCall (new CCodeIdentifier ("string_ref"));
		ref_call.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, src));
		var ref_block = new CCodeBlock ();
		ref_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, dest), ref_call)));
		function.block.add_statement (new CCodeIfStatement (new CCodeIdentifier ("src"), ref_block));

		source_type_member_definition.append (function);

		if (cl.scope.lookup ("equal") is Method) {
			var value_equal_fun = new CCodeFunction ("%s_value_equal".printf (cl.get_lower_case_cname ()), "bool");
			value_equal_fun.modifiers = CCodeModifiers.STATIC;
			value_equal_fun.add_parameter (new CCodeFormalParameter ("value", cl.get_cname () + "**"));
			value_equal_fun.add_parameter (new CCodeFormalParameter ("value_index", "int32_t"));
			value_equal_fun.add_parameter (new CCodeFormalParameter ("other", cl.get_cname () + "**"));
			value_equal_fun.add_parameter (new CCodeFormalParameter ("other_index", "int32_t"));
			value_equal_fun.block = new CCodeBlock ();
			var val = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("value"), new CCodeIdentifier ("value_index"));
			var other = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("other"), new CCodeIdentifier ("other_index"));
			var ccall = new CCodeFunctionCall (new CCodeIdentifier ("%s_equal".printf (cl.get_lower_case_cname ())));
			ccall.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, val));
			ccall.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, other));
			value_equal_fun.block.add_statement (new CCodeReturnStatement (ccall));
			source_type_member_definition.append (value_equal_fun);

			declare_set_value_equal_function (source_declarations);

			var value_equal_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_equal"));
			value_equal_call.add_argument (new CCodeIdentifier ("type"));
			value_equal_call.add_argument (new CCodeCastExpression (new CCodeIdentifier ("%s_value_equal".printf (cl.get_lower_case_cname ())), "bool (*)(void *, int32_t,  void *, int32_t)"));
			type_init_fun.block.add_statement (new CCodeExpressionStatement (value_equal_call));
		}

		if (cl.scope.lookup ("hash") is Method) {
			var value_hash_fun = new CCodeFunction ("%s_value_hash".printf (cl.get_lower_case_cname ()), "int32_t");
			value_hash_fun.modifiers = CCodeModifiers.STATIC;
			value_hash_fun.add_parameter (new CCodeFormalParameter ("value", cl.get_cname () + "**"));
			value_hash_fun.add_parameter (new CCodeFormalParameter ("value_index", "int32_t"));
			value_hash_fun.block = new CCodeBlock ();
			var val = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("value"), new CCodeIdentifier ("value_index"));
			var ccall = new CCodeFunctionCall (new CCodeIdentifier ("%s_hash".printf (cl.get_lower_case_cname ())));
			ccall.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, val));
			value_hash_fun.block.add_statement (new CCodeReturnStatement (ccall));
			source_type_member_definition.append (value_hash_fun);

			declare_set_value_hash_function (source_declarations);

			var value_hash_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_hash"));
			value_hash_call.add_argument (new CCodeIdentifier ("type"));
			value_hash_call.add_argument (new CCodeCastExpression (new CCodeIdentifier ("%s_value_hash".printf (cl.get_lower_case_cname ())), "int32_t (*)(void *, int32_t)"));
			type_init_fun.block.add_statement (new CCodeExpressionStatement (value_hash_call));
		}

		source_type_member_definition.append (type_init_fun);

		cl.accept_children (codegen);

		current_symbol = old_symbol;
	}

	public override void visit_creation_method (CreationMethod m) {
		if (current_type_symbol is Class &&
		    (current_class.base_class == null ||
		     current_class.base_class.get_full_name () != "Dova.Value")) {
			base.visit_creation_method (m);
			return;
		}

		visit_method (m);
	}

	public override void generate_struct_declaration (Struct st, CCodeDeclarationSpace decl_space) {
		base.generate_struct_declaration (st, decl_space);

		if (decl_space.add_symbol_declaration (st, st.get_copy_function ())) {
			return;
		}

		decl_space.add_include ("stdint.h");

		generate_class_declaration (type_class, decl_space);

		var type_fun = new CCodeFunction ("%s_type_get".printf (st.get_lower_case_cname ()), "DovaType *");
		if (st.access == SymbolAccessibility.PRIVATE) {
			type_fun.modifiers = CCodeModifiers.STATIC;
		}
		decl_space.add_type_member_declaration (type_fun);

		var type_init_fun = new CCodeFunction ("%s_type_init".printf (st.get_lower_case_cname ()));
		type_init_fun.add_parameter (new CCodeFormalParameter ("type", "DovaType *"));
		if (st.access == SymbolAccessibility.PRIVATE) {
			type_init_fun.modifiers = CCodeModifiers.STATIC;
		}
		decl_space.add_type_member_declaration (type_init_fun);

		var function = new CCodeFunction (st.get_copy_function (), "void");
		if (st.access == SymbolAccessibility.PRIVATE) {
			function.modifiers = CCodeModifiers.STATIC;
		}

		function.add_parameter (new CCodeFormalParameter ("dest", st.get_cname () + "*"));
		function.add_parameter (new CCodeFormalParameter ("dest_index", "int32_t"));
		function.add_parameter (new CCodeFormalParameter ("src", st.get_cname () + "*"));
		function.add_parameter (new CCodeFormalParameter ("src_index", "int32_t"));

		decl_space.add_type_member_declaration (function);
	}

	public override void visit_struct (Struct st) {
		base.visit_struct (st);

		source_declarations.add_include ("stddef.h");
		// calloc
		source_declarations.add_include ("stdlib.h");

		var cdecl = new CCodeDeclaration ("DovaType *");
		cdecl.add_declarator (new CCodeVariableDeclarator ("%s_type".printf (st.get_lower_case_cname ()), new CCodeConstant ("NULL")));
		cdecl.modifiers = CCodeModifiers.STATIC;
		source_declarations.add_type_member_declaration (cdecl);

		var type_fun = new CCodeFunction ("%s_type_get".printf (st.get_lower_case_cname ()), "DovaType *");
		type_fun.block = new CCodeBlock ();

		var type_init_block = new CCodeBlock ();

		generate_method_declaration ((Method) object_class.scope.lookup ("alloc"), source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("base_type")).get_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("base_type")).set_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("object_size")).get_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("object_size")).set_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("type_size")).get_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("type_size")).set_accessor, source_declarations);
		generate_property_accessor_declaration (((Property) type_class.scope.lookup ("value_size")).set_accessor, source_declarations);

		generate_class_declaration ((Class) context.root.scope.lookup ("Dova").scope.lookup ("Value"), source_declarations);

		var base_type = new CCodeFunctionCall (new CCodeIdentifier ("dova_value_type_get"));

		var base_type_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_get_type_size"));
		base_type_size.add_argument (base_type);

		var calloc_call = new CCodeFunctionCall (new CCodeIdentifier ("calloc"));
		calloc_call.add_argument (new CCodeConstant ("1"));
		calloc_call.add_argument (base_type_size);

		type_init_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())), calloc_call)));

		generate_class_declaration ((Class) object_class, source_declarations);

		type_init_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeMemberAccess.pointer (new CCodeCastExpression (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())), "DovaObject *"), "type"), new CCodeFunctionCall (new CCodeIdentifier ("dova_type_type_get")))));

		var set_base_type = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_base_type"));
		set_base_type.add_argument (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())));
		set_base_type.add_argument (base_type);
		type_init_block.add_statement (new CCodeExpressionStatement (set_base_type));

		var base_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_get_object_size"));
		base_size.add_argument (base_type);

		var sizeof_call = new CCodeFunctionCall (new CCodeIdentifier ("sizeof"));
		sizeof_call.add_argument (new CCodeIdentifier (st.get_cname ()));
		var set_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_object_size"));
		set_size.add_argument (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())));
		set_size.add_argument (new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, base_size, sizeof_call));
		type_init_block.add_statement (new CCodeExpressionStatement (set_size));

		set_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_size"));
		set_size.add_argument (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())));
		set_size.add_argument (sizeof_call);
		type_init_block.add_statement (new CCodeExpressionStatement (set_size));

		set_size = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_type_size"));
		set_size.add_argument (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())));
		set_size.add_argument (base_type_size);
		type_init_block.add_statement (new CCodeExpressionStatement (set_size));

		var type_init_call = new CCodeFunctionCall (new CCodeIdentifier ("%s_type_init".printf (st.get_lower_case_cname ())));
		type_init_call.add_argument (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ())));
		type_init_block.add_statement (new CCodeExpressionStatement (type_init_call));

		type_fun.block.add_statement (new CCodeIfStatement (new CCodeUnaryExpression (CCodeUnaryOperator.LOGICAL_NEGATION, new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ()))), type_init_block));

		type_fun.block.add_statement (new CCodeReturnStatement (new CCodeIdentifier ("%s_type".printf (st.get_lower_case_cname ()))));

		source_type_member_definition.append (type_fun);

		var type_init_fun = new CCodeFunction ("%s_type_init".printf (st.get_lower_case_cname ()));
		type_init_fun.add_parameter (new CCodeFormalParameter ("type", "DovaType *"));
		type_init_fun.block = new CCodeBlock ();

		type_init_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_value_type_init"));
		type_init_call.add_argument (new CCodeIdentifier ("type"));
		type_init_fun.block.add_statement (new CCodeExpressionStatement (type_init_call));

		declare_set_value_copy_function (source_declarations);

		var value_copy_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_copy"));
		value_copy_call.add_argument (new CCodeIdentifier ("type"));
		value_copy_call.add_argument (new CCodeCastExpression (new CCodeIdentifier ("%s_copy".printf (st.get_lower_case_cname ())), "void (*)(void *, int32_t,  void *, int32_t)"));
		type_init_fun.block.add_statement (new CCodeExpressionStatement (value_copy_call));

		if (st.scope.lookup ("equal") is Method) {
			var value_equal_fun = new CCodeFunction ("%s_value_equal".printf (st.get_lower_case_cname ()), "bool");
			value_equal_fun.modifiers = CCodeModifiers.STATIC;
			value_equal_fun.add_parameter (new CCodeFormalParameter ("value", st.get_cname () + "*"));
			value_equal_fun.add_parameter (new CCodeFormalParameter ("value_index", "int32_t"));
			value_equal_fun.add_parameter (new CCodeFormalParameter ("other", st.get_cname () + "*"));
			value_equal_fun.add_parameter (new CCodeFormalParameter ("other_index", "int32_t"));
			value_equal_fun.block = new CCodeBlock ();
			var val = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("value"), new CCodeIdentifier ("value_index"));
			var other = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("other"), new CCodeIdentifier ("other_index"));
			var ccall = new CCodeFunctionCall (new CCodeIdentifier ("%s_equal".printf (st.get_lower_case_cname ())));
			ccall.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, val));
			ccall.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, other));
			value_equal_fun.block.add_statement (new CCodeReturnStatement (ccall));
			source_type_member_definition.append (value_equal_fun);

			declare_set_value_equal_function (source_declarations);

			var value_equal_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_equal"));
			value_equal_call.add_argument (new CCodeIdentifier ("type"));
			value_equal_call.add_argument (new CCodeCastExpression (new CCodeIdentifier ("%s_value_equal".printf (st.get_lower_case_cname ())), "bool (*)(void *, int32_t,  void *, int32_t)"));
			type_init_fun.block.add_statement (new CCodeExpressionStatement (value_equal_call));
		}

		if (st.scope.lookup ("hash") is Method) {
			var value_hash_fun = new CCodeFunction ("%s_value_hash".printf (st.get_lower_case_cname ()), "int32_t");
			value_hash_fun.modifiers = CCodeModifiers.STATIC;
			value_hash_fun.add_parameter (new CCodeFormalParameter ("value", st.get_cname () + "*"));
			value_hash_fun.add_parameter (new CCodeFormalParameter ("value_index", "int32_t"));
			value_hash_fun.block = new CCodeBlock ();
			var val = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("value"), new CCodeIdentifier ("value_index"));
			var ccall = new CCodeFunctionCall (new CCodeIdentifier ("%s_hash".printf (st.get_lower_case_cname ())));
			ccall.add_argument (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, val));
			value_hash_fun.block.add_statement (new CCodeReturnStatement (ccall));
			source_type_member_definition.append (value_hash_fun);

			declare_set_value_hash_function (source_declarations);

			var value_hash_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_set_value_hash"));
			value_hash_call.add_argument (new CCodeIdentifier ("type"));
			value_hash_call.add_argument (new CCodeCastExpression (new CCodeIdentifier ("%s_value_hash".printf (st.get_lower_case_cname ())), "int32_t (*)(void *, int32_t)"));
			type_init_fun.block.add_statement (new CCodeExpressionStatement (value_hash_call));
		}

		source_type_member_definition.append (type_init_fun);

		add_struct_copy_function (st);
	}

	void add_struct_copy_function (Struct st) {
		var function = new CCodeFunction (st.get_copy_function (), "void");
		if (st.access == SymbolAccessibility.PRIVATE) {
			function.modifiers = CCodeModifiers.STATIC;
		}

		function.add_parameter (new CCodeFormalParameter ("dest", st.get_cname () + "*"));
		function.add_parameter (new CCodeFormalParameter ("dest_index", "int32_t"));
		function.add_parameter (new CCodeFormalParameter ("src", st.get_cname () + "*"));
		function.add_parameter (new CCodeFormalParameter ("src_index", "int32_t"));

		var cblock = new CCodeBlock ();
		var cfrag = new CCodeFragment ();
		cblock.add_statement (cfrag);

		var dest = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("dest"), new CCodeIdentifier ("dest_index"));
		var src = new CCodeBinaryExpression (CCodeBinaryOperator.PLUS, new CCodeIdentifier ("src"), new CCodeIdentifier ("src_index"));

		foreach (var f in st.get_fields ()) {
			if (f.binding == MemberBinding.INSTANCE) {
				var field = new CCodeMemberAccess.pointer (dest, f.name);

				var array_type = f.field_type as ArrayType;
				if (array_type != null && array_type.fixed_length) {
					for (int i = 0; i < array_type.length; i++) {
						var element = new CCodeElementAccess (field, new CCodeConstant (i.to_string ()));

						if (requires_destroy (array_type.element_type))  {
							cblock.add_statement (new CCodeExpressionStatement (get_unref_expression (element, array_type.element_type)));
						}
					}
					continue;
				}

				if (requires_destroy (f.field_type))  {
					var this_access = new MemberAccess.simple ("this");
					this_access.value_type = get_data_type_for_symbol ((TypeSymbol) f.parent_symbol);
					this_access.ccodenode = new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, dest);
					var ma = new MemberAccess (this_access, f.name);
					ma.symbol_reference = f;
					ma.value_type = f.field_type.copy ();
					cblock.add_statement (new CCodeExpressionStatement (get_unref_expression (field, f.field_type, ma)));
				}
			}
		}

		var copy_block = new CCodeBlock ();

		if (st.get_fields ().size == 0) {
			copy_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, dest), new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, src))));
		} else {
			foreach (var f in st.get_fields ()) {
				if (f.binding == MemberBinding.INSTANCE) {
					CCodeExpression copy = new CCodeMemberAccess.pointer (src, f.name);
					var dest_field = new CCodeMemberAccess.pointer (dest, f.name);

					var array_type = f.field_type as ArrayType;
					if (array_type != null && array_type.fixed_length) {
						for (int i = 0; i < array_type.length; i++) {
							CCodeExpression copy_element = new CCodeElementAccess (copy, new CCodeConstant (i.to_string ()));
							var dest_field_element = new CCodeElementAccess (dest_field, new CCodeConstant (i.to_string ()));

							if (requires_copy (array_type.element_type))  {
								copy_element = get_ref_cexpression (array_type.element_type, copy_element, null, f);
							}

							copy_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (dest_field_element, copy_element)));
						}
						continue;
					}

					if (requires_copy (f.field_type))  {
						var this_access = new MemberAccess.simple ("this");
						this_access.value_type = get_data_type_for_symbol ((TypeSymbol) f.parent_symbol);
						this_access.ccodenode = new CCodeUnaryExpression (CCodeUnaryOperator.POINTER_INDIRECTION, src);
						var ma = new MemberAccess (this_access, f.name);
						ma.symbol_reference = f;
						copy = get_ref_cexpression (f.field_type, copy, ma, f);
					}

					copy_block.add_statement (new CCodeExpressionStatement (new CCodeAssignment (dest_field, copy)));
				}
			}
		}

		cblock.add_statement (new CCodeIfStatement (new CCodeIdentifier ("src"), copy_block));

		append_temp_decl (cfrag, temp_vars);
		temp_vars.clear ();

		function.block = cblock;

		source_type_member_definition.append (function);
	}

	public override void visit_assignment (Assignment assignment) {
		var generic_type = assignment.left.value_type as GenericType;
		if (generic_type == null) {
			base.visit_assignment (assignment);
			return;
		}

		var dest = assignment.left;
		CCodeExpression cdest;
		CCodeExpression dest_index = new CCodeConstant ("0");
		var src = assignment.right;
		CCodeExpression csrc;
		CCodeExpression src_index = new CCodeConstant ("0");

		if (src is NullLiteral) {
			// TODO destroy dest
			assignment.ccodenode = new CCodeConstant ("0");
			return;
		}

		var dest_ea = dest as ElementAccess;
		var src_ea = src as ElementAccess;

		if (dest_ea != null) {
			dest = dest_ea.container;

			var array_type = dest.value_type as ArrayType;
			if (array_type != null && !array_type.inline_allocated) {
				generate_property_accessor_declaration (((Property) array_class.scope.lookup ("data")).get_accessor, source_declarations);

				var data_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_array_get_data"));
				data_call.add_argument ((CCodeExpression) get_ccodenode (dest));
				cdest = data_call;
			} else {
				cdest = (CCodeExpression) get_ccodenode (dest);
			}
			dest_index = (CCodeExpression) get_ccodenode (dest_ea.get_indices ().get (0));
		} else {
			cdest = (CCodeExpression) get_ccodenode (dest);
		}

		if (src_ea != null) {
			src = src_ea.container;

			var array_type = src.value_type as ArrayType;
			if (array_type != null && !array_type.inline_allocated) {
				generate_property_accessor_declaration (((Property) array_class.scope.lookup ("data")).get_accessor, source_declarations);

				var data_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_array_get_data"));
				data_call.add_argument ((CCodeExpression) get_ccodenode (src));
				csrc = data_call;
			} else {
				csrc = (CCodeExpression) get_ccodenode (src);
			}
			src_index = (CCodeExpression) get_ccodenode (src_ea.get_indices ().get (0));
		} else {
			csrc = (CCodeExpression) get_ccodenode (src);
		}

		var ccall = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_value_copy"));
		if (generic_type.type_parameter.parent_symbol is TypeSymbol) {
			// generic type
			ccall.add_argument (new CCodeMemberAccess.pointer (get_type_private_from_type ((ObjectTypeSymbol) generic_type.type_parameter.parent_symbol, new CCodeMemberAccess.pointer (new CCodeIdentifier ("this"), "type")), "%s_type".printf (generic_type.type_parameter.name.down ())));
		} else {
			// generic method
			ccall.add_argument (new CCodeIdentifier ("%s_type".printf (generic_type.type_parameter.name.down ())));
		}
		ccall.add_argument (cdest);
		ccall.add_argument (dest_index);
		ccall.add_argument (csrc);
		ccall.add_argument (src_index);
		assignment.ccodenode = ccall;
	}

	public override void visit_binary_expression (BinaryExpression expr) {
		var generic_type = expr.left.value_type as GenericType;
		if (generic_type == null) {
			base.visit_binary_expression (expr);
			return;
		}

		CCodeExpression cleft;
		CCodeExpression left_index = new CCodeConstant ("0");
		CCodeExpression cright;
		CCodeExpression right_index = new CCodeConstant ("0");

		var left_ea = expr.left as ElementAccess;
		var right_ea = expr.right as ElementAccess;

		if (left_ea != null) {
			generate_property_accessor_declaration (((Property) array_class.scope.lookup ("data")).get_accessor, source_declarations);

			var data_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_array_get_data"));
			data_call.add_argument ((CCodeExpression) get_ccodenode (left_ea.container));
			cleft = data_call;
			left_index = (CCodeExpression) get_ccodenode (left_ea.get_indices ().get (0));
		} else {
			cleft = (CCodeExpression) get_ccodenode (expr.left);
		}

		if (right_ea != null) {
			generate_property_accessor_declaration (((Property) array_class.scope.lookup ("data")).get_accessor, source_declarations);

			var data_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_array_get_data"));
			data_call.add_argument ((CCodeExpression) get_ccodenode (right_ea.container));
			cright = data_call;
			right_index = (CCodeExpression) get_ccodenode (right_ea.get_indices ().get (0));
		} else {
			cright = (CCodeExpression) get_ccodenode (expr.right);
		}

		var ccall = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_value_equal"));
		ccall.add_argument (get_type_id_expression (generic_type));
		ccall.add_argument (cleft);
		ccall.add_argument (left_index);
		ccall.add_argument (cright);
		ccall.add_argument (right_index);

		if (expr.operator == BinaryOperator.EQUALITY) {
			expr.ccodenode = ccall;
		} else {
			expr.ccodenode = new CCodeUnaryExpression (CCodeUnaryOperator.LOGICAL_NEGATION, ccall);
		}
	}

	public override void visit_method_call (MethodCall expr) {
		var ma = expr.call as MemberAccess;
		if (ma == null || ma.inner == null || !(ma.inner.value_type is GenericType)) {
			base.visit_method_call (expr);
			return;
		}

		// handle method calls on generic types

		expr.accept_children (codegen);

		if (ma.member_name == "hash") {
			var val = ma.inner;
			CCodeExpression cval;
			CCodeExpression val_index = new CCodeConstant ("0");

			var val_ea = val as ElementAccess;
			if (val_ea != null) {
				val = val_ea.container;

				generate_property_accessor_declaration (((Property) array_class.scope.lookup ("data")).get_accessor, source_declarations);

				var data_call = new CCodeFunctionCall (new CCodeIdentifier ("dova_array_get_data"));
				data_call.add_argument ((CCodeExpression) get_ccodenode (val));
				cval = data_call;
				val_index = (CCodeExpression) get_ccodenode (val_ea.get_indices ().get (0));
			} else {
				cval = (CCodeExpression) get_ccodenode (val);
			}

			var ccall = new CCodeFunctionCall (new CCodeIdentifier ("dova_type_value_hash"));
			ccall.add_argument (get_type_id_expression (ma.inner.value_type));
			ccall.add_argument (cval);
			ccall.add_argument (val_index);

			expr.ccodenode = ccall;
		}
	}

	public override void visit_list_literal (ListLiteral expr) {
		expr.accept_children (codegen);

		var array_type = new ArrayType (expr.element_type, 1, expr.source_reference);
		array_type.inline_allocated = true;
		array_type.fixed_length = true;
		array_type.length = expr.get_expressions ().size;

		var ce = new CCodeCommaExpression ();
		var temp_var = get_temp_variable (array_type, true, expr);
		var name_cnode = get_variable_cexpression (temp_var.name);

		temp_vars.insert (0, temp_var);

		int i = 0;
		foreach (Expression e in expr.get_expressions ()) {
			ce.append_expression (new CCodeAssignment (new CCodeElementAccess (name_cnode, new CCodeConstant (i.to_string ())), (CCodeExpression) e.ccodenode));
			i++;
		}

		ce.append_expression (name_cnode);

		var list_creation = new CCodeFunctionCall (new CCodeIdentifier ("dova_list_new"));
		list_creation.add_argument (get_type_id_expression (expr.element_type));
		list_creation.add_argument (new CCodeConstant (array_type.length.to_string ()));
		list_creation.add_argument (ce);

		expr.ccodenode = list_creation;
	}

	public override void visit_set_literal (SetLiteral expr) {
		expr.accept_children (codegen);

		var array_type = new ArrayType (expr.element_type, 1, expr.source_reference);
		array_type.inline_allocated = true;
		array_type.fixed_length = true;
		array_type.length = expr.get_expressions ().size;

		var ce = new CCodeCommaExpression ();
		var temp_var = get_temp_variable (array_type, true, expr);
		var name_cnode = get_variable_cexpression (temp_var.name);

		temp_vars.insert (0, temp_var);

		int i = 0;
		foreach (Expression e in expr.get_expressions ()) {
			ce.append_expression (new CCodeAssignment (new CCodeElementAccess (name_cnode, new CCodeConstant (i.to_string ())), (CCodeExpression) e.ccodenode));
			i++;
		}

		ce.append_expression (name_cnode);

		var set_creation = new CCodeFunctionCall (new CCodeIdentifier ("dova_set_new"));
		set_creation.add_argument (get_type_id_expression (expr.element_type));
		set_creation.add_argument (new CCodeConstant (array_type.length.to_string ()));
		set_creation.add_argument (ce);

		expr.ccodenode = set_creation;
	}

	public override void visit_map_literal (MapLiteral expr) {
		expr.accept_children (codegen);

		var key_array_type = new ArrayType (expr.map_key_type, 1, expr.source_reference);
		key_array_type.inline_allocated = true;
		key_array_type.fixed_length = true;
		key_array_type.length = expr.get_keys ().size;

		var key_ce = new CCodeCommaExpression ();
		var key_temp_var = get_temp_variable (key_array_type, true, expr);
		var key_name_cnode = get_variable_cexpression (key_temp_var.name);

		temp_vars.insert (0, key_temp_var);

		var value_array_type = new ArrayType (expr.map_value_type, 1, expr.source_reference);
		value_array_type.inline_allocated = true;
		value_array_type.fixed_length = true;
		value_array_type.length = expr.get_values ().size;

		var value_ce = new CCodeCommaExpression ();
		var value_temp_var = get_temp_variable (value_array_type, true, expr);
		var value_name_cnode = get_variable_cexpression (value_temp_var.name);

		temp_vars.insert (0, value_temp_var);

		for (int i = 0; i < expr.get_keys ().size; i++) {
			key_ce.append_expression (new CCodeAssignment (new CCodeElementAccess (key_name_cnode, new CCodeConstant (i.to_string ())), (CCodeExpression) expr.get_keys ().get (i).ccodenode));
			value_ce.append_expression (new CCodeAssignment (new CCodeElementAccess (value_name_cnode, new CCodeConstant (i.to_string ())), (CCodeExpression) expr.get_values ().get (i).ccodenode));
		}

		key_ce.append_expression (key_name_cnode);
		value_ce.append_expression (value_name_cnode);

		var map_creation = new CCodeFunctionCall (new CCodeIdentifier ("dova_map_new"));
		map_creation.add_argument (get_type_id_expression (expr.map_key_type));
		map_creation.add_argument (get_type_id_expression (expr.map_value_type));
		map_creation.add_argument (new CCodeConstant (key_array_type.length.to_string ()));
		map_creation.add_argument (key_ce);
		map_creation.add_argument (value_ce);

		expr.ccodenode = map_creation;
	}

	public override void visit_tuple (Tuple tuple) {
		tuple.accept_children (codegen);

		var type_array_type = new ArrayType (new PointerType (new VoidType ()), 1, tuple.source_reference);
		type_array_type.inline_allocated = true;
		type_array_type.fixed_length = true;
		type_array_type.length = tuple.get_expressions ().size;

		var type_temp_var = get_temp_variable (type_array_type, true, tuple);
		var type_name_cnode = get_variable_cexpression (type_temp_var.name);
		temp_vars.insert (0, type_temp_var);

		var array_type = new ArrayType (new PointerType (new VoidType ()), 1, tuple.source_reference);
		array_type.inline_allocated = true;
		array_type.fixed_length = true;
		array_type.length = tuple.get_expressions ().size;

		var temp_var = get_temp_variable (array_type, true, tuple);
		var name_cnode = get_variable_cexpression (temp_var.name);
		temp_vars.insert (0, temp_var);

		var type_ce = new CCodeCommaExpression ();
		var ce = new CCodeCommaExpression ();

		int i = 0;
		foreach (Expression e in tuple.get_expressions ()) {
			var element_type = tuple.value_type.get_type_arguments ().get (i);

			type_ce.append_expression (new CCodeAssignment (new CCodeElementAccess (type_name_cnode, new CCodeConstant (i.to_string ())), get_type_id_expression (element_type)));

			var cexpr = (CCodeExpression) e.ccodenode;

			var unary = cexpr as CCodeUnaryExpression;
			if (unary != null && unary.operator == CCodeUnaryOperator.POINTER_INDIRECTION) {
				// *expr => expr
				cexpr = unary.inner;
			} else if (cexpr is CCodeIdentifier || cexpr is CCodeMemberAccess) {
				cexpr = new CCodeUnaryExpression (CCodeUnaryOperator.ADDRESS_OF, cexpr);
			} else {
				// if cexpr is e.g. a function call, we can't take the address of the expression
				// tmp = expr, &tmp

				var element_temp_var = get_temp_variable (element_type);
				temp_vars.insert (0, element_temp_var);
				ce.append_expression (new CCodeAssignment (get_variable_cexpression (element_temp_var.name), cexpr));
				cexpr = new CCodeUnaryExpression (CCodeUnaryOperator.ADDRESS_OF, new CCodeIdentifier (element_temp_var.name));
			}

			ce.append_expression (new CCodeAssignment (new CCodeElementAccess (name_cnode, new CCodeConstant (i.to_string ())), cexpr));

			i++;
		}

		type_ce.append_expression (type_name_cnode);
		ce.append_expression (name_cnode);

		var tuple_creation = new CCodeFunctionCall (new CCodeIdentifier ("dova_tuple_new"));
		tuple_creation.add_argument (new CCodeConstant (tuple.get_expressions ().size.to_string ()));
		tuple_creation.add_argument (type_ce);
		tuple_creation.add_argument (ce);

		tuple.ccodenode = tuple_creation;
	}
}
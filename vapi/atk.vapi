/* atk.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Atk", gir_namespace = "Atk", gir_version = "1.0", lower_case_cprefix = "atk_")]
namespace Atk {
	[CCode (cheader_filename = "atk/atk.h")]
	[Compact]
	public class AttributeSet : GLib.SList<Atk.Attribute?> {
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_gobject_accessible_get_type ()")]
	public class GObjectAccessible : Atk.Object {
		[CCode (has_construct_function = false)]
		protected GObjectAccessible ();
		public static unowned Atk.Object for_object (GLib.Object obj);
		public unowned GLib.Object get_object ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_hyperlink_get_type ()")]
	public class Hyperlink : GLib.Object, Atk.Action {
		[CCode (has_construct_function = false)]
		protected Hyperlink ();
		public virtual int get_end_index ();
		public virtual int get_n_anchors ();
		public virtual unowned Atk.Object get_object (int i);
		public virtual int get_start_index ();
		public virtual string get_uri (int i);
		public bool is_inline ();
		[Deprecated]
		public virtual bool is_selected_link ();
		public virtual bool is_valid ();
		[NoWrapper]
		public virtual uint link_state ();
		public int end_index { get; }
		[NoAccessorMethod]
		public int number_of_anchors { get; }
		[Deprecated]
		[NoAccessorMethod]
		public bool selected_link { get; }
		public int start_index { get; }
		public virtual signal void link_activated ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_misc_get_type ()")]
	public class Misc : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Misc ();
		[Deprecated]
		public static unowned Atk.Misc get_instance ();
		[Deprecated]
		public virtual void threads_enter ();
		[Deprecated]
		public virtual void threads_leave ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_no_op_object_get_type ()")]
	public class NoOpObject : Atk.Object, Atk.Action, Atk.Component, Atk.Document, Atk.EditableText, Atk.Hypertext, Atk.Image, Atk.Selection, Atk.Table, Atk.TableCell, Atk.Text, Atk.Value, Atk.Window {
		[CCode (has_construct_function = false, type = "AtkObject*")]
		public NoOpObject (GLib.Object obj);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_no_op_object_factory_get_type ()")]
	public class NoOpObjectFactory : Atk.ObjectFactory {
		[CCode (has_construct_function = false, type = "AtkObjectFactory*")]
		public NoOpObjectFactory ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_object_get_type ()")]
	public class Object : GLib.Object {
		public weak string description;
		public Atk.Layer layer;
		public weak string name;
		public weak Atk.RelationSet relation_set;
		public Atk.Role role;
		[CCode (has_construct_function = false)]
		protected Object ();
		public bool add_relationship (Atk.RelationType relationship, Atk.Object target);
		[Deprecated]
		public virtual uint connect_property_change_handler (Atk.PropertyChangeHandler handler);
		public virtual Atk.AttributeSet get_attributes ();
		public virtual unowned string get_description ();
		public virtual int get_index_in_parent ();
		[Deprecated]
		public virtual Atk.Layer get_layer ();
		[Deprecated]
		public virtual int get_mdi_zorder ();
		public int get_n_accessible_children ();
		[NoWrapper]
		public virtual int get_n_children ();
		public virtual unowned string get_name ();
		public virtual unowned string get_object_locale ();
		public virtual unowned Atk.Object get_parent ();
		public virtual Atk.Role get_role ();
		public virtual void initialize (void* data);
		public void notify_state_change (Atk.State state, bool value);
		public unowned Atk.Object peek_parent ();
		public Atk.Object ref_accessible_child (int i);
		public virtual Atk.RelationSet ref_relation_set ();
		public virtual Atk.StateSet ref_state_set ();
		[Deprecated]
		public virtual void remove_property_change_handler (uint handler_id);
		public bool remove_relationship (Atk.RelationType relationship, Atk.Object target);
		public virtual void set_description (string description);
		public virtual void set_name (string name);
		public virtual void set_parent (Atk.Object parent);
		public virtual void set_role (Atk.Role role);
		[NoAccessorMethod]
		public int accessible_component_layer { get; }
		[NoAccessorMethod]
		public int accessible_component_mdi_zorder { get; }
		[NoAccessorMethod]
		public string accessible_description { owned get; set; }
		[NoAccessorMethod]
		public int accessible_hypertext_nlinks { get; }
		[NoAccessorMethod]
		public string accessible_name { owned get; set; }
		[NoAccessorMethod]
		public Atk.Object accessible_parent { owned get; set; }
		[NoAccessorMethod]
		public int accessible_role { get; set; }
		[Deprecated]
		[NoAccessorMethod]
		public string accessible_table_caption { owned get; set; }
		[NoAccessorMethod]
		public Atk.Object accessible_table_caption_object { owned get; set; }
		[Deprecated]
		[NoAccessorMethod]
		public string accessible_table_column_description { owned get; set; }
		[Deprecated]
		[NoAccessorMethod]
		public Atk.Object accessible_table_column_header { owned get; set; }
		[Deprecated]
		[NoAccessorMethod]
		public string accessible_table_row_description { owned get; set; }
		[Deprecated]
		[NoAccessorMethod]
		public Atk.Object accessible_table_row_header { owned get; set; }
		[NoAccessorMethod]
		public Atk.Object accessible_table_summary { owned get; set; }
		[Deprecated]
		[NoAccessorMethod]
		public double accessible_value { get; set; }
		public virtual signal void active_descendant_changed (void* child);
		public virtual signal void children_changed (uint change_index, void* changed_child);
		[Deprecated]
		public virtual signal void focus_event (bool focus_in);
		public virtual signal void property_change (void* values);
		public virtual signal void state_change (string name, bool state_set);
		public virtual signal void visible_data_changed ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_object_factory_get_type ()")]
	public class ObjectFactory : GLib.Object {
		[CCode (has_construct_function = false)]
		protected ObjectFactory ();
		public Atk.Object create_accessible (GLib.Object obj);
		public GLib.Type get_accessible_type ();
		public virtual void invalidate ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_plug_get_type ()")]
	public class Plug : Atk.Object, Atk.Component {
		[CCode (has_construct_function = false, type = "AtkObject*")]
		public Plug ();
		public string get_id ();
		[NoWrapper]
		public virtual string get_object_id ();
	}
	[CCode (cheader_filename = "atk/atk.h", copy_function = "g_boxed_copy", free_function = "g_boxed_free", type_id = "atk_range_get_type ()")]
	[Compact]
	public class Range {
		[CCode (has_construct_function = false)]
		public Range (double lower_limit, double upper_limit, string description);
		public Atk.Range copy ();
		public void free ();
		public unowned string get_description ();
		public double get_lower_limit ();
		public double get_upper_limit ();
	}
	[CCode (cheader_filename = "atk/atk.h")]
	public class Registry : GLib.Object {
		[Deprecated]
		public weak GLib.HashTable<GLib.Type,Atk.ObjectFactory> factory_singleton_cache;
		[Deprecated]
		public weak GLib.HashTable<GLib.Type,GLib.Type> factory_type_registry;
		[CCode (has_construct_function = false)]
		protected Registry ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_get_default_registry")]
		public static Atk.Registry get_default ();
		public unowned Atk.ObjectFactory get_factory (GLib.Type type);
		public GLib.Type get_factory_type (GLib.Type type);
		public void set_factory_type (GLib.Type type, GLib.Type factory_type);
	}
	[CCode (cheader_filename = "atk/atk.h")]
	public class Relation : GLib.Object {
		public Atk.RelationType relationship;
		[CCode (has_construct_function = false)]
		public Relation ([CCode (array_length_cname = "n_targets", array_length_pos = 1.5)] Atk.Object[] targets, Atk.RelationType relationship);
		public void add_target (Atk.Object target);
		public Atk.RelationType get_relation_type ();
		public unowned GLib.GenericArray<Atk.Object> get_target ();
		public bool remove_target (Atk.Object target);
		[Deprecated (replacement = "RelationType.for_name", since = "vala-0.16")]
		public static Atk.RelationType type_for_name (string name);
		[Deprecated (replacement = "RelationType.get_name", since = "vala-0.16")]
		public static unowned string type_get_name (Atk.RelationType type);
		[Deprecated (replacement = "RelationType.register", since = "vala-0.16")]
		public static Atk.RelationType type_register (string name);
		[NoAccessorMethod]
		public Atk.RelationType relation_type { get; set; }
		[NoAccessorMethod]
		public GLib.ValueArray target { owned get; set; }
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_relation_set_get_type ()")]
	public class RelationSet : GLib.Object {
		[Deprecated]
		public weak GLib.GenericArray<Atk.Relation> relations;
		[CCode (has_construct_function = false)]
		public RelationSet ();
		public void add (Atk.Relation relation);
		public void add_relation_by_type (Atk.RelationType relationship, Atk.Object target);
		public bool contains (Atk.RelationType relationship);
		public bool contains_target (Atk.RelationType relationship, Atk.Object target);
		public int get_n_relations ();
		public unowned Atk.Relation get_relation (int i);
		public unowned Atk.Relation get_relation_by_type (Atk.RelationType relationship);
		public void remove (Atk.Relation relation);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_socket_get_type ()")]
	public class Socket : Atk.Object, Atk.Component {
		[Deprecated]
		public weak string embedded_plug_id;
		[CCode (has_construct_function = false, type = "AtkObject*")]
		public Socket ();
		public virtual void embed (string plug_id);
		public bool is_occupied ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_state_set_get_type ()")]
	public class StateSet : GLib.Object {
		[CCode (has_construct_function = false)]
		public StateSet ();
		public bool add_state (Atk.StateType type);
		public void add_states ([CCode (array_length_cname = "n_types", array_length_pos = 1.1)] Atk.StateType[] types);
		public Atk.StateSet and_sets (Atk.StateSet compare_set);
		public void clear_states ();
		public bool contains_state (Atk.StateType type);
		public bool contains_states ([CCode (array_length_cname = "n_types", array_length_pos = 1.1)] Atk.StateType[] types);
		public bool is_empty ();
		public Atk.StateSet? or_sets (Atk.StateSet compare_set);
		public bool remove_state (Atk.StateType type);
		public Atk.StateSet xor_sets (Atk.StateSet compare_set);
	}
	[CCode (cheader_filename = "atk/atk.h", copy_function = "g_boxed_copy", free_function = "g_boxed_free", type_id = "atk_text_range_get_type ()")]
	[Compact]
	public class TextRange {
		public Atk.TextRectangle bounds;
		public string content;
		public int end_offset;
		public int start_offset;
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_util_get_type ()")]
	public class Util : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Util ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_add_focus_tracker")]
		[Deprecated]
		public static uint add_focus_tracker (Atk.EventListener focus_tracker);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_add_global_event_listener")]
		public static uint add_global_event_listener ([CCode (type = "GSignalEmissionHook")] Atk.SignalEmissionHook listener, string event_type);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_add_key_event_listener")]
		public static uint add_key_event_listener (Atk.KeySnoopFunc listener);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_focus_tracker_init")]
		[Deprecated]
		public static void focus_tracker_init (Atk.EventListenerInit init);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_focus_tracker_notify")]
		[Deprecated]
		public static void focus_tracker_notify (Atk.Object object);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_get_focus_object")]
		public static unowned Atk.Object get_focus_object ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_get_root")]
		public static unowned Atk.Object get_root ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_get_toolkit_name")]
		public static unowned string get_toolkit_name ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_get_toolkit_version")]
		public static unowned string get_toolkit_version ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_get_version")]
		public static unowned string get_version ();
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_remove_focus_tracker")]
		[Deprecated]
		public static void remove_focus_tracker (uint tracker_id);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_remove_global_event_listener")]
		public static void remove_global_event_listener (uint listener_id);
		[CCode (cheader_filename = "atk/atk.h", cname = "atk_remove_key_event_listener")]
		public static void remove_key_event_listener (uint listener_id);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_action_get_type ()")]
	public interface Action : GLib.Object {
		public abstract bool do_action (int i);
		public abstract unowned string? get_description (int i);
		public abstract unowned string? get_keybinding (int i);
		public abstract unowned string? get_localized_name (int i);
		public abstract int get_n_actions ();
		public abstract unowned string? get_name (int i);
		public abstract bool set_description (int i, string desc);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_component_get_type ()")]
	public interface Component : GLib.Object {
		[Deprecated]
		public abstract uint add_focus_handler (Atk.FocusHandler handler);
		public abstract bool contains (int x, int y, Atk.CoordType coord_type);
		public abstract double get_alpha ();
		public abstract void get_extents (int x, int y, int width, int height, Atk.CoordType coord_type);
		public abstract Atk.Layer get_layer ();
		public abstract int get_mdi_zorder ();
		[Deprecated]
		public abstract void get_position (int x, int y, Atk.CoordType coord_type);
		[Deprecated]
		public abstract void get_size (int width, int height);
		public abstract bool grab_focus ();
		public abstract Atk.Object? ref_accessible_at_point (int x, int y, Atk.CoordType coord_type);
		[Deprecated]
		public abstract void remove_focus_handler (uint handler_id);
		public abstract bool set_extents (int x, int y, int width, int height, Atk.CoordType coord_type);
		public abstract bool set_position (int x, int y, Atk.CoordType coord_type);
		public abstract bool set_size (int width, int height);
		public virtual signal void bounds_changed (Atk.Rectangle bounds);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_document_get_type ()")]
	public interface Document : GLib.Object {
		[CCode (vfunc_name = "get_document_attribute_value")]
		public virtual unowned string? get_attribute_value (string attribute_name);
		[CCode (vfunc_name = "get_document_attributes")]
		public virtual unowned Atk.AttributeSet get_attributes ();
		public virtual int get_current_page_number ();
		[Deprecated]
		public virtual void* get_document ();
		[Deprecated (replacement = "Document.get_locale", since = "vala-0.22")]
		public virtual unowned string get_document_locale ();
		[Deprecated]
		public virtual unowned string get_document_type ();
		[CCode (vfunc_name = "get_document_locale")]
		[Deprecated]
		public virtual unowned string get_locale ();
		public virtual int get_page_count ();
		[CCode (vfunc_name = "set_document_attribute")]
		public virtual bool set_attribute_value (string attribute_name, string attribute_value);
		public signal void load_complete ();
		public signal void load_stopped ();
		public signal void page_changed (int page_number);
		public signal void reload ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_editable_text_get_type ()")]
	public interface EditableText : GLib.Object {
		public abstract void copy_text (int start_pos, int end_pos);
		public abstract void cut_text (int start_pos, int end_pos);
		public abstract void delete_text (int start_pos, int end_pos);
		public abstract void insert_text (string string, int length, int position);
		public abstract void paste_text (int position);
		public abstract bool set_run_attributes (Atk.AttributeSet attrib_set, int start_offset, int end_offset);
		public abstract void set_text_contents (string string);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_hyperlink_impl_get_type ()")]
	public interface HyperlinkImpl : GLib.Object {
		public abstract Atk.Hyperlink get_hyperlink ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_hypertext_get_type ()")]
	public interface Hypertext : GLib.Object {
		public abstract unowned Atk.Hyperlink get_link (int link_index);
		public abstract int get_link_index (int char_index);
		public abstract int get_n_links ();
		public virtual signal void link_selected (int link_index);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_image_get_type ()")]
	public interface Image : GLib.Object {
		public abstract unowned string get_image_description ();
		public abstract unowned string? get_image_locale ();
		public abstract void get_image_position (int x, int y, Atk.CoordType coord_type);
		public abstract void get_image_size (int width, int height);
		public abstract bool set_image_description (string description);
	}
	[CCode (cheader_filename = "atk/atk.h")]
	public interface Implementor : GLib.Object {
		public abstract unowned Atk.Object ref_accessible ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_selection_get_type ()")]
	public interface Selection : GLib.Object {
		public abstract bool add_selection (int i);
		public abstract bool clear_selection ();
		public abstract int get_selection_count ();
		public abstract bool is_child_selected (int i);
		public abstract Atk.Object? ref_selection (int i);
		public abstract bool remove_selection (int i);
		public abstract bool select_all_selection ();
		public virtual signal void selection_changed ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_streamable_content_get_type ()")]
	public interface StreamableContent : GLib.Object {
		public abstract unowned string get_mime_type (int i);
		public abstract int get_n_mime_types ();
		public abstract GLib.IOChannel get_stream (string mime_type);
		public abstract unowned string? get_uri (string mime_type);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_table_get_type ()")]
	public interface Table : GLib.Object {
		public abstract bool add_column_selection (int column);
		public abstract bool add_row_selection (int row);
		public abstract unowned Atk.Object? get_caption ();
		[Deprecated]
		public abstract int get_column_at_index (int index_);
		public abstract unowned string get_column_description (int column);
		public abstract int get_column_extent_at (int row, int column);
		public abstract unowned Atk.Object? get_column_header (int column);
		[Deprecated]
		public abstract int get_index_at (int row, int column);
		public abstract int get_n_columns ();
		public abstract int get_n_rows ();
		[Deprecated]
		public abstract int get_row_at_index (int index_);
		public abstract unowned string? get_row_description (int row);
		public abstract int get_row_extent_at (int row, int column);
		public abstract unowned Atk.Object? get_row_header (int row);
		public abstract int get_selected_columns (int selected);
		public abstract int get_selected_rows (int selected);
		public abstract Atk.Object get_summary ();
		public abstract bool is_column_selected (int column);
		public abstract bool is_row_selected (int row);
		public abstract bool is_selected (int row, int column);
		public abstract Atk.Object ref_at (int row, int column);
		public abstract bool remove_column_selection (int column);
		public abstract bool remove_row_selection (int row);
		public abstract void set_caption (Atk.Object caption);
		public abstract void set_column_description (int column, string description);
		public abstract void set_column_header (int column, Atk.Object header);
		public abstract void set_row_description (int row, string description);
		public abstract void set_row_header (int row, Atk.Object header);
		public abstract void set_summary (Atk.Object accessible);
		public virtual signal void column_deleted (int column, int num_deleted);
		public virtual signal void column_inserted (int column, int num_inserted);
		public virtual signal void column_reordered ();
		public virtual signal void model_changed ();
		public virtual signal void row_deleted (int row, int num_deleted);
		public virtual signal void row_inserted (int row, int num_inserted);
		public virtual signal void row_reordered ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_table_cell_get_type ()")]
	public interface TableCell : Atk.Object {
		public abstract GLib.GenericArray<Atk.Object> get_column_header_cells ();
		public abstract int get_column_span ();
		public abstract bool get_position (out int row, out int column);
		public abstract bool get_row_column_span (out int row, out int column, out int row_span, out int column_span);
		public abstract GLib.GenericArray<Atk.Object> get_row_header_cells ();
		public abstract int get_row_span ();
		public abstract Atk.Object get_table ();
	}
	[CCode (cheader_filename = "atk/atk.h")]
	public interface Text : GLib.Object {
		public abstract bool add_selection (int start_offset, int end_offset);
		[Deprecated (replacement = "TextAttribute.for_name", since = "vala-0.16")]
		public static Atk.TextAttribute attribute_for_name (string name);
		[Deprecated (replacement = "TextAttribute.get_name", since = "vala-0.16")]
		public static unowned string attribute_get_name (Atk.TextAttribute attr);
		[Deprecated (replacement = "TextAttribute.get_value", since = "vala-0.16")]
		public static unowned string attribute_get_value (Atk.TextAttribute attr, int index_);
		[Deprecated (replacement = "TextAttribute.register", since = "vala-0.16")]
		public static Atk.TextAttribute attribute_register (string name);
		public static void free_ranges ([CCode (array_length = false)] Atk.TextRange[] ranges);
		[CCode (array_length = false, array_null_terminated = true, cname = "atk_text_get_bounded_ranges")]
		public virtual Atk.TextRange[] get_bounded_ranges (Atk.TextRectangle rect, Atk.CoordType coord_type, Atk.TextClipType x_clip_type, Atk.TextClipType y_clip_type);
		public abstract int get_caret_offset ();
		public abstract unichar get_character_at_offset (int offset);
		public abstract int get_character_count ();
		public abstract void get_character_extents (int offset, int x, int y, int width, int height, Atk.CoordType coords);
		public abstract Atk.AttributeSet get_default_attributes ();
		public abstract int get_n_selections ();
		public abstract int get_offset_at_point (int x, int y, Atk.CoordType coords);
		public abstract void get_range_extents (int start_offset, int end_offset, Atk.CoordType coord_type, Atk.TextRectangle rect);
		public abstract Atk.AttributeSet get_run_attributes (int offset, out int start_offset, out int end_offset);
		public abstract string get_selection (int selection_num, out int start_offset, out int end_offset);
		public abstract string? get_string_at_offset (int offset, Atk.TextGranularity granularity, out int start_offset, out int end_offset);
		public abstract string get_text (int start_offset, int end_offset);
		[Deprecated]
		public abstract string get_text_after_offset (int offset, Atk.TextBoundary boundary_type, out int start_offset, out int end_offset);
		[Deprecated]
		public abstract string get_text_at_offset (int offset, Atk.TextBoundary boundary_type, out int start_offset, out int end_offset);
		[Deprecated]
		public abstract string get_text_before_offset (int offset, Atk.TextBoundary boundary_type, out int start_offset, out int end_offset);
		public abstract bool remove_selection (int selection_num);
		public abstract bool set_caret_offset (int offset);
		public abstract bool set_selection (int selection_num, int start_offset, int end_offset);
		public virtual signal void text_attributes_changed ();
		public virtual signal void text_caret_moved (int location);
		[Deprecated]
		public virtual signal void text_changed (int position, int length);
		public signal void text_insert (int arg1, int arg2, string arg3);
		public signal void text_remove (int arg1, int arg2, string arg3);
		public virtual signal void text_selection_changed ();
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_value_get_type ()")]
	public interface Value : GLib.Object {
		[Deprecated]
		public abstract void get_current_value (GLib.Value value);
		public abstract double get_increment ();
		[Deprecated]
		public abstract void get_maximum_value (GLib.Value value);
		[Deprecated]
		public abstract void get_minimum_increment (GLib.Value value);
		[Deprecated]
		public abstract void get_minimum_value (GLib.Value value);
		public abstract Atk.Range? get_range ();
		public abstract GLib.SList<Atk.Range> get_sub_ranges ();
		public abstract void get_value_and_text (out double value, out string text);
		[Deprecated]
		public abstract bool set_current_value (GLib.Value value);
		public abstract void set_value (double new_value);
		public signal void value_changed (double value, string text);
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_window_get_type ()")]
	public interface Window : Atk.Object {
		public signal void activate ();
		public signal void create ();
		public signal void deactivate ();
		public signal void destroy ();
		public signal void maximize ();
		public signal void minimize ();
		public signal void move ();
		public signal void resize ();
		public signal void restore ();
	}
	[CCode (cheader_filename = "atk/atk.h", has_type_id = false)]
	public struct Attribute {
		public string name;
		public string value;
	}
	[CCode (cheader_filename = "atk/atk.h", has_type_id = false)]
	public struct KeyEventStruct {
		public int type;
		public uint state;
		public uint keyval;
		public int length;
		[CCode (cname = "string")]
		public weak string str;
		public uint16 keycode;
		public uint32 timestamp;
	}
	[CCode (cheader_filename = "atk/atk.h", has_type_id = false)]
	public struct PropertyValues {
		public weak string property_name;
		public GLib.Value old_value;
		public GLib.Value new_value;
	}
	[CCode (cheader_filename = "atk/atk.h", type_id = "atk_rectangle_get_type ()")]
	public struct Rectangle {
		public int x;
		public int y;
		public int width;
		public int height;
	}
	[CCode (cheader_filename = "atk/atk.h")]
	[SimpleType]
	public struct State : uint64 {
		[Deprecated (replacement = "StateType.for_name", since = "vala-0.16")]
		public static Atk.StateType type_for_name (string name);
		[Deprecated (replacement = "StateType.get_name", since = "vala-0.16")]
		public static unowned string type_get_name (Atk.StateType type);
		[Deprecated (replacement = "StateType.register", since = "vala-0.16")]
		public static Atk.StateType type_register (string name);
	}
	[CCode (cheader_filename = "atk/atk.h", has_type_id = false)]
	public struct TextRectangle {
		public int x;
		public int y;
		public int width;
		public int height;
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_XY_", type_id = "atk_coord_type_get_type ()")]
	public enum CoordType {
		SCREEN,
		WINDOW
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_HYPERLINK_IS_", type_id = "atk_hyperlink_state_flags_get_type ()")]
	[Flags]
	public enum HyperlinkStateFlags {
		INLINE
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_KEY_EVENT_", type_id = "atk_key_event_type_get_type ()")]
	public enum KeyEventType {
		PRESS,
		RELEASE,
		LAST_DEFINED
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_LAYER_", type_id = "atk_layer_get_type ()")]
	public enum Layer {
		INVALID,
		BACKGROUND,
		CANVAS,
		WIDGET,
		MDI,
		POPUP,
		OVERLAY,
		WINDOW
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_RELATION_", type_id = "atk_relation_type_get_type ()")]
	public enum RelationType {
		NULL,
		CONTROLLED_BY,
		CONTROLLER_FOR,
		LABEL_FOR,
		LABELLED_BY,
		MEMBER_OF,
		NODE_CHILD_OF,
		FLOWS_TO,
		FLOWS_FROM,
		SUBWINDOW_OF,
		EMBEDS,
		EMBEDDED_BY,
		POPUP_FOR,
		PARENT_WINDOW_OF,
		DESCRIBED_BY,
		DESCRIPTION_FOR,
		NODE_PARENT_OF,
		LAST_DEFINED;
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.RelationType for_name (string name);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_name (Atk.RelationType type);
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.RelationType register (string name);
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_ROLE_", type_id = "atk_role_get_type ()")]
	public enum Role {
		[Deprecated (replacement = "Role.ACCELERATOR_LABEL", since = "vala-0.22")]
		ACCEL_LABEL,
		INVALID,
		[CCode (cname = "ATK_ROLE_ACCEL_LABEL")]
		ACCELERATOR_LABEL,
		ALERT,
		ANIMATION,
		ARROW,
		CALENDAR,
		CANVAS,
		CHECK_BOX,
		CHECK_MENU_ITEM,
		COLOR_CHOOSER,
		COLUMN_HEADER,
		COMBO_BOX,
		DATE_EDITOR,
		DESKTOP_ICON,
		DESKTOP_FRAME,
		DIAL,
		DIALOG,
		DIRECTORY_PANE,
		DRAWING_AREA,
		FILE_CHOOSER,
		FILLER,
		FONT_CHOOSER,
		FRAME,
		GLASS_PANE,
		HTML_CONTAINER,
		ICON,
		IMAGE,
		INTERNAL_FRAME,
		LABEL,
		LAYERED_PANE,
		LIST,
		LIST_ITEM,
		MENU,
		MENU_BAR,
		MENU_ITEM,
		OPTION_PANE,
		PAGE_TAB,
		PAGE_TAB_LIST,
		PANEL,
		PASSWORD_TEXT,
		POPUP_MENU,
		PROGRESS_BAR,
		PUSH_BUTTON,
		RADIO_BUTTON,
		RADIO_MENU_ITEM,
		ROOT_PANE,
		ROW_HEADER,
		SCROLL_BAR,
		SCROLL_PANE,
		SEPARATOR,
		SLIDER,
		SPLIT_PANE,
		SPIN_BUTTON,
		STATUSBAR,
		TABLE,
		TABLE_CELL,
		TABLE_COLUMN_HEADER,
		TABLE_ROW_HEADER,
		TEAR_OFF_MENU_ITEM,
		TERMINAL,
		TEXT,
		TOGGLE_BUTTON,
		TOOL_BAR,
		TOOL_TIP,
		TREE,
		TREE_TABLE,
		UNKNOWN,
		VIEWPORT,
		WINDOW,
		HEADER,
		FOOTER,
		PARAGRAPH,
		RULER,
		APPLICATION,
		AUTOCOMPLETE,
		EDITBAR,
		EMBEDDED,
		ENTRY,
		CHART,
		CAPTION,
		DOCUMENT_FRAME,
		HEADING,
		PAGE,
		SECTION,
		REDUNDANT_OBJECT,
		FORM,
		LINK,
		INPUT_METHOD_WINDOW,
		TABLE_ROW,
		TREE_ITEM,
		DOCUMENT_SPREADSHEET,
		DOCUMENT_PRESENTATION,
		DOCUMENT_TEXT,
		DOCUMENT_WEB,
		DOCUMENT_EMAIL,
		COMMENT,
		LIST_BOX,
		GROUPING,
		IMAGE_MAP,
		NOTIFICATION,
		INFO_BAR,
		LEVEL_BAR,
		TITLE_BAR,
		BLOCK_QUOTE,
		AUDIO,
		VIDEO,
		DEFINITION,
		ARTICLE,
		LANDMARK,
		LOG,
		MARQUEE,
		MATH,
		RATING,
		TIMER,
		DESCRIPTION_LIST,
		DESCRIPTION_TERM,
		DESCRIPTION_VALUE,
		LAST_DEFINED;
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.Role for_name (string name);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_localized_name (Atk.Role role);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_name (Atk.Role role);
		[CCode (cheader_filename = "atk/atk.h")]
		[Deprecated]
		public static Atk.Role register (string name);
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_STATE_", type_id = "atk_state_type_get_type ()")]
	public enum StateType {
		INVALID,
		ACTIVE,
		ARMED,
		BUSY,
		CHECKED,
		DEFUNCT,
		EDITABLE,
		ENABLED,
		EXPANDABLE,
		EXPANDED,
		FOCUSABLE,
		FOCUSED,
		HORIZONTAL,
		ICONIFIED,
		MODAL,
		MULTI_LINE,
		MULTISELECTABLE,
		OPAQUE,
		PRESSED,
		RESIZABLE,
		SELECTABLE,
		SELECTED,
		SENSITIVE,
		SHOWING,
		SINGLE_LINE,
		STALE,
		TRANSIENT,
		VERTICAL,
		VISIBLE,
		MANAGES_DESCENDANTS,
		INDETERMINATE,
		TRUNCATED,
		REQUIRED,
		INVALID_ENTRY,
		SUPPORTS_AUTOCOMPLETION,
		SELECTABLE_TEXT,
		DEFAULT,
		ANIMATED,
		VISITED,
		CHECKABLE,
		HAS_POPUP,
		HAS_TOOLTIP,
		LAST_DEFINED;
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.StateType for_name (string name);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_name (Atk.StateType type);
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.StateType register (string name);
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_TEXT_ATTR_", type_id = "atk_text_attribute_get_type ()")]
	public enum TextAttribute {
		INVALID,
		LEFT_MARGIN,
		RIGHT_MARGIN,
		INDENT,
		INVISIBLE,
		EDITABLE,
		PIXELS_ABOVE_LINES,
		PIXELS_BELOW_LINES,
		PIXELS_INSIDE_WRAP,
		BG_FULL_HEIGHT,
		RISE,
		UNDERLINE,
		STRIKETHROUGH,
		SIZE,
		SCALE,
		WEIGHT,
		LANGUAGE,
		FAMILY_NAME,
		BG_COLOR,
		FG_COLOR,
		BG_STIPPLE,
		FG_STIPPLE,
		WRAP_MODE,
		DIRECTION,
		JUSTIFICATION,
		STRETCH,
		VARIANT,
		STYLE,
		LAST_DEFINED;
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.TextAttribute for_name (string name);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_name (Atk.TextAttribute attr);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string? get_value (Atk.TextAttribute attr, int index_);
		[CCode (cheader_filename = "atk/atk.h")]
		public static Atk.TextAttribute register (string name);
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_TEXT_BOUNDARY_", type_id = "atk_text_boundary_get_type ()")]
	public enum TextBoundary {
		CHAR,
		WORD_START,
		WORD_END,
		SENTENCE_START,
		SENTENCE_END,
		LINE_START,
		LINE_END
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_TEXT_CLIP_", type_id = "atk_text_clip_type_get_type ()")]
	public enum TextClipType {
		NONE,
		MIN,
		MAX,
		BOTH
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_TEXT_GRANULARITY_", type_id = "atk_text_granularity_get_type ()")]
	public enum TextGranularity {
		CHAR,
		WORD,
		SENTENCE,
		LINE,
		PARAGRAPH
	}
	[CCode (cheader_filename = "atk/atk.h", cprefix = "ATK_VALUE_", type_id = "atk_value_type_get_type ()")]
	public enum ValueType {
		VERY_WEAK,
		WEAK,
		ACCEPTABLE,
		STRONG,
		VERY_STRONG,
		VERY_LOW,
		LOW,
		MEDIUM,
		HIGH,
		VERY_HIGH,
		VERY_BAD,
		BAD,
		GOOD,
		VERY_GOOD,
		BEST,
		LAST_DEFINED;
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_localized_name (Atk.ValueType value_type);
		[CCode (cheader_filename = "atk/atk.h")]
		public static unowned string get_name (Atk.ValueType value_type);
	}
	[CCode (cheader_filename = "atk/atk.h", has_target = false)]
	public delegate void EventListener (Atk.Object obj);
	[CCode (cheader_filename = "atk/atk.h", has_target = false)]
	public delegate void EventListenerInit ();
	[CCode (cheader_filename = "atk/atk.h", has_target = false)]
	[Deprecated]
	public delegate void FocusHandler (Atk.Object object, bool focus_in);
	[CCode (cheader_filename = "atk/atk.h", instance_pos = 0.9)]
	public delegate bool Function ();
	[CCode (cheader_filename = "atk/atk.h", instance_pos = 1.9)]
	public delegate int KeySnoopFunc (Atk.KeyEventStruct event);
	[CCode (cheader_filename = "atk/atk.h", has_target = false)]
	[Deprecated]
	public delegate void PropertyChangeHandler (Atk.Object obj, Atk.PropertyValues vals);
	[CCode (cheader_filename = "atk/atk.h", cname = "GSignalEmissionHook", has_target = false)]
	public delegate bool SignalEmissionHook (GLib.SignalInvocationHint ihint, [CCode (array_length_pos = 1.9)] Atk.Value[] param_values, void* data);
	[CCode (cheader_filename = "atk/atk.h", cname = "ATK_BINARY_AGE")]
	public const int BINARY_AGE;
	[CCode (cheader_filename = "atk/atk.h", cname = "ATK_INTERFACE_AGE")]
	public const int INTERFACE_AGE;
	[CCode (cheader_filename = "atk/atk.h", cname = "ATK_MAJOR_VERSION")]
	public const int MAJOR_VERSION;
	[CCode (cheader_filename = "atk/atk.h", cname = "ATK_MICRO_VERSION")]
	public const int MICRO_VERSION;
	[CCode (cheader_filename = "atk/atk.h", cname = "ATK_MINOR_VERSION")]
	public const int MINOR_VERSION;
	[CCode (cheader_filename = "atk/atk.h", cname = "ATK_VERSION_MIN_REQUIRED")]
	public const int VERSION_MIN_REQUIRED;
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.add_focus_tracker", since = "vala-0.16")]
	public static uint add_focus_tracker (Atk.EventListener focus_tracker);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.add_global_event_listener", since = "vala-0.16")]
	public static uint add_global_event_listener (GLib.SignalEmissionHook listener, string event_type);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.focus_tracker_init", since = "vala-0.16")]
	public static void focus_tracker_init (Atk.EventListenerInit init);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.focus_tracker_notify", since = "vala-0.16")]
	public static void focus_tracker_notify (Atk.Object object);
	[CCode (cheader_filename = "atk/atk.h")]
	public static uint get_binary_age ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Registry.get_default.", since = "vala-0.16")]
	public static unowned Atk.Registry get_default_registry ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.get_focus_object", since = "vala-0.16")]
	public static unowned Atk.Object get_focus_object ();
	[CCode (cheader_filename = "atk/atk.h")]
	public static uint get_interface_age ();
	[CCode (cheader_filename = "atk/atk.h")]
	public static uint get_major_version ();
	[CCode (cheader_filename = "atk/atk.h")]
	public static uint get_micro_version ();
	[CCode (cheader_filename = "atk/atk.h")]
	public static uint get_minor_version ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.get_root", since = "vala-0.16")]
	public static unowned Atk.Object get_root ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.get_toolkit_name", since = "vala-0.16")]
	public static unowned string get_toolkit_name ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.get_toolkit_version", since = "vala-0.16")]
	public static unowned string get_toolkit_version ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.get_version", since = "vala-0.16")]
	public static unowned string get_version ();
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.remove_focus_tracker", since = "vala-0.16")]
	public static void remove_focus_tracker (uint tracker_id);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.remove_global_event_listener", since = "vala-0.16")]
	public static void remove_global_event_listener (uint listener_id);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Util.remove_key_event_listener", since = "vala-0.16")]
	public static void remove_key_event_listener (uint listener_id);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Role.for_name", since = "vala-0.16")]
	public static Atk.Role role_for_name (string name);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Role.get_localized_name", since = "vala-0.16")]
	public static unowned string role_get_localized_name (Atk.Role role);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Role.get_name", since = "vala-0.16")]
	public static unowned string role_get_name (Atk.Role role);
	[CCode (cheader_filename = "atk/atk.h")]
	[Deprecated (replacement = "Atk.Role.register", since = "vala-0.16")]
	public static Atk.Role role_register (string name);
}

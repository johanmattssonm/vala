/* libpeas-1.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Peas", gir_namespace = "Peas", gir_version = "1.0", lower_case_cprefix = "peas_")]
namespace Peas {
	[CCode (cheader_filename = "libpeas/peas.h", type_id = "peas_engine_get_type ()")]
	public class Engine : GLib.Object {
		[CCode (has_construct_function = false)]
		public Engine ();
		public void add_search_path (string module_dir, string? data_dir);
		public Peas.Extension create_extension (Peas.PluginInfo info, GLib.Type extension_type, ...);
		public Peas.Extension create_extensionv (Peas.PluginInfo info, GLib.Type extension_type, [CCode (array_length_cname = "n_parameters", array_length_pos = 2.5, array_length_type = "guint")] GLib.Parameter[]? parameters);
		public void enable_loader (string loader_name);
		public void garbage_collect ();
		public static unowned Peas.Engine get_default ();
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] get_loaded_plugins ();
		public unowned Peas.PluginInfo get_plugin_info (string plugin_name);
		public unowned GLib.List<Peas.PluginInfo> get_plugin_list ();
		public void prepend_search_path (string module_dir, string? data_dir);
		public bool provides_extension (Peas.PluginInfo info, GLib.Type extension_type);
		public void rescan_plugins ();
		public void set_loaded_plugins ([CCode (array_length = false, array_null_terminated = true)] string[]? plugin_names);
		[CCode (cname = "peas_engine_load_plugin")]
		public bool try_load_plugin (Peas.PluginInfo info);
		[CCode (cname = "peas_engine_unload_plugin")]
		public bool try_unload_plugin (Peas.PluginInfo info);
		[CCode (has_construct_function = false)]
		public Engine.with_nonglobal_loaders ();
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] loaded_plugins { owned get; set; }
		[NoAccessorMethod]
		public bool nonglobal_loaders { get; construct; }
		public void* plugin_list { get; }
		public virtual signal void load_plugin (Peas.PluginInfo info);
		public virtual signal void unload_plugin (Peas.PluginInfo info);
	}
	[CCode (cheader_filename = "libpeas/peas.h")]
	public class Extension : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Extension ();
	}
	[CCode (cheader_filename = "libpeas/peas.h", type_id = "peas_extension_base_get_type ()")]
	public abstract class ExtensionBase : GLib.Object {
		[CCode (has_construct_function = false)]
		protected ExtensionBase ();
		public string get_data_dir ();
		public unowned Peas.PluginInfo get_plugin_info ();
		public string data_dir { owned get; }
		public Peas.PluginInfo plugin_info { get; construct; }
	}
	[CCode (cheader_filename = "libpeas/peas.h", type_id = "peas_extension_set_get_type ()")]
	public class ExtensionSet : GLib.Object {
		[CCode (has_construct_function = false)]
		public ExtensionSet (Peas.Engine? engine, GLib.Type exten_type, ...);
		[NoWrapper]
		public virtual bool call (string method_name, GI.Argument args);
		public void @foreach (Peas.ExtensionSetForeachFunc func);
		public unowned Peas.Extension get_extension (Peas.PluginInfo info);
		[CCode (cname = "peas_extension_set_newv", has_construct_function = false)]
		public ExtensionSet.newv (Peas.Engine? engine, GLib.Type exten_type, [CCode (array_length_cname = "n_parameters", array_length_pos = 2.5, array_length_type = "guint")] GLib.Parameter[] parameters);
		public void* construct_properties { construct; }
		[NoAccessorMethod]
		public Peas.Engine engine { owned get; construct; }
		[NoAccessorMethod]
		public GLib.Type extension_type { get; construct; }
		public virtual signal void extension_added (Peas.PluginInfo info, GLib.Object exten);
		public virtual signal void extension_removed (Peas.PluginInfo info, GLib.Object exten);
	}
	[CCode (cheader_filename = "libpeas/peas.h", type_id = "peas_object_module_get_type ()")]
	public class ObjectModule : GLib.TypeModule, GLib.TypePlugin {
		[CCode (has_construct_function = false)]
		protected ObjectModule ();
		public void register_extension_factory (GLib.Type iface_type, owned Peas.FactoryFunc factory_func);
		public void register_extension_type (GLib.Type iface_type, GLib.Type extension_type);
		[NoAccessorMethod]
		public bool local_linkage { get; construct; }
		[NoAccessorMethod]
		public string module_name { owned get; construct; }
		[NoAccessorMethod]
		public string path { owned get; construct; }
		[NoAccessorMethod]
		public bool resident { get; construct; }
	}
	[CCode (cheader_filename = "libpeas/peas.h", copy_function = "g_boxed_copy", free_function = "g_boxed_free", type_id = "peas_plugin_info_get_type ()")]
	[Compact]
	public class PluginInfo {
		[CCode (array_length = false, array_null_terminated = true)]
		public unowned string[] get_authors ();
		public unowned string get_copyright ();
		public unowned string get_data_dir ();
		[CCode (array_length = false, array_null_terminated = true)]
		public unowned string[] get_dependencies ();
		public unowned string get_description ();
		public unowned string get_external_data (string key);
		public unowned string get_help_uri ();
		public unowned string get_icon_name ();
		public unowned string get_module_dir ();
		public unowned string get_module_name ();
		public unowned string get_name ();
		public GLib.Settings get_settings (string? schema_id);
		public unowned string get_version ();
		public unowned string get_website ();
		public bool has_dependency (string module_name);
		public bool is_available () throws GLib.Error;
		public bool is_builtin ();
		public bool is_hidden ();
		public bool is_loaded ();
	}
	[CCode (cheader_filename = "libpeas/peas.h", type_cname = "PeasActivatableInterface", type_id = "peas_activatable_get_type ()")]
	public interface Activatable : GLib.Object {
		public abstract void activate ();
		public abstract void deactivate ();
		public abstract void update_state ();
		[NoAccessorMethod]
		public abstract GLib.Object object { owned get; construct; }
	}
	[CCode (cheader_filename = "libpeas/peas.h", cprefix = "PEAS_PLUGIN_INFO_ERROR_")]
	public errordomain PluginInfoError {
		LOADING_FAILED,
		LOADER_NOT_FOUND,
		DEP_NOT_FOUND,
		DEP_LOADING_FAILED;
		public static GLib.Quark quark ();
	}
	[CCode (cheader_filename = "libpeas/peas.h", instance_pos = 3.9)]
	public delegate void ExtensionSetForeachFunc (Peas.ExtensionSet @set, Peas.PluginInfo info, Peas.Extension exten);
	[CCode (cheader_filename = "libpeas/peas.h", instance_pos = 1.9)]
	public delegate GLib.Object FactoryFunc ([CCode (array_length_cname = "n_parameters", array_length_pos = 0.5, array_length_type = "guint")] GLib.Parameter[] parameters);
}

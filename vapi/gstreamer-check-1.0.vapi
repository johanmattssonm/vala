/* gstreamer-check-1.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Gst", gir_namespace = "GstCheck", gir_version = "1.0", lower_case_cprefix = "gst_")]
namespace Gst {
	namespace Check {
		[CCode (cheader_filename = "gst/check/gstbufferstraw.h,gst/check/gstcheck.h,gst/check/gstconsistencychecker.h,gst/check/internal-check.h", cname = "GstStreamConsistency", lower_case_cprefix = "gst_consistency_checker_")]
		[Compact]
		[GIR (name = "StreamConsistency")]
		public class StreamConsistency {
			public StreamConsistency (Gst.Pad pad);
			public bool add_pad (Gst.Pad pad);
			public void free ();
			public void reset ();
		}
		[CCode (cheader_filename = "gst/check/check.h", cname = "GstTestClock", lower_case_cprefix = "gst_test_clock_", type_id = "gst_test_clock_get_type ()")]
		[GIR (name = "TestClock")]
		public class TestClock : Gst.Clock {
			[CCode (has_construct_function = false, type = "GstClock*")]
			public TestClock ();
			public void advance_time (Gst.ClockTimeDiff delta);
			public Gst.ClockTime get_next_entry_time ();
			public bool has_id (Gst.ClockID id);
			public static Gst.ClockTime id_list_get_latest_time (GLib.List<Gst.ClockID?>? pending_list);
			public uint peek_id_count ();
			public bool peek_next_pending_id (out Gst.ClockID pending_id);
			public uint process_id_list (GLib.List<Gst.ClockID?>? pending_list);
			public Gst.ClockID process_next_clock_id ();
			public void set_time (Gst.ClockTime new_time);
			public void wait_for_multiple_pending_ids (uint count, out GLib.List<Gst.ClockID?> pending_list);
			public void wait_for_next_pending_id (out Gst.ClockID pending_id);
			[Deprecated]
			public void wait_for_pending_id_count (uint count);
			[CCode (has_construct_function = false, type = "GstClock*")]
			public TestClock.with_start_time (Gst.ClockTime start_time);
			[NoAccessorMethod]
			public uint64 start_time { get; construct; }
		}
		[CCode (cheader_filename = "gst/check/check.h", has_type_id = false)]
		[GIR (name = "CheckABIStruct")]
		public struct ABIStruct {
			public weak string name;
			public int size;
			public int abi_size;
		}
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void abi_list (Gst.Check.ABIStruct list, bool have_abi_sizes);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void buffer_data (Gst.Buffer buffer, void* data, size_t size);
		[CCode (cheader_filename = "gst/check/check.h", cname = "gst_buffer_straw_get_buffer")]
		public static Gst.Buffer buffer_straw_get_buffer (Gst.Element bin, Gst.Pad pad);
		[CCode (cheader_filename = "gst/check/check.h", cname = "gst_buffer_straw_start_pipeline")]
		public static void buffer_straw_start_pipeline (Gst.Element bin, Gst.Pad pad);
		[CCode (cheader_filename = "gst/check/check.h", cname = "gst_buffer_straw_stop_pipeline")]
		public static void buffer_straw_stop_pipeline (Gst.Element bin, Gst.Pad pad);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void caps_equal (Gst.Caps caps1, Gst.Caps caps2);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.FlowReturn chain_func (Gst.Pad pad, Gst.Object parent, Gst.Buffer buffer);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void drop_buffers ();
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void element_push_buffer (string element_name, Gst.Buffer buffer_in, Gst.Caps caps_in, Gst.Buffer buffer_out, Gst.Caps caps_out);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void element_push_buffer_list (string element_name, owned GLib.List<Gst.Buffer> buffer_in, Gst.Caps caps_in, owned GLib.List<Gst.Buffer> buffer_out, Gst.Caps caps_out, Gst.FlowReturn last_flow_return);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void init (int argc, string argv);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void message_error (Gst.Message message, Gst.MessageType type, GLib.Quark domain, int code);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Element setup_element (string factory);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void setup_events (Gst.Pad srcpad, Gst.Element element, Gst.Caps? caps, Gst.Format format);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void setup_events_with_stream_id (Gst.Pad srcpad, Gst.Element element, Gst.Caps? caps, Gst.Format format, string stream_id);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_sink_pad (Gst.Element element, Gst.StaticPadTemplate tmpl);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_sink_pad_by_name (Gst.Element element, Gst.StaticPadTemplate tmpl, string name);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_sink_pad_by_name_from_template (Gst.Element element, Gst.PadTemplate tmpl, string name);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_sink_pad_from_template (Gst.Element element, Gst.PadTemplate tmpl);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_src_pad (Gst.Element element, Gst.StaticPadTemplate tmpl);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_src_pad_by_name (Gst.Element element, Gst.StaticPadTemplate tmpl, string name);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_src_pad_by_name_from_template (Gst.Element element, Gst.PadTemplate tmpl, string name);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static Gst.Pad setup_src_pad_from_template (Gst.Element element, Gst.PadTemplate tmpl);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void teardown_element (Gst.Element element);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void teardown_pad_by_name (Gst.Element element, string name);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void teardown_sink_pad (Gst.Element element);
		[CCode (cheader_filename = "gst/check/check.h")]
		public static void teardown_src_pad (Gst.Element element);
	}
}

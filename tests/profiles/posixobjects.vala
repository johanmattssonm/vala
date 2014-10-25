using Posix;

[Compact]
class CompactClass {
	public string field = "Hello World\n";
	public void hello () {
		print (field);
	}	
}

[Compact]
[CCode (ref_function = "compact_ref_counting_ref", unref_function = "compact_ref_counting_unref")]
class CompactRefCounting {
	public string field = "Hello World\n";
	public int ref_count = 1;

	public void hello () {
		print (field);
	}	
	
	public unowned CompactRefCounting @ref () {
		ref_count++;
		return this;
	}
	
	public void unref () {
		if (--ref_count == 0) {
			this.finalize ();
		}
	}		

	private extern void finalize ();
}

[Compact]
class CompactConstrucorDestructor {
	public string field;
	
	public CompactConstrucorDestructor () {
		field = "Hello World\n";
	}

	~CompactConstrucorDestructor () {
		field = "done.\n";
		hello ();
	}

	public void hello () {
		print (field);
	}
}

void run () {
	CompactClass o = new CompactClass ();
	o.hello ();

	CompactRefCounting r = new CompactRefCounting ();
	r.hello ();

	CompactConstrucorDestructor d = new CompactConstrucorDestructor ();
	d.hello ();
}

void main () {
	run ();
}

namespace Wilber.Util.Tests {

	public void test_optional_bool () {
		var t = new OptionalBool (true);
		assert_true (t.has_value);
		assert_true (t.value);
		assert_true (t.value_or_default(false));
		assert ("true" == t.to_string ());

		var f = new OptionalBool (false);
		assert_true (f.has_value);
		assert_false (f.value);
		assert_false (f.value_or_default (true));
		assert ("false" == f.to_string ());

		var n = new OptionalBool (null);
		assert_false (n.has_value);
		assert_true (n.value_or_default (true));
		assert_false (n.value_or_default (false));
		assert ("<null>" == n.to_string ());
	}

	public void test_optional_int32 () {
		var n = new OptionalInt32 (null);
		assert_false (n.has_value);
		assert (n.value_or_default (42) == 42);
		assert (n.value_or_default (-1) == -1);
		assert ("<null>" == n.to_string ());
	}

	public void test_optional_int64 () {
		var i1 = new OptionalInt64 (42);
		assert_true (i1.has_value);
		assert (42 == i1.value);
		assert (42 == i1.value_or_default (42));
		assert ("42" == i1.to_string ());

		var n = new OptionalInt64 (null);
		assert_false (n.has_value);
		assert (42 == n.value_or_default (42));
		assert (-1 == n.value_or_default (-1));
		assert ("<null>" == n.to_string ());
	}

	public void test_optional_string () {
		var s1 = new OptionalString ("Hello, World!");
		assert_true (s1.has_value);
		assert ("Hello, World!" == s1.value);
		assert ("Hello, World!" == s1.value_or_default ("Goodbye, World!"));
		assert ("Hello, World!" == s1.to_string ());

		var n = new OptionalString (null);
		assert_false (n.has_value);
		assert ("I am feeling lucky." == n.value_or_default ("I am feeling lucky."));
		assert ("<null>" == n.to_string ());
	}

	public int main (string[] args) {
		GLib.Test.init (ref args);

		GLib.Test.add_func ("/Wilber/Util Optional bool", test_optional_bool);
		GLib.Test.add_func ("/Wilber/Util Optional int32", test_optional_int32);
		return GLib.Test.run ();
	}

}

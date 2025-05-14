namespace Wilber.Util {
	public abstract class JsonSerializable : GLib.Object {

		public abstract Json.Node to_json_node () throws GLib.Error;

        public string to_json_data () throws GLib.Error {
			var generator = new Json.Generator ();
			generator.set_root (this.to_json_node ());
			return generator.to_data (null);
		}

	}
}

namespace Wilber.Util.Tests {

	class Movie : Wilber.Util.JsonSerializable {
		public string title { get; set construct; }
		public int year { get; set construct; }
		public GLib.Array<string> actors { get; set; }

		public Movie () {
			GLib.Object ();
		}

		public Movie.with_title_and_year (string title, int year) {
			GLib.Object (title: title, year: year);
		}

		public Movie.from_json_data (string json) throws GLib.Error{

			this ();

			var parser = new Json.Parser ();
			parser.load_from_data (json, json.length);
			var j_movie = parser.get_root ().get_object ();

			j_movie.foreach_member ((object, member_name, member_node) => {
				switch (member_name) {
					case "title":
						this.title = member_node.get_string ();
						break;
					case "year":
						this.year = (int) member_node.get_int ();
						break;
					case "actors":
						this.actors = new GLib.Array<string>();
						var j_actors = member_node.get_array ();
						j_actors.foreach_element ((araay, index, element_node) => {
							this.actors.append_val (element_node.get_string ());
						});
						break;
				}
			});

		}

		public override Json.Node to_json_node() {
			var builder = new Json.Builder ();
			var b_root = builder.begin_object ();
			  b_root.set_member_name ("title");
			  b_root.add_string_value (this.title);
			  b_root.set_member_name ("year");
			  b_root.add_int_value (this.year);
			  if (this.actors != null) {
				b_root.set_member_name ("actors");
				var b_actors = builder.begin_array ();
			    foreach (string actor in this.actors) {
			      b_actors.add_string_value (actor);
			    }
			    b_root.end_array ();
			  }
			b_root.end_object ();

			return (!) builder.get_root ();
		}
	}

	public void test_json_serialization () {
		var movie = new Movie.with_title_and_year ("Star Wars Eposode IV: A New Hope", 1977);

		string[] actors = {"Mark Hamill", "Harrison Ford", "Carrie Fisher"};
		movie.actors = new GLib.Array<string>();
		for (int i = 0; i < actors.length; i++) {
			movie.actors.append_val (actors[i]);
		}
		try {
			string movie_as_json = movie.to_json_data ();
			GLib.assert_true (movie_as_json != null);
			GLib.assert_true (movie_as_json.length >0);
			Movie movie2 = new Movie.from_json_data (movie_as_json);
			GLib.assert_true (movie.title == movie2.title);
			GLib.assert_true (movie.year == movie2.year);
			//GLib.assert_nonnull (movie2.actors);
			//GLib.assert_true (movie.actors.length == movie2.actors.length);
			/*for (int i = 0; i < movie.actors.length; i++) {
				assert_true (movie.actors.data[i] == movie2.actors.data[i]);
			}*/
		} catch (Error err) {
			GLib.assert_no_error (err);
		}

	}

	public int main (string[] args) {
		GLib.Test.init (ref args);

		GLib.Test.add_func ("/Wilber/Util JSON (De-)serialization ", test_json_serialization);
		return GLib.Test.run ();
	}
}

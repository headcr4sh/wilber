/* api_types.vala
 *
 * Copyright 2025 Benjamin P. Jung
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Wilber.Util;

namespace Ollama {

	public errordomain Error {
		SERIALIZATION_ERROR,
		DESERIALIZATION_ERROR,

		INVALID_SETTING,

		UNKNOWN_ERROR
	}

	public enum Format {
		DEFAULT,
		JSON;

		public static Format from_string (string? str) {
			if (str == null || str == "default") {
				return Format.DEFAULT;
			} else if (str == "json") {
				return Format.JSON;
			} else {
				assert_not_reached ();
			}
		}

		public string? to_string () {
			switch (this) {
				case Format.DEFAULT:
					return null;
				case Format.JSON:
					return "json";
				default:
					assert_not_reached ();
			}
		}

	}

	public enum Role {
		SYSTEM,
		USER,
		ASSISTANT,
		TOOL;

		public static Role from_string (string str) {
			if (str == "system") {
				return Role.SYSTEM;
			} else if (str == "user") {
				return Role.USER;
			} else if (str == "assistant") {
				return Role.ASSISTANT;
			} else if (str == "tool") {
				return Role.TOOL;
			} else {
				assert_not_reached ();
			}
		}

		public string to_string () {
			switch (this) {
				case Role.SYSTEM:
					return "system";
				case Role.USER:
					return "user";
				case Role.ASSISTANT:
					return "assistant";
				case Role.TOOL:
					return "tool";
				default:
					assert_not_reached ();
			}
		}

		public Json.Node to_json_node () throws GLib.Error {
			return Json.from_string (this.to_string ());
		}

	}

    public class Message : Wilber.Util.JsonSerializable {

        [Description (nick = "Role", blurb = "Originator of the message")]
        public Role role { get; construct set; }

        public string content { get; construct set; }
        // TODO images[] field is missing as of now.

		public OptionalString tool_name { get; construct set; }

        private Message (Role role, string content) {
            GLib.Object (
            		role: role,
            		content: content,
            		tool_name: new OptionalString(null)
            	);
        }

        public Message.with_system_role (string content) {
            this(Role.SYSTEM, content);
        }

        public Message.with_user_role (string content) {
            this(Role.USER, content);
        }

        public Message.with_assistant_role (string content) {
            this(Role.ASSISTANT, content);
        }

        public Message.with_tool_role (string tool_name, string content) {
            this(Role.ASSISTANT, content);
 			this.tool_name.set_value(tool_name);
        }

       	public Message.from_json_data (string json) throws GLib.Error {
			var parser = new Json.Parser ();
			parser.load_from_data (json, json.length);
			this.from_json_object(parser.get_root ()?.get_object ());
		}

		public Message.from_json_object (Json.Object j_object) throws GLib.Error {
			j_object.foreach_member ((object, member_name, member_node) => {
				switch (member_name) {
					case "role":
						this.role = Role.from_string ((!) member_node.get_string());
						break;
					case "content":
						this.content = (!) member_node.get_string ();
						break;
					case "tool_name":
						this.tool_name = new OptionalString(member_node.get_string ());
						break;
				}
			});
		}

		public override Json.Node to_json_node () throws GLib.Error {
			var node = new Json.Node (Json.NodeType.OBJECT);
			var obj = new Json.Object ();
			obj.set_string_member("role", this.role.to_string ());
			obj.set_string_member("content", this.content);
			this.tool_name.if_has_value (tool_name => obj.set_string_member ("tool_name", tool_name));
			node.set_object (obj);
			return node;
		}

    }

	public static Json.Node message_array_to_json_node (Array<Message> messages) throws GLib.Error {
		var node = new Json.Node (Json.NodeType.ARRAY);
		var arr = new Json.Array ();
		foreach (var message in messages.data) {
			arr.add_object_element (message.to_json_node ().get_object ());
		}
		node.set_array(arr);
		return node;
 	}


    public class Options : Wilber.Util.JsonSerializable {

   		public OptionalInt64 seed { get; construct set; }
     	public OptionalDouble temperature { get; construct set; }

        public Options (int64? seed, double? temperature)
        {
        		assert_true (seed == null || seed >= 0);
           	assert_true (temperature == null || (temperature >= 0 && temperature <= 1));
            GLib.Object(
		        	seed: new OptionalInt64 (seed),
		        	temperature: new OptionalDouble (temperature)
            );
        }

        public Options.with_defaults () {
            this(null, null);
        }

       	public Options.from_json_data (string json) throws GLib.Error {

			var parser = new Json.Parser ();
			parser.load_from_data (json, json.length);
			var j_options = parser.get_root ()?.get_object ();

			j_options?.foreach_member ((object, member_name, member_node) => {
				switch (member_name) {
					case "seed":
						this.seed = new OptionalInt64 (member_node.get_int ());
						break;
					case "temperature":
						this.temperature = new OptionalDouble ( member_node.get_double ());
						break;
				}
			});
		}

		public override Json.Node to_json_node () throws GLib.Error {
			var node = new Json.Node (Json.NodeType.OBJECT);
			var obj = new Json.Object ();
			this.seed.if_has_value (seed => obj.set_int_member ("seed", seed));
			this.temperature.if_has_value (temperature => obj.set_double_member ("temperature", temperature));
			node.set_object (obj);
			return node;
		}

    }

    public class ChatCompletionRequest : Wilber.Util.JsonSerializable {

        public Array<Message> messages { get; set construct; }

        public string model { get; set construct; }

        public bool stream { get; set construct; }
        public string keep_alive { get; set construct; default = "5m"; }

        public Format format { get; set construct; default = Format.DEFAULT; }
        public Options options { get; construct; default = new Options.with_defaults(); }

        public ChatCompletionRequest (string model, Format format, Options? options)
        {
            GLib.Object (
                         model: model,
                         format: format,
                         options: options
            );
        }

        public ChatCompletionRequest.with_default_format (string model)
        {
            this(model, Format.DEFAULT, null);
        }

        public ChatCompletionRequest.with_json_format (string model) {
            this(model, Format.JSON, null);
        }

        construct {
			this.messages = new Array<Message> ();
        }

		public void add_message ( Message message ) {
			this.messages.append_val (message);
		}

		public override Json.Node to_json_node () throws GLib.Error {
			var node = new Json.Node (Json.NodeType.OBJECT);
			var obj = new Json.Object ();
			obj.set_string_member("model", this.model);
			obj.set_boolean_member("stream", this.stream);
			obj.set_string_member("keep_alive", this.keep_alive);
			if (this.format != Format.DEFAULT) {
				obj.set_string_member("format", this.format.to_string ());
			}
			obj.set_member ("options", this.options.to_json_node ());
			obj.set_array_member ("messages", message_array_to_json_node (this.messages).get_array ());
			node.set_object (obj);
			return node;
		}
    }

    public class ChatCompletionResponse : Wilber.Util.JsonSerializable {

        public string model { get; set; }
        public string created_at { get; set; }
        public Message message { get; set; }
        public string done_reason { get; set; }
        public bool done { get; set; }
        public uint64 total_duration { get; set; }
        public uint64 load_duration { get; set; }
        public uint64 prompt_eval_duration { get; set; }
        public uint64 eval_count { get; set; }
        public uint64 eval_duration { get; set; }

        public ChatCompletionResponse.from_json_data (string json) throws Ollama.Error {
			var parser = new Json.Parser ();
			try {
				parser.load_from_data (json, json.length);
			} catch (GLib.Error e) {
				throw new Ollama.Error.DESERIALIZATION_ERROR (@"Protocol error / deserialization: $(e.message)");
			}
			var j_options = parser.get_root ()?.get_object ();

			Ollama.Error err = null;
			j_options?.foreach_member ((object, member_name, member_node) => {
				if (err != null) {
					return;
				}
				switch (member_name) {
					case "model":
						this.model = member_node.get_string ();
						break;
					case "created_at":
						this.created_at = member_node.get_string ();
						break;
					case "message":
						try {
							this.message = new Message.from_json_object (member_node.get_object ());
						} catch (GLib.Error e) {

							err =  new Ollama.Error.DESERIALIZATION_ERROR (@"Protocol Error / deserialization: $(e.message)");
						}
						break;
					case "done_reason":
						this.done_reason = member_node.get_string ();
						break;
					case "done":
						this.done = member_node.get_boolean ();
						break;
				}
			});

			if (err != null) {
				throw err;
			}
		}

  		public override Json.Node to_json_node () {
			var node = new Json.Node (Json.NodeType.OBJECT);
			var obj = new Json.Object ();
			// TODO add properties
			node.set_object (obj);
			return node;
		}
    }
}

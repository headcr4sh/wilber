namespace Ollama {

    public const string FORMAT_DEFAULT = null;
    public const string FORMAT_JSON = "json";

    public const string ROLE_SYSTEM = "system";
    public const string ROLE_USER = "user";
    public const string ROLE_ASSISTANT = "assistant";

    public class Message : Json.Api.Object {

        [Description (nick = "Role", blurb = "Originator of the message")]
        public string role { get; construct; }

        public string content { get; construct; }
        // TODO images[] field is missing as of now.

        private Message (string role, string content) {
            GLib.Object (role: role, content: content);
        }

        public Message.withSystemRole (string content) {
            this(Ollama.ROLE_SYSTEM, content);
        }

        public Message.withUserRole (string content) {
            this(Ollama.ROLE_USER, content);
        }

        public Message.withAssistantRole (string content) {
            this(Ollama.ROLE_ASSISTANT, content);
        }
    }

    public class Options : Json.Api.Object {
        public int* seed { get; set construct; }
        public int* temperature { get; set construct; }

        public Options (int* seed, int* temperature)
        {
            GLib.Object (
                         seed: seed,
                         temperature: temperature
            );
        }

        public Options.withDefaults () {
            this(null, null);
        }
    }

    public class ChatCompletionRequest : Json.Api.Object
    {

        private GLib.SList<Message> _messages;
        public GLib.SList<Message> messages
        {
            construct { this._messages = new GLib.SList<Message> (); }
            get { return this._messages; }
        }
        public string model { get; set construct; }

        public bool stream { get; set construct; }
        public string keep_alive { get; set construct; }

        public string? format { get; set construct; default = null; }
        public Options options { get; construct; }

        private ChatCompletionRequest (string model, string? format)
        {
            GLib.Object (
                         model: model,
                         format: format
            );
        }

        public ChatCompletionRequest.withDefaultFormat (string model)
        {
            this(model, FORMAT_DEFAULT);
        }

        public ChatCompletionRequest.withJsonFormat (string model) {
            this(model, FORMAT_JSON);
        }

        construct {
            this.options = new Options.withDefaults ();
            this._messages.append (new Message.withSystemRole ("You are \"Wilber\", the friendly assistant, named after the famous GIMP mascot."));
        }
    }
}

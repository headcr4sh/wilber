/* client.vala
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

namespace Ollama {

	public class ChatSession : GLib.Object {

		/** Mutex used to lock the session when a current request is ongoing. */
		private GLib.Mutex mutex = GLib.Mutex ();
		public bool busy { get; private set; }

		public string base_url { get; set construct; }
		public string model { get; set construct; }
		public GLib.Array<Message> messages { get; set construct; }
		public Options options { get; set construct; }
		public Format format { get; set construct; default = Format.DEFAULT; }
		public string keep_alive { get; set construct; default = "5m"; }
		private Wilber.Util.HttpClient < ChatCompletionRequest, ChatCompletionResponse > http_client;

		public signal void request_sent (ChatCompletionRequest req);
		public signal void response_received (ChatCompletionResponse res);

		public ChatSession (string base_url, string model, GLib.Array<Message> initial_messages, Options options, Format? format, string keep_alive) {
			GLib.Object (
				base_url: base_url,
				model: model,
				options: options,
				format: format,
				messages: initial_messages
			);
		}

		public ChatSession.with_settings (GLib.Settings settings) {
			GLib.Object (
				options: new Options.with_defaults (),
				messages: new GLib.Array<Message> ()
			);
			settings.bind (Wilber.SETTINGS_KEY_OLLAMA_URL, this, "base_url", GET_NO_CHANGES );
			settings.bind (Wilber.SETTINGS_KEY_OLLAMA_MODEL, this, "model", GET_NO_CHANGES );
			//settings.bind (Wilber.SETTINGS_KEY_OLLAMA_OPTION_SEED, this.options, "seed", GET);
			//settings.bind (Wilber.SETTINGS_KEY_OLLAMA_OPTION_TEMPERATURE, this.options, "temperature", GET);
		}

		construct {
			this.http_client = new Wilber.Util.HttpClient < ChatCompletionRequest, ChatCompletionResponse > ();
		}

		public async ChatCompletionResponse chat (string content) throws GLib.Error, GLib.UriError, Wilber.Util.HttpClientError {

			GLib.assert (this.http_client != null);

			this.busy = true;
			this.mutex.lock ();
			try {
				var request = new ChatCompletionRequest(this.model, this.format, this.options);
				request.keep_alive = this.keep_alive;
				request.stream = this.format == Format.DEFAULT;
				foreach (var message in this.messages) {
					request.add_message (message);
				}

				request.add_message (new Message.with_user_role (content));
				this.request_sent (request); // not entirely correct. Request is about to be send here...
				var response = yield this.http_client.http_post(
					@"$(this.base_url)/api/chat",
					request.to_json_data (),
					(request, ref response, line) => {
						var chunk = new ChatCompletionResponse.from_json_data (line);
						response.message = response.message ?? new Message.with_assistant_role ("");
						response.message.content += chunk.message.content;
						if (chunk.done) {
							response.model = chunk.model;
							response.created_at = chunk.created_at;
							response.done_reason = chunk.done_reason;
							response.done = chunk.done;
							response.total_duration = chunk.total_duration;
							response.load_duration = chunk.load_duration;
							response.prompt_eval_duration = chunk.prompt_eval_duration;
							response.eval_count = chunk.eval_count;
							response.eval_duration = chunk.eval_duration;
							this.response_received (response);
						}
					}
				);
				return response;
			} finally {
				this.mutex.unlock ();
				this.busy = false;
			}
		}
	}
}

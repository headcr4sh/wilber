/* window.vala
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

namespace Wilber {
		[GtkTemplate (ui = "/com/cathive/Wilber/window.ui")]
		public class Window : Adw.ApplicationWindow {

			public Ollama.ChatSession chat_session { get; set construct; }

			[GtkChild]
			private unowned Gtk.Entry input_entry;

			[GtkChild]
			private unowned Gtk.Button clear_input_button;

			[GtkChild]
			private unowned Gtk.ListBox messages_list_box;

			public virtual signal void clear_input () {
				this.input_entry.text = "";
			}

			[GtkCallback]
			private void on_clear_input () {
				this.clear_input ();
			}

			//[GtkCallback]
			private void on_message (Ollama.Message message) {
				print (message.content);
				this.messages_list_box.append ( new ChatMessageView ( message.content ) );
			}

			public Window (Wilber.Application application, Ollama.ChatSession chat_session) {
				GLib.Object (
					application: application,
					chat_session: chat_session
				);
			}

			construct {
				this.chat_session.bind_property (
					"busy",
					this.input_entry,
					"sensitive",
					DEFAULT | SYNC_CREATE | INVERT_BOOLEAN
				);
				this.input_entry.bind_property (
					"text",
					this.clear_input_button,
					"sensitive",
					DEFAULT | SYNC_CREATE,
					(binding, src, ref dst) => { dst.set_boolean (src.get_string().length > 0); return Gdk.EVENT_PROPAGATE; }
				);

				this.chat_session.request_sent.connect ((sess, req) => {
					this.on_message (req.messages.index (req.messages.length-1) );
				});

				this.chat_session.response_received.connect ((sess, res) => {
					this.on_message (res.message );
				});

				this.input_entry.activate.connect((target) => {
					var buffer = target.get_buffer();
					var content = buffer.get_text().strip();
					buffer.delete_text (0, buffer.get_length());
					if (content.length > 0) {
						this.chat_session.chat.begin(content);

					}
				});

				GLib.debug ("Created new window for Ollama chat session, url: %s, model: %s", chat_session.base_url, chat_session.model);
			}
		}
}

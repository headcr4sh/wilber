/* application.vala
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
    public class Application : Adw.Application {

        public GLib.Settings settings_backend_common { get; construct; }
        public GLib.Settings settings_backend_ollama { get; construct; }

        public Application () {
            GLib.Object (
				application_id: Wilber.APP_ID,
				flags: GLib.ApplicationFlags.DEFAULT_FLAGS,
				settings_backend_common: Wilber.common_settings (),
				settings_backend_ollama: Wilber.ollama_settings ()
			);
        }

        construct {
            ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "preferences", this.on_preferences_action },
                { "quit", this.quit }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});

			GLib.debug ("Application created with ID: %s", this.application_id);
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null) {
				var chat_session = new Ollama.ChatSession.with_settings (this.settings_backend_ollama);
				assert (chat_session.base_url != null);
                win = new Wilber.Window (this, chat_session);
            }

            win.present ();
        }

        private void on_about_action () {
            var about = new Adw.AboutDialog () {
                application_name = Wilber.APP_NAME,
                application_icon = "com.cathive.Wilber",
                developer_name = "Benjamin P. Jung",
                version = Wilber.APP_VERSION,
                developers = {
                    "Benjamin P. Jung",
                },
                copyright = "© 2025 Benjamin P. Jung",
            };

            about.present (this.active_window);
        }

        private void on_preferences_action () {
            new Wilber.PreferencesDialog.with_backends (
				this.settings_backend_common,
				this.settings_backend_ollama
			).present (this.active_window);
        }
    }
}

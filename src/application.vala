/* application.vala
 *
 * Copyright 2024 Benjamin P. Jung
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
        public Application () {
            Object (application_id: "com.cathive.Wilber", flags: ApplicationFlags.DEFAULT_FLAGS);
        }

        construct {
            ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "preferences", this.on_preferences_action },
                { "quit", this.quit }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null) {
                win = new Wilber.Window (this);
            }
            win.present ();
        }

        private void on_about_action () {
            string[] developers = { "Benjamin P. Jung" };
            var about = new Adw.AboutDialog () {
                application_name = "wilber",
                application_icon = "com.cathive.Wilber",
                developer_name = "Benjamin P. Jung",
                version = "0.1.0",
                developers = developers,
                copyright = "© 2024 Benjamin P. Jung",
            };

            about.present (this.active_window);
        }

        private void on_preferences_action () {
            new Wilber.PreferencesDialog().present (this.active_window);
        }
    }
}
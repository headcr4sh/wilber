/* preferences.vala
 *
 * Copyright 2024-2025 Benjamin P. Jung
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
    [GtkTemplate (ui = "/com/cathive/Wilber/preferences.ui")]
    public class PreferencesDialog : Adw.PreferencesDialog {

        [GtkChild]
        private unowned Adw.SwitchRow safe_search_switch;

        [GtkChild]
        private unowned Adw.EntryRow ollama_url_entry;

        [GtkChild]
        private unowned Adw.EntryRow ollama_model_entry;

        [GtkChild]
        private unowned Adw.SpinRow ollama_option_seed_entry;

        [GtkChild]
        private unowned Adw.SpinRow ollama_option_temperature_entry;


        [Description (nick="Common settings", blurb="Backend storage for common settings.")]
        public GLib.Settings settings_backend_common { get; construct; }

        [Description (nick="Ollama-related settings", blurb="Backend storage for Ollama-related settings.")]
        public GLib.Settings settings_backend_ollama { get; construct; }

        public PreferencesDialog.with_backends (GLib.Settings settings_backend_common, GLib.Settings settings_backend_ollama) {
            GLib.Object(
                settings_backend_common: settings_backend_common,
                settings_backend_ollama: settings_backend_ollama
            );
        }

        construct {
            this.settings_backend_common.bind (Wilber.SETTINGS_KEY_SAFE_SEARCH, this.safe_search_switch, "active", DEFAULT);
            this.settings_backend_ollama.bind (Wilber.SETTINGS_KEY_OLLAMA_URL, this.ollama_url_entry, "text", DEFAULT);
            this.settings_backend_ollama.bind (Wilber.SETTINGS_KEY_OLLAMA_MODEL, this.ollama_model_entry, "text", DEFAULT);
            this.settings_backend_ollama.bind (Wilber.SETTINGS_KEY_OLLAMA_OPTION_SEED, this.ollama_option_seed_entry, "value", DEFAULT);
            this.settings_backend_ollama.bind (Wilber.SETTINGS_KEY_OLLAMA_OPTION_TEMPERATURE, this.ollama_option_temperature_entry, "value", DEFAULT);
        }

    }
}

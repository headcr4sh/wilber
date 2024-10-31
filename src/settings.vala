/* settings.vala
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

    const string SETTINGS_SCHEMA_ID = "com.cathive.Wilber";

    const string SETTINGS_KEY_SAFE_SEARCH = "safe-search";

    const string SETTINGS_KEY_OLLAMA_URL = "url";
    const string SETTINGS_KEY_OLLAMA_MODEL = "model";
    const string SETTINGS_KEY_OLLAMA_OPTION_SEED = "option-seed";
    const string SETTINGS_KEY_OLLAMA_OPTION_TEMPERATURE = "option-temperature";

    public GLib.Settings common_settings() {
        return new GLib.Settings ( SETTINGS_SCHEMA_ID );
    }

    public GLib.Settings ollama_settings() {
        return new GLib.Settings ( @"$(SETTINGS_SCHEMA_ID).ollama" );
    }
}
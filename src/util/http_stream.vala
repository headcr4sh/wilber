/* http_stream.vala
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

namespace Wilber.Util {

	const string USER_AGENT = "Wilber/v1";

	public errordomain HttpClientError {
		UNKNOWN_ERROR,
		CLIENT_ERROR,
		SERVER_ERROR,
		NETWORK_ERROR,
		TIMEOUT_ERROR,
	}

	public delegate void JsonLineProcessor < I, O > (I input, ref O output, string line) throws GLib.Error;

	public class HttpClient < I, O > : GLib.Object {

		public Soup.Session http_session { get; set; }

		public HttpClient () {
			GLib.Object( );
		}

		construct {
			this.http_session = (!) (GLib.Object.new (typeof (Soup.Session), user_agent: USER_AGENT, max_conns: 1) as Soup.Session);
			GLib.debug ("HTTP Client initialized with user_agent: %s, max_conns: %d", this.http_session.user_agent, this.http_session.max_conns);
		}

		public async O http_post (string uri, string request, JsonLineProcessor < I, O > processor) throws GLib.UriError, HttpClientError {

			assert (GLib.Uri.is_valid (uri, GLib.UriFlags.NONE));

			var cancellable = new GLib.Cancellable ();
			var message = new Soup.Message ("POST", uri);
			message.set_request_body_from_bytes ("application/json", new GLib.Bytes (request.data));

			GLib.InputStream input_stream;
			try {
				input_stream = yield this.http_session.send_async(message, GLib.Priority.DEFAULT, cancellable);
			} catch (GLib.Error e) {
				throw new HttpClientError.NETWORK_ERROR(@"Network Error: $(e.message)");
			}

			if (message.status_code != Soup.Status.OK) {
				if (message.status_code >= 400 && message.status_code < 500) {
					throw new HttpClientError.CLIENT_ERROR(@"HTTP Client Error: $(message.status_code)-$(message.reason_phrase)");
				} else if (message.status_code >= 500 && message.status_code < 600) {
					throw new HttpClientError.SERVER_ERROR(@"HTTP ServerError: $(message.status_code)-$(message.reason_phrase)");
				} else if (message.status_code == Soup.Status.REQUEST_TIMEOUT) {
					throw new HttpClientError.TIMEOUT_ERROR(@"HTTP Error: $(message.status_code)-$(message.reason_phrase)");
				} else {
					throw new HttpClientError.UNKNOWN_ERROR(@"HTTP Error: $(message.status_code)-$(message.reason_phrase)");
				}
			}

			O response = GLib.Object.new (typeof (O));

			var data_input_stream = new GLib.DataInputStream (input_stream);
			string line;
			while (true) {
				try {
					line = yield data_input_stream.read_line_utf8_async (GLib.Priority.DEFAULT, cancellable);
				} catch (GLib.Error e) {
					throw new HttpClientError.NETWORK_ERROR(@"Read Error: $(e.message)");
				}
				if (line == null) {
					break;
				}
				try {
					processor (request, ref response, line);
				} catch (GLib.Error e) {
					throw new HttpClientError.CLIENT_ERROR(@"Processing Error: $(e.message)");
				}
			}

			return response;
		}
	}
}

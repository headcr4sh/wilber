namespace Ollama {

    const int CHUNK_BUFFER_SIZE = 128;

    public class Client < I, O > : GLib.Object {

        public Soup.Session httpSession { get; construct; }

        public Client () {
            GLib.Object( httpSession: new Soup.Session () );
        }

        construct {
            
        }

        async void _httpGet (Soup.Session session, string uri, I request, out O response) {
        
        }
    }
}

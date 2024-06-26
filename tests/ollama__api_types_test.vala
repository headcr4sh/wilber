public void test_ollama_message () {
	assert( new Ollama.Message.withSystemRole("{msg}").role == Ollama.ROLE_SYSTEM );
	assert( new Ollama.Message.withUserRole("{msg}").role == Ollama.ROLE_USER );
	assert( new Ollama.Message.withAssistantRole("{msg}").role == Ollama.ROLE_ASSISTANT );
}

public int main (string[] args) {
    Test.init (ref args);

    Test.add_func ("/ollama/Message",test_ollama_message);
    return Test.run ();
}

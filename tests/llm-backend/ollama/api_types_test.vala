namespace Ollama {

void assert_Options_json_serializable (Options obj) {
	try {
		var json_data = obj.to_json_data ();
		var obj_from_json = new Ollama.Options.from_json_data (json_data);
		obj.temperature.if_has_value (temperature => {
			assert_nonnull (obj_from_json.temperature);
			assert (obj.temperature.value == obj_from_json.temperature.value);
		});

	} catch (GLib.Error e) {
		assert_not_reached ();
	}
}

public void test_ChatCompletionRequest () {
	try {
		var ccr_json = new Ollama.ChatCompletionRequest.with_json_format ("localhost/my-model:latest");
		assert (Format.JSON == ccr_json.format);
	} catch (GLib.Error e) {
		assert_not_reached ();
	}
}

public void test_Format () {

	// From string
	assert ( Ollama.Format.DEFAULT == Ollama.Format.from_string (null) );
	assert ( Ollama.Format.DEFAULT == Ollama.Format.from_string ("default") );
	assert ( Ollama.Format.JSON == Ollama.Format.from_string ("json") );

	// TO string
	assert ( null == Ollama.Format.DEFAULT.to_string() );
	assert ( "json" == Ollama.Format.JSON.to_string() );
}

public void test_Message () {
	assert( new Ollama.Message.with_system_role("{msg}").role == Ollama.Role.SYSTEM );
	assert( new Ollama.Message.with_user_role("{msg}").role == Ollama.Role.USER );
	assert( new Ollama.Message.with_assistant_role("{msg}").role == Ollama.Role.ASSISTANT );

	var msg = new Ollama.Message.with_user_role ("{msg}");
	assert( msg.content == "{msg}" );
	try {
		var msg_as_json = msg.to_json_data ();
		var msg_from_json = new Ollama.Message.from_json_data (msg_as_json);
		assert (msg.role == msg_from_json.role);
		assert (msg.content == msg_from_json.content);
	} catch (GLib.Error e) {
		assert_not_reached ();
	}
}

public void test_Options () {

	var options = new Ollama.Options.with_defaults ();
	assert_false (options.seed.has_value);
	assert_false (options.temperature.has_value);
	assert_Options_json_serializable (options);

	int seed = 42;
	double temperature = 0.42;
	options = new Ollama.Options(seed, temperature);
	assert_Options_json_serializable (options);


}

public void test_Role () {

	// From string
	assert ( Ollama.Role.SYSTEM == Ollama.Role.from_string ("system") );
	assert ( Ollama.Role.USER == Ollama.Role.from_string ("user") );
	assert ( Ollama.Role.ASSISTANT == Ollama.Role.from_string ("assistant") );

	// To string
	assert ( "system" == Ollama.Role.SYSTEM.to_string() );
	assert ( "user" == Ollama.Role.USER.to_string() );
	assert ( "assistant" == Ollama.Role.ASSISTANT.to_string() );
}

public int main (string[] args) {
    Test.init (ref args);

	Test.add_func ("/wilber/llm-backend/ollama/ChatCompletionRequest", test_ChatCompletionRequest);
	Test.add_func ("/wilber/llm-backend/ollama/Format",test_Format);
    Test.add_func ("/wilber/llm-backend/ollama/Message",test_Message);
    Test.add_func ("/wilber/llm-backend/ollama/Options",test_Options);
    Test.add_func ("/wilber/llm-backend/ollama/Role",test_Role);

    return Test.run ();
}
}

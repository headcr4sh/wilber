unit_tests = [
  { 'name': 'Utility/Optional Types', 'files': files(['util/optional_test.vala']), 'suite': ['util']},
  { 'name': 'Utility/Generic JSON API', 'files': files(['util/json_api_test.vala']), 'suite': ['util']},
  { 'name': 'LLM backend (Ollama)', 'files': files(['llm-backend/ollama/api_types_test.vala']), 'suite': ['ollama']},
]

foreach unit_test: unit_tests
  exe_name = unit_test['name'].to_lower().replace(' ', '_')
  exe = executable(
    exe_name,
    unit_test['files'],
    sources: wilber_sources,
    dependencies: wilber_deps,
    build_by_default: true,
  )
  test('Unit test - ' + unit_test['name'], exe, suite: unit_test['suite'])
endforeach

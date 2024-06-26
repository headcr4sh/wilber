tests = [
  'ollama__api_types_test.vala',
]

foreach test_file: tests
  exe = executable(
    test_file.split('.')[0],
    test_file,
    sources: wilber_sources,
    #include_directories: top_inc,
    dependencies: wilber_deps,
    #c_args: warn_flags,
  )
  test('name-of-test-TODO', exe)
endforeach

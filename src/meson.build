wilber_sources = files([
  'settings.vala',
  'application.vala',
  'window.vala',
  'preferences.vala',
  'ollama/http_stream.vala',
  'ollama/json_api.vala',
  'ollama/api_types.vala',
  'ollama/client.vala',
])

wilber_deps = [
  dependency('gio-2.0'),
  dependency('gtk4'),
  dependency('json-glib-1.0'),
  dependency('libadwaita-1', version: '>= 1.6'),
  dependency('libsoup-3.0')
]

wilber_sources += gnome.compile_resources('wilber-resources',
  'wilber.gresource.xml',
  c_name: meson.project_name()
)

executable(
  meson.project_name(),
  sources: wilber_sources + files(['main.vala']),
  dependencies: wilber_deps,
       install: true,
)

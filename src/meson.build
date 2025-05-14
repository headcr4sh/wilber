settings_vala = configure_file(
    input: 'settings.vala.in',
    output: 'settings.vala',
    configuration: cfg_data,
    install: false,
)

version_vala = configure_file(
    input: 'version.vala.in',
    output: 'version.vala',
    configuration: cfg_data,
    install: false,
)

wilber_sources = files(
    settings_vala.full_path(),
    version_vala.full_path(),
    'application.vala',
    'chat_message_view.vala',
    'window.vala',
    'preferences.vala',
    'util/http_stream.vala',
    'util/json_api.vala',
    'util/optional.vala',
    'llm-backend/ollama/api_types.vala',
    'llm-backend/ollama/client.vala',
)

wilber_deps = [
    dependency('gio-2.0'),
    dependency('gtk4'),
    dependency('json-glib-1.0'),
    dependency('libadwaita-1', version: '>= 1.6'),
    dependency('libsoup-3.0'),
]

wilber_sources += gnome.compile_resources('wilber-resources', 'wilber.gresource.xml', c_name: meson.project_name())

executable(
    meson.project_name(),
    sources: wilber_sources + files('main.vala'),
    dependencies: wilber_deps,
    install: true,
)

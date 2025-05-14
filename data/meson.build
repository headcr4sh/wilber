configure_file(
    input: 'com.cathive.Wilber.service.in',
    output: 'com.cathive.Wilber.service',
    configuration: cfg_data,
    install: true,
    install_dir: get_option('datadir') / 'dbus-1' / 'services',
)

desktop_file = i18n.merge_file(
    input: configure_file(
        input: 'com.cathive.Wilber.desktop.in',
        output: 'com.cathive.Wilber.desktop.i18n.in',
        configuration: cfg_data,
    ),
    output: 'com.cathive.Wilber.desktop',
    type: 'desktop',
    po_dir: '../po',
    install: true,
    install_dir: get_option('datadir') / 'applications',
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
    test('Validate desktop file', desktop_utils, args: [desktop_file])
endif

appstream_file = i18n.merge_file(
    input: 'com.cathive.Wilber.metainfo.xml.in',
    output: 'com.cathive.Wilber.metainfo.xml',
    po_dir: '../po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo',
)

appstreamcli = find_program('appstreamcli', required: false)
if appstreamcli.found()
    test(
        'Validate appstream file',
        appstreamcli,
        args: ['validate', '--no-net', '--explain', appstream_file],
    )
endif

configure_file(
    input: 'com.cathive.Wilber.gschema.xml.in',
    output: 'com.cathive.Wilber.gschema.xml',
    configuration: cfg_data,
    install: true,
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

glib_compile_schemas = find_program('glib-compile-schemas', required: false)
if glib_compile_schemas.found()
  test('validate gsettings schemas',
    glib_compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()],
  )
endif

subdir('icons')

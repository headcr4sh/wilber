project(
    'wilber',
    ['vala', 'c'],
    version: '0.1.0',
    license: 'GPL-3.0-or-later',
    license_files: ['COPYING'],
    default_options: [
        'warning_level=2',
        'werror=false',
    ],
    meson_version: '>= 1.5.0',
)

#add_project_arguments('--enable-experimental-non-null', language: 'vala')

application_id = 'com.cathive.Wilber'
if get_option('profile') == 'development'
    application_id = 'com.cathive.Wilber.Devel'
endif

desktop_utils = find_program('desktop-file-validate', required: false)

cfg_data = configuration_data()
cfg_data.set('BINDIR_ABSOLUTE', join_paths(get_option('prefix'), get_option('bindir')))
cfg_data.set('PACKAGE_VERSION', meson.project_version())
cfg_data.set(
    'PACKAGE_NAME',
    meson.project_name(),
    description: 'Short package name, used for the executable name',
)
cfg_data.set(
    'APPLICATION_ID',
    application_id,
    description: 'Application ID in reverse domain notation',
)
cfg_data.set('GSCHEMA_PATH', '/' + application_id.replace('.', '/') + '/')

glib = dependency('glib-2.0', version: '>=2.40', required: true)
gio = dependency('gio-2.0', version: '>=2.40', required: true)
gobject = dependency('gobject-2.0', version: '>=2.40', required: true)

gnome = import('gnome', required: true)
i18n = import('i18n', required: true)
pkg = import('pkgconfig', required: true)

subdir('data')
subdir('src')
subdir('po')
subdir('tests')

gnome.post_install(
    glib_compile_schemas: true,
    gtk_update_icon_cache: true,
    update_desktop_database: true,
    update_mime_database: false,
)

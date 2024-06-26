project('wilber', ['c', 'vala'],
          version: '0.1.0',
          license: 'GPL-3.0-or-later',
  default_options: [ 'warning_level=2', 'werror=false', ],
    meson_version: '>= 1.4.0',
)

application_id = 'com.cathive.Wilber'

cfg_data = configuration_data()
cfg_data.set('PACKAGE_VERSION', meson.project_version())
cfg_data.set('PACKAGE_NAME', meson.project_name())
cfg_data.set('APPLICATION_ID', application_id)
cfg_data.set('GSCHEMA_PATH', '/' + application_id.replace('.', '/') + '/')

glib = dependency('glib-2.0', version: '>=2.40')
gobject = dependency('gobject-2.0', version: '>=2.40')

gnome = import('gnome')
i18n = import('i18n')
pkg = import('pkgconfig')

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

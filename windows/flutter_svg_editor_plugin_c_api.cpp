#include "include/flutter_svg_editor/flutter_svg_editor_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_svg_editor_plugin.h"

void FlutterSvgEditorPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_svg_editor::FlutterSvgEditorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

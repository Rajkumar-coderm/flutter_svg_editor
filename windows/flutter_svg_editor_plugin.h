#ifndef FLUTTER_PLUGIN_FLUTTER_SVG_EDITOR_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_SVG_EDITOR_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_svg_editor {

class FlutterSvgEditorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterSvgEditorPlugin();

  virtual ~FlutterSvgEditorPlugin();

  // Disallow copy and assign.
  FlutterSvgEditorPlugin(const FlutterSvgEditorPlugin&) = delete;
  FlutterSvgEditorPlugin& operator=(const FlutterSvgEditorPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_svg_editor

#endif  // FLUTTER_PLUGIN_FLUTTER_SVG_EDITOR_PLUGIN_H_

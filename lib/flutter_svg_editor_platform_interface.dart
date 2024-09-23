import 'package:flutter_svg_editor/flutter_svg_editor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterSvgEditorPlatform extends PlatformInterface {
  /// Constructs a FlutterDemoPlatform.
  FlutterSvgEditorPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSvgEditorPlatform _instance = MethodChannelFlutterSvgEditor();

  /// The default instance of [FlutterSvgEditorPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSvgEditor].
  static FlutterSvgEditorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSvgEditorPlatform] when
  /// they register themselves.
  static set instance(FlutterSvgEditorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

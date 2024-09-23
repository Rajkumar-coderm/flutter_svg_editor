# Flutter SVG Editor

The `flutter_svg_editor` library is a powerful tool for editing SVG files within Flutter applications. With its intuitive API and robust feature set, this library makes it easy to create, modify, and manipulate SVG files on the fly.

## Overview

The `flutter_svg_editor` library provides a comprehensive set of features for working with SVG files in Flutter. Whether you're building a graphic design app, a vector graphics editor, or simply need to manipulate SVG files in your Flutter project, this library has got you covered.

## Features

* **Change SVG Colors**: Easily change the colors of individual elements or entire groups within an SVG file.
* **Copy SVG String Data**: Copy the SVG string data to the clipboard for easy sharing or reuse.
* **Download SVG File**: Download the edited SVG file to the device's file system.
* **Flip Mode**: Rotate the existing SVG image by 90, 180, or 270 degrees with a simple flip mode feature.
* **Return Updated Real-Time Data**: Get real-time updates to the SVG data as you make changes, allowing for seamless integration with your app's UI.

## Integration

To integrate the `flutter_svg_editor` library into your Flutter project, simply add the following code to your widget tree:

```dart
FlutterSvgEditor(
  onChange: (svgValue) {
    // Handle changes to the SVG data
  },
  onReset: (svgValue) {
    // Handle resets to the original SVG data
  },
  onCopied: (svgValue) {
    // Handle copying of the SVG string data
  },
)
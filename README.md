# Flutter SVG Editor

The `flutter_svg_editor` library is a powerful tool for editing SVG files within Flutter applications. With its intuitive API and robust feature set, this library makes it easy to create, modify, and manipulate SVG files on the fly.

## Mobile SVG Editor View

<div style="display: flex; flex-direction: row;">
  <img src="https://github.com/user-attachments/assets/34a76aa7-d2db-4d36-b1d9-6da5a8c22b03" width="300px" alt="Image description">

  <div style = "width:30px"></div>

  <img src="https://github.com/user-attachments/assets/9059726f-9a0e-4f7e-ac27-1848c4c6a5df" width="300px" alt="Image description">
</div>

## Web and Desktop SVG Editor View

<div style="">
  <img src="https://github.com/user-attachments/assets/e70b86a0-462c-476c-a4ae-46e8eadc50a9" width="900px" alt="Image description">

  <div style = "height:30px"></div>

  <img src="https://github.com/user-attachments/assets/43e37c3b-45c5-4281-b431-a53390b2aeb6" width="900px" alt="Image description">
</div>


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
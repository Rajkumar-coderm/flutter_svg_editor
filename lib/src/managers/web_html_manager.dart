import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;

class HtmlWebManager {
  Future<String> uploadNewSvgImageFormWeb() async {
    final svgFile = await _uploadSvg();
    final svgString = await _readFileAsText(svgFile);
    return svgString;
  }

  // Method to handle file uploading and return the file
  Future<html.File> _uploadSvg() async {
    final completer = Completer<html.File>();
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.svg';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        completer.complete(file);
      } else {
        completer.completeError('No file selected');
      }
    });

    return completer.future;
  }

  // Method to read the uploaded file as text
  Future<String> _readFileAsText(html.File file) async {
    final completer = Completer<String>();
    final reader = html.FileReader();

    reader.readAsText(file);

    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as String);
    });

    reader.onError.listen((event) {
      completer.completeError('Error reading file');
    });

    return completer.future;
  }

  // Method to download SVG file from string data
  void downloadSvg(String svgString, String fileName) {
    // Create a Blob from the SVG string data
    final blob = html.Blob([svgString], 'image/svg+xml');

    // Create an anchor element for the download
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    // Revoke the URL after the download to free up memory
    html.Url.revokeObjectUrl(url);
  }

  Future<String> setupDragDropListeners(
    Function(bool onDrag) onDragging,
  ) async {
    final body = html.document.body;
    final completer = Completer<html.File>();

    // Handle dragging over the app
    body?.addEventListener('dragover', (event) {
      event.preventDefault();
      onDragging.call(true);
    });

    // Handle dragging leaving the app
    body?.addEventListener('dragleave', (event) {
      event.preventDefault();
      onDragging.call(false);
    });

    // Handle dropping the file into the app
    body?.addEventListener('drop', (event) {
      event.preventDefault();
      onDragging.call(false);
      final dataTransfer = (event as html.MouseEvent).dataTransfer;
      final files = dataTransfer.files!;
      final file = files.first;

      if (file.type == 'image/svg+xml') {
        completer.complete(file);
      } else {
        log('Only SVG files are allowed.');
        completer.completeError('Error reading file');
      }
    });
    return _readFileAsText(await completer.future);
  }
}

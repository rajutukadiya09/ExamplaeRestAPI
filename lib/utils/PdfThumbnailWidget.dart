import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:nimodrive/utils/utility.dart';
import 'package:path_provider/path_provider.dart';

import 'api_constant.dart';
import 'app_pref.dart';

class BlobPdfViewer extends StatefulWidget {
  final String url;

  const BlobPdfViewer({super.key, required this.url});

  @override
  State<BlobPdfViewer> createState() => _BlobPdfViewerState();
}

class _BlobPdfViewerState extends State<BlobPdfViewer> {
  String? _localPath; // Local file path for the file
  bool _isLoading = true; // Loading state
  String? _error; // Error message
  String? _fileContent; // Content for text files

  @override
  void initState() {
    super.initState();
    _loadFileFromBlob(widget.url);
  }

  Future<void> _loadFileFromBlob(String url) async {
    try {
      String pathBase64 = convertBase64(url);

      String authToken = await AppPref().getSeasonToken();
      // Fetch the file as a blob
      final response = await http.get(
        Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.donwloadFile}/$pathBase64"),
        headers: {
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final fileName =
            'temp.${_getFileExtension(url)}'; // Determine file extension
        final filePath = '${dir.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        if (_isTextFile(fileName)) {
          // If it's a text file, read its content
          final content = await file.readAsString();
          setState(() {
            _fileContent = content;
            _isLoading = false;
          });
        } else {
          // Otherwise, update the path for PDF rendering
          setState(() {
            _localPath = filePath;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load file. Status Code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading file: $e';
        _isLoading = false;
      });
    }
  }

  bool _isTextFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ext == 'txt';
  }

  String _getFileExtension(String url) {
    return url.split('.').last.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }

    if (_fileContent != null) {
      // Display text content for .txt files
      return Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    _fileContent!,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              )));
    }

    if (_localPath != null) {
      // Render the PDF using flutter_pdfview
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: PDFView(
          filePath: _localPath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          onPageChanged: (int? current, int? total) {
            print('Page changed: $current / $total');
          },
          onError: (error) {
            print('PDFView Error: $error');
          },
          onRender: (pages) {
            print('PDF rendered with $pages pages');
          },
        ),
      );
    }

    return const Center(
      child: Text('Unable to display file'),
    );
  }
}

/*class BlobPdfViewer extends StatefulWidget {
  final String url;

  const BlobPdfViewer({super.key, required this.url});

  @override
  State<BlobPdfViewer> createState() => _BlobPdfViewerState();
}

class _BlobPdfViewerState extends State<BlobPdfViewer> {
  String? _localPath; // Local file path for the PDF
  bool _isLoading = true; // Loading state
  String? _error; // Error message

  @override
  void initState() {
    super.initState();
    _loadPdfFromBlob(widget.url);
  }

  Future<void> _loadPdfFromBlob(String url) async {
    try {
      String pathBase64 = convertBase64(url);


      String authToken = await AppPref().getSeasonToken();
      // Fetch PDF data as a blob
      final response = await http.get(Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.donwloadFile}${pathBase64}"),
        headers: {
          'Authorization': authToken,
        },);

      if (response.statusCode == 200) {
        // Get the temporary directory
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/temp.pdf';

        // Write the blob data to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Update the local file path
        setState(() {
          _localPath = filePath;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load PDF. Status Code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading PDF: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }

    if (_localPath != null) {
      // Render the PDF using flutter_pdfview
      return  Padding(
          padding: const EdgeInsets.only(top: .0), // Add 16.0 pixels of top padding
          child: PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onPageChanged: (int? current, int? total) {
          print('Page changed: $current / $total');
        },
        onError: (error) {
          print('PDFView Error: $error');
        },
        onRender: (pages) {
          print('PDF rendered with $pages pages');
        },
      ));
    }

    return const Center(
      child: Text('Unable to display PDF'),
    );
  }
}*/

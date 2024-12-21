import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ThumbnailWidget extends StatelessWidget {
  final String path;
  final controller; // Controller to fetch the thumbnail

  const ThumbnailWidget(
      {Key? key, required this.path, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Uint8List>(
        future: controller.fetchThumbnail(path),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the image to load
            return const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // Handle any errors
            return const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: Text('Error loading image')),
            );
          } else if (snapshot.hasData) {
            // Display the image when the data is available
            return InteractiveViewer(
              panEnabled: true, // Allows panning
              scaleEnabled: true, // Allows scaling (zooming)
              child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity, // Allow the width to wrap
                    maxHeight: double.infinity, // Allow the height to wrap
                  ),
                  child:Image.memory(
                    snapshot.data!,
                    fit: BoxFit.contain,
                  )),
            );
          } else {
            // Handle the case where no data is available
            return const SizedBox(
              width: 300,
              height: 300,
              child: Center(child: Text('No image available')),
            );
          }
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagenAmpliada extends StatefulWidget {
  final String nombreArticulo;
  final String imagen;
  const ImagenAmpliada({super.key, required this.nombreArticulo, required this.imagen});

  @override
  State<ImagenAmpliada> createState() => _ImagenAmpliadaState();
}

class _ImagenAmpliadaState extends State<ImagenAmpliada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nombreArticulo}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imagen),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered*2,
        ),
      ),
    );
  }
}
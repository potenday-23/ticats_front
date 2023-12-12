import 'dart:io' as io;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MaskedImage extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final String mask;

  const MaskedImage({super.key, this.imageUrl, this.imagePath, required this.mask});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<ImageShader>(
        future: _createShaderAndImage(constraints.maxWidth, constraints.maxHeight),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Stack(
            children: [
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (rect) => snapshot.data!,
                child: Image.asset(mask),
              ),
              Positioned.fill(
                bottom: 24.w,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset('assets/tickets/ticats.svg'),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Future<ImageShader> _createShaderAndImage(double w, double h) async {
    late Uint8List data;

    if (imageUrl != null) {
      File file = await DefaultCacheManager().getSingleFile(imageUrl!);

      data = file.readAsBytesSync().buffer.asUint8List();
    } else {
      data = io.File(imagePath!).readAsBytesSync().buffer.asUint8List();
    }

    Codec codec = await instantiateImageCodec(data, targetWidth: w.toInt(), targetHeight: h.toInt());

    FrameInfo fi = await codec.getNextFrame();
    ImageShader shader = ImageShader(fi.image, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);

    return shader;
  }
}

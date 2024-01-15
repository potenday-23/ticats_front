import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';

enum Rotation { Rot0, Rot90, Rot180, Rot270 }

extension Rotate on Rotation {
  Rotation get cw {
    const values = Rotation.values;
    return values.elementAt((index + 1) % values.length);
  }

  Rotation get ccw {
    const values = Rotation.values;
    return values.elementAt((index - 1) % values.length);
  }
}

class CropImagePage extends StatefulWidget {
  const CropImagePage({super.key, required this.image, this.isProfile = false});

  final Uint8List image;
  final bool isProfile;

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();

  bool isCropping = false;
  Rotation rotation = Rotation.Rot0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackAppBar(title: "이미지 자르기"),
      body: SafeArea(
        child: ExtendedImage.memory(
          widget.image,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: editorKey,
          initEditorConfigHandler: (state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              editorKey.currentState?.setState(() {
                for (var i = 0; i < rotation.index; ++i) {
                  editorKey.currentState?.rotate();
                }
              });
            });

            return EditorConfig(
              maxScale: 4,
              cropRectPadding: const EdgeInsets.all(20.0),
              editorMaskColorHandler: (context, pointerDown) => Colors.black.withOpacity(0.4),
              cropAspectRatio: widget.isProfile
                  ? 1 / 1
                  : rotation.index % 2 == 0
                      ? 57 / 94
                      : 94 / 57,
              cropLayerPainter: widget.isProfile ? const CircleEditorCropLayerPainter() : const EditorCropLayerPainter(),
              hitTestSize: widget.isProfile ? 0 : 20,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: SizedBox(
            height: 74.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => setState(() => rotation = rotation.ccw),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                      child: SvgPicture.asset('assets/icons/rotate.svg', width: 17.5.w, height: 21.w),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      if (isCropping) return;

                      setState(() {
                        isCropping = true;
                      });

                      final Uint8List img = editorKey.currentState!.rawImageData;
                      final EditActionDetails action = editorKey.currentState!.editAction!;
                      final ImageEditorOption option = ImageEditorOption();

                      Rect cropRect = editorKey.currentState!.getCropRect()!;
                      if (action.needCrop) {
                        option.addOption(ClipOption.fromRect(cropRect));
                      }

                      final int rotateAngle = action.rotateAngle.toInt();

                      if (action.hasRotateAngle) {
                        option.addOption(RotateOption(rotateAngle));
                      }

                      final Uint8List? croppedImage = await ImageEditor.editImage(
                        image: img,
                        imageEditorOption: option,
                      );

                      if (croppedImage != null) {
                        final directory = (await getTemporaryDirectory()).path;
                        final newImage = await File('$directory/${DateTime.now().millisecondsSinceEpoch}').create();
                        await newImage.writeAsBytes(croppedImage);

                        Get.back(result: newImage.path);
                      }

                      setState(() {
                        isCropping = false;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                      child: isCropping
                          ? SizedBox(width: 21.w, height: 21.w, child: const CircularProgressIndicator())
                          : Row(
                              children: [
                                SvgPicture.asset('assets/icons/rotate.svg', width: 17.5.w, height: 21.w),
                                SizedBox(width: 10.w),
                                Text("자르기 완료", style: AppTypeFace.xSmall16SemiBold),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleEditorCropLayerPainter extends EditorCropLayerPainter {
  const CircleEditorCropLayerPainter();

  @override
  void paintCorners(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    // do nothing
  }

  @override
  void paintMask(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect rect = Offset.zero & size;
    final Rect cropRect = painter.cropRect;
    final Color maskColor = painter.maskColor;
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = maskColor);
    canvas.drawCircle(cropRect.center, cropRect.width / 2.0, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  void paintLines(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    final Rect cropRect = painter.cropRect;
    if (painter.pointerDown) {
      canvas.save();
      canvas.clipPath(Path()..addOval(cropRect));
      super.paintLines(canvas, size, painter);
      canvas.restore();
    }
  }
}

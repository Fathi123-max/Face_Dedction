import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final ImageProvider spidermanMask = AssetImage('assets/sad.png');
  final ImageProvider OtherMask = AssetImage('assets/happy.png');
  @override
  void paint(Canvas canvas, Size size) {
    for (final Face face in faces) {
      final left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      final maskRect = Rect.fromLTRB(left, top, right, bottom);
      double maskWidth, maskHeight;
      if (face.smilingProbability! < 0.5) {
        spidermanMask.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((info, _) {
            maskWidth = info.image.width.toDouble();
            maskHeight = info.image.height.toDouble();
            final matrix = Matrix4.identity()
              ..translate(maskRect.left, maskRect.top)
              ..scale(maskRect.width / maskWidth, maskRect.height / maskHeight);

            canvas.save();
            canvas.transform(matrix.storage);
            spidermanMask
                .resolve(ImageConfiguration())
                .addListener(ImageStreamListener((info, _) {
              canvas.drawImage(info.image, Offset.zero, Paint());
            }));
            canvas.restore();
          }),
        );
      } else if (face.smilingProbability! > 0.5) {
        OtherMask.resolve(ImageConfiguration()).addListener(
          ImageStreamListener((info, _) {
            maskWidth = info.image.width.toDouble();
            maskHeight = info.image.height.toDouble();
            final matrix = Matrix4.identity()
              ..translate(maskRect.left, maskRect.top)
              ..scale(maskRect.width / maskWidth, maskRect.height / maskHeight);

            canvas.save();
            canvas.transform(matrix.storage);
            OtherMask.resolve(ImageConfiguration())
                .addListener(ImageStreamListener((info, _) {
              canvas.drawImage(info.image, Offset.zero, Paint());
            }));
            canvas.restore();
          }),
        );
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

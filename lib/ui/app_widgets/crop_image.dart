import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class CropImageWidget extends StatefulWidget {
  final File fileImage;
  final double aspectRatio;

  late double height;
  late double width;

  late final im.Image image;
  final transformationController = TransformationController();

  CropImageWidget({
    super.key,
    required this.fileImage,
    this.aspectRatio = 1,
  }) {
    image = im.decodeImage(fileImage.readAsBytesSync())!;
    transformationController.addListener(() {
      alignImage();
    });
  }

  @override
  State<CropImageWidget> createState() => _CropImageWidgetState();

  void alignImage() async {
    var scaleHeight = height / image.height;
    var scaleWidth = width / image.width;
    var minScale = min(scaleHeight, scaleWidth);

    var normSizeImageInWidget =
        Size(image.width * minScale, image.height * minScale);

    var centerXOffset = -(width - normSizeImageInWidget.width) / 2;
    var centerYOffset = -(height - normSizeImageInWidget.height) / 2;

    var zoomFactor = transformationController.value[0];

    var zoomSizeImageInWidget = Size(normSizeImageInWidget.width * zoomFactor,
        normSizeImageInWidget.height * zoomFactor);

    var xOffset =
        centerXOffset * zoomFactor - transformationController.value[12];
    var yOffset =
        centerYOffset * zoomFactor - transformationController.value[13];

    if (zoomSizeImageInWidget.height < height) {}

    if (zoomSizeImageInWidget.width < width) {
      transformationController.value[12] = centerXOffset * zoomFactor -
          (zoomSizeImageInWidget.width - width) / 2;
    } else if (xOffset < 0) {
      transformationController.value[12] = centerXOffset * zoomFactor;
    } else if (xOffset > zoomSizeImageInWidget.width - width) {
      transformationController.value[12] =
          centerXOffset * zoomFactor - (zoomSizeImageInWidget.width - width);
    }

    if (zoomSizeImageInWidget.height < height) {
      transformationController.value[13] = centerYOffset * zoomFactor -
          (zoomSizeImageInWidget.height - height) / 2;
    } else if (yOffset < 0) {
      transformationController.value[13] = centerYOffset * zoomFactor;
    } else if (yOffset > zoomSizeImageInWidget.height - height) {
      transformationController.value[13] =
          centerYOffset * zoomFactor - (zoomSizeImageInWidget.height - height);
    }
  }

  Future<File?> cropImage() async {
    var scaleHeight = height / image.height;
    var scaleWidth = width / image.width;
    var minScale = min(scaleHeight, scaleWidth);

    var normSizeImageInWidget =
        Size(image.width * minScale, image.height * minScale);

    var centerXOffset = -(width - normSizeImageInWidget.width) / 2;
    var centerYOffset = -(height - normSizeImageInWidget.height) / 2;

    var zoomFactor = transformationController.value[0];

    var zoomSizeImageInWidget = Size(normSizeImageInWidget.width * zoomFactor,
        normSizeImageInWidget.height * zoomFactor);

    double widthNewImage = normSizeImageInWidget.width /
        zoomSizeImageInWidget.width *
        width /
        minScale;

    double heightNewImage = normSizeImageInWidget.height /
        zoomSizeImageInWidget.height *
        height /
        minScale;

    var xOffset =
        (centerXOffset * zoomFactor - transformationController.value[12]) /
            zoomFactor /
            minScale;
    var yOffset =
        (centerYOffset * zoomFactor - transformationController.value[13]) /
            zoomFactor /
            minScale;

    final newImage = im.Image(widthNewImage.floor(), heightNewImage.floor());

    if (newImage.height > image.height) {
      var cropImage =
          im.copyCrop(image, xOffset.floor(), 0, newImage.width, image.height);
      im.copyInto(newImage, cropImage, dstY: -yOffset.floor());
    } else if (newImage.width > image.width) {
      var cropImage =
          im.copyCrop(image, 0, yOffset.floor(), image.width, newImage.height);
      im.copyInto(newImage, cropImage, dstX: -xOffset.floor());
    } else {
      var cropImage = im.copyCrop(image, xOffset.floor(), yOffset.floor(),
          newImage.width, newImage.height);
      im.copyInto(newImage, cropImage, blend: false);
    }

    var tempDirectory = await getTemporaryDirectory();
    File imgFile = File(join(tempDirectory.path, "EDITED${const Uuid().v4()}"));
    await imgFile.create();

    await imgFile.writeAsBytes(im.encodePng(newImage));

    return imgFile;
  }
}

class _CropImageWidgetState extends State<CropImageWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        widget.height = min(boxConstraints.maxWidth,
            boxConstraints.maxHeight * widget.aspectRatio);
        widget.width = widget.height * widget.aspectRatio;
        return Container(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            width: widget.width,
            height: widget.height,
            child: InteractiveViewer(
              transformationController: widget.transformationController,
              // boundaryMargin: EdgeInsets.all(50),
              maxScale: 4,
              child: Image.file(widget.fileImage),
            ),
          ),
        );
      },
    );
  }
}

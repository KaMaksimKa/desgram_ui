import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as im;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_navigator.dart';

class EditImageViewModel extends ChangeNotifier {
  File file;
  Size? _widgetSize;
  Size? get widgetSize => _widgetSize;
  set widgetSize(Size? val) {
    _widgetSize = val;
  }

  late final im.Image image;
  final transformationController = TransformationController();
  final editingImageKey = GlobalKey();
  final BuildContext context;

  EditImageViewModel({
    required this.file,
    required this.context,
  }) {
    image = im.decodeImage(file.readAsBytesSync())!;
    transformationController.addListener(() {
      alignImage();
    });
  }

  void alignImage() async {
    if (widgetSize == null) {
      return;
    }
    var scaleHeight = widgetSize!.height / image.height;
    var scaleWidth = widgetSize!.width / image.width;
    var minScale = min(scaleHeight, scaleWidth);

    var normSizeImageInWidget =
        Size(image.width * minScale, image.height * minScale);

    var centerXOffset = -(widgetSize!.width - normSizeImageInWidget.width) / 2;
    var centerYOffset =
        -(widgetSize!.height - normSizeImageInWidget.height) / 2;

    var zoomFactor = transformationController.value[0];

    var zoomSizeImageInWidget = Size(normSizeImageInWidget.width * zoomFactor,
        normSizeImageInWidget.height * zoomFactor);

    var xOffset =
        centerXOffset * zoomFactor - transformationController.value[12];
    var yOffset =
        centerYOffset * zoomFactor - transformationController.value[13];

    if (zoomSizeImageInWidget.height < widgetSize!.height) {}

    if (zoomSizeImageInWidget.width < widgetSize!.width) {
      transformationController.value[12] = centerXOffset * zoomFactor -
          (zoomSizeImageInWidget.width - widgetSize!.width) / 2;
    } else if (xOffset < 0) {
      transformationController.value[12] = centerXOffset * zoomFactor;
    } else if (xOffset > zoomSizeImageInWidget.width - widgetSize!.width) {
      transformationController.value[12] = centerXOffset * zoomFactor -
          (zoomSizeImageInWidget.width - widgetSize!.width);
    }

    if (zoomSizeImageInWidget.height < widgetSize!.height) {
      transformationController.value[13] = centerYOffset * zoomFactor -
          (zoomSizeImageInWidget.height - widgetSize!.height) / 2;
    } else if (yOffset < 0) {
      transformationController.value[13] = centerYOffset * zoomFactor;
    } else if (yOffset > zoomSizeImageInWidget.height - widgetSize!.height) {
      transformationController.value[13] = centerYOffset * zoomFactor -
          (zoomSizeImageInWidget.height - widgetSize!.height);
    }
    notifyListeners();
  }

  Future editImage({required Size screenSize}) async {
    if (widgetSize == null) {
      return;
    }
    var scaleHeight = widgetSize!.height / image.height;
    var scaleWidth = widgetSize!.width / image.width;
    var minScale = min(scaleHeight, scaleWidth);

    var normSizeImageInWidget =
        Size(image.width * minScale, image.height * minScale);

    var centerXOffset = -(widgetSize!.width - normSizeImageInWidget.width) / 2;
    var centerYOffset =
        -(widgetSize!.height - normSizeImageInWidget.height) / 2;

    var zoomFactor = transformationController.value[0];

    var zoomSizeImageInWidget = Size(normSizeImageInWidget.width * zoomFactor,
        normSizeImageInWidget.height * zoomFactor);

    double width = normSizeImageInWidget.width /
        zoomSizeImageInWidget.width *
        widgetSize!.width /
        minScale;

    double height = normSizeImageInWidget.height /
        zoomSizeImageInWidget.height *
        widgetSize!.height /
        minScale;

    var xOffset =
        (centerXOffset * zoomFactor - transformationController.value[12]) /
            zoomFactor /
            minScale;
    var yOffset =
        (centerYOffset * zoomFactor - transformationController.value[13]) /
            zoomFactor /
            minScale;

    final newImage = im.Image(width.floor(), height.floor());

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
    file = imgFile;
    notifyListeners();
    AppNavigator.popPage<File>(imgFile);
  }
}

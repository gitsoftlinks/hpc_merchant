import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:happiness_club_merchant/app/app_theme/app_theme.dart';
import 'package:happiness_club_merchant/app/toast_messages/toast_messages.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../app/custom_widgets/custom_snackbar.dart';
import '../globals.dart';

class ImageCropper extends StatefulWidget {
  final String path;

  const ImageCropper({
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  late CustomImageCropController controller;
  late File imageFile;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    imageFile = File(widget.path);
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Image"),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 80,
            child: Center(
              child: CustomImageCrop(
                cropController: controller,
                // image: const AssetImage('assets/test.png'), // Any Imageprovider will work, try with a NetworkImage for example...
                image: FileImage(imageFile),
                shape: CustomCropShape.Circle,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              color: kBrownTitleColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: const Icon(
                        Icons.restore,
                      ),
                      onPressed: controller.reset),
                  IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () =>
                          controller.addTransition(CropImageData(scale: 1.33))),
                  IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () =>
                          controller.addTransition(CropImageData(scale: 0.75))),
                  IconButton(
                      icon: const Icon(Icons.rotate_left),
                      onPressed: () => controller
                          .addTransition(CropImageData(angle: -pi / 4))),
                  IconButton(
                      icon: const Icon(Icons.rotate_right),
                      onPressed: () => controller
                          .addTransition(CropImageData(angle: pi / 4))),
                  isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            try {
                              isLoading = true;
                              setState(() {});

                              //   final image = await controller.onCropImage();

                              var tempDir = await getTemporaryDirectory();
                              var file;
                              String dynamicImageType =
                                  imageFile.path.split('.').last;
                              final result =
                                  await FlutterImageCompress.compressAndGetFile(
                                imageFile.path,
                                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.$dynamicImageType',
                                quality: 85,
                              );

                              if (result != null) {
                                file = File(result.path);
                                print(
                                    'Compressed image saved to: ${result.path}');
                                Navigator.pop(context, file);
                              } else {
                                print('Compression failed.');
                                showSnackBarMessage(
                                    context: navigatorKeyGlobal.currentContext!,
                                    content: 'Trade license failed to upload',
                                    backgroundColor: kErrorColor);
                              }

                            } catch (e) {
                              showErrorToast(context,
                                  "something went wrong please try again");

                              setState(() {
                                isLoading = false;
                              });

                              print(e.toString());
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final MemoryImage image;

  const ResultScreen({
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image(
              image: image,
            ),
            ElevatedButton(
              child: const Text('Back'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

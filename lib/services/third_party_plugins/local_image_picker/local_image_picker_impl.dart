import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:happiness_club_merchant/utils/extensions/extensions.dart';
import 'package:images_picker/images_picker.dart';

import '../../../app/app_usecase/get_image_from_camera.dart';
import '../../../app/app_usecase/pick_multi_images_from_gallery.dart';
import 'local_image_picker.dart';

class LocalImagePickerImpl implements LocalImagePicker {
  final ImagePicker imagePicker;
  final FilePicker filePicker;
  final ImagesPicker newImagesPicker;

  LocalImagePickerImpl(
      {required this.imagePicker,
      required this.filePicker,
      required this.newImagesPicker});

  @override
  Future<List<MediaResponse>> getImageFromCamera(
      GetImageFromCameraParams params) async {
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: params.pickType,
      quality: params.quality,
      maxSize: params.maxSize,
      maxTime: params.maxTime,
    );
    if (res != null) {
      var response = List<MediaResponse>.from(res.map((e) =>
          MediaResponse.fromString(
              filePath: e.path, thumbPath: e.thumbPath, size: e.size)));
      return response;
    }

    throw Exception('unable_to_pick_image'.ntr());
  }

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }

  @override
  Future<String> pickMultipleFilesFromGallery() async {
    FilePickerResult? result =
        await filePicker.pickFiles(type: FileType.any, allowMultiple: true);

    if (result != null) {
      return result.files.single.path!;
    } else {
      throw Exception('unable_to_pick_file'.ntr());
    }
  }

  @override
  Future<List<MediaResponse>> getMultipleImagesFromGallery(
      PickType pickType) async {
    List<Media>? res = await ImagesPicker.pick(
      count: 10,
      pickType: pickType,
      language: Language.System,
      maxTime: 30,
    );

    if (res != null) {
      var response = List<MediaResponse>.from(res.map((e) =>
          MediaResponse.fromString(
              filePath: e.path, thumbPath: e.thumbPath, size: e.size)));
      return response;
    }
    throw Exception('unable_to_pick_file'.ntr());
  }

  @override
  Future<String> pickImage() async {
    var xFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (xFile == null) {
      return '';
    }
    return xFile.path;
  }
}

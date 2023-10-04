
import 'package:camera/camera.dart';
import 'package:images_picker/images_picker.dart';

import '../../../app/app_usecase/get_image_from_camera.dart';
import '../../../app/app_usecase/pick_multi_images_from_gallery.dart';

abstract class LocalImagePicker {
  /// This method returns the image path picked from gallery
  /// Output : if operation successful returns [String] tells image is picked successfully
  Future<List<MediaResponse>> getMultipleImagesFromGallery(PickType pickType);

  /// This method returns the file path picked from gallery
  /// Output : if operation successful returns [String] tells image is picked successfully
  Future<String> pickMultipleFilesFromGallery();


  /// This method returns the image path picked from gallery
  /// Input: [GetImageFromCameraParams] contains camera preference which is rear or front cameras.
  /// Output : if operation successful returns [String] tells image is picked successfully
  Future<List<MediaResponse>> getImageFromCamera(GetImageFromCameraParams params);

  /// This method returns the list of available cameras
  /// Output : if operation successful returns list of [CameraDescription] e.g rare front or external
  Future<List<CameraDescription>> getAvailableCameras();


  /// This method returns the image path selected from gallery
  Future<String>  pickImage();
}
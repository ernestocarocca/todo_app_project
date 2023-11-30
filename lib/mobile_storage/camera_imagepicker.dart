import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();
    final directory =  getApplicationDocumentsDirectory();


     Future<void> captureAndSaveImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    File imageFile = File('$appDocPath/image.jpg');
    // Do something with the imageFile, like saving the captured image
  }

   
  Future<File?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Error while taking photo: $e');
    }
    return null;
  }

 

  Future<void> saveImageToDevice(File image) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      
      // Ange den specifika sökvägen och filnamnet där du vill spara bilden
      String destinationPath = '$appDocPath/my_images/image.jpg';
      
      File newImage = await image.copy(destinationPath);
      print('Image saved at: ${newImage.path}');
    } catch (e) {
      print('Error saving image: $e');
    }
  }
}
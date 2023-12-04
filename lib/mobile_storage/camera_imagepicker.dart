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
    print('Sökväg till den tagna bilden: ${imageFile.path}');
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

    // Ange sökvägen där du vill spara bilden
    String destinationPath = '$appDocPath/images/';

    // Skapa mappen om den inte finns
    await Directory(destinationPath).create(recursive: true);

    // Lägg till filnamnet till sökvägen
    destinationPath += 'image.jpg';

    // Kopiera filen till destinationen
    File newImage = await image.copy(destinationPath);
    print('Bilden sparad på: ${newImage.path}');
  } catch (e) {
    print('Fel vid sparande av bild: $e');
  }
}

}
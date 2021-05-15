import 'package:firebase_storage/firebase_storage.dart';


void uploadFile(user, image){
  Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("profileImages/${user.uid}/$image");
  UploadTask uploadTask = firebaseStorageRef.putFile(image.path);
}
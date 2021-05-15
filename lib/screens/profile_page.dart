import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:async';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var picUserProfileLink;
  File _profileImage;

  Future<String> getUserPicProfile() async{
    Reference ref = FirebaseStorage.instance.ref().child('profilePictures/${widget.user.uid}/${widget.user.uid}');
    var picLink = await ref.getDownloadURL();
    return picLink;
  }


  Future _imgFromCamera() async {
    final image = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    File renamedFile = uploadFile(File(image.path));
  }

  Future _imgFromGallery() async {
    final image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    File renamedImage = uploadFile(File(image.path));
  }
  File uploadFile(image){
    image = changeFileNameOnlySync(image, widget.user.uid);

    String fileName = basename(image.path);


    print("This is the actual image file: $fileName");
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("profilePictures/${widget.user.uid}/$fileName");
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    uploadTask.snapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    return image;
  }

  File changeFileNameOnlySync(File image, String newFileName) {
    var path = image.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return image.renameSync(newPath);
  }

  void _showPicker(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
                ),
                color: Colors.blueGrey[900]
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Photo',
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            _imgFromGallery();
                            Navigator.pop(context);
                          },
                          color: Colors.blueGrey[900],
                          elevation: 0,
                          child: Column(
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/images/gallery_icon.png'),
                                width: 45,
                                height: 45,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat'
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        RaisedButton(
                          onPressed: () {
                            _imgFromCamera();
                            Navigator.pop(context);
                          },
                          color: Colors.blueGrey[900],
                          elevation: 0,
                          child: Column(
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/images/camera_icon.png'),
                                width: 45,
                                height: 45,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat'
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
          );
        }
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncOperation().then((picUserProfile) {
      setState(() {
        picUserProfileLink = picUserProfile.toString();
        print("THIS IS THE OTHER LINK: $picUserProfileLink");
      });
      print("Success!");
    }).catchError((error, stackTrace){
      print("Outer: $error");
    });
    }
  Future<String> asyncOperation() async{
    var picUserProfile = getUserPicProfile();
    return picUserProfile;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.5, 0.7, 0.9],
                colors: [
                  Colors.purple[900],
                  Colors.purple[900],
                  Colors.purple[900],
                  Colors.purple[900],
                ]
            )
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: 40),
                  Container(
                    height: 140,
                    width: 140,
                    child: CircleAvatar(
                      backgroundImage: picUserProfileLink == null
                      ? AssetImage('assets/images/noProfilePic.jpg')
                      : NetworkImage(picUserProfileLink),
                      backgroundColor: Colors.black,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      onPressed: (){
                        _showPicker(context);
                      },
                      backgroundColor: Colors.green,
                      child: Icon(Icons.camera_alt_rounded, color: Colors.white, size:19),
                    ),
                  )
                ],
              ),
            ),
            RaisedButton(
              highlightColor: Colors.white10,
              color: Colors.purple[900],
              elevation: 0,
              onPressed: (){
                Navigator.pushNamed(context, '/editProfile');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12.5,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              widget.user.displayName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.1,
              color: Colors.grey[400],
              indent: 65,
            ),
            RaisedButton(
              highlightColor: Colors.white10,
              color: Colors.purple[900],
              elevation: 0,
              onPressed: (){
                Navigator.pushNamed(context, '/editProfile');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Icon(
                            Icons.alternate_email_rounded,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Username',
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12.5,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              widget.user.displayName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.1,
              color: Colors.grey[400],
              indent: 65,
            ),
          ],
        ),
      ),
      onRefresh: _refreshPage,
    );
  }

  Future<void> _refreshPage() {
    initState();
  }
}

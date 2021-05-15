import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:purple_app/post_model.dart';
import 'package:purple_app/backend/database.dart';
import 'package:purple_app/screens/home_page.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class CreatePostPage extends StatefulWidget {
  User user;
  CreatePostPage(this.user);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> with SingleTickerProviderStateMixin{
  AnimationController controller;
  File postImage;
  String postImageLink = 'null';

  final myController = TextEditingController();
  TextStyle textFieldStyle = TextStyle(fontSize: 8.0, fontFamily: 'Montserrat', fontStyle: FontStyle.italic, color: Colors.white);

  @override
  void initState(){
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.purple[900],
                    Colors.purple[900],
                    Colors.purple[700],
                    Colors.purple[700],
                  ]
              )
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_comment_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'What purple you have',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'to say to the world?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 8,
                        color: Colors.grey[800],
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 5),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: myController,
                                    autocorrect: false,
                                    decoration: new InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                        labelStyle: textFieldStyle.copyWith(fontSize: 18),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: new BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: new OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: new BorderSide(color: Colors.white),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1.5,
                                            )
                                        ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.5,
                                          )
                                      ),
                                    ),
                                    cursorColor: Colors.white,
                                    minLines: 2,
                                    maxLines: 15,
                                    validator: (val){
                                      if(val.length == 0){
                                        return 'Purple cannot be empty';
                                      }else{
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    style: textFieldStyle.copyWith(fontSize: 16),
                                  ),

                                ],
                              )
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                postImage != null
                                    ? Container(
                                  width: double.infinity,
                                  height: 390,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(postImage)
                                    ),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(5.5)),
                                  ),
                                )
                                    : SizedBox(height: 0.1),

                              ],
                            )
                          ],
                        )
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 10,
                        onPressed: () {
                          _showPicker(context);
                        },
                        color: Colors.blue[800],
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Add',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.white,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      RaisedButton(
                        elevation: 10,
                        onPressed: () async{
                          if(postImage != null){
                            postImageLink = await uploadFile(postImage, postImageLink);
                            print("Post Image Link: $postImageLink");
                            String content = myController.text;
                            String time = getTime();
                            String profilePicLink = await getUserPicProfile();
                            profilePicLink = profilePicLink.toString();
                            var post = new Post(content, widget.user.displayName, profilePicLink, postImageLink, time);
                            post.setId(savePost(post));
                            _showDialog(context);
                            startTimer(context);
                          }
                          else{
                            String content = myController.text;
                            String time = getTime();
                            String profilePicLink = await getUserPicProfile();
                            profilePicLink = profilePicLink.toString();
                            var post = new Post(content, widget.user.displayName, profilePicLink, postImageLink, time);
                            post.setId(savePost(post));
                            _showDialog(context);
                            startTimer(context);
                          }
                        },
                        color: Colors.green[700],
                        child: Row(
                          children: [
                            Text(
                              'Post',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.whatshot_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50)
                ],
              )
            ),
          )
      ),
    );
  }

  String getTime() {
    final now = new DateTime.now();
    String time = DateFormat('yMd').format(now);
    return time;
  }

  void startTimer(context) async{
    Timer(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(widget.user)));
    });
  }
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 25),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            elevation: 10,
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 0.5, 0.7, 0.9],
                        colors: [
                          Colors.purple[900],
                          Colors.purple[900],
                          Colors.purple[700],
                          Colors.purple[700],
                        ]
                    )
                ),
                child: SpinKitWave(
                  color: Colors.white,
                  size: 90,
                ),
              )
          ),
        );
      },
    );
  }

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

    setState(() {
      postImage = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    final image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      postImage = File(image.path);
    });
  }
  Future<String> uploadFile(image, postImageLink) async {
    String fileName = basename(image.path);

    print("This is the actual image file: $fileName");
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("postImages/${widget.user.uid}/$fileName");
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    postImageLink = await uploadTask.snapshot.ref.getDownloadURL();
    return postImageLink;
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
}

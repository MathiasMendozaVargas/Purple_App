import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Post{
  User user;
  String profilePicLink;
  String content;
  String postImageLink;
  String author;
  String username;
  String defaultPic = 'assets/images/noProfilePic.jpg';
  String time;
  Set usersLiked = {};
  DatabaseReference _id;

  Post(this.content, this.author, this.profilePicLink, this.postImageLink, this.time);

  void likePost(User user) {
    if(this.usersLiked.contains(user.uid)){
      this.usersLiked.remove(user.uid);
    }else{
      this.usersLiked.add(user.uid);
    }
  }

  void setId(DatabaseReference id){
    this._id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'author': this.author,
      'profilePicLink': this.profilePicLink,
      'defaultPic': this.defaultPic,
      'body': this.content,
      'postImageLink': this.postImageLink,
      'username': username,
      'time': this.time,
    };
  }

}

Post createPost(record){
  Map<String, dynamic> attributes = {
    'author': '',
    'profilePicLink': '',
    'content': '',
    'postImageLink': '',
    'time': '',
  };


  record.forEach((key, value) => {attributes[key] = value});

  Post post = new Post(attributes['body'], attributes['author'], attributes['profilePicLink'], attributes['postImageLink'], attributes['time']);

  return post;
}
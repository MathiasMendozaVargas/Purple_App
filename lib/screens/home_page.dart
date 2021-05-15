import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purple_app/post_model.dart';
import 'package:purple_app/screens/createpost_page.dart';
import 'package:purple_app/backend/database.dart';
import 'package:purple_app/screens/purples_feed.dart';
import 'package:purple_app/screens/profile_page.dart';
import 'package:purple_app/screens/camera_page.dart';

// ignore: non_constant_identifier_names


class HomePage extends StatefulWidget {
  final User user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Post> posts = [];

  void updatePosts() {
    getAllPosts().then((posts) => {
      this.setState(() {
        this.posts = posts;
      })
    });
  }

  @override
  void initState(){
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    updatePosts();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        automaticallyImplyLeading: false,
        leadingWidth: 65,
        title: Text(
          'Purple',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            fontStyle: FontStyle.italic
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_vert),
          )
        ],
        backgroundColor: Colors.purple,
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          tabs: [Tab(child: Text('PURPLES', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Montserrat', fontSize: 12),)),
            Tab(child: Text('PROFILE', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Montserrat', fontSize: 12),)),
          ],
          controller: _tabController,
          indicatorColor: Colors.purple,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Image(
            image: AssetImage('assets/images/purple_logo.png'),
            color: Colors.white,
          ),
        )
      ),
      body: TabBarView(
        children: [
          PurplesPage(posts),
          ProfilePage(widget.user)
        ],
        controller: _tabController,
      ),
      floatingActionButton: Container(
        width: 55,
        height: 55,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage(widget.user)));
          },
          backgroundColor: Colors.green[600],
          child: Icon(Icons.edit_outlined),
          elevation: 12.0,
        ),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}

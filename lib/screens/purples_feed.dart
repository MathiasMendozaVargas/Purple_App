import 'package:flutter/material.dart';
import 'package:purple_app/post_model.dart';


class PurplesPage extends StatefulWidget {
  List<Post> posts = [];
  PurplesPage(this.posts);

  @override
  _PurplesPageState createState() => _PurplesPageState();
}

class _PurplesPageState extends State<PurplesPage> {

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Container(
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: ListView.builder(
                itemCount: widget.posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      color: Colors.grey[800],
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 14),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.posts[index].time,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    widget.posts[index].profilePicLink != "null"
                                    ? CircleAvatar(radius: 30, backgroundImage: NetworkImage(widget.posts[index].profilePicLink), backgroundColor: Colors.transparent)
                                    : CircleAvatar(radius: 30, backgroundImage: AssetImage(widget.posts[index].defaultPic), backgroundColor: Colors.transparent),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    widget.posts[index].author,
                                                    style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Montserrat',
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    Icons.verified,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "@${widget.posts[index].author}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    widget.posts[index].content,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          if (widget.posts[index].postImageLink == "null")
                            SizedBox(height: 0.01)
                          else
                            Container(
                              width: double.infinity,
                              height: 390,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.posts[index].postImageLink)
                                ),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.5), bottomRight: Radius.circular(5.5)),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
      ),
      onRefresh: _refreshPage,
    );
  }

  Future<void> _refreshPage() async{
    setState(() {
      initState();
    });
  }
}

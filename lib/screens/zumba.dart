import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'webview.dart';

class Zumba extends StatefulWidget {
  @override
  _ZumbaState createState() => _ZumbaState();
}

class _ZumbaState extends State<Zumba> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('zumba').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading....');
              default:
                return Scrollbar(
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: new ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      String url = document['imageUrl'];
                      return Column(
                        children: <Widget>[
                          new Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove,
                                      color: Colors.red.shade700,
                                      size: 30.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _handleURLButtonPress(
                                          context,
                                          document['link'],
                                          document['title'],
                                        );
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        child: AutoSizeText(
                                          document['title'],
                                          style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 18),
                                          minFontSize: 14,
                                          stepGranularity: 1,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Image(
                                      image: AssetImage('images/lineh.png'),
                                      height: 30.0,
                                      width: 2.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      child: AutoSizeText(
                                        document['level'],
                                        style: TextStyle(
                                            fontFamily: 'Rubik', fontSize: 15),
                                        minFontSize: 13,
                                        stepGranularity: 1,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 25.0,
                                    top: 13,
                                    bottom: 12.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: InkWell(
                                      onTap: () {
                                        _handleURLButtonPress(
                                          context,
                                          document['link'],
                                          document['title'],
                                        );
                                      },
                                      child: Image.network(
                                        url,
                                        height: 53.0,
                                        width: 100.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
            }
          }),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewContainer(url, title),
      ),
    );
  }
}

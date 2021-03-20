import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitility/adminside/screen/createpage.dart';
import 'package:fitility/adminside/screen/deletepage.dart';
import 'package:fitility/services/transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifyPage extends StatefulWidget {
  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  int danceworkout = 1, workoutGenre = 1, level = 1;
  String videoName = "Select";

  TextEditingController videoNameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController videoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        leading: Icon(
          Icons.menu,
          color: Color(0xffdc2126),
          size: 35.0,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 40.0),
            Image.asset(
              'images/logo.png',
              height: 35.0,
            ),
            SizedBox(width: 5.0),
            Text(
              "Fitility Admin",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          child: Container(
            color: Color(0xffdc2126),
            height: 2.5,
          ),
          preferredSize: Size.fromHeight(2.5),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        FadeRoute(page: CreatePage()),
                      );
                    },
                    child: CategoryTile(
                      categoryname: "Create",
                      isModify: false,
                    ),
                  ),
                  CategoryTile(
                    categoryname: "Modify",
                    isModify: true,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        FadeRoute(page: DeletePage()),
                      );
                    },
                    child: CategoryTile(
                      categoryname: "Delete",
                      isModify: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              MainTitleText(text: "Update a Video"),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                height: 2.0,
                color: Color(0xffdc2126),
              ),
              SizedBox(height: 20.0),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Video Name",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('videos')
                            .orderBy('videoname', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );

                          return Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: videoName,
                                onChanged: (value) {
                                  setState(() {
                                    videoName = value;
                                    videoNameController.text = videoName;
                                    snapshot.data.documents.map((document) {
                                      if (document['videoname'] == videoName)
                                        descriptionController.text =
                                            document['description'];
                                      videoController.text = document['ytlink'];
                                    }).toList();
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                                dropdownColor: Colors.grey[100],
                                isExpanded: true,
                                isDense: true,
                                hint: Text(
                                  videoName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                items: snapshot.data != null
                                    ? snapshot.data.documents
                                        .map<DropdownMenuItem<String>>(
                                          (value) =>
                                              new DropdownMenuItem<String>(
                                            value: value['videoname'],
                                            child: new Container(
                                              child:
                                                  new Text(value['videoname']),
                                            ),
                                          ),
                                        )
                                        .toList()
                                    : DropdownMenuItem(
                                        value: 'null',
                                        child: new Container(
                                          child: new Text('null'),
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              AbsorbPointer(
                absorbing: videoName == "Select" ? true : false,
                child: Opacity(
                  opacity: videoName == "Select" ? 0.3 : 1.0,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.red[800],
                                    size: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 45.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.black,
                                  ),
                                  child: TextField(
                                    controller: videoNameController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      hintText: "Video name",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.red[800],
                                    size: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.black,
                                  ),
                                  child: TextField(
                                    controller: descriptionController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      hintText: "Description of video",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Genre",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.red[800],
                                    size: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      activeColor: Colors.red[800],
                                      value: 1,
                                      groupValue: danceworkout,
                                      onChanged: (val) {
                                        setState(() {
                                          danceworkout = val;
                                        });
                                      },
                                    ),
                                    Text(
                                      "Dance",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Radio(
                                      activeColor: Colors.red[800],
                                      value: 2,
                                      groupValue: danceworkout,
                                      onChanged: (val) {
                                        setState(() {
                                          danceworkout = val;
                                        });
                                      },
                                    ),
                                    Text(
                                      "Workout",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      (danceworkout == 2)
                          ? Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Workout\nGenre",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.red[800],
                                              size: 10.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 11.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Radio(
                                                    activeColor:
                                                        Colors.red[800],
                                                    value: 1,
                                                    groupValue: workoutGenre,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        workoutGenre = val;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Zumba",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 20.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Radio(
                                                    activeColor:
                                                        Colors.red[800],
                                                    value: 2,
                                                    groupValue: workoutGenre,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        workoutGenre = val;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Pillates",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Radio(
                                                    activeColor:
                                                        Colors.red[800],
                                                    value: 3,
                                                    groupValue: workoutGenre,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        workoutGenre = val;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Steppers",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Radio(
                                                    activeColor:
                                                        Colors.red[800],
                                                    value: 4,
                                                    groupValue: workoutGenre,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        workoutGenre = val;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "HIIT",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 20.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Radio(
                                                    activeColor:
                                                        Colors.red[800],
                                                    value: 5,
                                                    groupValue: workoutGenre,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        workoutGenre = val;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    "Bootcamp",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                activeColor: Colors.red[800],
                                                value: 6,
                                                groupValue: workoutGenre,
                                                onChanged: (val) {
                                                  setState(() {
                                                    workoutGenre = val;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Bolly-Aero",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Text(
                                                "Level",
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                  Icons.star,
                                                  color: Colors.red[800],
                                                  size: 10.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 12.0),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Radio(
                                                        activeColor:
                                                            Colors.red[800],
                                                        value: 1,
                                                        groupValue: level,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            level = val;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Beginner",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5.0),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Radio(
                                                        activeColor:
                                                            Colors.red[800],
                                                        value: 2,
                                                        groupValue: level,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            level = val;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Intermediate",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Radio(
                                                        activeColor:
                                                            Colors.red[800],
                                                        value: 3,
                                                        groupValue: level,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            level = val;
                                                          });
                                                        },
                                                      ),
                                                      Text(
                                                        "Advanced",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Image",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.red[800],
                                    size: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 50.0),
                            Icon(Icons.add_a_photo, size: 30.0),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Video Link",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.red[800],
                                    size: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: Colors.black,
                                  ),
                                  child: TextField(
                                    controller: videoController,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      hintText: "Youtube link",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Colors.red[800],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String categoryname;
  final bool isModify;
  CategoryTile({this.categoryname, this.isModify});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
        color: isModify ? Color(0xffdc2126) : Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 1.0,
            blurRadius: 2.0,
            offset: Offset(2.0, 5.0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          categoryname,
          style: TextStyle(
            color: isModify ? Colors.white : Color(0xff181818),
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Rubik' 'Regular',
          ),
        ),
      ),
    );
  }
}

class MainTitleText extends StatelessWidget {
  final String text;
  MainTitleText({this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.0,
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'images/bullet.png',
            height: 6.0,
            width: 15.0,
          ),
        ),
        SizedBox(width: 5.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik Medium' 'Regular',
            color: Color(0xff181818),
          ),
        ),
      ],
    );
  }
}

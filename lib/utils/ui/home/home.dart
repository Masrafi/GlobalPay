import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:globalpay/components/style/color.dart';
import 'package:globalpay/utils/ui/internet_check.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/api/config.dart';
import '../../../features/database/database.dart';
import '../../../features/model/sql_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var colorfactory = ColorFactory();
  late String title, rating, description, price, image;
  var id;
  late List<Note> notes;
  late List<Note> idD;
  bool isLoading = false;
  late int a;
  bool showSpinner = false;
  var deleteID;
  //Api calling method
  Future progressShowData() async {
    try {
      idD = await NotesDatabase.instance.readAllNotes();
      deleteID = idD[0].id;
      print('This is try catch id: $deleteID');
      await NotesDatabase.instance.delete(deleteID);
    } catch (e) {
      print("This is error in id gate");
    }

    // setState(() {
    //   deleteID = idD[1].id;
    // });
    try {
      final response = await http.get(Uri.parse(Config.PRODUCT_URL));
      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // a = sharedPreferences.getInt('a') ?? 0;
      // print("This is $a");
      // if (deleteID != null) {
      //await NotesDatabase.instance.delete(a);
      // }

      //a++;
      //sharedPreferences.setInt('a', a);
      Map<String, dynamic> map = jsonDecode(response.body);
      setState(() {
        title = map['title'];
        rating = map['rating']['rate'].toString();
        description = map['description'];
        price = map['price'].toString();
        image = map['image'].toString();

        addNote();
      });
    } catch (e) {
      print(e);
    }
  }

  //Save api data to sqflite database
  Future addNote() async {
    print("Thisd is working");
    print(title);
    print(rating);
    print(description);
    print(price);
    print(image);
    final note = Note(
      title: title,
      rating: rating,
      image: image,
      isImportant: true,
      price: price,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressShowData();
    refreshNotes();
    //check interner
    Internet().connectivityChecker();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

//get data from sqflite database
  Future refreshNotes() async {
    notes = await NotesDatabase.instance.readAllNotes();
    // print("This is notes: ${notes[0].id}");
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    refreshNotes();
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      color: colorfactory.black,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: colorfactory.black,
        valueColor: AlwaysStoppedAnimation<Color>(colorfactory.green),
      ),
      child: Scaffold(
        backgroundColor: colorfactory.theme,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 18,
                  bottom: MediaQuery.of(context).size.height / 50,
                  //left: MediaQuery.of(context).size.width / 3.5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: colorfactory.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                            progressShowData();
                          });
                        },
                        child: Center(
                          child: Text(
                            'Reload',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.5,
                              fontSize: MediaQuery.of(context).size.height / 45,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 35,
                        color: colorfactory.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                      ),
                      onPressed: () async {
                        print(id);
                        await NotesDatabase.instance.delete(id);
                      },
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: refreshNotes(),
                builder: (BuildContextcontext, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    //   studlist = notes;
                    return Center(
                        child: Text("You have an error in loadingdata"));
                  }
                  if (snapshot.hasData) {
                    if (notes.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: notes.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("This is index: $index");
                          final st = notes[index];
                          id = st.id;
                          return Stack(
                            children: [
                              Container(
                                //height: MediaQuery.of(context).size.height / 1.22,
                                margin: EdgeInsets.only(
                                  // top: MediaQuery.of(context).size.height / 200,
                                  right: MediaQuery.of(context).size.width / 15,
                                  left: MediaQuery.of(context).size.width / 15,
                                  bottom:
                                      MediaQuery.of(context).size.width / 30,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              40,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        right:
                                            MediaQuery.of(context).size.height /
                                                30,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                            ),
                                            child: Text.rich(
                                              TextSpan(
                                                  text: 'X',
                                                  style: TextStyle(
                                                    //color: color.theme,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            30,
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: 'E',
                                                      style: TextStyle(
                                                        color: colorfactory
                                                            .theme
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            30,
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),

                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  14,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8,
                                              decoration: BoxDecoration(
                                                color: Color(0xffFBF6F3)
                                                    .withOpacity(0.4),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                '\u2764',
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          25,
                                                ),
                                              ))),
                                          // Image.asset(
                                          //   'assets/thumbnail.png',
                                          //   height: MediaQuery.of(context).size.height / 30,
                                          // )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              30,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xffD1EFF7).withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          st.createdTime
                                              .toString()
                                              .substring(0, 10),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.w700,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                55,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  50,
                                            ),
                                            decoration: new BoxDecoration(
                                              color: Color(0xffFCDFDF),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  15,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6,
                                            decoration: new BoxDecoration(
                                              color: Color(0xffFFEADC),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                11,
                                          ),
                                          child: Center(
                                            child: Image.network(
                                              '${st.image}',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffD1EFF7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffD1EFF7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Container(
                                          width: 30,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            color: Color(0xffD1EFF7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffD1EFF7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffD1EFF7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50,
                                    ),
                                    Container(
                                      //height: MediaQuery.of(context).size.height / 1.22,

                                      decoration: BoxDecoration(
                                        color: Color(0xffF7F7F7),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  st.title
                                                      .toString()
                                                      .substring(0, 15),
                                                  style: TextStyle(
                                                    color: colorfactory.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            40,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Color(0xffF3D05B)
                                                          .withOpacity(0.6),
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              30,
                                                    ),
                                                    Text(
                                                      "(${st.rating.toString()})",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            50,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                200,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                            child: Text(
                                              st.description
                                                  .toString()
                                                  .substring(0, 50),
                                              style: TextStyle(
                                                color: colorfactory.black
                                                    .withOpacity(0.3),
                                                fontWeight: FontWeight.w700,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    50,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                150,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Size:",
                                                  style: TextStyle(
                                                    color: colorfactory.black
                                                        .withOpacity(0.2),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            50,
                                                  ),
                                                ),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      25,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      15,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffD1EFF7),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "US 6",
                                                      style: TextStyle(
                                                        color: colorfactory
                                                            .black
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            45,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "US 7",
                                                  style: TextStyle(
                                                    color: colorfactory.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            45,
                                                  ),
                                                ),
                                                Text(
                                                  "US 8",
                                                  style: TextStyle(
                                                    color: colorfactory.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            45,
                                                  ),
                                                ),
                                                Text(
                                                  "US 9",
                                                  style: TextStyle(
                                                    color: colorfactory.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            45,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                100,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  30,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Available Color:",
                                                  style: TextStyle(
                                                    color: colorfactory.black
                                                        .withOpacity(0.2),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            45,
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffFFD347)
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffF95A5E)
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffF5A5E0)
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xff67A1FC)
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      30,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 0,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        30,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            40,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .monetization_on_outlined,
                                                            size: 20,
                                                            color: colorfactory
                                                                .black
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                          Text(
                                                            st.price,
                                                            style: TextStyle(
                                                              color: colorfactory
                                                                  .black
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  40,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.add_chart,
                                                            color: colorfactory
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                30,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Add To Cart",
                                                            style: TextStyle(
                                                              color: colorfactory
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  48,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      60,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        6.5,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            6.5,
                                                  ),
                                                  child: Divider(
                                                    color: colorfactory.black
                                                        .withOpacity(0.1),
                                                    thickness: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

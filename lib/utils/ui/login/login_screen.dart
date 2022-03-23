import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:globalpay/components/style/color.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _pass = new TextEditingController();
  var _email = new TextEditingController();
  bool colorEmailIcon = false;
  bool colorPassIcon = false;
  bool colorEmailText = false;
  bool colorPassText = false;
  bool _obscureText = true;
  var colorFactory = new ColorFactory();
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 40,
                right: MediaQuery.of(context).size.height / 40,
                top: MediaQuery.of(context).size.height / 40,
                bottom: MediaQuery.of(context).size.height / 40,
              ),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
                left: MediaQuery.of(context).size.height / 40,
                right: MediaQuery.of(context).size.height / 40,
                // top: displayWidth(context) * .04,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/registration.png',
                        //height: MediaQuery.of(context).size.height / 30,
                        width: MediaQuery.of(context).size.width / 20,
                      ),
                      Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 40,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        colorEmailIcon = true;
                        colorPassIcon = false;
                        colorEmailText = true;
                        colorPassText = false;
                      });
                    },
                    cursorColor: colorFactory.green,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    style: TextStyle(color: colorFactory.green),
                    validator: (val) => val!.isEmpty || !val.contains("@")
                        ? "Enter a valid eamil"
                        : null,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorFactory.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorFactory.green),
                        ),
                        //border: InputBorder.none,
                        // contentPadding: EdgeInsets.only(top: 14, left: 20, right: 20),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            FontAwesomeIcons.envelope,
                            color: colorEmailIcon == true
                                ? colorFactory.green
                                : colorFactory.black,
                            size: 20,
                          ), // Change this icon as per your requirement
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: colorEmailIcon == true
                              ? colorFactory.green
                              : colorFactory.black,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        colorEmailIcon = false;
                        colorPassIcon = true;
                        colorPassText = true;
                        colorEmailText = false;
                      });
                    },
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    //controller: _pass,
                    controller: _pass,
                    style: TextStyle(color: colorFactory.green),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Password is empty';
                      } else if (val.trim().length < 8) {
                        return "Give at least 6 characters";
                      }
                    },
                    cursorColor: colorFactory.green,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorFactory.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: colorFactory.green),
                        ),
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          top: 14,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            FontAwesomeIcons.key,
                            color: colorPassIcon == true
                                ? colorFactory.green
                                : colorFactory.black,
                            size: 20,
                          ), // Change this icon as per your requirement
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            _toggle();
                          },
                          child: Icon(
                            FontAwesomeIcons.eye,
                            color: colorFactory.black,
                            size: 20,
                          ),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: colorPassText == true
                              ? colorFactory.green
                              : colorFactory.black,
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 45,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 270, right: 20, top: 50),
              height: 45,
              decoration: BoxDecoration(
                color: colorFactory.green,
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
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  }
                },
                child: Center(
                  child: Text(
                    'Log In',
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
          ],
        ),
      ),
    );
  }
}

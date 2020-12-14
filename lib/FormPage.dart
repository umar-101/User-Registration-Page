import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'InputDeco_design.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _auth = FirebaseAuth.instance;

  String name, email, password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  File _image;
  final _picker = ImagePicker();
  _openGallery(BuildContext context) async {
    var pickedFile = await _picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no Image Selected');
      }
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Choose Profile Photo',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Future<void> uploadFile(String filePath) async {
  //   File _image = File(filePath);

  //   try {
  //     await firebase_storage.FirebaseStorage.instance
  //         .ref('uploads/$_image')
  //         .putFile(_image);
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
                colors: [Color(0xFF53A3FF), Color(0xFF31CF99)])),

        //Color(0xFF53A3FF), Color(0xFF31CF99)
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CREATE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'YOUR ACCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showChoiceDialog(context);
                              },
                              child: _image == null
                                  ? CircleAvatar(
                                      radius: 50.0,
                                      child:
                                          Icon(Icons.add_a_photo, size: 50.0),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                        width: 70.0,
                                        height: 70.0,
                                      ),
                                    ),
                            ),
                            SizedBox(width: 20.0),
                            Text(
                              'Upload Profile Picture',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 17.0,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration:
                          buildInputDecoration(Icons.person, "Username"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter your Username';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.email, "Email"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter your Email';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'Please Enter valid Email';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        email = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.lock, "Password"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a Enter your Password';
                        }
                        if (value.length < 8) {
                          return 'Password must be atleast 8 characters';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        password = value;
                      },
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          //Navigate to LoginIn Screen.
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                    width: 230,
                    height: 45,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          try {
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            print(e);
                          }
                          return;
                        } else {
                          print("UnSuccessfull");
                        }
                        uploadFile('uploads/$_image');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      textColor: Colors.black,
                      child: Text("SIGN UP"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

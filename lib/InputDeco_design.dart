import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    hintStyle: TextStyle(color: Colors.black54),
    prefixIcon: Icon(
      icons,
      //color: Colors.black54,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.white, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.5,
      ),
    ),
  );
}

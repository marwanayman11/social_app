import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      elevation: 20,
      selectedLabelStyle:GoogleFonts.actor(),
      unselectedLabelStyle: GoogleFonts.actor(),
    ),
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        elevation: 0,
        //backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        )),
    textTheme: TextTheme(
      bodyText1: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
      bodyText2: TextStyle(color: Colors.grey[600], fontSize: 15),
    ));
ThemeData darkTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      elevation: 20,
      selectedLabelStyle:GoogleFonts.actor(),
      unselectedLabelStyle: GoogleFonts.actor(),
    ),
    scaffoldBackgroundColor: Colors.black,
    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
    primarySwatch: Colors.blue,
    appBarTheme:  AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: Colors.white
      ),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        elevation: 0,
        //backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        )),
    textTheme: TextTheme(
      bodyText1: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
      bodyText2: TextStyle(color: Colors.grey[600], fontSize: 15),
    ));
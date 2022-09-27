import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF212121);
const backgroundColor = Color(0xFF323232);
const secondaryColor = Color(0xFF757575);
// const gradientStartColor = Color(0xFF0050AC);
// const gradientEndColor = Color(0xFF9354B9);

// const gradientStartColor = Color.fromARGB(255, 55, 111, 214);
// const gradientEndColor = Color.fromARGB(255, 42, 18, 56);

const gradientStartColor = Color.fromARGB(255, 145, 183, 253);
const gradientEndColor = Color.fromARGB(255, 25, 34, 122);

ThemeData getThemeData(BuildContext context) => ThemeData(
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white70,
      textTheme: ButtonTextTheme.primary,
      colorScheme:
          Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // floatingLabelStyle: GoogleFonts.montserrat(
      //     fontWeight: FontWeight.w500, fontSize: 12, color: Colors.teal),
      labelStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 71, 180, 75),
      textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
    )),
    primaryColor: primaryColor,
    primarySwatch: Colors.indigo,
    textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white));

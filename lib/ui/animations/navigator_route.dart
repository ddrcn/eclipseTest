import 'package:flutter/material.dart';

Route scaleRoute(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //const begin = Offset(0.0, 0.0);
      //const end = Offset(1.0, 1.0);
      const curve = Curves.easeIn;

      var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

      return ScaleTransition(
        scale: animation.drive(tween),
        child: child,
      );
    },
  );
}

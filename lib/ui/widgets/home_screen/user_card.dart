import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/utils/app_theme.dart';

/// Карточка пользователя на главном экране, состоящая из name и username
class UserCard extends StatelessWidget {
  final String name;
  final String username;
  final void Function() onTap;

  const UserCard(
      {Key? key,
      required this.name,
      required this.username,
      required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.overlay,
              borderRadius: BorderRadius.circular(10),
              color: primaryColor.withOpacity(0.5)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                username.length < 50
                    ? Text(
                        username,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        username,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(
                  height: 20,
                ),
                name.length < 50
                    ? Text(
                        name,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        name,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
              ])),
    );
  }
}

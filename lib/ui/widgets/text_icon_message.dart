import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Колонка из текста и изображения
class TextIconMessage extends StatelessWidget {
  const TextIconMessage({
    required this.message,
    this.imgPath = '',
    Key? key,
  }) : super(key: key);

  final String message;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            message,
            style: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        imgPath.isEmpty
            ? const SizedBox()
            : Image.asset(
                imgPath,
                height: 250,
                width: 250,
              ),
      ],
    );
  }
}

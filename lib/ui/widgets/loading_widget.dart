import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Индикатор загрузки данных
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Загрузка...',
          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Image.asset(
          'assets/loading.gif',
          height: 50,
          width: 50,
        ),
      ],
    );
  }
}

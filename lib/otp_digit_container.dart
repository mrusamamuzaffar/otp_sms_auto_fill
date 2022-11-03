import 'package:flutter/material.dart';

class OtpDigitContainer extends StatelessWidget {
  const OtpDigitContainer({Key? key, required this.digit}) : super(key: key);

  final String digit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

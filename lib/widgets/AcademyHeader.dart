import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AcademyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/icons/logo.jpeg',
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.width / 1.2,
            )),
      ],
    );
  }
}

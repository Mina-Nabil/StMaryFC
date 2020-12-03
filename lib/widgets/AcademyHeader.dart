import 'dart:math';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AcademyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    double logoDimention = min(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height) / 1.2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
            tag: 'logo',
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Image.asset(
                'assets/icons/logo.jpeg',
                width: logoDimention,
                height: logoDimention,
              ),
            )),
      ],
    );
  }
}

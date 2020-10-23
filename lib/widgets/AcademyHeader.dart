import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AcademyHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/icons/logo.jpeg',
          width:  MediaQuery.of(context).size.width/1.5,
          height: MediaQuery.of(context).size.width/1.5,
        ),
      ],
    );
  }
  
}
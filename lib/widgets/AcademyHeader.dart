import 'package:flutter/material.dart';

class AcademyHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/church.png'),
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      'St. Mary Rehab Football Academy',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24
                      ),
                    ),
                  )
                ],
              );
  }
  
}
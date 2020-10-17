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
                    child: FittedBox(
                      child: Text(
                        'ST. MARY REHAB FOOTNALL ACADEMY',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      'PLAY | PRAY | OBEY',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22
                      ),
                    ),
                  )
                ],
              );
  }
  
}
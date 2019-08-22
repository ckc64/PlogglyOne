import 'package:flutter/material.dart';


class StepCircle extends StatelessWidget {
  String txt;
  double padL,padT,padR,padB;
  StepCircle({@required this.txt,
  this.padL,this.padT,this.padR,this.padB});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(this.padL,this.padT,this.padR,this.padB),
                decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle                  
                ),                         
                   
                     
                    child: Text(this.txt,
                      style: TextStyle(
                        fontSize: 40.0,
                        
                        fontFamily: 'Pacifico',
                        color: Colors.white
                      ),
                  ),
                   
           
    );
  }
}
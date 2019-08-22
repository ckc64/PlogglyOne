import 'package:flutter/material.dart';


class StepCircle extends StatelessWidget {
  String txt;
  Color color;
  double padL,padT,padR,padB;
  StepCircle({@required this.txt,
  this.padL,this.padT,this.padR,this.padB,
  this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(this.padL,this.padT,this.padR,this.padB),
                decoration: BoxDecoration(
                  
                    color: this.color,
                    shape: BoxShape.circle                  
                ),                         
                   
                     
                    child: Text(this.txt,
                      style: TextStyle(
                        fontSize: 28.0,
                        
                        fontFamily: 'Pacifico',
                        color: Colors.white
                      ),
                  ),
                   
           
    );
  }
}
import 'package:flutter/material.dart';
class CustomBackButton extends StatelessWidget {
  final String text;  
  CustomBackButton({
    this.text,   
  });


    Widget _buildWithText() {
    return FittedBox(
          child: Container(      
            padding: const EdgeInsets.only(left: 2, right: 7, top: 1, bottom: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30, width: 2),
              color: Colors.black54,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white.withOpacity(0.87),
                    size: 20,
                  ),
                  VerticalDivider(
                    color: Colors.white30,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(text,
                        style: TextStyle(
                            
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.87))),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildWithoutText() {
    return
    Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30, width: 2),
          color: Colors.black54,  
          
        ),        
        child:
        Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.87), size: 25,),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(20),      
        splashColor: Colors.black,
        highlightColor: Colors.black,
        onTap: () {
    Navigator.of(context).pop();
        },
        child: text == null ? _buildWithoutText() : _buildWithText()
      );
  }
}

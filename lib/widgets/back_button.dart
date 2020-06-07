import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),      
      splashColor: Colors.black,
      highlightColor: Colors.black,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black45,
        ),
        child: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.87), size: 25,),
      ),
    );
  }
}

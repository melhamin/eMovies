import 'package:flutter/cupertino.dart';
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
                        fontFamily: 'Helvatica',
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
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30, width: 2),
        color: Colors.black54,
      ),
      child: Icon(
        Icons.arrow_back,
        color: Colors.white.withOpacity(0.87),
        size: 25,
      ),
    );
  }

  Widget _buildText() {
    return FittedBox(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30, width: 2),
          color: Colors.black54,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.87),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 50;
    return Container(
      width: width,
      child: Row(
        children: [
          SizedBox(width: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
                borderRadius: BorderRadius.circular(20),                                
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: _buildWithoutText()),
          ),
          if (text != null)
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: _buildText(),
              ),
            ),
        ],
      ),
    );
  }
}

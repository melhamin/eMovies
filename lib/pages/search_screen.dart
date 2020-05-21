import 'package:e_movies/consts/consts.dart';
import 'package:e_movies/providers/lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController;
  var expanded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    expanded = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BASELINE_COLOR,
        title: TextField(
          cursorColor: Theme.of(context).accentColor,
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search movies & TV shows...',
            hintStyle: const TextStyle(color: Colors.white30),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          // onChanged: _updateSearchQuery,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: Container(
            height: 300,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  color: Colors.red,
                  onPressed: () {
                    Provider.of<Lists>(context, listen: false).addToPrefs();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  color: Colors.red,
                  onPressed: () {
                    Provider.of<Lists>(context, listen: false).printPrefs();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ExpandableText extends StatefulWidget {
//   final TextSpan textSpan;
//   final TextSpan moreSpan;
//   final int maxLines;
//   ExpandableText({this.textSpan, this.moreSpan, this.maxLines});
//   @override
//   _ExpandableTextState createState() => _ExpandableTextState();
// }

// // extension _TextMeasurer on RichText {
// //   List<TextBox> measure(BuildContext context, Constraints constraints) {

// //   }
// // }
// extension _TextMeasurer on RichText {
//   List<TextBox> measure(BuildContext context, BoxConstraints constraints) {
//     final renderObject = createRenderObject(context)..layout(constraints);
//     return renderObject.getBoxesForSelection(
//       TextSelection(
//         baseOffset: 0,
//         extentOffset: text.toPlainText().length,
//       ),
//     );
//   }
// }

// class _ExpandableTextState extends State<ExpandableText> {
//   static const String _ellipsis = "\u2026\u0020";
//   bool _isExpanded = false;

//   GestureRecognizer get _tapRecognizer => TapGestureRecognizer()
//     ..onTap = () {
//       setState(() {
//         _isExpanded = !_isExpanded;
//       });
//     };

//   String get _lineEnding => '$_ellipsis${widget.moreSpan.text}';

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         builder: (context, constraints) {
//           final maxLines = widget.maxLines;

//           final richText = Text.rich(widget.textSpan).build(context) as RichText;
//           final boxes = richText.measure(context, constraints);

//           if (boxes.length <= maxLines || _isExpanded) {
//             return RichText(text: widget.textSpan);
//           } else {
//             final croppedText = _ellipsizeText(boxes);
//             final ellipsizedText = _buildEllipsizedText(croppedText, _tapRecognizer);

//             if (ellipsizedText.measure(context, constraints).length <= maxLines) {
//               return ellipsizedText;
//             } else {
//               final fixedEllipsizedText = croppedText.substring(0, croppedText.length - _lineEnding.length);
//               return _buildEllipsizedText(fixedEllipsizedText, _tapRecognizer);
//             }
//           }
//         },
//       );

//     // return LayoutBuilder(
//     //   builder: (context, constraints) {
//     //     final maxLines = widget.maxLines;
//     //     final richText = Text.rich(widget.textSpan).build(context) as RichText;
//     //     final boxes = richText.measure(context, constraints);

//     //     if (boxes.length <= maxLines || _isExpanded) {
//     //       return RichText(text: widget.textSpan);
//     //     } else {
//     //       final croppedText = _ellipsizeText(boxes);
//     //       final ellipsizedText = _buildEllipsizedText(croppedText, _tapRecognizer);

//     //       if(ellipsizedText.measure(context, constraints).length <= maxLines) {
//     //         return ellipsizedText;
//     //       }
//     //       else {
//     //         final fixedEllipsizedText = croppedText.substring(0, croppedText.length - _lineEnding.length);
//     //         return _buildEllipsizedText(fixedEllipsizedText, _tapRecognizer);
//     //       }
//     //     }
//     //   },
//     // );
//   }

// //   String _ellipsizeText(List<TextBox> boxes) {
// //     final text = widget.textSpan.text;
// //     final maxLines = widget.maxLines;

// //     double _calculateLinesLength(List<TextBox> boxes) => boxes
// //         .map((box) => box.right - box.left)
// //         .reduce((acc, value) => acc += value);

// //     final _requiredLength = _calculateLinesLength(boxes.sublist(0, maxLines));
// //     final _totalLength = _calculateLinesLength(boxes);

// //     final _requierdTextFraction = _requiredLength / _totalLength;
// //     return text.substring(0, text.length * _requierdTextFraction.floor());
// //   }

// //   RichText _buildEllipsizedText(String text, GestureRecognizer tapRecognizer) => RichText(
// //   text: TextSpan(
// //     text: '$text$_ellipsis',
// //     style: widget.textSpan.style,
// //     children: [widget.moreSpan],
// //   ),
// // );

// String _ellipsizeText(List<TextBox> boxes) {
//     final text = widget.textSpan.text;
//     final maxLines = widget.maxLines;

//     double _calculateLinesLength(List<TextBox> boxes) => boxes.map((box) => box.right - box.left).reduce((acc, value) => acc += value);

//     final requiredLength = _calculateLinesLength(boxes.sublist(0, maxLines));
//     final totalLength = _calculateLinesLength(boxes);

//     final requiredTextFraction = requiredLength / totalLength;
//     return text.substring(0, (text.length * requiredTextFraction).floor());
//   }

//   RichText _buildEllipsizedText(String text, GestureRecognizer tapRecognizer) => RichText(
//         text: TextSpan(
//           text: "$text$_ellipsis",
//           style: widget.textSpan.style,
//           children: [widget.moreSpan],
//         ),
//       );

// }

// class MyTextPainter extends CustomPainter {
//   final TextSpan text;
//   final int maxLines;
//   final String ellipsis;

//   MyTextPainter({this.text, this.maxLines, this.ellipsis}) : super();

//   @override
//   void paint(Canvas canvas, Size size) {
//     TextPainter painter = TextPainter(
//       text: text,
//       maxLines: maxLines,
//       textDirection: TextDirection.ltr,
//     )..ellipsis = this.ellipsis;
//     painter.layout(maxWidth: size.width);
//     painter.paint(canvas, Offset(0, 0));
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_movies/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyListsItem extends StatelessWidget {
  final Map<String, dynamic> list;
  final Function onTap;
  MyListsItem({this.list, this.onTap});

  // // when length is 1 or 2 crossAxisCount should be 1 (in case 2 since childAspectRatio is 2, each image will occupy half of the space)
  // int _calcCrossAxisCount(int length) {
  //   return length <= 2 ? 1 : 2;
  // }

  // // when length 2 both ratio should be 2 (since crossAxisCount is 1 both images will be visible)
  // double _calcChildAspectRation(int length) {
  //   return length == 2 ? 2 : 1;
  // }

  @override
  Widget build(BuildContext context) {
    final data = list['data'];
    return InkWell(
      onTap: onTap,
      splashColor: Colors.black,
      highlightColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
        margin: const EdgeInsets.only(bottom: 5),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              child: data.length == 0 // no item? show placehlder
                  ? Container(
                      color: Hexcolor('#202020'),
                      child: Icon(
                        Icons.theaters,
                        size: 40,
                        color: Colors.white54,
                      ),
                    )
                  : (data.length > 0 &&
                          data.length < 4) // 0 > items > 4 show only one image
                      ? CachedNetworkImage(
                          imageUrl: data[0]['posterUrl'],
                          fit: BoxFit.cover,
                        )
                      : GridView.builder(
                          // 4 or more items, show grid of four images
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return CachedNetworkImage(
                              imageUrl: data[i]['posterUrl'],
                              fit: BoxFit.cover,
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,                          
                            childAspectRatio: 1,
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft ,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          list['title'],
                          style: kListsItemTitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          data.length == 0
                              ? 'empty'
                              : '${data.length} ' +
                                  (data.length == 1 ? 'item' : 'items'),
                          style: kSubtitle1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
    //  ListTile(
    //   leading: ListItemLeading(list['data']),
    //   title: Text(list['title'], style: kListsItemTitleStyle,),
    //   trailing: Text('${list['data'].length}', style: kSubtitle1,),
    // );
  }
}

class ListItemLeading extends StatelessWidget {
  final List<dynamic> data;
  ListItemLeading(this.data);

  // List<Widget> _buildImges() {
  //   return [
  //     CachedNetworkImage(),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length > 4 ? 4 : data.length,
        itemBuilder: (context, i) {
          return CachedNetworkImage(
            imageUrl: data[i]['imageURL'],
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 0.5,
        ),
      ),
    );
  }
}

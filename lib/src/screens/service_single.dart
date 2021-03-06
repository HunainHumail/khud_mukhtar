import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khud_mukhtar/constants/colors.dart';
import 'package:khud_mukhtar/src/models/user_model.dart';
import 'package:khud_mukhtar/src/screens/profile_screen.dart';
import 'package:khud_mukhtar/src/widgets/loading.dart';

import 'chat_screen.dart';
import 'service_details.dart';

class bottomAppBar extends StatelessWidget {
  final Product product;
  final User user;
  final currentLoggedInuser;

  const bottomAppBar({this.product, this.user, this.currentLoggedInuser});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      Profile(
                        userID: user.id,
                        currentUserId: currentLoggedInuser.uid,
                      )),
                );
              },
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: Image
                            .network(user.imageUrl)
                            .image,
                      ),
                      Positioned(
                        top: 30,
                        bottom: -2,
                        right: -1,
                        left: 30,
                        child: ClipOval(
                          child: Container(
                            width: 0.5,
                            height: 0.5,
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 19.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text(
                            (user.rating ?? 0).toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black45,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            OutlineButton(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.mail_outline,
                      color: pink300,
                      size: 20,
                    ),
                  ),
                  Text(
                    'MESSAGE',
                    style:
                    TextStyle(color: pink300, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              highlightedBorderColor: pink500,
              onPressed: () async {
                FirebaseUser currentUser =
                await FirebaseAuth.instance.currentUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Chat(
                          peerId: user.id,
                          peerAvatar: user.imageUrl,
                          id: currentUser.uid,
                          peerName: user.name,
                        ),
                  ),
                );
              }, //callback when button is clicked
              borderSide: BorderSide(
                color: pink300, //Color of the border
                style: BorderStyle.solid, //Style of the border
                width: 2.5, //width of the border
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceSinglePage extends StatefulWidget {
  static final String path = "lib/src/pages/food/recipe_single.dart";
  Product product;

  ServiceSinglePage({this.product});

  @override
  _ServiceSinglePageState createState() => _ServiceSinglePageState();
}

class _ServiceSinglePageState extends State<ServiceSinglePage> {
  final Color icon = pink300;

  final Color color1 = pink500;

  final Color color2 = pink300;

  final Color color3 = pink300;

  bool isLiked = false;

  FirebaseUser currentLoggedInUser;
  Future getUserInformation() async {
    currentLoggedInUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snapshot = await Firestore.instance
        .collection("Users")
        .document(widget.product.userId)
        .get();
    print("${widget.product.userId} my data");
    return snapshot.data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInformation(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Container(
              color: Colors.white,
              child: Center(child: LoadingView()),
            );
          }

          var user = User.fromMap(snapshot.data);
          //print(user.city);

          return Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: bottomAppBar(
                product: widget.product,
                user: user,
                currentLoggedInuser: currentLoggedInUser,
              ),
            ),
            body: Container(
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 350,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [color2, color3],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                      )),
                  Positioned(
                    top: 350,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.location_on, color: Colors.white),
                              Text(
                                '${user.city} , Pakistan',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "${widget.product.title}".toUpperCase(),
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 25.0),
                          ),
                          SizedBox(height: 5.0),
                          RatingBar(
                            initialRating: user.rating ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Rs. ${widget.product.price}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.servicestack, size: 30,
                                    color: Colors.white,),
                                  SizedBox(height: 5,),

                                  Text(
                                    'Service Type',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  Text(
                                    '${widget.product.serviceType}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Container(
                                height: 60,
                                width: 0.5,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.list, color: Colors.white,
                                    size: 30,),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Category',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  Text(
                                    widget.product.categoryName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Container(
                                height: 60,
                                width: 0.5,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.city, size: 30,
                                    color: Colors.white,),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Area',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  Text(
                                    '${user.area}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 380,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        boxShadow: [
                      BoxShadow(color: Colors.black38, blurRadius: 30.0)
                    ]),
                    child: SizedBox(
                      height: 350,
                      width: double.infinity,
                      child: Image.network(widget.product.mainImage,
                          fit: BoxFit.fill),
                      //Image.asset((widget.product.mainImage), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 325,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: IconButton(
                          color: icon,
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          icon: isLiked
                              ? Icon(
                            FontAwesomeIcons.solidHeart,
                          )
                              : Icon(
                            FontAwesomeIcons.heart,
                          )),
                    ),
                  ),
                  Positioned(
                    top: 325,
                    right: 20,
                    child: RaisedButton(
                      child: Text("Read More".toUpperCase()),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ServiceDetailsPage(
                                    product: widget.product,
                                  )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

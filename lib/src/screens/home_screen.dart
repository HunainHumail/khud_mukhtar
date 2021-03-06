import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khud_mukhtar/src/components/HomeScreenComponents/browse_categories.dart';
import 'package:khud_mukhtar/src/components/HomeScreenComponents/drawer/oval-right-clipper.dart';
import 'package:khud_mukhtar/src/screens/profile_screen.dart';
import 'package:khud_mukhtar/src/screens/search_screen.dart';
import 'package:khud_mukhtar/src/widgets/FeaturedHList.dart';
import 'package:khud_mukhtar/src/widgets/HListViewProducts.dart';

import 'forums/forum.dart';
import 'login_screen.dart';

final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  bool searchEnabled = false;


  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  Future _future;
  double preferredSize = 64;
  static int none = 2;
  FirebaseUser currentUser;
  String city;
  bool absorb = true;

  Future<bool> getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userDocument = await Firestore.instance.collection('Users')
        .document(currentUser.uid)
        .get();
    city = userDocument.data['city'] + ', Pakistan';
    setState(() {
      absorb = false;
    });
    if (city == null) {
      Fluttertoast.showToast(msg: 'Make sure you are connected to internet',
          backgroundColor: Colors.pink,
          textColor: Colors.white);
    }

    return city != null;
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    AssetImage profileimage = AssetImage('assets/momina.jpg'),
        sampleimage = AssetImage('assets/quranforkidssample.jpg');

    // TODO: implement build
    return AbsorbPointer(
      absorbing: absorb,
      child: Scaffold(
        key: _key,
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: Colors.pink[300],
          leading: widget.searchEnabled
              ? Icon(
            Icons.arrow_back,
            color: Colors.white,
          )
              : IconButton(
            onPressed: () {
              _key.currentState.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FutureBuilder(
                  future: _future,
                  builder: (_, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        "$city",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                    return Text('');
                  },
                ),

                Icon(
                  Icons.location_on,
                  color: Colors.white,
                )
              ],
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(preferredSize),
            child: Padding(
              padding:
              const EdgeInsets.only(top: 0, bottom: 25, right: 16, left: 16),
              child: Container(
                alignment: Alignment.center,
                height: preferredSize,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 9,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: TextField(
                        onTap: () {
                          navigateToSubPage(context);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          hintText: "What are you looking for",
                          hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: BrowseCategoriesCard(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FeaturedHList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'All Services',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          height: 200,
                          child: HListViewProducts(),
                        )

                      ],

                    ),
                  ),
                ),
              ]),
            ),

//          SliverGrid.count(
//            crossAxisCount: 2,
//            children: List.generate(4, (index) {
//              return Center(
//                child: AllServicesCard(
//                  product: allProducts[index],
//                  onPress: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => ServiceSinglePage(
//                                product: allProducts[index],
//                              )),
//                    );
//                  },
//                ),
//              );
//            }),
//          )
          ],
        ),
      ),
    );
  }
}

final Color primary = Colors.pink[300];
final Color active = Colors.pink[300];


_buildDrawer(BuildContext context) {
  AssetImage image = new AssetImage('assets/fatima.jpeg');
  return ClipPath(
    clipper: OvalRightBorderClipper(),
    child: Drawer(
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 40),
        decoration: BoxDecoration(
            color: Color.fromRGBO(240, 98, 146, 1),
            boxShadow: [BoxShadow(color: Colors.black45)]),
        width: 300,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print('Logging user out');
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                ),
                ProfileSnippet(),
                SizedBox(height: 30.0),

                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: _buildRow(Icons.person_pin, "Your profile")),
                _buildDivider(),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Forums()));
                    },
                    child: _buildRow(Icons.forum, "Forums")),
                _buildDivider(),
                _buildRow(Icons.settings, "Settings"),
                _buildDivider(),
                _buildRow(Icons.email, "Contact us"),
                _buildDivider(),
                _buildRow(Icons.info_outline, "Help"),
                _buildDivider(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Divider _buildDivider() {
  return Divider(
    color: Colors.white,
  );
}

Widget _buildRow(IconData icon, String title) {
  final TextStyle tStyle = TextStyle(color: Colors.white, fontSize: 16.0);
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(children: [
      Icon(
        icon,
        color: Colors.white,
      ),
      SizedBox(width: 10.0),
      Text(
        title,
        style: tStyle,
      ),
    ]),
  );
}


class ProfileSnippet extends StatelessWidget {
  String imageUrl;
  String userName;


  Future<bool> userMeta() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DocumentReference userDocument = Firestore.instance.collection('Users')
        .document(currentUser.uid);
    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("Users").document(
        currentUser.uid).get();
    if (documentSnapshot != null) {
      imageUrl = documentSnapshot.data['imageUrl'];
      userName = documentSnapshot.data['name'];
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userMeta(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Column(
            children: <Widget>[
              Container(
                height: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(240, 98, 146, 1),
                      Colors.white
                    ])),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                "$userName",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          );
        }
        else {
          return Column(
            children: <Widget>[
              Container(
                height: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(240, 98, 146, 1),
                      Colors.white
                    ])),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                "",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),

            ],
          );
        }
      },
    );
  }
}







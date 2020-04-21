import 'package:flutter/material.dart';
import 'package:khud_mukhtar/src/models/user_model.dart';
import 'package:khud_mukhtar/src/screens/Add_Service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final User user;
  Profile({this.user});

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  //AssetImage profileimage = AssetImage('assets/fatima.jpeg');
var userID  = "xkfGHSZxFTWbg8IOLcQz2SaOWcC3";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyCustomAppBar(userID: userID,),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(240, 98, 146, 1),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddService()));
        },
      ),
      body: SafeArea(

          child: SingleChildScrollView(

            //scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomListView(userID: userID,),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}


class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String userID;
  MyCustomAppBar({this.userID});



  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(250);
  @override
  _MyCustomAppBarState createState() => _MyCustomAppBarState();
}

class _MyCustomAppBarState extends State<MyCustomAppBar> {
  //var userID = "";

  Future getDP() async{
    var userID = widget.userID;
    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("Users").document(userID).get();
    print("HELLO");
    print(documentSnapshot.data);
    return documentSnapshot.data;

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: getDP()
    ,builder: (_, snapshot){
      print(snapshot.data);
     Image myDP = Image.network(snapshot.data['imageUrl']);
     var rating = snapshot.data['rating'] ?? 0;

      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child:Text("Loading!"));
      }

      return Container(
        color: Color.fromRGBO(240, 98, 146, 1),
        child:SafeArea(child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0)),
              child: Container(
                  height: 250.0,
                  color: Color.fromRGBO(240, 98, 146, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Text(snapshot.data['city'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Services',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(snapshot.data['productList'].length.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white))
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
//                                      Text('${widget.user.followers}',
                                  Text(snapshot.data['followers'].toString(),

                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white))
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
//                                      Text('${widget.user.following}',
                                  Text(snapshot.data['following'].toString(),

                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white))
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 80),
                          child: Column(
                            children: <Widget>[
                              Text(snapshot.data['name'].toString(),

                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300),
                              ),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                  ),
//                                      Text('${widget.user.rating}',
                                  Text(rating.toString(),

                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              OutlineButton(
                                  borderSide:
                                  BorderSide(color: Colors.white),
                                  child: Text(
                                    'EDIT PROFILE',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {},
                                  color: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(30.0)))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            Positioned(
              bottom: -20,
              left: 30,
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(240, 98, 146, 1),
                radius: 60,

//                      backgroundImage: AssetImage(widget.user.imageUrl)
                backgroundImage: myDP.image,
              ),
            )
          ],
          alignment: AlignmentDirectional.bottomStart,
          overflow: Overflow.visible,
        ),),);
    });


  }
}


//CustomListView -> Fetches data from Firestore

class CustomListView extends StatefulWidget {
  final String userID;
  CustomListView({this.userID});
  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  //var sampleimage = AssetImage('assets/quranforkidssample.jpg');

  Future getItems() async{
    var firestore = Firestore.instance;
    DocumentSnapshot userDoc =  await firestore.collection("Users").document(widget.userID).get();
    //print(userDoc.data);
    //print(widget.userID);
    if(userDoc.data.containsKey("productList")){

      var myProductIDs = (userDoc.data["productList"]);

     var myProducts = [];
     for(String id in myProductIDs){
       print(id);

       DocumentSnapshot product = await firestore.collection("Products").document(id).get();
       myProducts.add(product);
     }
     return myProducts;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:FutureBuilder(
      future: getItems()
      ,builder:(_, snapshot){

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child:Text("Loading!"));
        }else {
          return

            GridView.count(
              crossAxisCount: 2,
              children:List.generate(snapshot.data.length, (index){
                DocumentSnapshot doc = snapshot.data[index];
                Map product = doc.data;
                Image thumnail = Image.network(product['imageurl']);
                print("Rs "+product['price'].toString());
                return Center(
                  child: Card(

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(width: MediaQuery.of(context).size.width,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: thumnail.image,
                                  ),
                                ),),
                            ),
                            Container(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(product['title']),


                                  Row(
                                    children: <Widget>[

                                      Text("Rs "+product['price'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                                      Spacer(),
                                      Icon(Icons.favorite,color: Colors.red,),
                                      Text(product['likes'].toString(),style: TextStyle(color:Color.fromRGBO(240, 98, 146, 1) ),)
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    elevation: 5.0,
                  ),
                );
              })
        );
        }

      })
    );
  }
}

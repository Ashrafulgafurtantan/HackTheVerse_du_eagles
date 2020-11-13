import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth_gorgeous_login/models/app_gaurd.dart';
import 'package:firebase_auth_gorgeous_login/models/app_user.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:firebase_auth_gorgeous_login/widgets/profile.dart';
import 'package:firebase_auth_gorgeous_login/widgets/search.dart';
import 'package:firebase_auth_gorgeous_login/widgets/upload.dart';
import 'package:flutter/material.dart';
final followerRef = FirebaseFirestore.instance.collection("followers");
final followingRef = FirebaseFirestore.instance.collection("followings");


class Home extends StatefulWidget {
  final AppGuard appGuard;

  Home({this.appGuard});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController _pageController;


  getCurrentUser()async{
   DocumentSnapshot doc =await userRef.doc(widget.appGuard.email).get();//.....
    thisDeviceAppUser = AppUser.fromDocument(doc,doc.id);//...
    print("thisDeviceAppUser = $thisDeviceAppUser");
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Search(),
            Upload(currentUser: thisDeviceAppUser,),
            Profile(),


          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color.fromRGBO(1, 76, 64,1),
        color:  Color.fromRGBO(1,133,120, 0.8),
        index: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(index,duration: Duration(microseconds: 200),curve: Curves.bounceInOut);
        },

        items: <Widget>[

          Icon(Icons.search,size: 30,color: Colors.white),
          Icon(Icons.photo_camera,size: 40,color: Colors.white),
          Icon(Icons.account_circle,size: 30,color: Colors.white ),

        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_gorgeous_login/models/app_user.dart';
import 'package:firebase_auth_gorgeous_login/ui/signIn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_path/storage_path.dart';
import 'package:uuid/uuid.dart';
final storage = FirebaseStorage.instance;
final postRef = FirebaseFirestore.instance.collection("posts");

class Upload extends StatefulWidget {
  final AppUser currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> with AutomaticKeepAliveClientMixin<Upload>{
  TextEditingController captionController;
  TextEditingController locationController;
  File file;
  List<FileModel> fileModel;
  List<Widget> cardList=new List() ;
  List<GridTile>gridTiles=[];
  String postId;

  fromGalleryHandle()async{
    File f=await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 960,maxHeight: 675);
    if(f!=null)

    setState(() {
      file=f;
    });
  }
  fromCameraHandle()async{
    File f=await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 960,maxHeight: 675);
    if(f!=null)

    setState(() {
      file=f;
    });
  }
  GridTile addDefaultTiles(String name,Function handle){
    return  GridTile(child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: handle,
        child: Container(
          height: 50,width: 50,
          decoration: BoxDecoration(
              color: Colors.blueGrey
          ),
          child: Center(child: Text(name,style: TextStyle(color: Colors.white,fontSize: 18),)),
        ),
      ),
    ),);
  }

  uploadImgInFirestore(String mediaUrl,String description,String location){
    postRef.doc(thisDeviceAppUser.email).collection('userPosts').doc(postId).set({
      'postId':postId,
      'ownerMail':thisDeviceAppUser.email,
      'username': thisDeviceAppUser.username,
      'mediaUrl':mediaUrl,
      'description':description,
      'location':location,
      'timestamp':DateTime.now(),
      'likes':{},
    });
  }

  Future<void> uploadImage(imgFile)async{

    UploadTask task = FirebaseStorage.instance.ref('post_$postId.jpg').putFile(file);task.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Snapshot state: ${snapshot.state}'); // paused, running, complete
      print('Progress: ${ (snapshot.bytesTransferred.toDouble()/snapshot.totalBytes.toDouble())*100.00} ');

    }, onError: (Object e) {
      print(e); // FirebaseException
    });
    task.whenComplete(() async{
      String downloadURL = await storage.ref('post_$postId.jpg').getDownloadURL();
      print(downloadURL);
      String cap=captionController.text,location = locationController.text;
      await uploadImgInFirestore(downloadURL,cap,location);
      setState(() {
        locationController.clear();
        captionController.clear();
        file=null;

      });
    });
    task.then((TaskSnapshot snapshot) async{
      print('Upload complete!');
    })
        .catchError((Object e) {
      print(e); // FirebaseException
    });

  }


  getImagesPath() async {

    List<GridTile>tiles=[addDefaultTiles("Camera",fromCameraHandle),addDefaultTiles("Gallery",fromGalleryHandle)];
    String imagespath = "";
    try {
      imagespath = await StoragePath.imagesPath;
      var response = jsonDecode(imagespath);
      var imageList = response as List;

      List<FileModel> list = imageList.map<FileModel>((json) => FileModel.fromJson(json)).toList();

      list.forEach((element)async {
      //  print(element.toString());
        if(element.folder =='Camera'){

          for(int i=0;i<element.files.length && i<10;i++){
            FileImage image=new FileImage(new File(element.files[i]));
           // print(image);
            if(image != null){
              tiles.add(GridTile(child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(child:Container(height:50 ,width: 50,decoration: BoxDecoration(
                    image: DecorationImage(image: image,fit: BoxFit.cover)),),
                  onTap: (){
                    setState(() {
                      file=File(element.files[i]);
                      DraggableScrollableActuator.reset(context);
                    });
                  },
                ),
              ),));
            //  print(tiles.length);
            }

          }
          setState(() {
            gridTiles = tiles;
          });
        }
      });
    } on PlatformException {
      imagespath = 'Failed to get path';
    }
  }

//  grantPermission()async{
//      final picker=ImagePicker();
//      await Permission.photos.request();
//      var permissionStatus = await Permission.photos.status;
//
//      if(permissionStatus.isDenied){
//
//      }else{
//        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
//      }
//  }

  uploadButtonPressed()async{
    await uploadImage(file);
  }

  @override
  void initState() {
    getImagesPath();
    super.initState();
    captionController = TextEditingController();
    locationController = TextEditingController();
    postId=Uuid().v4();
  }
  @override
  bool get wantKeepAlive =>true;
  Widget build(BuildContext context) {
    super.build(context);


    return Scaffold(
//      appBar: AppBar(
//        actions: [
//
//        ],
//      ),
      body: new Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              //   isUploading ? linearProgress() :Text(''),
              file==null? Container(child: Text(""),): ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight:  Radius.circular(40)),
                child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(file),
                              )
                          ),
                        ),


                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(

                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(FontAwesomeIcons.cloudUploadAlt,size: 20,),
                              color: Colors.white,
                              onPressed: uploadButtonPressed,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(

                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              icon: Icon(FontAwesomeIcons.trash,size: 20,),
                              color: Colors.white,
                              onPressed: (){
                                setState(() {

                                  file = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),

              ListTile(
                leading: CircleAvatar(
                  backgroundImage:  NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'),
                  //     NetworkImage(thisDeviceAppUser.photoURL  ),
                  backgroundColor: Colors.grey,
                ),
                title: Container(
                  padding: EdgeInsets.only(top: 7),
                  height: 120,
                  child: TextField(
                    maxLines: 5,
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: 'Write a Caption',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 5,
              ),
              ListTile(
                leading: Icon(Icons.pin_drop,
                  color: Colors.deepOrange,
                  size: 35,
                ),
                title: Container(
                  width: 250,
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                        hintText: 'Where the photo taken',
                        border: InputBorder.none
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 200,
                alignment: Alignment.center,
                child: RaisedButton.icon(
                  color: Colors.blueAccent,
                  icon: Icon(Icons.my_location,
                    color: Colors.white,
                  ),
                  label: Text('Use Current location',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  onPressed: ()async{
//                    final Position position=await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//                    List<Placemark>placemarks=await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
//                    Placemark placemark=placemarks[0];
//                    String formattedAddress='${placemark.locality},${placemark.country}';


                    //  print(thisDeviceAppUser.email);
                    String formattedAddress="Pahartali, Chittagong.";
                    setState(() {
                      locationController.text=formattedAddress;
                    });
                  },
                ),
              )
            ],
          ),
          file!=null? Container():  SizedBox.expand(
            child:DraggableScrollableActuator(
              child: DraggableScrollableSheet(
                initialChildSize: 0.30,
                minChildSize: 0.12,
                maxChildSize: .65,
                builder: (BuildContext c, ScrollController scrollController ){
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,

                      // color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                        )
                      ],

                    ),
                    child: gridTiles==null? CircularProgressIndicator(): ListView(
                      controller: scrollController,
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 8,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text("Select Photo",style: TextStyle(color: Colors.grey,fontSize: 22,fontFamily:"WorkSansSemiBold" ),),
                        SizedBox(height: 10,),
                        GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          physics: NeverScrollableScrollPhysics(),
                          children: gridTiles,
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ) ,
          )
        ],
      ),
    );
  }
}
class FileModel {
  List<String> files;
  String folder;

  FileModel({this.files, this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folder = json['folderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['files'] = this.files;
    data['folderName'] = this.folder;
    return data;
  }

  @override
  String toString() {
    return 'FileModel{ folder: $folder}';
  }

}

/*Center(child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(file),

                        )
                    ),
                  ),),*/
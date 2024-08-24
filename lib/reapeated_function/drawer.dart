import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_app/components/square_tile.dart';
import 'package:my_movie_app/home_page/section_page/authentication/auth_page.dart';
import 'package:my_movie_app/home_page/section_page/favoriate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class drawerfunc extends StatefulWidget {
  drawerfunc({
    super.key,
  });

  @override
  State<drawerfunc> createState() => _drawerfuncState();
}

class _drawerfuncState extends State<drawerfunc> {
  File? _image;

  Future<void> selectImage() async {
    // final pickedfile =
    //     await ImagePicker().(source: ImageSource.gallery);
    // if (pickedfile != null) {
    //   CroppedFile? cropped = await ImageCropper().cropImage(
    //     sourcePath: pickedfile.path,
    //     aspectRatioPresets: [
    //       CropAspectRatioPreset.square,
    //       CropAspectRatioPreset.ratio3x2,
    //       CropAspectRatioPreset.original,
    //       CropAspectRatioPreset.ratio4x3,
    //       CropAspectRatioPreset.ratio16x9
    //     ],
    //   );
    //   SharedPreferences sp = await SharedPreferences.getInstance();
    //   sp.setString('imagepath', cropped!.path);
    //   _image = cropped as File?;
    // } else {
    //   print('No image selected.');
    // }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        _image = File(sp.getString('imagepath')!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(18, 18, 18, 0.9),
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await selectImage();
                        //toast message
                        Fluttertoast.showToast(
                            msg: "Image Changed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: _image == null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_image!),
                            ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                    msg:
                        "This function are test mode, please waiting new feature!");
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                child: Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white30),
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            size: 20,
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Premium Member",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'The best movies are collected\n for you, activate Premium!',
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            listtilefunc('Home', Icons.home, ontap: () {
              //close drawer
              Navigator.pop(context);
            }),
            listtilefunc('Favorite', Icons.favorite, ontap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoriateMovies()));
            }),
            listtilefunc(
              'Our Website',
              FontAwesomeIcons.solidNewspaper,
              ontap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                      appBar: AppBar(
                        backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
                        title: Text('https://www.themoviedb.org/'),
                      ),
                    ),
                  ),
                );
              },
            ),
            listtilefunc('Subscribe US', FontAwesomeIcons.youtube,
                ontap: () async {
              var url = 'https://www.youtube.com/@imdb';
              await launch(url);
            }),
            listtilefunc(
              'About',
              Icons.info,
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
                      title: Text(
                          'Official Application My Movie App. You may get the latest info and watch the best movies and TV series. TMDB API is used to fetch data.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Ok'))
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 105),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12)),
              child:
                  listtilefunc('Log Out', Icons.exit_to_app_rounded, ontap: () {
                //SystemNavigator.pop();
                signUserOut();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

Widget listtilefunc(String title, IconData icon, {Function? ontap}) {
  return GestureDetector(
    onTap: ontap as void Function()?,
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

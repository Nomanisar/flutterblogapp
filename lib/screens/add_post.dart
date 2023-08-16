import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myflutterblogapplication/components/rounded_buttons.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:myflutterblogapplication/screens/homescreen.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final postRef = FirebaseDatabase.instance.ref().child("Posts");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool showSpinner = false;
  String title = "", description = "";
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  Future getImagGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("NO IMAGE SELECTED");
      }
    });
  }

  Future getImagCamera() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("NO IMAGE SELECTED");
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getImagCamera();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.camera_alt,
                        color: Colors.deepPurple,
                      ),
                      title: Text("Camera"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getImagGallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Colors.deepPurple,
                      ),
                      title: Text("Gallary"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            "Upload Blog",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: Container(
                    // height: MediaQuery.of(context).size.height * .2,
                    // width: MediaQuery.of(context).size.width * .1,
                    child: _image != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ClipRRect(
                              child: Image.file(
                                _image!.absolute,
                                width: 350,
                                height: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 100,
                              width: double.infinity,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        onChanged: (value) {
                          value = title;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter Title" : null;
                        },
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter Post Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          value = description;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter Description" : null;
                        },
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Enter Post Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundedButtons(
                  title: "Upload",
                  onPress: () async {
                    _formKey.currentState!.validate();
                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      int date = DateTime.now().millisecondsSinceEpoch;

                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref("/FFBlog$date");

                      UploadTask uploadTask = ref.putFile(_image!.absolute);
                      await Future.value(uploadTask);
                      var newUrl = await ref.getDownloadURL();
                      final User? user = _auth.currentUser;

                      postRef.child("Post List").child(date.toString()).set({
                        "pId": date.toString(),
                        "pImage": newUrl.toString(),
                        "pTime": date.toString(),
                        "pTitle": titleController.text.toString(),
                        "pDescription": descriptionController.text.toString(),
                        "pUserEmail": user!.email.toString(),
                        "pUserId": user.uid.toString(),
                      }).then((value) {
                        toastMessage("Post Published");
                        setState(() {
                          showSpinner = false;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        });
                      }).onError((error, stackTrace) {
                        toastMessage(error.toString());
                        setState(() {
                          showSpinner = false;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(e.toString());
                      toastMessage(e.toString());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myflutterblogapplication/screens/add_post.dart';
import 'package:myflutterblogapplication/screens/option_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String search = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.ref().child("Posts");
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddPost()));
              },
              child: const Icon(
                Icons.add,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                _auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OptionScreen()));
                });
              },
              child: const Icon(
                Icons.logout,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
          ],
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            "New Blog",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Search with blog title",
                  hintStyle: const TextStyle(
                    color: Colors.deepPurple,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                    print(search);
                  });
                },
              ),
              Expanded(
                  child: FirebaseAnimatedList(
                      query: dbRef.child("Post List"),
                      itemBuilder: ((BuildContext context,
                          DataSnapshot snapshot,
                          Animation<double> animation,
                          int index) {
                        String tempTitle =
                            (snapshot.value as Map<dynamic, dynamic>)["pTitle"];
                        if (searchController.text.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .25,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          "assets/images/flutterflow1.png",
                                      image: (snapshot.value
                                          as Map<dynamic, dynamic>)["pImage"],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      (snapshot.value
                                          as Map<dynamic, dynamic>)["pTitle"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      (snapshot.value as Map<dynamic, dynamic>)[
                                          "pDescription"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Posted by"),
                                        Text(
                                          (snapshot.value as Map<dynamic,
                                              dynamic>)["pUserEmail"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else if (tempTitle.toLowerCase().contains(
                            searchController.text.trim().toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .25,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          "assets/images/flutterflow1.png",
                                      image: (snapshot.value
                                          as Map<dynamic, dynamic>)["pImage"],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      (snapshot.value
                                          as Map<dynamic, dynamic>)["pTitle"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      (snapshot.value as Map<dynamic, dynamic>)[
                                          "pDescription"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })))
            ],
          ),
        ),
      ),
    );
  }
}

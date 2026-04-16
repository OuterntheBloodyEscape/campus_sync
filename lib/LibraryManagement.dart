import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Book_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class libraryManagement extends StatefulWidget {
  const libraryManagement({super.key});

  @override
  State<libraryManagement> createState() => _libraryManagementState();
}

MaterialColor checkAvailability(String availability) {
  if (availability == 'Available')
    return Colors.green;
  else
    return Colors.red;
}


Widget TopCards(String asset, String availability, String link) => Card(
  elevation: 5,
  shadowColor: Colors.grey,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  clipBehavior: Clip.antiAlias,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Material(
        color: Colors.transparent,
        child: asset.isEmpty

            ? InkWell(
                onTap: () async {
                  final Uri url = Uri.parse(link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 500,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 100, color: Colors.grey),
                ),
              )

            : Ink.image(
                image: NetworkImage(asset),
                width: double.infinity,
                height: 500,
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () async {
                    final Uri url = Uri.parse(link);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      print("Could not launch $link");
                    }
                  },
                ),
              ),
      ),
      OverflowBar(
        alignment: MainAxisAlignment.end,
        children: [
          TextButton(
            clipBehavior: Clip.antiAlias,
            onPressed: () {},
            child: Text(
              availability,
              style: TextStyle(
                color: checkAvailability(availability),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);

Widget buildUsers(List<Book> books) => ListView.builder(
  shrinkWrap: true,
  physics:
      const NeverScrollableScrollPhysics(),
  itemCount: books.length,
  itemBuilder: (context, index) {
    final book = books[index];
    return TopCards(book.cover, 'Available', book.link);
  },
);
Future<List<Book>> books = getBooks();
Future<List<Book>> getBooks() async {

  const url = 'https://campussync-a8ebc-default-rtdb.firebaseio.com/.json';

  final response = await http.get(Uri.parse(url));
  final dynamic body = json.decode(response.body);

  List<Book> loadedBooks = [];

  // Safety check if database returns nothing
  if (body == null) return loadedBooks;

  // Firebase sees 0, 1, 2 and sends us a clean List!
  if (body is List) {
    for (var item in body) {
      // item is the individual book map (e.g., Jane Austen's book)
      if (item != null) {
        loadedBooks.add(Book.fromJson(item));
      }
    }
  }
  // Just in case Firebase randomly sends it as a Map dictionary
  else if (body is Map) {
    body.forEach((key, value) {
      if (value != null && value is Map) {
        loadedBooks.add(Book.fromJson(value));
      }
    });
  }

  return loadedBooks;
}

class _libraryManagementState extends State<libraryManagement> {
  bool Title = true;
  bool ISBN = false;
  bool Author = false;
  int? groupValue = 0;
  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    double h = ScreenSize.height;
    double w = ScreenSize.width;

    return Scaffold(
      drawer: CustomDrawer(pageNo: 2),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == "profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentProfile()),
                );
              } else {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (route) => false,
                );
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "profile",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.account_circle, color: Colors.black),
                      ),
                      Text("Profile"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "signout",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.logout, color: Colors.black),
                      ),
                      Text("Sign Out"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.blue,
        title: Text("Smart Library", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w / 10,
                  vertical: h / 40,
                ),
                child: SearchAnchor(
                  //viewBackgroundColor: Colors.transparent,
                  //viewElevation: 100.0,
                  viewSurfaceTintColor: Colors.transparent,
                  builder: (BuildContext context, SearchController controller) {
                    return Row(
                      spacing:
                          10, //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            //decoration: BoxDecoration(color: Colors.pink),
                            child: SearchBar(
                              autoFocus: true,
                              controller: controller,
                              hintText: 'Search by Title...',
                              leading: const Icon(Icons.search),
                              onTap: () => controller.openView(),
                              onChanged: (_) => controller.openView(),
                            ),
                          ),
                        ),

                        //SizedBox(width: 50.0,),
                        //Padding(
                        //padding: const EdgeInsets.fromLTRB(
                        // 30.0,
                        //5.0,
                        //0,
                        //5.0,
                        //),
                        // child:
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Flexible(
                            child: Container(
                              //decoration: BoxDecoration(color: Colors.green),
                              child: CupertinoSlidingSegmentedControl(
                                groupValue: groupValue,
                                thumbColor: Colors.blue,
                                backgroundColor: Colors.white,
                                children: {
                                  0: Text('Name'),
                                  1: Text('Author'),
                                  2: Text('ISBN'),
                                },
                                padding: EdgeInsets.all(2.0),
                                onValueChanged: (groupValue) {
                                  setState(() {
                                    this.groupValue = groupValue;
                                    if (this.groupValue == 0) {
                                      ISBN = false;
                                      Author = false;
                                      Title = true;
                                    } else if (this.groupValue == 1) {
                                      ISBN = false;
                                      Author = true;
                                      Title = false;
                                    } else if (this.groupValue == 2) {
                                      ISBN = true;
                                      Author = false;
                                      Title = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        //),
                      ],
                    );
                    //SizedBox(height: 10),

                    //Card(child: SvgPicture.asset('assets/Images/document.svg')),

                    // Card(child: Image.asset('assets/Images/CampusSync.png')),
                  },
                  suggestionsBuilder:
                      (
                        BuildContext context,
                        SearchController controller,
                      ) async {

                        final Future<List<Book>> campusLocations = books;


                        final String keyword = controller.text.toLowerCase();


                        List<Book> resolvedList = await campusLocations;

                        List<Book> filteredList = resolvedList.where((
                          location,
                        ) {
                          if (Title)
                            return location.title.toLowerCase().contains(
                              keyword,
                            );
                          else if (Author)
                            return location.author.toLowerCase().contains(
                              keyword,
                            );
                          else if (ISBN)
                            return location.isbn.toLowerCase().contains(
                              keyword,
                            );
                          return false;
                        }).toList();


                        if (filteredList.isEmpty) {
                          return [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No matching books found.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ];
                        }


                        return filteredList.map((location) {
                          return ListTile(
                            title: Text(location.title),
                            subtitle: Text(location.author),

                            onTap: () async {

                              if (Title)
                                return controller.closeView(location.title);
                              else if (Author)
                                return controller.closeView(location.author);
                              else if (ISBN)
                                return controller.closeView(location.isbn);



                            },
                          );
                        }).toList();
                      },
                ),
              ),
              ListTile(
                title: Text(
                  'Most Searched...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                selectedColor: Colors.grey[350],
              ),
              //buildUsers(books),
              FutureBuilder<List<Book>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return buildUsers(snapshot.data!);
                  } else {
                    return const Center(child: Text("No books available."));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

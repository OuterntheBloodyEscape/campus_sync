import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/basic_custom_data_base.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_sync/main.dart';
import 'Canteen.dart';

class libraryManagement extends StatefulWidget {
  final String logInUser;
  final Map<String, User> ul;
  final List<Note> nl;
  const libraryManagement({
    required this.ul,
    required this.logInUser,
    required this.nl,
    super.key,
  });

  @override
  State<libraryManagement> createState() => _libraryManagementState();
}

MaterialColor checkAvailability(String availability) {
  if (availability == 'Available')
    return Colors.green;
  else
    return Colors.red;
}

Widget TopCards(String asset, String availability) => Card(
  elevation: 5,
  shadowColor: Colors.grey,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  clipBehavior: Clip.antiAlias,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Material(
        color: Colors.transparent,
        child: Ink.image(
          image: AssetImage(asset),
          width: double.infinity,
          height: 500,
          fit: BoxFit.cover,
          child: InkWell(onTap: () {}),
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

class Book {
  final String title;
  final String author;
  final String isbn;
  const Book({required this.title, required this.author, required this.isbn});
}

const allBooks = [
  Book(
    title: 'Fundamentals of Physics',
    author: 'Halliday & Resnick',
    isbn: '00724105101114',
  ),
  Book(
    title: 'Fundamentals of Chemistry',
    author: 'Aristotle',
    isbn: '00724105101116',
  ),
  Book(title: 'Harry Potter', author: 'J. K. Rawlings', isbn: '0072410510130'),
];
List<Book> books = allBooks;

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
      drawer: CustomDrawer(
        ul: widget.ul,
        logInUser: widget.logInUser,
        nl: widget.nl,
        pageNo: 2,
      ),
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
            onSelected: (value) {
              if (value == "profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentProfile(
                      ul: widget.ul,
                      nl: widget.nl,
                      logInUser: widget.logInUser,
                    ),
                  ),
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WelcomeScreen(ul: widget.ul, nl: widget.nl),
                  ),
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
                  value: "Sign out",
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
                    return Row(spacing: 10,//mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Flexible(
                               child: Container(decoration: BoxDecoration(color: Colors.pink),
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
                                    child: Container(decoration: BoxDecoration(color: Colors.green),
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
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    // 1. Your raw data
                    final List<Book> campusLocations = allBooks;

                    // 2. Get what the user is currently typing (converted to lowercase)
                    final String keyword = controller.text.toLowerCase();

                    // 3. Filter the list: keep only items that contain the typed keyword
                    final List<Book> filteredList = campusLocations.where((
                      location,
                    ) {
                      if (Title)
                        return location.title.toLowerCase().contains(keyword);
                      else if (Author)
                        return location.author.toLowerCase().contains(keyword);
                      else if (ISBN)
                        return location.isbn.toLowerCase().contains(keyword);
                      return false;
                    }).toList();

                    // 4. If nothing matches, show a friendly message
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

                    // 5. Map the filtered list into ListTiles
                    return filteredList.map((location) {
                      return ListTile(
                        title: Text(location.title),
                        subtitle: Text(location.author),
                        // Optional: Highlight the search icon to make it look active
                        onTap: () {
                          // Update the search bar with the selected text and close the menu
                          if (Title)
                            return controller.closeView(location.title);
                          else if (Author)
                            return controller.closeView(location.author);
                          else if (ISBN)
                            return controller.closeView(location.isbn);

                          // TODO: Add your navigation or logic here!
                          // print("User selected: $location");
                        },
                      );
                    }).toList();
                  },
                ),
              ),
              ListTile(
                title: Text('Most Searched...'),
                selectedColor: Colors.grey[350],
              ),
              TopCards('assets/Images/physics.jpg', 'Available'),
              SizedBox(height: 10),
              TopCards('assets/Images/chemistry.jpg', 'Available'),
              SizedBox(height: 10),
              TopCards('assets/Images/Harry potter.jpg', 'Unavailable'),
            ],
          ),
        ],
      ),
    );
  }
}

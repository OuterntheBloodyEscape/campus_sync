import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campus_sync/main.dart';
import 'LibraryManagement.dart';

class Canteen extends StatefulWidget {

  const Canteen({

    super.key,
  });

  @override
  State<Canteen> createState() => _CanteenState();
}

Widget TopCards(
  BuildContext context,
  String name,
  String asset,
  String availability,
  String price,
) => Card(
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
          height: 160,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {
              if (availability == 'Available') openDialog(context);
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
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
      ),
    ],
  ),
);

void openDialog(BuildContext context) => showDialog(
  context: context,

  builder: (dialogContext) => AlertDialog(
    title: const Text('Order Quantity'),
    content: const TextField(
      decoration: InputDecoration(hintText: 'Enter Quantity'),
      autofocus: true,
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(dialogContext).pop();
        },
        child: const Text('Order'),
      ),
    ],
  ),
);

class Food {
  final String name;

  const Food({required this.name});
}

const allFoods = [
  Food(name: 'Burger'),
  Food(name: 'Pizza'),
  Food(name: 'Sandwich'),
];
List<Food> foods = allFoods;

class _CanteenState extends State<Canteen> {
  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    double h = ScreenSize.height;
    double w = ScreenSize.width;
    return Scaffold(
      drawer: CustomDrawer( pageNo: 3),
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

                    ),
                  ),
                );
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WelcomeScreen(),
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
        title: Text("Canteen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SearchBar(
                            controller: controller,
                            hintText: 'Search food...',
                            leading: const Icon(Icons.search),
                            onTap: () => controller.openView(),
                            onChanged: (_) => controller.openView(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final List<Food> campusLocations = allFoods;
              final String keyword = controller.text.toLowerCase();
              final List<Food> filteredList = campusLocations.where((
                  location,
                  ) {
                return location.name.toLowerCase().contains(keyword);
              }).toList();
              if (filteredList.isEmpty) {
                return [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No matching found.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ];
              }
              return filteredList.map((location) {
                return ListTile(
                  title: Text(location.name),
                  onTap: () {
                    controller.closeView(location.name);
                  },
                );
              }).toList();
            },
          ),
          ListTile(
            title: Text(
              'Hot Items.....',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: w > 800 ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: .75,

              //padding: const EdgeInsets.all(16.0),
              children: [
                Flexible(
                  child: TopCards(
                    context,
                    'Fried Rice',
                    'assets/Images/Fried Rice.jpeg',
                    'Available',
                    '100Tk',
                  ),
                ),
                Flexible(
                  child: TopCards(
                    context,
                    'Burger',
                    'assets/Images/Burger.jpg',
                    'Available',
                    '200Tk',
                  ),
                ),
                Flexible(
                  child: TopCards(
                    context,
                    'Coffee',
                    'assets/Images/Coffee.jpg',
                    'Unavailable',
                    '300Tk',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

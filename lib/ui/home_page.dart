import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'inventory_location.dart'; // Import the InventoryLocation file
import 'profile.dart'; // Import the Profile file
import 'move_inventory.dart'; // Import the MoveInventory file
import 'add_inventory.dart'; // Import the AddInventory file
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget { // Change the class to a StatefulWidget
  final String token;

  const Dashboard({required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> { // Change the class to a State<Dashboard>
  late String userId;
  late Future<Map<String, String>> _usernameFuture;

  List? items;

  int _currentIndex = 0;
  List<Image> images = [ // Create a list of Image widgets
    Image.asset('images/dispatch.jpeg'),
    Image.asset('images/inv-manager-hero1.jpeg'),
    Image.asset('images/warehouse-guy.jpeg'),
  ];

  @override
  void initState() { // Initialize the userId and _usernameFuture
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    _usernameFuture = _initializePrefs();
  }

  Future<Map<String, String>> _initializePrefs() async { // Initialize SharedPreferences and retrieve the username
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return {'username': username ?? ''};
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) { // Update the UI to display the dashboard
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar( // Add a leading icon button to open the drawer
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
        _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.2,
        backgroundColor: Colors.grey[300],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text( // Display the sidebar title
                'Sidebar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton( // Inventory Location button
              icon: Icon(Icons.pallet),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryLocation()),
                );
              },
              tooltip: 'Inventory Location',
              color: Colors.black,
            ),
            IconButton( // Move Inventory button
              icon: Icon(Icons.forklift),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoveInventory()),
                );
              },
              tooltip: 'Move Inventory',
              color: Colors.black,
            ),
            IconButton( // Add Inventory button
              icon: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddInventory()),
                );
              },
              tooltip: 'Add Inventory',
              color: Colors.black,
            ),
            IconButton( // Profile button
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              tooltip: 'Profile',
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, String>>( // Update FutureBuilder to use Map<String, String>
        future: _usernameFuture,
        builder: (context, snapshot) { // Update the FutureBuilder builder
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) { // Display an error message if SharedPreferences initialization fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else { // Retrieve the username from the snapshot map
            String username = snapshot.data?['username'] ?? 'Unknown';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox( // Display the PageView with images
                  height: 275,
                  child: PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index; // Update the current index when the page changes
                      });
                    },
                    itemBuilder: (context, index) {
                      return Hero( // Add a Hero widget to the image
                        tag: 'image$index', // Set a unique tag for each image
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: images[index].image, // Display the image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text( // Display a welcome message
                          "Welcome back, $username! \u270B", // Display the username with hand emoji
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center( 
                        child: Text( // Display the title
                          "Inventory Manager",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                            Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text( // Display the description
                              "Welcome to the Inventory Manager. Here you can manage your inventory and keep track of your items. \n\nNavigate through the sidebar to access different features.",
                              style: TextStyle(fontSize: 16, color: Colors.black), // Set the text color to white
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "Message of the Day: \n\n\"The best way to predict the future is to create it.\" - Peter Drucker",
                              style: TextStyle(fontSize: 16, color: Colors.black), // Set the text color to white
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


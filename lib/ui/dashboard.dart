import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'inventoryLocation.dart'; // Import the InventoryLocation file
import 'profile.dart'; // Import the Profile file
import 'moveInventory.dart'; // Import the MoveInventory file
import 'addInventory.dart'; // Import the AddInventory file

class Dashboard extends StatefulWidget { // A StatefulWidget to display the dashboard.
  final token; 
  
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState(); // Return the state of the Dashboard.
}

class _DashboardState extends State<Dashboard> { // A State class to handle the state of the Dashboard.
  late String userId; // A variable to store the user ID.
  // Create two TextEditingController objects to get the user input for the title and description of the To-Do.
  List? items;

  // Create a variable to store the current index of the image.
  int _currentIndex = 0;
  // Create a list of image URLs.
  List<Image> images = [ // images (directory added to pubspec.yaml)
    Image.asset('images/warehouse.jpeg'),
    Image.asset('images/dispatch.jpeg'),
    Image.asset('images/warehouse-guy.jpeg'),
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a GlobalKey for the Scaffold.

  @override
  void initState() { // A function to initialize the state of the Dashboard.
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
  }

  @override
  Widget build(BuildContext context) { // Build the UI of the Dashboard.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer( // A drawer is a panel that slides in from the side of the screen. It is often used to provide navigation options to the user.
      // reduce the size of the drawer
        width: MediaQuery.of(context).size.width * 0.2,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader( // A header for the drawer.
              decoration: BoxDecoration(
                color: Colors.blue,
                // reduce the hight of the header
              ),
              child: Text( // A text widget to display the title of the drawer.
                'Sidebar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton( // An icon button to navigate to the Inventory Location page.
              icon: Icon(Icons.pallet),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryLocation()), // Navigate to the InventoryLocation page.
                );
              },
              tooltip: 'Inventory Location', // A tooltip to display when the user hovers over the icon button.
            ),
            IconButton(
              icon: Icon(Icons.forklift),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoveInventory()), // Navigate to the Profile page.
                );
              },
              tooltip: 'Move Inventory', // A tooltip to display when the user hovers over the icon button.
            ),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddInventory()), // Navigate to the Profile page.
                );
              },
              tooltip: 'Add Inventory', // A tooltip to display when the user hovers over the icon button.
            ),
            IconButton( // An icon button to navigate to the Profile page.
              icon: Icon(Icons.person),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>Profile()) // Navigate to the Profile page.
                );
              },
              tooltip: 'Profile', // A tooltip to display when the user hovers over the icon button.
            ),
          ],
        ),
      ),
      body: Column( // A column widget to display the main content of the dashboard.
        crossAxisAlignment: CrossAxisAlignment.start, // Align the content to the start of the column.
        children: [
          SizedBox(
            height: 275,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index; // Update the current index of the image.
                });
              },
              itemBuilder: (context, index) {
                return Hero( // A hero widget to create a hero animation. (image slider)
                  tag: 'image$index', // A unique tag for the hero widget.
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: images[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20), // Add some space between the image slider and the main content.
          Padding(
            padding: const EdgeInsets.all(8.0), // Add padding to the main content.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align the content to the start of the column.
              children: <Widget>[
                Center( // Center the text in the column.
                  child: Text(
                  "Inventory Manager",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Welcome to the Inventory Manager. Here you can manage your inventory and keep track of your items. \nNavigate through the sidebar to access different features.",
                  style: TextStyle( fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
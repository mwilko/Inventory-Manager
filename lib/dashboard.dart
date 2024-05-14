import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Import the config file
import 'inventoryLocation.dart'; // Import the InventoryLocation file
import 'profile.dart'; // Import the Profile file

class Dashboard extends StatefulWidget { // A StatefulWidget to display the dashboard.
  final token; 
  
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState(); // Return the state of the Dashboard.
}

class _DashboardState extends State<Dashboard> { // A State class to handle the state of the Dashboard.
  late String userId; // A variable to store the user ID.
  // Create two TextEditingController objects to get the user input for the title and description of the To-Do.
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  // Create a variable to store the current index of the image.
  int _currentIndex = 0;
  // Create a list of image URLs.
  List<String> imageUrls = [
    'https://via.placeholder.com/200',
    'https://via.placeholder.com/300',
    'https://via.placeholder.com/400',
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a GlobalKey for the Scaffold.

  @override
  void initState() { // A function to initialize the state of the Dashboard.
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    getTodoList(userId); // Call the getTodoList function to get the list of To-Dos.
  }

  void addTodo() async { // A function to add a To-Do.
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text
      };

      try { // Try to send a POST request to the API.
        var response = await http.post(
          Uri.parse(addtodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        if (response.statusCode == 200) { // Check if the response is OK.
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse is Map && jsonResponse.containsKey('status')) {
            if (jsonResponse['status']) {
              _todoDesc.clear();
              _todoTitle.clear();
              Navigator.pop(context);
              getTodoList(userId);
            } else { // If the response is not OK, print an error message.
              print("Something went wrong");
            }
          } else { // If the response is not OK, print an error message.
            print("Invalid response format");
          }
        } else { // If the response is not OK, print an error message.
          print('Failed to add todo: ${response.statusCode}');
        }
      } catch (e) { // If the response is not OK, print an error message.
        print('Error adding todo: $e');
      }
    }
  }

  void getTodoList(userId) async { // A function to get the list of To-Dos.
    var regBody = {"userId": userId};

    try {
      var response = await http.post( // Send a POST request to the API
        Uri.parse(getToDoList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) { // Check if the response is OK.
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('success')) {
          items = jsonResponse['success'];
        } else {
          items = [];
        }
      } else { // If the response is not OK, print an error message.
        print('Failed to fetch todo list: ${response.statusCode}');
      }
    } catch (e) { // If the response is not OK, print an error message.
      print('Error fetching todo list: $e');
    }

    setState(() {}); // Update the state of the Dashboard.
  }

  void deleteItem(id) async { // A function to delete a To-Do.
    var regBody = {"id": id};

    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getTodoList(userId);
    }
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader( // A header for the drawer.
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text( // A text widget to display the title of the drawer.
                'Sidebar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            TextButton(
              child: Text('Inventory Location'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryLocation()),
                );
              },
            ),
            TextButton(
              child: Text('Profile'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>Profile())
                );
              }, 
            ),
          ],
        ),
      ),
      body: Column( // A column widget to display the main content of the dashboard.
        crossAxisAlignment: CrossAxisAlignment.start, // Align the content to the start of the column.
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index; // Update the current index of the image.
                });
              },
              itemBuilder: (context, index) {
                return Hero( // A hero widget to create a hero animation. (image slider)
                  tag: 'image$index', // A unique tag for the hero widget.
                  child: Image.network( // An image widget to display the image.
                    imageUrls[index], // The URL of the image.
                    fit: BoxFit.cover, // The fit of the image.
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
      floatingActionButton: FloatingActionButton( // A floating action button to add a new To-Do.
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add ToDo',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async { // A function to display a dialog to add a new To-Do.
    return showDialog( 
      context: context,
      builder: (context) { // Build the dialog.
        return AlertDialog(
          title: Text('Add To-Do'), 
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding( // Add padding to the text field.
                padding: EdgeInsets.all(8.0), // Add padding here
                child: TextField( 
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true, // Fill the text field with a color.
                    fillColor: Colors.white,
                    hintText: "Title", 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Add rounded corners to the text field.
                    ),
                  ),
                ),
              ),
              Padding( // Add padding to the text field.
                padding: EdgeInsets.all(8.0), // Add padding here
                child: TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              ElevatedButton( // An elevated button to add the To-Do.
                onPressed: () {
                  addTodo(); // Call the addTodo function to add the To-Do.
                  Navigator.pop(context); // Close the dialog.
                },
                child: Text("Add"), // The text of the button.
              ),
            ],
          ),
        );
      },
    );
  }
}

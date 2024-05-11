import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token,Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

void addTodo() async {
  if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
    var regBody = { // Create a map of the data you want to send to the API
      "userId": userId,
      "title": _todoTitle.text,
      "desc": _todoDesc.text
    };

    try { // Use a try/catch block to handle potential errors
      var response = await http.post(
        Uri.parse(addtodo), // Send a POST request to the API
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody), // Convert the map to a JSON string
      );

      if (response.statusCode == 200) { // Check if the API returns a 200 OK response
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('status')) {
          if (jsonResponse['status']) {
            _todoDesc.clear();
            _todoTitle.clear();
            Navigator.pop(context);
            getTodoList(userId);
          } else {
            print("Something went wrong");
          }
        } else {
          print("Invalid response format");
        }
      } else {
        // Handle non-200 status code
        print('Failed to add todo: ${response.statusCode}');
        // You can show a snackbar, toast, or display an error message to the user
      }
    } catch (e) { 
      // Handle network or other errors
      print('Error adding todo: $e');
      // You can show a snackbar, toast, or display an error message to the user
    }
  }
}


void getTodoList(userId) async {
  var regBody = { // Create a map of the data you want to send to the API
    "userId": userId
  };

  try { // Use a try/catch block to handle potential errors
    var response = await http.post(
      Uri.parse(getToDoList), // Send a POST request to the API
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody), // Convert the map to a JSON string
    );

    if (response.statusCode == 200) { // Check if the API returns a 200 OK response
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is Map && jsonResponse.containsKey('success')) {
        // Check if the response is a JSON object and contains the 'success' key
        items = jsonResponse['success'];
      } else {
        items = [];
      }
    } else {
      // Handle non-200 status code
      print('Failed to fetch todo list: ${response.statusCode}');
      // You can show a snackbar, toast, or display an error message to the user
    }
  } catch (e) {
    // Handle network or other errors
    print('Error fetching todo list: $e');
    // You can show a snackbar, toast, or display an error message to the user
  }

  // Ensure to update the state after handling the response
  setState(() {});
}


  void deleteItem(id) async{
    var regBody = {
      "id":id
    };

    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['status']){
      getTodoList(userId);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
       body: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             padding: EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 CircleAvatar(child: Icon(Icons.list,size: 30.0,),backgroundColor: Colors.white,radius: 30.0,),
                 SizedBox(height: 10.0),
                 Text('ToDo with NodeJS + Mongodb',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w700),),
                 SizedBox(height: 8.0),
                 Text('5 Task',style: TextStyle(fontSize: 20),),

               ],
             ),
           ),
           Expanded(
             child: Container(
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
               ),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: items == null ? null : ListView.builder(
                     itemCount: items!.length,
                     itemBuilder: (context,int index){
                       return Slidable(
                         key: const ValueKey(0),
                         endActionPane: ActionPane(
                           motion: const ScrollMotion(),
                           dismissible: DismissiblePane(onDismissed: () {}),
                           children: [
                             SlidableAction(
                               backgroundColor: Color(0xFFFE4A49),
                               foregroundColor: Colors.white,
                               icon: Icons.delete,
                               label: 'Delete',
                               onPressed: (BuildContext context) {
                                 print('${items![index]['_id']}');
                                 deleteItem('${items![index]['_id']}');
                               },
                             ),
                           ],
                         ),
                         child: Card(
                           borderOnForeground: false,
                           child: ListTile(
                             leading: Icon(Icons.task),
                             title: Text('${items![index]['title']}'),
                             subtitle: Text('${items![index]['desc']}'),
                             trailing: Icon(Icons.arrow_back),
                           ),
                         ),
                       );
                     }
                 ),
               ),
             ),
           )
         ],
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>_displayTextInputDialog(context) ,
        child: Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add To-Do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ).p4().px8(),
                ElevatedButton(onPressed: (){
                  addTodo();
                  }, child: Text("Add"))
              ],
            )
          );
        });
  }
}
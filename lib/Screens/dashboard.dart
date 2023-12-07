import 'package:flutter/material.dart';
import 'package:untitled/Budget/budget.dart';
import 'package:untitled/Calender/calender.dart';

import 'package:untitled/Media/media.dart';
import 'package:untitled/Notes/notes.dart';
import 'package:untitled/Password/password.dart';
import 'package:untitled/todo_frontend/screens/Todolist.dart';
import '../Files/files.dart'; // Import the 'files.dart' page

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text
        (
        'Dashboard',
          style: TextStyle(color: Colors.white),
        ),

        backgroundColor: Color(0xFFB65C3F),

      ),


      body:
      GridView.count(

        crossAxisCount: 2,

        children: [



      // Change this to your desired color
            DashboardTile(
              icon: Icons.file_copy,
              title: 'Files',
              onTap: () {
                // Navigate to FilesPage when 'Files and Documents' tile is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilesListPage()),
                );
              }, color: Color(0xFFFF6262),
            ),



           DashboardTile(
            icon: Icons.photo,
            title: 'Media',
            onTap: () {
              // Navigate to FilesPage when 'Files and Documents' tile is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MediaPage()),
              );
            }, color: Color(0xFFFF9162),
          ),
          DashboardTile(
            icon: Icons.note,
            title: 'Notes',
            onTap: () {
              // Navigate to FilesPage when 'Files and Documents' tile is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotesPage()),
              );
            }, color: Color(0xFF1D68C9),
          ),
          DashboardTile(
           icon: Icons.key,
            title: 'Password',
            onTap:(){
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PasswordPage()),
             );
            }, color: Color(0xFFA966FF),

          ),
          DashboardTile(
              icon: Icons.checklist,
              title: 'Todo',
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoList()),
                );
              }, color: Color(0xFF3AE35F),
          ),
          DashboardTile(
              icon: Icons.wallet ,
              title: 'Wallet',
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BudgetPage()),
                );
              }, color: Color(0xFF47D3FF),
          ),
          DashboardTile(
            icon: Icons.calendar_month ,
            title: 'Calender',
            onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomCalender()),
              );
            }, color: Colors.yellowAccent,
          ),
          DashboardTile(
            icon: Icons.add,
            title: 'Add new',
            onTap: () {
              _addNewTileDialog(context);
            },
            color: Colors.green,
          ),

          //
          //
          //
          // Add more tiles here
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

void _addNewTileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent closing the dialog by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Tile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter tile title",
                  ),
                  onChanged: (value) {
                    // Store the entered title for later use
                  },
                ),
                Row(
                  children: [
                    Text("Choose icon:"),
                    const SizedBox(width: 10.0),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // Implement icon selection logic here
                        // ...
                      },
                    ),
                    // ... Add more icon options if desired
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                // Add new tile with entered title, icon, and color
                // Update the GridView with the new tile
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


// ...

class DashboardTile extends StatelessWidget {
  const DashboardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap; // Callback for tile tap
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          if (title == "Add new") {
            _addNewTileDialog(context); // Open dialog on "Add new" tap
          } else {
            onTap(); // Trigger original onTap for other tiles
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  icon,
                  size: 50.0,
                  color: Colors.white
              ),
              const SizedBox(height: 18.0),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


// ...

}

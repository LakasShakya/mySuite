import 'package:flutter/material.dart';
import 'package:untitled/Notes/add_notes.dart';
import 'package:untitled/Notes/ViewNotes.dart';
import 'dart:math';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';



class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
 NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {

  String readNotes = """
    query {
  	notes(sort:"createdAt:desc") {
      data {
        id
        attributes {
          title
          description
          createdAt
        }
      }
    }
  } """;

  var colors = [
    Colors.indigo,
    Colors.green,
    Colors.purple,
    Colors.pinkAccent,
    Colors.red,
    Colors.black
  ];

  Random random = Random();
  List<Map<String, dynamic>> notes = [];

  randomColors() {
    int randomNumber = random.nextInt(colors.length);
    return colors[randomNumber];
  }

  onChange(b) {
    return true;
  }

//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notes'),
//       ),
//       body: Stack(
//         children: [
//           // Your existing notes list view
//
//           // Positioned add button at bottom right
//           Positioned(
//             bottom: 16.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               child: Icon(Icons.add),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const AddNotesPage()),
//                 );
//                 // Implement navigation to your note creation page
//                 // e.g., Navigator.push(context, ...);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
          options: QueryOptions(
            document: gql(readNotes),
            pollInterval: const Duration(seconds: 0),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(child: Text('Loading'));
            }

            Map<String, dynamic> notes = result.data?["notes"];

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(8, 50, 0, 9),
                    color: Color(0xFF1D68C9),
                    child: const Text(
                      "Notes",
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ListView.builder(
                    itemCount: notes["data"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewNote(
                                    id: notes["data"][index]["id"],
                                    refresh: () {
                                      refetch!();
                                    }),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                              color: randomColors(),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 6, 0, 6),
                                        // child: Text('To do'),
                                        child: Text(
                                            notes['data'][index]["attributes"]
                                            ["title"]
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        DateFormat("yMMMEd")
                                            .format(DateTime.parse(notes['data']
                                        [index]["attributes"]
                                        ["createdAt"]
                                            .toString()))
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ] ,
                            ),
                          ));
                    },
                  ),
                ),
              ]),
              floatingActionButton: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNote(refresh: () {
                        refetch!();
                      }),
                    ),
                  );
                },
                tooltip: 'Add new note',
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
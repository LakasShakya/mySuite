import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/GraphQLConfig.dart';

String addNote = """
    mutation addNote(\$title: String, \$description: String) {
      addNote(data: { title: \$title, description: \$description}) {
        data {
          id
          attributes {
            title
            description
          }
        }
      }
    }
    """;

class AddNote extends StatelessWidget {
  final myController = TextEditingController();

  // final myController = TextEditingController();

  final refresh;
  AddNote({Key? key, this.refresh}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),
        child: Mutation(
            options: MutationOptions(
              document: gql(addNote),
              update: (GraphQLDataProxy cache, QueryResult? result) {
                return cache;
              },
              onCompleted: (dynamic resultData) {
                refresh!();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New note added.')));
                Navigator.pop(context);
              },
            ),
            builder: (
                RunMutation runMutation,
                QueryResult? result,
                ) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Add Note"),
                  ),
                  body: Column(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 9),
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add note'),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add description'),
                        )),
                    Row(children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: MaterialButton(
                                onPressed: () {
                                  runMutation({
                                    'title': myController.text,
                                    'description': myController.text
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Adding new note...')));
                                },
                                color: Colors.blue,
                                padding: const EdgeInsets.all(17),
                                child: const Text(
                                  "Add",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              )))
                    ])
                  ]));
            }));;
  }
}
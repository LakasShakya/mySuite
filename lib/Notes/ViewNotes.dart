import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/GraphQLConfig.dart';
String readNote = """
    query(\$id: ID!) {
      note(id: \$id) {
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
String updateNote = """
    mutation updateNote(\$id: ID!, \$title: String, \$description: String) {
      updateNote(id: \$id, data: { title: \$title, description: \$description}) {
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
String deleteNote = """
    mutation deleteNote(\$id: ID!) {
      deleteNote(id: \$id) {
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


class ViewNote extends StatefulWidget {
  final id;
  final refresh;
  const ViewNote({Key? key, @required this.id, @required this.refresh})
      : super(key: key);

  @override
  ViewNoteState createState() =>
      ViewNoteState(id: this.id, refresh: this.refresh);
}


class ViewNoteState extends State<ViewNote> {
  late final id;
  late final refresh;
  ViewNoteState({Key? key, @required this.id, this.refresh});
  var editMode = false;
  var myController;
  bool? done;


  @override
  Widget build(BuildContext context) {

    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),
        child: Query(
            options: QueryOptions(
                document: gql(readNote),
                variables: {'id': id},
                pollInterval: const Duration(seconds: 0)),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return const Scaffold(body: Center(child: Text('Loading')));
              }
              // it can be either Map or List
              var note = result.data?["note"];
              // done = note["data"]["attributes"]["done"];
              myController = TextEditingController(
                  text: note["data"]["attributes"]["title"].toString());
              myController = TextEditingController(
                  text: note["data"]["attributes"]["description"].toString());




              return Scaffold(
                  appBar: AppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Color(0xFF1D68C9),
                      flexibleSpace: SafeArea(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  right: 16, top: 4, bottom: 4, left: 0),
                              child: Row(children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "View Notes",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ])))),
                  body: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.blue),
                    width: double.infinity,
                    height: 200,
                    child: editMode
                        ? Column(
                      children: [
                        Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.fromLTRB(0, 0, 0, 4),
                            child: const Text("Notes:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ))),
                        TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white)),
                              hintText: 'Add notes'),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 0, 4),
                                  child: const Text("Done:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ))),
                            ])
                      ],
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.fromLTRB(0, 0, 0, 4),
                              child: const Text("Note:",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                                padding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Text(
                                    note["data"]["attributes"]["title"]
                                        .toString(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text("description:",
                                textAlign: TextAlign.left,
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                note["data"]["attributes"]["description"]
                                    .toString(),
                                softWrap: true,
                                textAlign: TextAlign.left,
                                style: const TextStyle(

                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: !editMode
                      ? Mutation(
                      options: MutationOptions(
                        document: gql(deleteNote),
                        update:
                            (GraphQLDataProxy cache, QueryResult? result) {
                          return cache;
                        },
                        onCompleted: (dynamic resultData) {
                          refresh();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Done.')));
                          Navigator.pop(context);
                        },
                      ),
                      builder:
                          (RunMutation runMutation, QueryResult? result) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                heroTag: null,
                                child: const Icon(Icons.delete),
                                onPressed: () {
                                  runMutation({'id': id});
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                      Text('Deleting note...')));
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    editMode = true;
                                  });
                                },
                                tooltip: 'Edit note',
                                child: const Icon(Icons.edit),
                              )
                            ]);
                      })
                      : Mutation(
                      options: MutationOptions(
                        document: gql(updateNote),
                        update:
                            (GraphQLDataProxy cache, QueryResult? result) {
                          return cache;
                        },
                        onCompleted: (dynamic resultData) {
                          refresh();
                          refetch!();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Done.')));
                        },
                      ),
                      builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                          ) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: FloatingActionButton(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    heroTag: null,
                                    child: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        editMode = false;
                                      });
                                    },
                                  )),
                              FloatingActionButton(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                heroTag: null,
                                child: const Icon(Icons.save),
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                      Text('Updating note...')));
                                  runMutation({
                                    'id': id,
                                    'title': myController.text,
                                    'description': myController.description
                                  });
                                  setState(() {
                                    editMode = false;
                                  });
                                },
                              )
                            ]);
                      }));
            }));
  }
}
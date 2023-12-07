import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/GraphQLConfig.dart';

String readPassword = """
    query(\$id: ID!) {
      password(id: \$id) {
        data {
          id
          attributes {
            site_name
            password
            username
          }
        }
      }
    }
    """;
String updatePassword = """
    mutation updatePassword(\$id: ID!, \$site_name:String, \$password: Password, \$username: String) {
      updatePassword(id: \$id, data: { username: \$username, password: \$password, site_name: \$site_name}) {
        data {
          id
          attributes {
            site_name
            password
            username
          }
        }
      }
    }
    """;

String deletePassword = """
    mutation deletePassword(\$id: ID!) {
      deletePassword(id: \$id) {
        data {
          id
          attributes {
            site_name
            password
            username
          }
        }
      }
    }
    """;

class viewPassword extends StatefulWidget {
  final id;
  final refresh;
  const viewPassword({Key? key, @required this.id, @required this.refresh})
      : super(key: key);

  @override
  viewPasswordState createState() =>
      viewPasswordState(id: this.id, refresh: this.refresh);
}
class viewPasswordState extends State<viewPassword> {
  late final id;
  late final refresh;
  viewPasswordState({Key? key, @required this.id, this.refresh});
  var editMode = false;
  var myController;
  bool? done;


  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),
        child: Query(
            options: QueryOptions(
                document: gql(readPassword),
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
              var password = result.data?["password"];
              done = password["data"]["attributes"]["done"];
              myController = TextEditingController(
                  text: password["data"]["attributes"]["name"].toString());
              return Scaffold(
                  appBar: AppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.blue,
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
                                  "View Password",
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
                            child: const Text("Password:",
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
                              hintText: 'Add password'),
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
                              StatefulBuilder(builder:
                                  (BuildContext context,
                                  StateSetter setState) {
                                return Checkbox(
                                  value: done,
                                  onChanged: (value) {
                                    setState(() {
                                      done = value;
                                    });
                                  },
                                );
                              }),
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
                              child: const Text("Site Name:",
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
                                    password["data"]["attributes"]["site_name"]
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
                            const Text("Password:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                                password["data"]["attributes"]["password"]
                                    .toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: !editMode
                      ? Mutation(
                      options: MutationOptions(
                        document: gql(deletePassword),
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
                                      Text('Deleting password...')));
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
                                tooltip: 'Edit password',
                                child: const Icon(Icons.edit),
                              )
                            ]);
                      })
                      : Mutation(
                      options: MutationOptions(
                        document: gql(updatePassword),
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
                                      Text('Updating password...')));
                                  runMutation({
                                    'id': id,
                                    'site_name': myController.text,
                                    'password': myController.text,
                                    'username':myController.text
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
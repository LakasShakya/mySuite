import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/GraphQLConfig.dart';

String addMedia = """
    mutation createMedia(\$media_name: String) {
      createMedia(data: {  media_name: \$media_name}) {
        data {
          id
          attributes {
            media_name
          }
        }
      }
    }
    """;

class AddMedia extends StatelessWidget {
  final myController = TextEditingController();
  final refresh;
  AddMedia({Key? key, this.refresh}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),
        child: Mutation(
            options: MutationOptions(
              document: gql(addMedia),
              update: (GraphQLDataProxy cache, QueryResult? result) {
                return cache;
              },
              onCompleted: (dynamic resultData) {
                refresh!();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New media added.')));
                Navigator.pop(context);
              },
            ),
            builder: (
                RunMutation runMutation,
                QueryResult? result,
                ) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Add Media"),
                  ),
                  body: Column(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 50, 10, 9),
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add media'),
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
                                          content: Text('Adding new media...')));
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
            }));
  }
}
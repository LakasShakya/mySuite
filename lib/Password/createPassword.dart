import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/GraphQLConfig.dart';

String addPassword = """
    mutation createPassword(\$site_name: String, \$username: String , \$password: String) {
      createPassword(data: { site_name: \$site_name,password:\$password, username: \$username}) {
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
class CreatePassword extends StatelessWidget {
  final passwordController = TextEditingController();
  final siteNameController = TextEditingController();
  final refresh;
  final bool passToggle = true;

  CreatePassword({Key? key, this.refresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),
        child: Mutation(
            options: MutationOptions(
              document: gql(addPassword),
              update: (GraphQLDataProxy cache, QueryResult? result) {
                return cache;
              },
              onCompleted: (dynamic resultData) {
                refresh!();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New password added.')));
                Navigator.pop(context);
              },
            ),
            builder: (
                RunMutation runMutation,
                QueryResult? result,
                ) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Add Password"),
                  ),
                  body: Column(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
                        child: TextField(
                          obscureText: passToggle,
                          controller: passwordController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add password'),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
                        child: TextField(
                          controller: siteNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Add site_name'),
                        )),
                    Row(children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: MaterialButton(
                                onPressed: () {
                                  runMutation({
                                    'site_name': siteNameController.text,
                                    'password': passwordController.text,
                                    // 'username': myController.text,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Adding new password...')));
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
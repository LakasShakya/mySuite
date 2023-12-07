import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/Password/createPassword.dart';
import"dart:math";

import 'package:untitled/Password/viewPassword.dart';


class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage>{
  String readpasswords = """
    query {
  	passwords(sort:"createdAt:desc") {
      data {
        id
        attributes {
          site_name
          password
          username
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
  List<Map<String, dynamic>> passwords = [];

  randomColors() {
    int randomNumber = random.nextInt(colors.length);
    return colors[randomNumber];
  }

  onChange(b) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
          options: QueryOptions(
            document: gql(readpasswords),
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

            Map<String, dynamic> passwords = result.data?["passwords"];

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(8, 50, 0, 9),
                    color: Colors.blue,
                    child: const Text(
                      "Password Manager",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ListView.builder(
                    itemCount: passwords["data"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewPassword(
                                    id: passwords["data"][index]["id"],
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
                                            passwords['data'][index]["attributes"]
                                            ["site_name"]
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        DateFormat("yMMMEd")
                                            .format(DateTime.parse(passwords['data']
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
                                // Checkbox(
                                //   value: passwords["data"][index]["attributes"]
                                //   ["done"],
                                //   onChanged: onChange,
                                //   checkColor: Colors.white,
                                //   activeColor: Colors.white,
                                // )
                              ],
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
                      builder: (context) => CreatePassword(refresh: () {
                        refetch!();
                      }),
                    ),
                  );
                },
                tooltip: 'Add new password',
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}

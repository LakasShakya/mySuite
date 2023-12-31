import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:untitled/todo_frontend/screens/ViewTodo.dart';
import 'package:untitled/todo_frontend/screens/createTodo.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  String readTodos = """
    query {
  	todos(sort:"createdAt:desc") {
      data {
        id
        attributes {
          name
          done
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
  List<Map<String, dynamic>> todos = [];

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
            document: gql(readTodos),
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

            Map<String, dynamic> todos = result.data?["todos"];

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(8, 50, 0, 9),
                    color: Colors.blue,
                    child: const Text(
                      "Todo List",
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
                    itemCount: todos["data"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewTodo(
                                    id: todos["data"][index]["id"],
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
                                            todos['data'][index]["attributes"]
                                            ["name"]
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        DateFormat("yMMMEd")
                                            .format(DateTime.parse(todos['data']
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
                                Checkbox(
                                  value: todos["data"][index]["attributes"]
                                  ["done"],
                                  onChanged: onChange,
                                  checkColor: Colors.white,
                                  activeColor: Colors.white,
                                )
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
                      builder: (context) => CreateTodo(refresh: () {
                        refetch!();
                      }),
                    ),
                  );
                },
                tooltip: 'Add new todo',
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
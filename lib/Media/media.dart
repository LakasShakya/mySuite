import 'package:flutter/material.dart';
import 'package:untitled/Media//add_media.dart';
import 'package:untitled/Media//ViewMedia.dart';
import 'dart:math';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';



class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  MediaPageState createState() => MediaPageState();
}

class MediaPageState extends State<MediaPage> {

  String readMedias = """
    query {
  	meds(sort:"createdAt:desc") {
      data {
        id
        attributes {
          media_name
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
  List<Map<String, dynamic>> media = [];

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
            document: gql(readMedia),
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

            Map<String, dynamic> media = result.data?["media"];

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(8, 50, 0, 9),
                    color: Color(0xFFFF9162),
                    child: const Text(
                      "Media",
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
                    itemCount: media["data"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewMedia(
                                    id: media["data"][index]["id"],
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
                                            media['data'][index]["attributes"]
                                            ["media_name"]
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        DateFormat("yMMMEd")
                                            .format(DateTime.parse(media['data']
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
                      builder: (context) => AddMedia(refresh: () {
                        refetch!();
                      }),
                    ),
                  );
                },
                tooltip: 'Add new media',
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
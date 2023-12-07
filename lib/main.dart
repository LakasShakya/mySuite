// import 'package:flutter/material.dart';
// import 'package:untitled/Screens/dash.dart';
//
//
// void main(){
//   runApp(MyApp());
// }
//
//
//
// class MyApp extends StatelessWidget{
//   @override
//
//   Widget build (BuildContext context){
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//       ),
//         home: dash(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:untitled/GraphQLConfig.dart';
import 'package:untitled/Screens/dash.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: GraphQLConfiguration.clientToQuery(),

        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const dash(),
        ));
  }
}


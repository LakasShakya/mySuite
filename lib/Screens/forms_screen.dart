import 'package:flutter/material.dart';
import 'package:untitled/Screens/dashboard.dart';
import 'package:untitled/Screens/signup.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  @override

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text
          (
          'mySuite',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFB64620),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formfield,
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      children: [
                        // TextSpan(
                        //   text: 'my',
                        //   style: TextStyle(fontSize: 20.0, color: Color(0xFFB64620)),
                        // ),

                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Color(0xFFB64620),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TextSpan(
                        //   text: 'App',
                        //   style: TextStyle(fontSize: 30.0, color: Colors.black),
                        // ),

                      ],
                    ),
                  ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Please enter your login details to sign in',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                  )
                   ),
                ),

                SizedBox(height: 80),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: passController,
                      obscureText: passToggle,
                      decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap:() {
                          setState(() {
                            passToggle = !passToggle;
                          });
                          },
                          child : Icon(
                              passToggle ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                      ),

            SizedBox(height: 60),
            InkWell(
              onTap: (){
                if(_formfield.currentState!.validate()){
                  print("Success");
                  emailController.clear();
                  passController.clear();
                }
              },
              child: Container(
              height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFB64620),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child:TextButton(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardPage()),
                      );
                    },
                  ),
                ),
            )
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                      ),
                    ],
                  ),
          ],
              ),
          ),
        ),
      ),
    );
  }
}

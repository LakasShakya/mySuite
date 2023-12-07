import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _termsAgreed = false;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFB64620),
      ),



      body:

      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'my',
                          style: TextStyle(
                            fontSize: 20,
                            color:Color(0xFFB64620),
                          ),
                      ),
                      TextSpan(
                        text: 'Suite',
                        style: TextStyle(
                          fontSize: 30,
                          color:Color(0xFFB64620),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      TextSpan(
                        text: 'App',
                        style: TextStyle(
                          fontSize: 15,
                          color:Colors.black,
                        ),
                      ),
                    ]
                 ),
                ),
              ),

              SizedBox(height:50),

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]+$').hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2_outlined)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key_sharp)
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key_sharp)
                ),
                obscureText: true,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your password.';
                //   }
                //   if (value.length < 8) {
                //     return 'Password must be at least 8 characters long.';
                //   }
                //   return null;
                // },
              ),

              SizedBox(height: 50),

              // Create account button
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFB64620),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextButton(
                    child: Text(
                      "Create New Account",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _termsAgreed) {
                        // Implement account creation logic
                        // or navigate to DashboardPage
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => DashboardPage()),
                        // );
                      } else if (! _termsAgreed) {
                        // Show error message for missing terms agreement
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please agree to terms and privacy policy'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height:10),
              Row(
                children: [
                  Checkbox(
                    value: _termsAgreed,
                    onChanged: (value) => setState(() => _termsAgreed = value!),
                  ),
                  const Text(
                    'I agree to terms and Privacy Policy of this app',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    child: Text('Sign In'),
                    onPressed: () {
                      // Navigate back to forms_screen.dart
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

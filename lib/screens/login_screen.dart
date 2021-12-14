import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/screens/home_screen.dart';
import 'package:rento_admin/services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login-screen';

  LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF3c5784).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500));
    _login({username, password}) {
      progressDialog.show();
      _services.getAdmincredentials(username).then((value) async {
        if (value.exists) {
          if (value.get('username') == username) {
            if (value.get('password') == password) {
              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                if (userCredential != null) {
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              } catch (e) {
                progressDialog.dismiss();
                _services.showMyDialog(
                    context: context,
                    title: 'Login',
                    message: '${e.toString()}');
              }
              return;
            }
            progressDialog.dismiss();
            _services.showMyDialog(
                context: context,
                title: 'Incorrect Password',
                message: 'Password you have entered is invalid , try again');

            return;
          }
          progressDialog.dismiss();
          _services.showMyDialog(
              context: context,
              title: 'Invalid Username',
              message: 'User name you have entered is incorrect , try again');
        }
        progressDialog.dismiss();
        _services.showMyDialog(
            context: context,
            title: 'Invalid Username',
            message: 'User name you have entered is incorrect , try again');
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3c5784),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Rento App Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Connection Failed'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF3c5784), Colors.white],
                    stops: [1.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 0.0)),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 400,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.blueAccent, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'images/splash.png',
                                    height: 80,
                                    width: 250,
                                  ),
                                  Text(
                                    'RENTO APP ADMIN',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                      controller: _usernameTextController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter User Name';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'User Name',
                                          prefixIcon: Icon(Icons.person),
                                          hintText: 'User Name',
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2)))),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                      controller: _passwordTextController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter Password';
                                        }
                                        if (value.length < 6) {
                                          return 'Minimun 6 characters';
                                        }

                                        return null;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          helperText: 'Minimun 6 characters',
                                          prefixIcon: Icon(Icons.vpn_key_sharp),
                                          hintText: 'Password',
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2)))),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        //  print('validated');
                                        _login(
                                            username:
                                                _usernameTextController.text,
                                            password:
                                                _passwordTextController.text);
                                      }
                                    },
                                    child: Text('LOGIN',
                                        style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .primaryColor)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

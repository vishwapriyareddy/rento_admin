import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rento_admin/services/firebase_services.dart';

class CreateServiceBoy extends StatefulWidget {
  const CreateServiceBoy({Key? key}) : super(key: key);

  @override
  _CreateServiceBoyState createState() => _CreateServiceBoyState();
}

class _CreateServiceBoyState extends State<CreateServiceBoy> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  bool _visible = false;
  var emailText = TextEditingController();
  var passwordText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF3c5784).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500));
    return Container(
      color: Colors.grey,
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Visibility(
            visible: _visible ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black54)),
                  onPressed: () {
                    setState(() {
                      _visible = true;
                    });
                  },
                  child: Text(
                    'Create New Service Provider',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _visible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 200,
                          height: 30,
                          child: TextField(
                            //TODO: Email validation
                            controller: emailText,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email ID',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 20)),
                          )),
                      SizedBox(width: 10),
                      SizedBox(
                          width: 200,
                          height: 30,
                          child: TextField(
                            controller: passwordText,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 20)),
                          )),
                      SizedBox(width: 10),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black54)),
                        onPressed: () {
                          if (emailText.text.isEmpty) {
                            _services.showMyDialog(
                                context: context,
                                title: 'Email ID',
                                message: 'Email ID not entered');
                          }
                          if (passwordText.text.isEmpty) {
                            _services.showMyDialog(
                                context: context,
                                title: 'Password',
                                message: 'Password not entered');
                          }
                          if (passwordText.text.length < 6) {
                            //minimum 6 character
                            _services.showMyDialog(
                                context: context,
                                title: 'Password',
                                message: 'Minimun 6 charaters');
                          }
                          progressDialog.show();
                          _services
                              .saveServiceProviderBoys(
                                  emailText.text, passwordText.text)
                              .whenComplete(() {
                            emailText.clear();
                            passwordText.clear();
                            progressDialog.dismiss();
                            _services.showMyDialog(
                                context: context,
                                title: 'Save Service Provider Boy',
                                message: 'Saved Successfully');
                          });
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

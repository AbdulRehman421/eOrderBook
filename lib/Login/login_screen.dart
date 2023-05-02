import 'package:Mini_Bill/Invoices/InvoicesList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/db.dart';
import 'auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  String login = '';
  String password = '';
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    showLoaderDialog(context, "Syncing data", "Please wait");
    bool val = await sync();
    if (val == true) {
      isLoading = false;
    }
    Navigator.pop(context);
    setState(() {});
  }
  static showLoaderDialog(BuildContext context, title, subtitle) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      contentPadding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
      content: WillPopScope(
        onWillPop: () => Future.value(true),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator()),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 7), child: Text(subtitle)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { return false; },
      child: Scaffold(appBar: AppBar(
        centerTitle: true,
        title: Text('eOrderBook'),
         leading: IconButton(
             onPressed: () {
               getData();
             },icon: Icon(Icons.sync)),
      ),
        body: Container(

          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Welcome to eOrderBook',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                    SizedBox(height: 10),
                    Text('Please Login to book order',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'username',icon: Icon(Icons.alternate_email),
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          login = value;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: TextField(
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'password',
                          icon: Icon(Icons.lock_outline_sharp),
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 200),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () async {
                          if (localAuth(password: password, login: login)) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('saveUser', isChecked);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceList(),));
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Incorrect login or password'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Try again'),
                                    child: const Text('Try again'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 50.0,
                          ),
                          child: Text('Login'),
                        ),

                      ),
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

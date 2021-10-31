import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/Pharmacy/OrderScreen.dart';
import 'package:pharmacy_app/screens/auth_screen.dart';
import 'package:pharmacy_app/screens/home_screen.dart';
import 'package:pharmacy_app/services/auth.dart';
import 'package:pharmacy_app/widgets/original_button.dart';

//StatefulWidget cus want to take info
class AuthForm extends StatefulWidget {
  final AuthType authType;
  final String email;

  const AuthForm({Key key, @required this.authType, this.email})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isHiden = true;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();


  final _formKey = GlobalKey<FormState>();

  AuthBase authBase = AuthBase();

  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController nameInputController;
  TextEditingController phoneInputController;
  TextEditingController licenseInputController;

  String email;
  bool loggingIn = false;
  bool loginError = false;
  @override
  void initState() {
    emailInputController = TextEditingController(text: "");
    pwdInputController = TextEditingController(text: "");
    nameInputController = TextEditingController(text: "");
    phoneInputController = TextEditingController(text: "");
    licenseInputController = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  if (widget.authType == AuthType.login) {
    if (widget.authType == AuthType.login) {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: emailInputController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Enter your email',
                  hintText: 'ex: test@gmail.com',
                ),
                onChanged: (value) {
                  AuthForm auth = new AuthForm();
                  email = value;
                },
                validator: (value) =>
                    value.isEmpty ? 'You must enter a valid email' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pwdInputController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_open_rounded),
                  labelText: 'Enter your password',
                  hintText: '******',
                  suffixIcon: InkWell(
                    onTap: _togglePasswordView,
                      child: Icon(Icons.visibility)),
                ),
                obscureText: isHiden,
                // onChanged: (value) {
                //  _password = value;
                // },
                // add validator
                validator: (value) => value.length <= 6
                    ? 'Your password must be larger than 6 characters'
                    : null,
              ),
              SizedBox(height: 15),
              loginError
                  ? Text(
                      'Something went wrong, please try again',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(height: 5),
              OriginalButton(
                text: widget.authType == AuthType.login
                    ? (loggingIn ? 'Logging In...' : 'Login')
                    : 'Register',
                color: Colors.orange.shade200,
                textColor: Colors.white,


                onPressed: () async {
                  if (loggingIn) return;
                  setState(() {
                    loginError = false;
                  });

                  if (_formKey.currentState.validate()) {
                    // for database
                    if (widget.authType == AuthType.login) {
                      if (emailInputController.text.isEmpty ||
                          pwdInputController.text.isEmpty) {
                        print("Email and password cannot be empty");
                        return;
                      }
                      setState(() {
                        loggingIn = true;
                      });

                      final user = await AuthBase.loginWithEmailAndPassword(
                          email: emailInputController.text,
                          password: pwdInputController.text);

                      if (user != null) {
                        print("login successful" + user.toString());
                        print("login");
                        // pushReplacementNamed
                        _goToRole(context);
                      } else {
                        setState(() {
                          loggingIn = false;
                          loginError = true;
                        });
                      }
                    } else if (widget.authType == AuthType.register) {
                      // here add category
                      await authBase.registerWithEmailAndPassword(
                          emailInputController.text,
                          pwdInputController.text,
                          nameInputController.text,
                          phoneInputController.text);
                      Navigator.of(context).pushReplacementNamed('login');
                    }
                  } else {
                    await authBase.register2WithEmailAndPassword(
                      emailInputController.text,
                      pwdInputController.text,
                      nameInputController.text,
                      phoneInputController.text,
                      licenseInputController.text,
                    );
                    Navigator.of(context).pushReplacementNamed('login');
//                  print(_email);
//                  print(_password);
                  }
                },
              ),

              SizedBox(height: 6),
              FlatButton(
                onPressed: () {
                  if (widget.authType == AuthType.login) {
                    Navigator.of(context).pushReplacementNamed('category');
                    print(widget.authType);
                  } else {
                    Navigator.of(context).pushReplacementNamed('login');
                  }
                },
                child: Text(
                  widget.authType == AuthType.login
                      ? 'Don\'t have an account?'
                      : 'Already have an account?',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.authType == AuthType.register) {
      final role = ModalRoute.of(context).settings.arguments;

      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              TextFormField(
                controller: emailInputController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'ex: test@gmail.com',
                ),
                validator: (value) =>
                    value.isEmpty ? 'You must enter a valid email' : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: pwdInputController,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                ),
                obscureText: true,
                // onChanged: (value) {
                //  _password = value;
                //},
                // add validator
                validator: (value) => value.length <= 6
                    ? 'Your password must be larger than 6 characters'
                    : null,
              ),
              SizedBox(height: 8),
              TextFormField(
                  controller: nameInputController,
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    hintText: 'Name as in ID',
                  ),
                  // onChanged: (value) {
                  //  _name = value;
                  //},
                  //controller: name,
                  validator: (value) {
                    if (value.length < 5) {
                      return 'Please enter a valid name ';
                    } else {
                      return null;
                    }
                  }),
              SizedBox(height: 8),
              TextFormField(
                  controller: phoneInputController,
                  decoration: InputDecoration(
                    labelText: 'Enter your phone number',
                    hintText: '',
                  ),
                  // onChanged: (value) {
                  // _phone = value;
                  //},
                  validator: (value) {
                    if (value.length < 8) {
                      return 'Please enter a valid phone number ';
                    } else {
                      return null;
                    }
                  }),
              SizedBox(height: 8),
              role == 'pharmacy' || role == 'delivery'
                  ? TextFormField(
                      controller: licenseInputController,
                      decoration: InputDecoration(
                        labelText: 'Enter your license',
                      ),
                      obscureText: true,
                      validator: (value) => value.length <= 5
                          ? 'Your license must be larger than 6 characters'
                          : null,
                    )
                  : SizedBox(
                      height: 2,
                    ),
              SizedBox(height: 8),
              OriginalButton(
                text: widget.authType == (AuthType.login == 'Login')
                    ? 'Login'
                    : (AuthType.register == 'Register')
                        ? 'Register'
                        : (AuthType.register2 == 'Register_2')
                            ? 'Register_2'
                            : 'Register',
                color: Colors.orange.shade200,
                textColor: Colors.white,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    // for database
                    if (widget.authType == AuthType.login) {

                      if (widget.authType == AuthType.login) {
                        await AuthBase.loginWithEmailAndPassword();
                        if (emailInputController.text.isEmpty ||
                            pwdInputController.text.isEmpty) {
                          print("Email and password cannot be empty");
                          return;
                        }
                        try {
                          final user = await AuthBase.loginWithEmailAndPassword(
                              email: emailInputController.text,
                              password: pwdInputController.text);
                          if (user != null) {
                            print("login successful");
                          }
                        } catch (e) {
                          print(e);
                        }

                      } else if (widget.authType == AuthType.register)

                        await authBase.registerWithEmailAndPassword(
                            emailInputController.text,
                            pwdInputController.text,
                            nameInputController.text,
                            phoneInputController.text);
                      Navigator.of(context).pushReplacementNamed('home');
                    } else {
                      var user = await authBase.register2WithEmailAndPassword(
                          emailInputController.text,
                          pwdInputController.text,
                          nameInputController.text,
                          phoneInputController.text,
                          licenseInputController.text,
                          role: role);
                      if (user != null) _goToRole(context);
//                  print(_email);
//                  print(_password);
                    }
                  }
                },
              ),
              SizedBox(height: 6),
              FlatButton(
                onPressed: () {
                  if (widget.authType == AuthType.login) {
                    Navigator.of(context).pushReplacementNamed('category');
                    print(widget.authType);
                  } else {
                    Navigator.of(context).pushReplacementNamed('login');
                  }
                },
                child: Text(
                  widget.authType == AuthType.login
                      ? 'Don\'t have an account?'
                      : 'Already have an account?',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _goToRole(context) {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then((docs) {
      if (docs.docs[0].exists) {
        print(docs.docs[0].data());
        if (docs.docs[0].data()['role'] == 'patient') {
          print(FirebaseAuth.instance.currentUser.email.toString());
          Navigator.of(context).pushReplacementNamed('patient');
        } else if (docs.docs[0].data()['role'] == 'pharmacy') {
          Navigator.of(context).pushReplacementNamed(
            'pharmacy',
            arguments: PharmacyInfo(
              pharma_name: docs.docs[0].data()['pharmacy_name'],
            ),
          );
        } else if (docs.docs[0].data()['role'] == 'delivery') {
          Navigator.of(context).pushReplacementNamed(
            'delivery',
            arguments: PharmacyInfo(
              pharma_name: docs.docs[0].data()['pharmacy_name'],
            ),
          );
        } else {
          Navigator.of(context).pushReplacementNamed('patient');
        }
        setState(() {
          loggingIn = false;
          loginError = false;
        });
      } else {
        setState(() {
          loggingIn = false;
          loginError = true;
        });
      }
    }).catchError((e) => {
              setState(() {
                loggingIn = false;
                loginError = true;
              })
            });
  }
  void _togglePasswordView(){

    setState(() {
      isHiden =!isHiden;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:taxidriver/model/currentlocation.dart';
import 'package:taxidriver/page/profile_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

const Color primaryColor = Color(0xFF9A9696);
const Color secondaryColor = Color(0xFF013C61);

class clientPage extends StatefulWidget {
  const clientPage({Key? key}) : super(key: key);
  @override
  clientPageState createState() => clientPageState();
}

final _formKey = GlobalKey<FormState>();
var confirmPass;
final firstNameEditingController = new TextEditingController();
final secondNameEditingController = new TextEditingController();
final emailNameEditingController = new TextEditingController();
final PasswordNameEditingController = new TextEditingController();
final confirmPasswordNameEditingController = new TextEditingController();

// Uncomment lines 3 and 6 to view the visual layou
class clientPageState extends State<clientPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailNameEditingController = new TextEditingController();
  final PasswordNameEditingController = new TextEditingController();
  final confirmPasswordNameEditingController = new TextEditingController();
  @override
//  String _title = 'Uber';
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a First Name.';
        }
        return null;
      },
    );

    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a First Name.';
        }
        return null;
      },
    );

    final emailField = TextFormField(
        autofocus: false,
        controller: emailNameEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          emailNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (textValue) {
          if (textValue == null || textValue.isEmpty) {
            return 'Email is required!';
          }
          if (!EmailValidator.validate(textValue)) {
            return 'Please enter a valid email';
          }
          return null;
        });

    final PasswordNameField = TextFormField(
        autofocus: false,
        controller: PasswordNameEditingController,
        obscureText: true,
        onSaved: (value) {
          PasswordNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          confirmPass = value;
          if (value == null || value.isEmpty) {
            return 'Please enter a password.';
          } else if (value.length < 8) {
            return "Password must be atleast 8 characters long";
          } else {
            return null;
          }
        });

    final confirmPasswordNameField = TextFormField(
      autofocus: false,
      controller: confirmPasswordNameEditingController,
      obscureText: true,
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        confirmPass = value;
        if (value == null || value.isEmpty) {
          return 'Please Confirm password.';
        } else if (value.length < 8) {
          return "Password must be atleast 8 characters long";
        } else if (value != confirmPass) {
          return "Password must be same as above";
        } else {
          return null;
        }
      },
    );
    final String backendUrl =
        "http://127.0.0.1:8000/api/auth/registration/user/";
    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: secondaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 30, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await http.post(Uri.parse(backendUrl), body: {
              "email": emailNameEditingController.text,
              "password": PasswordNameEditingController.text,
              // add any other required fields here
            });
            if (response.statusCode == 200) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CurrentLocationScreen()));
            } else {
              // handle error response from backend
              // for example, show a snackbar with the error message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Signup failed: ${response.body}"),
                duration: Duration(seconds: 3),
              ));
            }
          }
        },
        child: Text(
          "Signup",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: secondaryColor,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child:
                          Image.asset("assets/ETAXI.png", fit: BoxFit.contain),
                    ),
                    SizedBox(height: 20),
                    firstNameField,
                    SizedBox(height: 20),
                    secondNameField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    PasswordNameField,
                    SizedBox(height: 20),
                    confirmPasswordNameField,
                    SizedBox(height: 15),
                    signupButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

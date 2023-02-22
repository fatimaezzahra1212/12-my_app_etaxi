import 'package:flutter/material.dart';
import 'package:taxidriver/model/testmaps.dart';
import 'signupp.dart';
import 'package:http/http.dart' as http;
import 'package:taxidriver/page/profile_page.dart';
import 'package:taxidriver/page/forgetpassword.dart';
import 'package:email_validator/email_validator.dart';
import 'package:taxidriver/drivers/welcome_driver.dart';

const Color primaryColor = Color(0xFF9A9696);
const Color secondaryColor = Color(0xFF013C61);

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);
  @override
  loginPageState createState() => loginPageState();
}

final _formKey = GlobalKey<FormState>();
final firstNameEditingController = new TextEditingController();
final secondNameEditingController = new TextEditingController();
final emailNameEditingController = new TextEditingController();
final PasswordNameEditingController = new TextEditingController();
final confirmPasswordNameEditingController = new TextEditingController();

// Uncomment lines 3 and 6 to view the visual layou
class loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailNameEditingController = new TextEditingController();
  final PasswordNameEditingController = new TextEditingController();
  void submitLoginForm() async {
    final response = await http.post(
      Uri.parse('https://10.211.25.236:8000/api/auth/login'),
      body: {
        'email': emailNameEditingController.text,
        'password': PasswordNameEditingController.text,
      },
    );

    if (response.statusCode == 200) {
      // Login successful, handle response data
      // For example, you can navigate to the profile page:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      // Login failed, handle error
      // For example, you can show a snackbar with the error message:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
//  String _title = 'Uber';
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password.';
        }
        return null;
      },
    );
    final String backendUrl =
        "http://127.0.0.1:8000/api/auth/registration/driver/";
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
                  context, MaterialPageRoute(builder: (context) => mapsi()));
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log in',
              style: TextStyle(
                  fontSize: 20,
                  color: primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    SizedBox(height: 18);
    SizedBox(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Don\'t have an account? ',
              style: TextStyle(
                  fontSize: 13,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginasPage()));
            },
            child: const Text('Sign up',
                style: TextStyle(
                    fontSize: 15,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    SizedBox(height: 20);

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
                      width: double.infinity,
                      height: size.height * 0.3,
                      child:
                          Image.asset("assets/ETAXI.png", fit: BoxFit.contain),
                    ),
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    PasswordNameField,
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

  void _handleLoginUser() {
    // login user
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data..')),
      );
    }
  }
}

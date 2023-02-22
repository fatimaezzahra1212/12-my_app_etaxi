import 'package:flutter/material.dart';
import 'package:taxidriver/drivers/welcome_driver.dart';
import '../page/profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:taxidriver/model/currentlocation.dart';

const Color primaryColor = Color(0xFF9A9696);
const Color secondaryColor = Color(0xFF013C61);

class continuePage extends StatefulWidget {
  const continuePage({Key? key}) : super(key: key);
  @override
  continuePageState createState() => continuePageState();
}

final _formKey = GlobalKey<FormState>();
final licenseEditingController = new TextEditingController();
final nationalIdentityEditingController = new TextEditingController();
final taxiCardEditingController = new TextEditingController();
final photoTaxiEditingController = new TextEditingController();
final numberTaxiEditingController = new TextEditingController();

// Uncomment lines 3 and 6 to view the visual layou
class continuePageState extends State<continuePage> {
  final _formKey = GlobalKey<FormState>();
  final licenseEditingController = new TextEditingController();
  final nationalIdentityEditingController = new TextEditingController();
  final taxiCardEditingController = new TextEditingController();
  final photoTaxiEditingController = new TextEditingController();
  final numberTaxiEditingController = new TextEditingController();
  @override
//  String _title = 'Uber';
  Widget build(BuildContext context) {
    final licenseField = TextFormField(
        onTap: () async {
          var result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.isNotEmpty) {
            /*PlatformFile file = result.files.first;
            setState(() {
              licenseEditingController.text = result.files.first;
            });*/
          }
        },
        autofocus: false,
        controller: licenseEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          licenseEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.drive_folder_upload),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Driver license",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a Driver license.';
          } else if (value is FilePicker) {
            return 'You should upload a Driver license.';
          }
          return null;
        });

    final nationalIdentityField = TextFormField(
        onTap: () async {
          var result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.isNotEmpty) {
            /*
            nationalIdentityEditingController.text = file.path;
          });*/
          }
        },
        autofocus: false,
        controller: nationalIdentityEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          nationalIdentityEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "national Identity Card",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a national Identity Card.';
          } else if (value is FilePicker) {
            return 'You should upload a national Identity Card.';
          }
          return null;
        });

    final taxiCardField = TextFormField(
        onTap: () async {
          var result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.isNotEmpty) {
            /*
            taxiCardEditingController.text = file.path;
          });*/
          }
        },
        autofocus: false,
        controller: taxiCardEditingController,
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          taxiCardEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.insert_photo_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "taxi Slip Card",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a taxi Slip Card.';
          } else if (value is FilePicker) {
            return 'You should upload a taxi Slip Card.';
          }
          return null;
        });

    final photoTaxiField = TextFormField(
        onTap: () async {
          var result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.isNotEmpty) {
            /*
            photoTaxiEditingController.text = file.path;
          });*/
          }
        },
        autofocus: false,
        controller: photoTaxiEditingController,
        obscureText: true,
        onSaved: (value) {
          photoTaxiEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.camera_alt_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "photo of Taxi",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a photo of Taxi.';
          } else if (value is FilePicker) {
            return 'You should upload a photo of Taxi.';
          }
          return null;
        });
    /*SizedBox(height: 15);
    ElevatedButton(
      child: Text('Upload file'),
      onPressed: () async {
        var file = await FilePicker.getFile();
      },
    );*/
    final numberTaxiField = TextFormField(
        onTap: () async {},
        autofocus: false,
        controller: numberTaxiEditingController,
        obscureText: true,
        onSaved: (value) {
          numberTaxiEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.numbers_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Matricule Taxi",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a Matricule Number.';
          }

          // Define a regular expression pattern for a valid matricule number
          RegExp pattern = RegExp(r'^[A-Z]{2}\d{4}$');

          // Check if the value matches the pattern
          if (!pattern.hasMatch(value)) {
            return 'Please enter a valid Matricule Number in the format XX0000.';
          }

          return null;
        });
    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: secondaryColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 30, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CurrentLocationScreen()));
        },
        child: Text(
          "Sign Up",
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
                    licenseField,
                    SizedBox(height: 20),
                    nationalIdentityField,
                    SizedBox(height: 20),
                    taxiCardField,
                    SizedBox(height: 20),
                    photoTaxiField,
                    SizedBox(height: 20),
                    numberTaxiField,
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

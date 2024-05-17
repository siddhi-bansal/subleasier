import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'posting_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firestore_service.dart';
import 'package:uuid/uuid.dart';
// import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
var uuid = const Uuid();
final picker = ImagePicker();
String _name = '';
String _email = '';
String? _sex = 'Male';
String? _sublessee_preferred_sex = 'Male';
String? _location = 'Moontower';
String _additional_info = '';
int _monthly_price = 0;
bool image_error = false; // true if user submits form with 0 images
final List<String> _sexList = ['Male', 'Female'];
final List<String> _locationList = ['Moontower', 'Lark', '2400 Nueces', 'Inspire'];
List<File> _images = [];

class SublessorForm extends StatefulWidget {
  @override
  
  _SublessorFormState createState() => _SublessorFormState();
}

class _SublessorFormState extends State<SublessorForm> {
  @override

  void set_image_error_true() {
    setState(() {
      image_error = true;
    });
  }

  Future getImages() async {
    try {
      final pickedFiles = await picker.pickMultiImage();
      setState(() {
        _images =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'SUBLEASIER',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the title bold
            fontSize: 42.0,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize:
              Size.fromHeight(20), // Adjust the height of the subtitle area
          child: Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: Text(
              'making subleasing easier',
              style: TextStyle(
                fontSize: 18.0, // Adjust the font size of the subtitle
              ),
            ),
          ),
        ),
      ),
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/tower.jpg'),
            fit: BoxFit.cover,
            // alignment: Alignment(20 / MediaQuery.of(context).size.width, 0),
            alignment: const Alignment(0.05, 0),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop, // Blend mode for the color filter
            ),
          ),
        )),
        Positioned(
            top: 145,
            left: 31,
            child: Container(
                width: 332,
                height: 680,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(200, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  const SizedBox(height: 10.0),
                  Form(
                    key:
                        _formKey, // Associate the form key with this Form widget
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // const Center(child: Text('About You', style: TextStyle(fontSize: 19, color: Colors.black))),
                          // const SizedBox(height: 6),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Your Name',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ), // Change to your desired color
                              ),
                            ),
                            cursorColor: const Color.fromARGB(237, 193, 90, 5),
                            style: const TextStyle(fontSize: 15.0),
                            validator: (value) {
                              // Validation function for the name field
                              if (value == null || value!.isEmpty) {
                                return 'Please enter your name.'; // Return an error message if the name is empty
                              }
                              return null; // Return null if the name is valid
                            },
                            onSaved: (value) {
                              setState(() {
                                _name = value!; // Save the entered name
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Your Email',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ), // Change to your desired color
                              ),
                            ),
                            cursorColor: const Color.fromARGB(237, 193, 90, 5),
                            style: const TextStyle(fontSize: 15.0),
                            validator: (value) {
                              // Validation function for the email field
                              if (value == null || value!.isEmpty) {
                                return 'Please enter your email.'; // Return an error message if the email is empty
                              }
                              return null; // Return null if the email is valid
                            },
                            onSaved: (value) {
                               setState(() {
                              _email = value!; // Save the entered email
                               });
                            },
                          ),
                          const SizedBox(height: 10.0),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Your Sex', // Hint text
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ),
                              ),
                            ),
                            value: _sex,
                            items: _sexList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _sex = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10.0),
                          // const Center(child: Text('About Your Apartment', style: TextStyle(fontSize: 19, color: Colors.black))),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Monthly Price (\$) of Apartment',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ), // Change to your desired color
                              ),
                            ),
                            cursorColor: const Color.fromARGB(237, 193, 90, 5),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'[0-9]')), // Only allow numeric characters
                            ],
                            style: const TextStyle(fontSize: 15.0),
                            validator: (value) {
                              // Validation function for the monthly price field
                              if (value == null || value!.isEmpty) {
                                return 'Please enter your monthly price as an integer.'; // Return an error message if the monthly price is empty
                              } else {
                                return null; // Return null if the name is valid
                              }
                            },
                            onSaved: (value) {
                               setState(() {
                                _monthly_price = int.tryParse(value!) ?? 0; // Save the entered monthly price
                               });
                            },
                          ),

                          const SizedBox(height: 10.0),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Location of Apartment', // Hint text
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ),
                              ),
                            ),
                            value: _location,
                            items: _locationList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _location = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Additional Info about Apartment',
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ), // Change to your desired color
                              ),
                            ),
                            cursorColor: const Color.fromARGB(237, 193, 90, 5),
                            style: const TextStyle(fontSize: 15.0),
                            validator: (value) {
                              return null; // Return null if the name is valid
                            },
                            onSaved: (value) {
                               setState(() {
                                _additional_info = value!; // Save the entered name
                               });
                            },
                          ),
                          const SizedBox(height: 15.0),
                          ElevatedButton(
                            onPressed:getImages,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(120, 255, 115, 0)),
                              minimumSize: WidgetStateProperty.all<Size>(
                                  const Size(20, 30)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Set border radius to 0 for a rectangular button
                              )),
                            ),
                            child: const Text(
                              'Upload Images',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(5), child: Text('Please upload at least one image', style: TextStyle(color: image_error ? Colors.red : Colors.black))),
                          const SizedBox(height: 15.0),
                          // const Center(child: Text('About Your Sublessee', style: TextStyle(fontSize: 19, color: Colors.black))),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText:
                                  'Preferred Sex of Sublessee', // Hint text
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(237, 193, 90, 5),
                                ),
                              ),
                            ),
                            value: _sublessee_preferred_sex,
                            items: _sexList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _sublessee_preferred_sex = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(120, 255, 115, 0))),
                              onPressed: () {
                                // print('yas');
                                _formKey.currentState!.save();
                                submitForm(context, _name, _email, _sex, _monthly_price, _location, _additional_info, _sublessee_preferred_sex, _images, set_image_error_true);
                              },
                              child: const Text('Submit',
                                  style: TextStyle(color: Colors.white))),
                          const SizedBox(
                            height: 10.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ]))))
      ]),
    );
  }
}

// This method will upload the images stored as Files to Firebase Storage and return their corresonding URLs
// in Storage
Future<List<String>> upload_images_to_fb_storage(List<File> images, String uuid) async {
  List<String> image_urls = [];

  try {
    for (int i = 0; i < images.length; i++) {

      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = storageRef.child('$uuid/image_$i').putFile(images[i]);
      await uploadTask;
      String url = await storageRef.child('$uuid/image_$i').getDownloadURL();
      image_urls.add(url);
    }
  } catch(e) {
    print('error: $e');
  }

  return image_urls;
}

/*
This method should send data to Firestore. Then, navigate to posting_success.
*/
void submitForm(BuildContext context, String name, String email, String? sex, int price, String? location, String additional_info, String? sublessee_preferred_sex, List<File> images, Function set_image_error_true) async {
  if (images.isEmpty) {
    set_image_error_true();
    return null;
  }
  if (_formKey.currentState!.validate()) {
    final db = FirestoreService().db;
    String curr_uuid = uuid.v4();
    List<String> image_urls = await upload_images_to_fb_storage(images, curr_uuid);

    final posting = {'name': name, 'email': email, 'sublessor sex': sex, 'price': price, 'location': location, 'additional info': additional_info, 'preferred sublessee sex': sublessee_preferred_sex, 'images': image_urls};
    db.collection('postings').add(posting).then((DocumentReference doc) =>
      print('Apartment added with ID: ${doc.id}'));
    
    print('Form submitted!');
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostingSuccess()),
    );

    // print('Curr db storage:');
    // await db.collection("users").get().then((event) {
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // });

  }
  // else, Flutter will automatically handle error.
}

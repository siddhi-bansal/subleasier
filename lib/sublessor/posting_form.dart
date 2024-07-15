import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'posting_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firestore_service.dart';
import 'package:uuid/uuid.dart';
// import 'package:firebase_auth/firebase_auth.dart';

final geminiApiKey = 'AIzaSyD_Y1NAZtWP2DvgD3OT748H3nJT2m-sxV4';
final List<String> _sexList = ['Male', 'Female'];
final List<String> _aptNameList = [
  'Moontower',
  'Lark',
  '2400 Nueces',
  'Inspire',
  'Other'
];
final List<String> _bathroomTypeList = ['Private', 'Shared'];
Map<String, String> _aptUrls = {
  'Moontower': 'https://moontoweratx.com/',
  'Lark': 'https://larkaustin.com/',
  '2400 Nueces': 'https://housing.utexas.edu/housing/2400-nueces-apartments',
  'Inspire': 'https://www.liveatinspireatx.com/'
};
List<File> _images = [];

class SublessorForm extends StatefulWidget {
  @override
  _SublessorFormState createState() => _SublessorFormState();
}

class _SublessorFormState extends State<SublessorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var uuid = const Uuid();
  final picker = ImagePicker();
  String selectedPage = '';
  String _name = '';
  String _email = '';
  String? _sex = 'Male';
  String? _sublesseePreferredSex = 'Male';
  String? _aptName = 'Moontower';
  String? _finalAptName = 'Moontower';
  String? _bathroomType = 'Private';
  String _additionalInfo = '';
  int _monthlyPrice = 0;
  bool _imageError = false; // true if user submits form with 0 images

  void setImageErrorTrue() {
    setState(() {
      _imageError = true;
    });
  }

  /*
  This method should send data to Firestore. Then, navigate to posting_success.
  */
  void submitForm(
      BuildContext context,
      String name,
      String email,
      String? sex,
      int price,
      String? aptName,
      String? aptUrl,
      String? bathroomType,
      String additionalInfo,
      String? sublesseePreferredSex,
      List<File> images,
      Function setImageErrorTrue) async {
    if (images.isEmpty) {
      setImageErrorTrue();
      return null;
    }
    if (_formKey.currentState!.validate()) {
      final db = FirestoreService().db;
      String currUuid = uuid.v4();
      List<String> imageUrls =
          await uploadImagesToFirebaseStorage(images, currUuid);
      String? aptCondition = await getAptConditionFromGemini(images);
      final posting = {
        'name': name,
        'email': email,
        'sublessor_sex': sex,
        'price': price,
        'apt_name': aptName,
        'apt_url': aptUrl,
        'bathroom_type': bathroomType,
        'additional_info': additionalInfo,
        'preferred_sublessee_sex': sublesseePreferredSex,
        'images': imageUrls,
        'apartment_condition': aptCondition
      };
      db.collection('postings').add(posting).then((DocumentReference doc) =>
          print('Apartment added with ID: ${doc.id}'));

      print('Form submitted!');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostingSuccess()));
    }
    // else, Flutter will automatically handle error.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: Padding(
              padding: const EdgeInsets.only(left: 15, top: 5),
              child: PopupMenuButton(onSelected: (value) {
                setState(() {
                  selectedPage = value.toString();
                  Navigator.pushNamed(context, value.toString());
                });
              }, itemBuilder: (BuildContext bc) {
                return const [
                  PopupMenuItem(value: '/home', 
                  child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.home_outlined),
                        ),
                        Text(
                          'Home',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ),
                  PopupMenuItem(
                      value: '/sublessor_form', 
                      child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.description_outlined),
                        ),
                        Text(
                          'Sublessor Form',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ),
                  PopupMenuItem(
                      value: '/all_listings', 
                      child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.list),
                        ),
                        Text(
                          'All Listings',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ),
                  PopupMenuItem(value: '/profile', 
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.person_outline_rounded),
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ),
                ];
              })),
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
                              if (value == null || value.isEmpty) {
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
                              if (value == null || value.isEmpty) {
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
                              if (value == null || value.isEmpty) {
                                return 'Please enter your monthly price as an integer.'; // Return an error message if the monthly price is empty
                              } else {
                                return null; // Return null if the name is valid
                              }
                            },
                            onSaved: (value) {
                              setState(() {
                                _monthlyPrice = int.tryParse(value!) ??
                                    0; // Save the entered monthly price
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Location', // Hint text
                                    labelStyle: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(237, 193, 90, 5),
                                      ),
                                    ),
                                  ),
                                  value: _aptName,
                                  items: _aptNameList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _aptName = value;
                                      _finalAptName = value;
                                    });
                                  },
                                )),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Bathroom Type', // Hint text
                                    labelStyle: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(237, 193, 90, 5),
                                      ),
                                    ),
                                  ),
                                  value: _bathroomType,
                                  items: _bathroomTypeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _bathroomType = value;
                                    });
                                  },
                                )),
                              ]),
                          const SizedBox(height: 15.0),
                          if (_aptName == 'Other')
                            Column(children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name of your Apartment',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(237, 193, 90, 5),
                                    ), // Change to your desired color
                                  ),
                                ),
                                cursorColor:
                                    const Color.fromARGB(237, 193, 90, 5),
                                style: const TextStyle(fontSize: 15.0),
                                validator: (value) {
                                  if (_aptName == 'Other' &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter the custom apartment name.';
                                  }
                                  return null; // Return null if the name is valid
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _finalAptName =
                                        value!.trim(); // Save the entered name
                                  });
                                },
                              ),
                              const SizedBox(height: 15.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Link to Apartment Website',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(237, 193, 90, 5),
                                    ), // Change to your desired color
                                  ),
                                ),
                                cursorColor:
                                    const Color.fromARGB(237, 193, 90, 5),
                                style: const TextStyle(fontSize: 15.0),
                                validator: (value) {
                                  if (_aptName == 'Other' &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter the custom apartment name.';
                                  }
                                  return null; // Return null if the name is valid
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _aptUrls[_finalAptName!] =
                                        value!; // Save the entered name in Urls list
                                  });
                                },
                              ),
                              const SizedBox(height: 15.0),
                            ]),
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
                                _additionalInfo =
                                    value!; // Save the entered name
                              });
                            },
                          ),
                          const SizedBox(height: 15.0),
                          ElevatedButton(
                            onPressed: getImages,
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
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('Please upload at least one image',
                                  style: TextStyle(
                                      color: _imageError
                                          ? Colors.red
                                          : Colors.black))),
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
                            value: _sublesseePreferredSex,
                            items: _sexList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _sublesseePreferredSex = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(120, 255, 115, 0))),
                              onPressed: () {
                                // print('yas');
                                _formKey.currentState!.save();
                                submitForm(
                                    context,
                                    _name,
                                    _email,
                                    _sex,
                                    _monthlyPrice,
                                    _finalAptName,
                                    _aptUrls[_finalAptName],
                                    _bathroomType,
                                    _additionalInfo,
                                    _sublesseePreferredSex,
                                    _images,
                                    setImageErrorTrue);
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
  
  Future<String?> getAptConditionFromGemini (List<File> images) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: geminiApiKey);
    final prompt = TextPart("In a few words, describe the condition of this apartment for a potential sublessee. Additionally, highlight any amenities or features that you think may be useful for the sublessee to know as well.");
    List<Part> imageBytesList = [];
    for (var image in images) {
      Uint8List imageBytes = await image.readAsBytes();
      imageBytesList.add(DataPart('image/jpeg', imageBytes));
    }
    final response = await model.generateContent([
    Content.multi([prompt, ...imageBytesList])
  ]);
    return response.text;
  }
}

// This method will upload the images stored as Files to Firebase Storage and return their corresonding URLs
// in Storage
Future<List<String>> uploadImagesToFirebaseStorage(
    List<File> images, String uuid) async {
  List<String> imageUrls = [];

  try {
    for (int i = 0; i < images.length; i++) {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = storageRef.child('$uuid/image_$i').putFile(images[i]);
      await uploadTask;
      String url = await storageRef.child('$uuid/image_$i').getDownloadURL();
      imageUrls.add(url);
    }
  } catch (e) {
    print('error: $e');
  }

  return imageUrls;
}

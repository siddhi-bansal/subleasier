import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'posting_success.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class SublessorForm extends StatefulWidget {
  @override
  _SublessorFormState createState() => _SublessorFormState();
}

class _SublessorFormState extends State<SublessorForm> {
  
  String _name = '';
  String _email = '';
  String? _sex = 'Male';
  String? _sublessee_preferred_sex = 'Male';
  String? _location = 'Moontower';
  String? _additional_info = '';
  int _monthly_price = 0;
  final List<String> _sexList = ['Male', 'Female'];
  final List<String> _locationList = ['Moontower', 'Lark', '2400 Nueces'];
  @override
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
            preferredSize: Size.fromHeight(20), // Adjust the height of the subtitle area
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
      body: Stack(
        children: [
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
        )
          ),
      Positioned(
        top: 145,
        left: 31,
        child: Container(
        width: 332,
        height: 680,
        decoration: BoxDecoration(
          color:const Color.fromARGB(200, 255, 255, 255),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10.0),
            Form( 
        key: _formKey, // Associate the form key with this Form widget 
        child: Padding( 
          padding: EdgeInsets.symmetric(horizontal: 16.0), 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Center(child: Text('About You', style: TextStyle(fontSize: 20, color: Colors.black))), 
              TextFormField( 
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(237, 193, 90, 5),), // Change to your desired color
                  ),
                  ),
                cursorColor: Color.fromARGB(237, 193, 90, 5),
                style: TextStyle(fontSize: 15.0),
                validator: (value) { 
                  // Validation function for the name field 
                  if (value == null || value!.isEmpty) { 
                    return 'Please enter your name.'; // Return an error message if the name is empty 
                  } 
                  return null; // Return null if the name is valid 
                }, 
                onSaved: (value) { 
                  _name = value!; // Save the entered name 
                }, 
              ), 
              TextFormField( 
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(237, 193, 90, 5),), // Change to your desired color
                  ),
                  ),
                cursorColor: const Color.fromARGB(237, 193, 90, 5),
                style: TextStyle(fontSize: 15.0),
                validator: (value) { 
                  // Validation function for the email field 
                  if (value == null || value!.isEmpty) { 
                    return 'Please enter your email.'; // Return an error message if the email is empty 
                  } 
                  return null; // Return null if the email is valid 
                }, 
                onSaved: (value) { 
                  _email = value!; // Save the entered email 
                }, 
              ), 
              SizedBox(height: 10.0),
              
              DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sex', // Hint text
                    labelStyle:
               TextStyle(color: Colors.black, fontSize: 18),
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
                const SizedBox(height: 15.0),
                const Center(child: Text('About Your Apartment', style: TextStyle(fontSize: 20, color: Colors.black))), 
                 TextFormField( 
                decoration: const InputDecoration(
                  labelText: 'Monthly Price (\$)',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(237, 193, 90, 5),), // Change to your desired color
                  ),
                  ),
                cursorColor: Color.fromARGB(237, 193, 90, 5),
                inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only allow numeric characters
                  ],
                style: TextStyle(fontSize: 15.0),
                validator: (value) { 
                  // Validation function for the monthly price field 
                  if (value == null || value!.isEmpty) { 
                    return 'Please enter your monthly price as an integer.'; // Return an error message if the monthly price is empty 
                  } else {
                    return null; // Return null if the name is valid 
                  }
                }, 
                onSaved: (value) { 
                  _monthly_price = int.parse(value!); // Save the entered monthly price 
                }, 
              ), 

            const SizedBox(height: 10.0),

            DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Location', // Hint text
                    labelStyle:
               TextStyle(color: Colors.black, fontSize: 18),
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

                TextFormField( 
                decoration: const InputDecoration(
                  labelText: 'Additional Info',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(237, 193, 90, 5),), // Change to your desired color
                  ),
                  ),
                cursorColor: Color.fromARGB(237, 193, 90, 5),
                style: TextStyle(fontSize: 15.0),
                validator: (value) { 
                  return null; // Return null if the name is valid 
                }, 
                onSaved: (value) { 
                  _additional_info = value!; // Save the entered name 
                }, 
              ), 
              const SizedBox(height: 15.0),
                const Center(child: Text('About Your Sublessee', style: TextStyle(fontSize: 20, color: Colors.black))), 
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Preferred Sex', // Hint text
                    labelStyle:
               TextStyle(color: Colors.black, fontSize: 18),
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
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(120, 255, 115, 0))
              ),
              onPressed: () {
                submitForm(context);
              }, 
              child: const Text(
                'Submit',
                style: TextStyle(
                    color: Colors.white
                    )
                )
            ), 
            ], 
          ), 
        ), 
      ),
          ]
        )
      )
      )
        ]
      ),
    );
  }
}

/*
This method should send data to firebase. Then, navigate to posting_success.
*/
void submitForm(BuildContext context) {
  if (_formKey.currentState!.validate()) {
    print('Form submitted!');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostingSuccess()),
    );
  }
  // else, Flutter will automatically handle error.

}
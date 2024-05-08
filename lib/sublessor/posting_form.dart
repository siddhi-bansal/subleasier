import 'package:flutter/material.dart';
import 'posting_success.dart';

class SublessorForm extends StatelessWidget {
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
            const SizedBox(height: 20.0),
            const Text('rest of the content for form will go in here!'),
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
            )
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
  print('Form submitted!');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PostingSuccess()),
  );
}
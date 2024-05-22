import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualPosting extends StatelessWidget {
  final Map<String, dynamic> posting;
  IndividualPosting({required this.posting});
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
          preferredSize:
              Size.fromHeight(20.0), // Adjust the height of the subtitle area
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
        children: [Container(
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
        ),
      ),
      Positioned(
        top: 145,
        left: 31,
        child: Container(
                width: 332,
                height: 680,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(200, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView (
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      SizedBox (
                        height: 200,
                        child: PageView.builder(
                        itemCount: posting['images'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                            child: Image.network(
                            posting['images'][index],
                            fit: BoxFit.cover,
                          ));
                        }
                      )
                      ),
                      if (posting['images'].length > 1)
                      ...[
                        Text('Swipe to see more images'),
                        SizedBox(height: 10),
                      ],
                      SizedBox(height: 15),
                      Text('About the Apartment', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Text('Monthly Price: \$${posting['price']}')
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Text('Preferred Sublessee Sex: ${posting['preferred sublessee sex']}')
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Text('Additional Information: ${posting['additional info']}')
                      ),
                      SizedBox(height: 30),
                      Text('About the Sublessor', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Text('Sublessor Sex: ${posting['sublessor sex']}')
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Text('Name: ${posting['name']}')
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: Text('Email: ${posting['email']}')
                      ),
                      SizedBox(height: 25), 
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(120, 255, 115, 0))
                        ),
                        onPressed: () {
                          send_email(posting['email']);
                        },
                        child: Text('Email Sublessor', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 30)
                      ],
                    )
                )
              )
      )]
      )
    );
  }
}


String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

// TODO: need to test if sending email actually works
Future<void> send_email(String email_address) async {
  final Uri email_launch_uri = Uri(
    scheme: 'mailto',
    path: email_address,
  );
  try {
    await launchUrl(email_launch_uri);
    // NOTE: email doesn't launch on iOS because Mail not installed
    // on iOS emulator. The button has not been tested yet.
  } catch(e) {
    print('Could not launch email: $e');
  }
}
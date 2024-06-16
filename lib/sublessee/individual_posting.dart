import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String selectedPage = '';

class IndividualPosting extends StatefulWidget {
  final Map<String, dynamic> posting;
  const IndividualPosting({required this.posting});
  @override
 _IndividualPostingState createState() => _IndividualPostingState();
}

class _IndividualPostingState extends State<IndividualPosting> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> posting = widget.posting;
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
              PopupMenuItem(
                value: '/home',
                child: Text('Home')
              ),
              PopupMenuItem(
                value: '/sublessor_form',
                child: Text('Sublessor Form')
              ),
              PopupMenuItem(
                value: '/all_listings',
                child: Text('All Listings')
              ),
              PopupMenuItem(
                value: '/profile',
                child: Text('Profile')
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
                      const SizedBox(height: 15),
                      SizedBox (
                        height: 200,
                        child: PageView.builder(
                        itemCount: posting['images'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 7),
                            child: Image.network(
                            posting['images'][index],
                            fit: BoxFit.cover,
                          ));
                        }
                      )
                      ),
                      if (posting['images'].length > 1)
                      ...[
                        const Text('Swipe to see more images'),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 7),
                      const Text('About the Apartment', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Monthly Price: \$${posting['price']}')
                      ),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Preferred Sublessee Sex: ${posting['preferred_sublessee_sex']}')
                      ),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Bathroom Type: ${posting['bathroom_type']}')
                      ),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Additional Information: ${posting['additional_info']}')
                      ),
                      const SizedBox(height: 30),
                      const Text('About the Sublessor', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Sublessor Sex: ${posting['sublessor_sex']}')
                      ),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Name: ${posting['name']}')
                      ),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text('Email: ${posting['email']}')
                      ),
                      const SizedBox(height: 20), 
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(120, 255, 115, 0))
                        ),
                        onPressed: () {
                          sendEmail(posting['email']);
                        },
                        child: const Text('Email Sublessor', style: TextStyle(color: Colors.white)),
                      )
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
Future<void> sendEmail(String emailAddress) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
  );
  try {
    await launchUrl(emailLaunchUri);
    // NOTE: email doesn't launch on iOS because Mail not installed
    // on iOS emulator. The button has not been tested yet.
  } catch(e) {
    print('Could not launch email: $e');
  }
}
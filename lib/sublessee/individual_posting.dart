import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String selectedPage = '';

class IndividualPosting extends StatefulWidget {
  final Map<String, dynamic> posting;
  const IndividualPosting({super.key, required this.posting});
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
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('images/tower.jpg'),
                fit: BoxFit.cover,
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
              left: 20,
              child: Container(
                  width: 332,
                  height: 650,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      const SizedBox(height: 15),
                      SizedBox(
                          height: 200,
                          child: PageView.builder(
                              itemCount: posting['images'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                        bottom: 7),
                                    child: Image.network(
                                      posting['images'][index],
                                      fit: BoxFit.cover,
                                    ));
                              })),
                      if (posting['images'].length > 1) ...[
                        const Text('Swipe to see more images'),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 7),
                      const Text('About the Apartment',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text('Monthly Price: \$${posting['price']}')),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Dates: ${posting['sublease_start_date']} to ${posting['sublease_end_date']}')),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Preferred Sublessee Sex: ${posting['preferred_sublessee_sex']}')),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Bathroom Type: ${posting['bathroom_type']}')),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Additional Information: ${posting['additional_info']}')),
                      const SizedBox(height: 30),
                      const Text('About the Sublessor',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Sublessor Sex: ${posting['sublessor_sex']}')),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text('Name: ${posting['name']}')),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text('Email: ${posting['email']}')),
                      const SizedBox(height: 30),
                      const Text('AI-Generated Information',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 15),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Condition of the Apartment: ${posting['apartment_condition']}')),
                      const SizedBox(height: 5),
                      Container(
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Text(
                              'Fair Market Value: \$${posting['fair_market_value']}', textAlign: TextAlign.center)),
                        const SizedBox(height: 5),
                        Column(
                        children: [
                           posting['price'] > posting['fair_market_value']
                              ? Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 35, right: 35),
                                child: Text(
                                    '*Posting is \$${posting['price'] - posting['fair_market_value']} more expensive than fair market value!*', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)))
                              : Container(
                                padding: const EdgeInsets.only(left: 35, right: 35),
                                child: Text(
                                  '*Posting is \$${posting['fair_market_value'] - posting['price']} cheaper than fair market value!*', textAlign: TextAlign.center, style: const TextStyle(color: Color.fromARGB(255, 54, 112, 56)))), 
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(230, 191, 87, 0))),
                        onPressed: () {
                          sendEmail(posting['email']);
                        },
                        child: const Text('Email Sublessor',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ))))
        ]));
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

int getIntParsedFromPrice(String? price) {
  price ??= "\$1000";
  return int.parse(price.replaceAll(RegExp(r'[^0-9]'),''));
}

Future<void> sendEmail(String emailAddress) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
  );
  try {
    await launchUrl(emailLaunchUri);
  } catch (e) {
    print('Could not launch email: $e');
  }
}

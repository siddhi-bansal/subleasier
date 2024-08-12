import 'package:flutter/material.dart';
import 'package:subleasier/sublessee/postings_board.dart';

String selectedPage = '';

class PostingSuccess extends StatefulWidget {
  const PostingSuccess({super.key});

  @override
  _PostingSuccessState createState() => _PostingSuccessState();
}

class _PostingSuccessState extends State<PostingSuccess> {
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
        )),
        Positioned(
            top: 313,
            left: 20,
            child: Container(
                width: 332,
                height: 226,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(200, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    const SizedBox(height: 10),
                    const Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Text(
                              'Congrats, we’ve listed your apartment! Interested sublessees will reach out to you at the phone number you provided!',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(230, 191, 87, 0)),
                              minimumSize: WidgetStateProperty.all<Size>(
                                  const Size(10, 40)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const PostingsBoard()));
                            },
                            child: const Center(
                                child: Text('View all Listings',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )))))
                  ]),
                )))
      ]),
    );
  }
}

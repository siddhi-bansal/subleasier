import 'package:flutter/material.dart';
import 'package:subleasier/sublessee/postings_board.dart';

class PostingSuccess extends StatelessWidget {
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
            top: 313,
            left: 31,
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(120, 255, 115, 0)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(10, 40)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostingsBoard()));
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

import 'package:flutter/material.dart';
import 'package:subleasier/firebase_options.dart';
import 'sublessor/posting_form.dart';
import 'sublessee/postings_board.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subleasier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SUBLEASIER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            widget.title,
            style: const TextStyle(
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
        body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 110.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(230, 191, 87, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Set border radius to 0 for a rectangular button
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SublessorForm()),
                    );
                  },
                  child: const Column(
                    children: [
                      SizedBox(height: 30.0),
                      Text('I\'m a Sublessor',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 22.0, color: Colors.white)),
                      SizedBox(height: 10.0),
                      Text(
                        'Looking for a Subtenant',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(230, 191, 87, 0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Set border radius to 0 for a rectangular button
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostingsBoard()),
                    );
                  },
                  child: const Column(
                    children: [
                      SizedBox(height: 30.0),
                      Text('I\'m a Sublessee',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 22.0, color: Colors.white)),
                      SizedBox(height: 10.0),
                      Text(
                        'Looking for an Apartment',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

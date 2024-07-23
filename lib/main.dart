import 'package:flutter/material.dart';
import 'sublessor/posting_form.dart';
import 'sublessee/postings_board.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

String selectedPage = '';

Future<void> main() async {
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
        routes: {
          '/home': (context) => const MyApp(),
          '/sublessor_form': (context) => const SublessorForm(),
          '/all_listings': (context) => const PostingsBoard(),
          '/profile': (context) => const Profile(),
        });
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
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(230, 191, 87, 0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SublessorForm()),
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
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(230, 191, 87, 0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Set border radius to 0 for a rectangular button
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostingsBoard()),
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

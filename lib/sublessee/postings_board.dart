import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:subleasier/sublessee/chat_screen.dart';
import 'package:subleasier/sublessee/individual_posting.dart';
import 'package:url_launcher/url_launcher.dart';
import '../firestore_service.dart';

String selectedPage = '';
List<Map<String, dynamic>> allPostings = [];

class PostingsBoard extends StatefulWidget {
  const PostingsBoard({super.key});

  @override
  _PostingsBoardState createState() => _PostingsBoardState();
}

class _PostingsBoardState extends State<PostingsBoard> {
  final TextEditingController _controller = TextEditingController();

  Future<void> loadPostings() async {
    List<Map<String, dynamic>> postings = await getAllPostingsFromFirestore();
    setState(() {
      allPostings = postings;
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupByAptName(
      List<Map<String, dynamic>> postings) {
    Map<String, List<Map<String, dynamic>>> groups = {};
    for (int i = 0; i < postings.length; i++) {
      String aptName = postings[i]['apt_name'];
      if (!groups.containsKey(aptName)) {
        groups[aptName] = [postings[i]];
      } else {
        groups[aptName]!.add(postings[i]);
      }
    }
    return groups;
  }

  @override
  void initState() {
    super.initState();
    loadPostings();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedPostings =
        _groupByAptName(allPostings);
    // grouped_postings: {Moontower: [all postings with Moontower], 2400 Nueces: [all postings with 2400 Nueces]}
    final entriesList = groupedPostings.entries.toList();
    // entries_list: [MapEntry(Moontower: []), MapEntry(2400 Nueces: [])]
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
        children: [
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
          Positioned.fill(
              child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  // first ListView.builder is to iterate through the apartments
                  // TODO: maybe change first ListView.builder into .map because the length isn't as much?
                  child: ListView.builder(
                      itemCount: entriesList.length,
                      itemBuilder: (context, index) {
                        final currPostings = entriesList[index].value;
                        return ListTile(
                          title: Container(
                              // padding: EdgeInsets.only(top: 10, left: 15),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(200, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: TextButton(
                                      child: Text(entriesList[index].key,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                      onPressed: () => launchUrlForApt(
                                          currPostings[0]['apt_url']),
                                    )),
                                SizedBox(
                                    height: 220,
                                    // second ListView.builder is for iterating through each posting within the current apartment
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: currPostings.length,
                                        itemBuilder: (currContext, currIndex) {
                                          final posting =
                                              currPostings[currIndex];
                                          return ElevatedButton(
                                              onPressed: () {
                                                navigateToIndividualPosting(
                                                    context, posting);
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty.all<Color>(
                                                          Colors.transparent),
                                                  shadowColor:
                                                      WidgetStateProperty.all<Color?>(
                                                          Colors.transparent),
                                                  shape: WidgetStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20)))),
                                              child: Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(height: 20),
                                                  Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10,
                                                            left: 10),
                                                    child: Image.network(
                                                      width: 150,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                      posting['images'][0],
                                                      loadingBuilder: (BuildContext
                                                              imageContext,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                    ),
                                                  )),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                      '\$${posting['price']}/month',
                                                      style: const TextStyle(
                                                          color: Colors.black)),
                                                ],
                                              ));
                                        }))
                              ])),
                        );
                      }))),
          Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton (
                    backgroundColor: Color.fromARGB(230, 191, 87, 0),
                    onPressed: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(database: allPostings),
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white,)
                    )
                  ),
        ],
      ),
    );
  }
}


Future<List<Map<String, dynamic>>> getAllPostingsFromFirestore() async {
  final db = FirestoreService().db;
  List<Map<String, dynamic>> allPostings = [];
  try {
    QuerySnapshot querySnapshot = await db.collection("postings").get();
    for (var docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> posting = docSnapshot.data() as Map<String, dynamic>;
      posting['id'] = docSnapshot.id;
      allPostings.add(posting);
    }
  } catch (e) {
    print("Error completing: $e");
  }
  return allPostings;
}

void navigateToIndividualPosting(
    BuildContext context, Map<String, dynamic> posting) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => IndividualPosting(posting: posting)),
  );
}

void launchUrlForApt(String url) async {
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }
  try {
    Uri urlUri = Uri.parse(url);
    if (await canLaunchUrl(urlUri)) {
      await launchUrl(urlUri);
    } else {
      print("Can't launch URL: $url");
    }
  } catch (e) {
    print("Error in launching URL: $e");
  }
}

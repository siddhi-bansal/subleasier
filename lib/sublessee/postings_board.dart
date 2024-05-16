import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firestore_service.dart';
import '../sublessor/posting_form.dart';

List<Map<String, dynamic>> all_postings = [];

class PostingsBoard extends StatefulWidget {
  @override
  _PostingsBoardState createState() => _PostingsBoardState();
}

class _PostingsBoardState extends State<PostingsBoard> {
  Future<void> loadPostings() async {
    List<Map<String, dynamic>> postings = await get_all_postings_from_db();
    setState(() {
      all_postings = postings;
    });
  }

  Map<String, List<Map<String, dynamic>>> group_by_location(List<Map<String, dynamic>> postings) {
    Map<String, List<Map<String, dynamic>>> groups = {};
    for (int i = 0; i < postings.length; i++) {
      String location = postings[i]['location'];
      if (!groups.containsKey(location)) {
        groups[location] = [postings[i]];
      } else {
        groups[location]!.add(postings[i]);
      }
    }
    return groups;
  }

  @override
  void initState() {
    super.initState();
    loadPostings();
  }

  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> grouped_postings = group_by_location(all_postings);
    // print(grouped_postings); // for debugging
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
        body: Stack (
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
          ),
        ),
        const Positioned.fill( 
          child: Align (
            alignment: Alignment.center,
            child: const Text('hi'),
          )
           //      ListView.builder(
          //       itemCount: grouped_postings.length,
          //       itemBuilder: (context, index) {
          //         return ListTile(
          //           title: Container(
          //             padding: EdgeInsets.all(12),
          //             margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             child: Text(grouped_postings[index]?.isNotEmpty ?? false ? grouped_postings[index]![0]['name'] : ''),
          //           ),
          //         );
          //       },
          // )
        )],
          ),
          );
  }
}

Future<List<Map<String, dynamic>>> get_all_postings_from_db() async {
    final db = FirestoreService().db;
    List<Map<String, dynamic>> all_postings = [];
    try {
      QuerySnapshot querySnapshot = await db.collection("postings").get();
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> posting = docSnapshot.data() as Map<String, dynamic>;
        all_postings.add(posting);
      }
    } catch(e) {
      print("Error completing: $e");
    }
    return all_postings;
  }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firestore_service.dart';

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

  @override
  void initState() {
    super.initState();
    loadPostings();
  }

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
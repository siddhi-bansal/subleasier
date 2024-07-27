import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const geminiApiKey = 'AIzaSyD_Y1NAZtWP2DvgD3OT748H3nJT2m-sxV4';

class ChatScreen extends StatefulWidget {
  final List<Map<String, dynamic>> database;

  const ChatScreen({super.key, required this.database});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _geminiResponseLoading = false;
  final List<String> _messages = [];
  final List<Content> _historyContents = [];

  @override
  void initState() {
    super.initState();
  }
    
  Future<String> chatWithGemini(String message) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: geminiApiKey);
    setState(() {
      _geminiResponseLoading = true;
    });
    try {
      final chat = model.startChat(history: _historyContents);
      String finalMessage = "Based on the following requirements of the user and the provided database of allListings, return the top 5 recommendations for the user. Return only a list of IDs of the top 5 recommendations as Strings with double quotations. If the user's message does not describe requirements, just return an empty list\n";
      finalMessage += "User Message: $message\n";
      finalMessage += "Database: ${widget.database}\n";
      final response = await chat.sendMessage(Content.text(finalMessage));
      List<dynamic> aptRecsList = jsonDecode(response.text!);
      if (aptRecsList.isEmpty) {
        return 'I am sorry, but I could not find any apartment recommendations for you based on your responses.';
      } else {
        return 'Sure! Here are some apartment recommendations for you based on your responses: \n${aptRecsList.toString()}';
      }
    } catch (e) {
      print(e);
      return 'A problem occured. Please try again.';
    } finally {
      setState(() {
        _geminiResponseLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
    }
  }

  void _sendMessage() async {
    String input = _chatController.text;
    _chatController.clear();
    setState(() {
      _messages.add('Me: $input');
      _historyContents.add(Content.text('Me: $input'));
    });
    _scrollToBottom();
      String response = await chatWithGemini(input);
      setState(() {
      _messages.add('Gemini: $response');
      _historyContents.add(Content.text('Gemini: $response'));
      });
      _scrollToBottom();
    }

    Widget _buildMessageBubble(String message, int index) {
    bool isMe = index % 2 == 0;
    return 
    Container(
      padding: isMe ? const EdgeInsets.only(left: 60, bottom: 15) : const EdgeInsets.only(right: 60, bottom: 15),
      child: Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? const Color.fromARGB(230, 191, 87, 0) : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Padding(padding: EdgeInsets.only(left: 20, right: 20),
          child: Text("Welcome to Chat with Gemini!",  textAlign: TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ))),
          const SizedBox(height: 10),
          const Padding(padding: EdgeInsets.only(left: 20, right: 20), 
          child: Text("Tell us what you're looking for and we'll provide you with some apartment recommendations.", textAlign: TextAlign.center, style: TextStyle(
                fontSize: 14.0, // Adjust the font size of the subtitle
              ))),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], index);
              },
            ),
          ),
          _geminiResponseLoading ? const LinearProgressIndicator() : const SizedBox(), 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container (
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 15, bottom: 20),
              child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Adjust border radius as needed
      borderSide: BorderSide(
        color: Color.fromARGB(230, 191, 87, 0), // Set the border color
        width: 1.0, // Adjust border width as needed
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)), // Adjust border radius as needed
      borderSide: BorderSide(
        color: Color.fromARGB(230, 191, 87, 0), // Set the border color
        width: 2.0, // Adjust border width as needed
      ),
    ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color.fromARGB(230, 191, 87, 0),
                  onPressed: _sendMessage,
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}
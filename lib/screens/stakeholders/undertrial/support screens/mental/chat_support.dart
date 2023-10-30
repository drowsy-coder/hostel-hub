// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messageInsert = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        elevation: 10,
        title: const Text("Mental Health Chatbot"),
      ),
      body: Stack(
        children: [
          Container(
            //get max height
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: false,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (_chatHistory[index]["isSender"]
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: (_chatHistory[index]["isSender"]
                            ? Color.fromARGB(255, 0, 0, 0)
                            : Colors.white),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(_chatHistory[index]["message"],
                          style: TextStyle(
                              fontSize: 15,
                              color: _chatHistory[index]["isSender"]
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(255, 0, 0, 0),
                            ]),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          controller: messageInsert,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (messageInsert.text.isNotEmpty) {
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": messageInsert.text,
                            "isSender": true,
                          });
                          messageInsert.clear();
                        }
                      });
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );

                      getAnswer();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF69170),
                              Color(0xFFF69170),
                            ]),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0,
                              minHeight:
                                  36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.send,
                            color: Colors.black,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Bubble(
        radius: const Radius.circular(15.0),
        color: data == 0 ? Colors.blue : Colors.orange,
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(data == 0
                    ? "assets/images/bot.png"
                    : "assets/images/profile.png"),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                  child: Text(
                message,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void getAnswer() async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=AIzaSyDSBUzYXvYfxV9p_ATprNMm6luUdvrUTbg";
    final uri = Uri.parse(url);
    List<Map<String, String>> msg = [];
    for (var i = 0; i < _chatHistory.length; i++) {
      msg.add({"content": _chatHistory[i]["message"]});
    }

    Map<String, dynamic> request = {
      "prompt": {
        "messages": [msg]
      },
      "temperature": 0.25,
      "candidateCount": 1,
      "topP": 1,
      "topK": 1
    };

    final response = await http.post(uri, body: jsonEncode(request));

    setState(() {
      _chatHistory.add({
        "time": DateTime.now(),
        "message": json.decode(response.body)["candidates"][0]["content"],
        "isSender": false,
      });
    });

    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }
}

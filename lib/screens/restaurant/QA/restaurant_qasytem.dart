import 'package:flutter/material.dart';
import 'package:jkmapp/providers/QA/QA_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA/Speech_provider.dart';
import 'package:go_router/go_router.dart';

class RestaurantQASystem extends StatefulWidget {
  const RestaurantQASystem({super.key});

  @override
  RestaurantQASystemState createState() => RestaurantQASystemState();
}

class RestaurantQASystemState extends State<RestaurantQASystem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final speechProvider = Provider.of<SpeechProvider>(context, listen: false);
    speechProvider.initializeSpeech();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final qaProvider = Provider.of<QAprovider>(context, listen: false);
      String userQuestion = _controller.text;
      qaProvider.sendMessage(userQuestion);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final qaProvider = Provider.of<QAprovider>(context);
    final speechProvider = Provider.of<SpeechProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              '歡迎使用客服系統',
              style: TextStyle(fontFamily: 'Cursive', fontSize: 30),
            ),
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: qaProvider.messages.length,
                itemBuilder: (context, index) {
                  final message = qaProvider.messages[index];
                  bool isUser = message['sender'] == "user";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.black12 : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text'] ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _controller.text = '點餐';
                      _sendMessage();
                    },
                    child: const Text('點餐', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '請輸入你的問題',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF223888)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF223888)),
                    onPressed: _sendMessage,
                  ),
                  GestureDetector(
                    onTap: () => speechProvider.startRecording(
                      context,
                      _controller,
                      _sendMessage,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.mic,
                        color: speechProvider.isRecording
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
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

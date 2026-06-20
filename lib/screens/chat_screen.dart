import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../services/chat_api_service.dart';
import '../models/chat_message.dart';



class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String title;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();


  final ChatApiService apiService = ChatApiService();

  List<Message> messages = [];

  bool isLoading = true;
  bool isSending = false;
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    _controller.clear();

    setState(() {
      isSending = true;
    });

    final response = await apiService.sendMessage(
      conversationId: widget.conversationId,
      message: text,
    );

    if (response != null) {
      await loadMessages();
    }

    setState(() {
      isSending = false;
    });
  }
  Future<void> loadMessages() async {
    final data = await apiService.getMessages(
      widget.conversationId,
    );

    setState(() {
      messages = data.map((msg) {
        return Message(
          text: msg.content,
          isUser: msg.role == "user",
        );
      }).toList();

      isLoading = false;
    });

    print(
      "Loaded ${data.length} messages",
    );
  }
  Future<void> _deleteChat() async {
    await apiService.deleteConversation(
      widget.conversationId,
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();

    print(
      "Conversation ID: ${widget.conversationId}",
    );

    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        text: messages[index].text,
                        isUser: messages[index].isUser,
                      );
                    },
                  ),
                ),

                if (isSending)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),

          MessageInput(
            controller: _controller,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
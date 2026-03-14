import 'package:flutter/material.dart';

class DonorMessagesPage extends StatefulWidget {
  const DonorMessagesPage({super.key});

  @override
  State<DonorMessagesPage> createState() => _DonorMessagesPageState();
}

class _DonorMessagesPageState extends State<DonorMessagesPage> {
  final TextEditingController messageController = TextEditingController();

  /// List of sample conversations
  final List<Map<String, String>> conversations = [
    {
      "name": "CareBridge Admin",
      "lastMessage": "Thank you for supporting Alice!",
      "time": "10:30 AM"
    },
    {
      "name": "Project Coordinator",
      "lastMessage": "Renovation project update available.",
      "time": "Yesterday"
    },
    {
      "name": "Events Team",
      "lastMessage": "You are invited to our next charity event.",
      "time": "2 days ago"
    },
  ];

  /// Messages per conversation (key = conversation index)
  final Map<int, List<Map<String, Object>>> messagesPerConversation = {
    0: [
      {"text": "Hello! Thank you for supporting our children.", "isMe": false},
      {"text": "You're welcome. How is Alice doing?", "isMe": true},
      {"text": "She is doing great and improving at school.", "isMe": false},
    ],
    1: [],
    2: [],
  };

  /// Currently selected conversation
  int? selectedConversationIndex;

  /// Send message to current conversation
  void sendMessage() {
    if (selectedConversationIndex == null) return;

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messagesPerConversation[selectedConversationIndex!]!.add({
        "text": text,
        "isMe": true,
      });
    });

    messageController.clear();
  }

  /// Conversation ListTile
  Widget conversationTile(Map<String, String> convo, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(convo["name"]!),
      subtitle: Text(convo["lastMessage"]!),
      trailing: Text(
        convo["time"]!,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      selected: selectedConversationIndex == index,
      onTap: () {
        setState(() {
          selectedConversationIndex = index;
        });
      },
    );
  }

  /// Single message bubble
  Widget messageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isMe ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  /// Chat area for a conversation
  Widget chatArea(int convoIndex) {
    final convoMessages = messagesPerConversation[convoIndex]!;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: convoMessages.length,
            itemBuilder: (context, index) {
              final msg = convoMessages[index];
              return messageBubble(
                msg["text"] as String,
                msg["isMe"] as bool,
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.deepPurple),
                onPressed: sendMessage,
              )
            ],
          ),
        ),
      ],
    );
  }

  /// Conversation list view
  Widget conversationList() {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        return conversationTile(conversations[index], index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Row(
        children: [
          /// Conversation list
          Container(
            width: isWide ? 320 : width,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: conversationList(),
          ),

          /// Chat area (only wide screens or if selected conversation exists)
          if (isWide && selectedConversationIndex != null)
            Expanded(
              child: chatArea(selectedConversationIndex!),
            ),
        ],
      ),
    );
  }
}
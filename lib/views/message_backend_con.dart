import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagePage extends StatelessWidget {
  final String currentUserID;
  final String otherUserID;

  MessagePage({required this.currentUserID, required this.otherUserID});

  @override
  Widget build(BuildContext context) {
    String conversationID = _generateConversationID();
    TextEditingController _textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
            ),
            SizedBox(width: 10),
            Text(otherUserID),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Handle phone press action
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Handle video call press action
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Handle info press action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .where('conversationID', isEqualTo: conversationID)
                  
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No messages available"),
                  );
                } else {
                  List<DocumentSnapshot> messages = snapshot.data!.docs;
                  messages = messages.reversed.toList();
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> messageData =
                          messages[index].data() as Map<String, dynamic>;
                      bool isCurrentUserMessage =
                          messageData['senderID'] == currentUserID;
                      return _buildMessageBubble(
                          messageData['message'], isCurrentUserMessage);
                    },
                  );
                }
              },
            ),
          ),
          Container(
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      // Handle more options press action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      // Handle camera press action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () {
                      // Handle image press action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      // Handle microphone press action
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: TextField(
                          controller: _textEditingController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                final String message =
                                    _textEditingController.text.trim();
                                if (message.isNotEmpty) {
                                  sendMessage(message, conversationID);
                                  _textEditingController.clear();
                                }
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {
                      // Handle thumbs up press action
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isCurrentUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_placeholder.jpg'),
              radius: 15,
            ),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Align(
              alignment:
                  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.green : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String message, String conversationID) {
    FirebaseFirestore.instance.collection('messages').add({
      'message': message,
      'senderID': currentUserID,
      'recipientID': otherUserID,
      'conversationID': conversationID,
      'timestamp': Timestamp.now(),
    });
  }

  String _generateConversationID() {
    // Sort the user IDs alphabetically to maintain consistency
    List<String> sortedUserIDs = [currentUserID, otherUserID]..sort();
    return '${sortedUserIDs[0]}-${sortedUserIDs[1]}';
  }
}

import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400, // Slightly darker shade of gray
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
            Text('Name'),
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
            child: ListView(
              children: [
                _buildMessageBubble('hi how are you?', true),
                _buildMessageBubble('good and you?', false),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade400, // Same color as app bar
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
                        color: Colors.white, // Lighter color for the message input
                        borderRadius: BorderRadius.circular(20), // Rounded edges
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0), // Add padding to the bottom
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            border: InputBorder.none,
              
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: IconButton( // Happy face icon as suffix
                              icon: Icon(Icons.sentiment_satisfied),
                              onPressed: () {
                                // Handle emoji press action
                              },
                            ),
                          ),
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
              alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
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
}

import 'package:christmes/screens/chatDetailPage.dart';
import 'package:christmes/widgets/conversationList.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import '../misc/colors.dart';
import 'loginPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  void _logout() async {
    final client = Provider.of<Client>(context, listen: false);
    await client.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  void _join(Room room) async {
    if (room.membership != Membership.join) {
      await room.join();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          'Chats',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        // TODO: Logout an der stelle ausbauen, macht keinen Sinn geht auch in den Settings
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Conversations",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      foregroundColor: Colors.pink.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 0,
                      minimumSize: const Size(10, 30),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add New"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Chat List
              StreamBuilder(
                stream: client.onSync.stream,
                builder: (context, _) {
                  return ListView.builder(
                    itemCount: client.rooms.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      final room = client.rooms[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ConversationList(
                          name: room.getLocalizedDisplayname(),
                          messageText:
                          room.lastEvent?.body ?? 'No messages yet',
                          imageUrl: room.avatar.toString(),
                          time: room.lastEvent?.originServerTs
                              .toLocal()
                              .toString()
                              .split('.')[0] ??
                              '',
                          isMessageRead: room.notificationCount > 0,
                          client: client,
                          room: room,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

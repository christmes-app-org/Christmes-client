import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatefulWidget {
  final Room room;
  const ChatDetailPage({required this.room, Key? key}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _sendController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timelineFuture = widget.room.getTimeline(
      onInsert: (i) => _listKey.currentState?.insertItem(i),
      onRemove: (i) => _listKey.currentState?.removeItem(i, (_, __) => const ListTile()),
    );
  }

  void _send() {
    final text = _sendController.text.trim();
    if (text.isNotEmpty) {
      widget.room.sendTextEvent(text);
      _sendController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = widget.room.avatar?.getThumbnailUri(
      widget.room.client,
      width: 80,
      height: 80,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              foregroundImage: avatarUrl != null ? NetworkImage(avatarUrl.toString()) : null,
              child: avatarUrl == null
                  ? Text(widget.room.getLocalizedDisplayname().characters.first.toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.room.getLocalizedDisplayname(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Online", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black54),
              onPressed: () {}, // optional
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Timeline>(
              future: _timelineFuture,
              builder: (context, snapshot) {
                final timeline = snapshot.data;
                if (timeline == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    // "Mehr laden"-Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: TextButton(
                        onPressed: timeline.requestHistory,
                        child: const Text('Mehr laden...'),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: AnimatedList(
                        key: _listKey,
                        reverse: true,
                        initialItemCount: timeline.events.length,
                          itemBuilder: (context, i, animation) {
                            final event = timeline.events[i];
                            if (event.relationshipEventId != null) return const SizedBox.shrink();

                            final isMe = event.sender.id == widget.room.client.userID;
                            final message = event.getDisplayEvent(timeline).body;
                            final time = DateFormat.Hm().format(event.originServerTs.toLocal());
                            final senderName = event.sender.calcDisplayname();

                            // Vergleich mit vorheriger Nachricht (nächste im Array wegen reverse: true)
                            final isFirstFromSender = i == timeline.events.length - 1 || timeline.events[i + 1].sender.id != event.sender.id;
                            final showName = !isMe && isFirstFromSender;

                            final isLastFromSenderInMinute = i == 0 ||
                                timeline.events[i - 1].sender.id != event.sender.id ||
                                timeline.events[i - 1].originServerTs.difference(event.originServerTs).inMinutes != 0;
                            final showTime = isLastFromSenderInMinute;



                            return SizeTransition(
                              sizeFactor: animation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    if (showName)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          senderName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                      decoration: BoxDecoration(
                                        color: isMe ? Colors.blueAccent : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                                          bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: Text(
                                        message,
                                        style: TextStyle(
                                          color: isMe ? Colors.white : Colors.black87,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    if (showTime)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          time,
                                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }


                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _sendController,
                      decoration: const InputDecoration(
                        hintText: 'Nachricht schreiben...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

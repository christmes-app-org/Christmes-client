

import 'package:christmes/models/chatMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class ChatDetailPage extends StatefulWidget{
  final Room room;
  const ChatDetailPage({required this.room, Key? key}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}


class _ChatDetailPageState extends State<ChatDetailPage> {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _count = 0;

  @override
  void initState() {
    _timelineFuture = widget.room.getTimeline(onChange: (i) {
      print('on change! $i');
      _listKey.currentState?.setState(() {});
    }, onInsert: (i) {
      print('on insert! $i');
      _listKey.currentState?.insertItem(i);
      _count++;
    }, onRemove: (i) {
      print('On remove $i');
      _count--;
      _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
    }, onUpdate: () {
      print('On update');
    });
    super.initState();
  }

  final TextEditingController _sendController = TextEditingController();

  void _send() {
    widget.room.sendTextEvent(_sendController.text.trim());
    _sendController.clear();
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: NetworkImage("https://matrix-client.matrix.org/_matrix/media/v3/thumbnail/matrix.org/tHwINSDGpHigLhiNfKAQxMeR?width=800&height=600&method=scale"),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.room.getLocalizedDisplayname(),style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),

                  Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),



      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Timeline>(
                future: _timelineFuture,
                builder: (context, snapshot) {
                  final timeline = snapshot.data;
                  if (timeline == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  _count = timeline.events.length;
                  return Column(
                    children: [
                      Center(
                        child: TextButton(
                            onPressed: timeline.requestHistory,
                            child: const Text('Load more...')),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: AnimatedList(
                          key: _listKey,
                          reverse: true,
                          initialItemCount: timeline.events.length,
                          itemBuilder: (context, i, animation) => timeline
                              .events[i].relationshipEventId !=
                              null
                              ? Container()
                              : ScaleTransition(
                            scale: animation,
                            child: Opacity(
                              opacity: timeline.events[i].status.isSent
                                  ? 1
                                  : 0.5,
                              child: ListTile(
                                leading: CircleAvatar(
                                  foregroundImage: timeline.events[i]
                                      .sender.avatarUrl ==
                                      null
                                      ? null
                                      : NetworkImage(timeline
                                      .events[i].sender.avatarUrl!
                                      .getThumbnailUri(
                                    widget.room.client,
                                    width: 56,
                                    height: 56,
                                  )
                                      .toString()),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(timeline
                                          .events[i].sender
                                          .calcDisplayname()),
                                    ),
                                    Text(
                                      timeline.events[i].originServerTs
                                          .toIso8601String(),
                                      style:
                                      const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                subtitle: Text(timeline.events[i]
                                    .getDisplayEvent(timeline)
                                    .body),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: _sendController,
                        decoration: const InputDecoration(
                          hintText: 'Send message',
                        ),
                      )),
                  IconButton(
                    icon: const Icon(Icons.send_outlined),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
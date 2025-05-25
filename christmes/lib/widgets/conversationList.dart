import 'dart:developer';

import 'package:christmes/screens/chatDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:hive/hive.dart';

import '../models/chatMessageModel.dart';
class ConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  Client client;
  Room room;
  ConversationList({super.key, required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead, required this.client, required this.room});

  @override
  _ConversationListState createState() => _ConversationListState();
}

String? mxcToHttp(String? mxcUrl) {
  if (mxcUrl == null || !mxcUrl.startsWith("mxc://")) return null;

  final cleaned = mxcUrl.replaceFirst("mxc://", "");
  final parts = cleaned.split("/");

  if (parts.length != 2) return null;

  final server = parts[0];
  final mediaId = parts[1];

//  return "https://$server/_matrix/media/v3/thumbnail/$server/$mediaId"
  return "https://matrix-client.matrix.org/_matrix/media/v3/thumbnail/$server/$mediaId"
      "?width=64&height=64&method=crop&allow_redirect=true";
}




class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if (widget.room.membership != Membership.join) {
          await widget.room.join();
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(room: widget.room),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: (widget.imageUrl.isNotEmpty)
                        ? NetworkImage(mxcToHttp(widget.imageUrl) ?? '')
                        : null,
                    child: (widget.imageUrl.isEmpty)
                        ? Text(
                      widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                        : null,
                    maxRadius: 30,
                  ),

                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}
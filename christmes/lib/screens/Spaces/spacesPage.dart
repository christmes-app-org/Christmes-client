import 'package:christmes/screens/chatDetailPage.dart';
import 'package:christmes/widgets/conversationList.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import '../../misc/colors.dart';


class SpacesPage extends StatefulWidget {
  const SpacesPage({Key? key}) : super(key: key);

  @override
  SpacesPageState createState() => SpacesPageState();
}

class SpacesPageState extends State<SpacesPage> {
  void _openSpace(Room space) async {
    if (space.membership != Membership.join) {
      await space.join();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(room: space),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<Client>(context, listen: false);
    final theme = Theme.of(context);

    final spaces = client.rooms.where((room) => room.isSpace).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          'Spaces',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Your Spaces",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Funktion zum Erstellen eines neuen Spaces und anpassen an UI
                    },
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
                    label: const Text("New Space"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search Spaces...",
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

              // Space List
              StreamBuilder(
                stream: client.onSync.stream,
                builder: (context, _) {
                  return GridView.builder(
                    itemCount: spaces.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Zwei Kacheln pro Zeile
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2, // Seitenverhältnis (anpassbar)
                    ),
                    itemBuilder: (context, i) {
                      final space = spaces[i];
                      return GestureDetector(
                        onTap: () => _openSpace(space),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(space.avatar.toString()),
                                radius: 24,
                                backgroundColor: Colors.grey.shade200,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                space.getLocalizedDisplayname(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                space.lastEvent?.body ?? "No recent activity",
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.black54,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                space.lastEvent?.originServerTs
                                    .toLocal()
                                    .toString()
                                    .split('.')[0] ??
                                    '',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
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

// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../models/dashboardPost.dart';
import '../../models/userPermissionDashboard.dart';
import '../../misc/colors.dart';
import 'editDashboardPostDialog.dart';


class DashboardDetailScreen extends StatefulWidget {
  final DashboardPost post;

  const DashboardDetailScreen({super.key, required this.post});

  @override
  State<DashboardDetailScreen> createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {
  late DashboardPost post;
  String? attendance; // 'yes', 'no'
  bool liked = false;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  UserPermissions get currentUserPermissions {
    return post.username == "Max"
        ? UserPermissions(canRead: true, canWrite: true, canEdit: true, isAdmin: true)
        : UserPermissions(canRead: true, canWrite: true);
  }

  void _onAttend(String choice) {
    setState(() {
      attendance = (attendance == choice) ? null : choice;
    });
  }

  void _onLike() {
    setState(() {
      liked = !liked;
    });
  }

  Future<void> _showEditDialog() async {
    final updated = await showDialog<DashboardPost>(
      context: context,
      builder: (context) => EditDashboardPostDialog(
        originalPost: post,
        permissions: currentUserPermissions,
        onSave: (updatedPost) {
          Navigator.of(context).pop(updatedPost);
        },
      ),
    );

    if (updated != null) {
      setState(() {
        post = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beitrag aktualisiert')),
      );
    }
  }

  bool _showsDate() {
    final type = post.type.toLowerCase();
    return type == 'veranstaltung' || type == 'mitarbeitersuche';
  }

  bool _showsAttendanceButtons() {
    final type = post.type.toLowerCase();
    return !(type == 'suche' || type == 'empfehle');
  }

  bool _showsRunning() {
    return post.isRunning && _showsDate();
  }

  bool get canEdit => currentUserPermissions.canEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.type),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //TODO: Das Bild ist ein Bild, das in der Nachricht mit dranhängt
          children: [
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 40),
                ),
              ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                post.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 16),

            //TODO: Zusage und Absage sind Reaktionen auf eine Nachricht also thumbsup und thumbsdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (_showsAttendanceButtons()) ...[
                    _buildAttendButton('yes', Icons.thumb_up, 'Zusage'),
                    _buildAttendButton('no', Icons.thumb_down, 'Absage'),
                  ],
                  _buildLikeButton(),
                  if (canEdit)
                    ElevatedButton.icon(
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text("Bearbeiten"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),

                  if (post.type.toLowerCase() == 'veranstaltung' && post.location != null)
                    Row(
                      children: [
                        const Icon(Icons.place, size: 20),
                        const SizedBox(width: 6),
                        Text(post.location!, style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  if (post.location != null) const SizedBox(height: 16),

                  if (_showsDate()) ...[
                    Row(
                      children: [
                        Icon(_getIconForType(post.type), color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(post.formattedDateRange),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (_showsRunning())
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text("Läuft gerade", style: TextStyle(color: Colors.white)),
                    ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                      ),
                      const SizedBox(width: 10),
                      Text(post.username, style: const TextStyle(fontSize: 15)),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendButton(String type, IconData icon, String label) {
    final isSelected = attendance == type;

    return ElevatedButton.icon(
      onPressed: () => _onAttend(type),
      icon: Icon(icon, color: isSelected ? Colors.white : AppColors.primary),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.secondary : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
  //TODO: Gefällt mir ist die Chatreaktion Herz
  Widget _buildLikeButton() {
    return ElevatedButton.icon(
      onPressed: _onLike,
      icon: Icon(Icons.favorite, color: liked ? Colors.white : AppColors.primary),
      label: const Text('Gefällt mir'),
      style: ElevatedButton.styleFrom(
        backgroundColor: liked ? AppColors.secondary : Colors.grey[200],
        foregroundColor: liked ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'veranstaltung':
        return Icons.event;
      case 'ankündigung':
        return Icons.campaign;
      case 'suche':
        return Icons.search;
      case 'empfehle':
        return Icons.thumb_up;
      case 'mitarbeitersuche':
        return Icons.work;
      default:
        return Icons.info;
    }
  }
}



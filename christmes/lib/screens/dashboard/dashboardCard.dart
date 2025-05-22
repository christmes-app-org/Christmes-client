import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/dashboardPost.dart';
import '../../misc/colors.dart';
import 'dashbaordDetailScreen.dart';



class DashboardCard extends StatelessWidget {
  final DashboardPost post;

  const DashboardCard({super.key, required this.post});

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

  bool _showsDate() {
    final type = post.type.toLowerCase();
    return type == 'veranstaltung' || type == 'mitarbeitersuche';
  }

  bool _showsRunning() {
    return post.isRunning && _showsDate();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardDetailScreen(post: post),
          ),
        );
      },
      //TODO: Stern durch Offical Logo ersetzen - Ich habe das bei mir schon als Datei
      child: Stack(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColors.backgroundLight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Links: Informationen
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("von ${post.username}", style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),

                        // Titel (fett)
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Typ-Zeile mit Icon
                        Row(
                          children: [
                            Icon(_getIconForType(post.type), size: 18, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(post.type, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Datum nur bei Veranstaltung / Mitarbeitersuche
                        if (_showsDate())
                          Text(
                            post.formattedDateRange,
                            style: const TextStyle(fontSize: 13),
                          ),

                        // "Läuft gerade"
                        if (_showsRunning()) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              "Läuft gerade",
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Rechts: Bild mit Verlauf
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 150,
                      height: 100,
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 100,
                            child: Image.network(
                              post.imageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 30),
                            ),
                          ),
                          // Verlaufs-Overlay (linkes Drittel)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 150 / 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.backgroundLight,
                                      AppColors.backgroundLight.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Offical-Stern
          if (post.isOfficial)
            Positioned(
              top: 5,
              right: 15,
              child: SvgPicture.asset(
               // 'assets/icons/official.svg',
                'assets/icons/christmes_offical_2025.svg',
                height: 32,
                width: 32,
              ),
            ),
        ],
      ),
    );
  }
}

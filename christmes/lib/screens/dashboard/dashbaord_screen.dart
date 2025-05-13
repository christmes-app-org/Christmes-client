import 'package:flutter/material.dart';
import '../../models/dashboardPost.dart';
import '../../misc/colors.dart';
import 'dashboardCard.dart';
import 'package:flutter/gestures.dart';

//TODO: Beitrag erstellen Button etc. einfügen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
//TODO: hier noch die hintergrundfarbe auf die backgroundfarbe ändern
class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> tabs = [
    'Alle',
    'Offiziell',
    'Veranstaltung',
    'Empfehlung',
    'Mitarbeitersuche',
    'Biete/Suche',
  ];

  //TODO: Wenn Matrix anbindung da ist, ersetzten durch chat inhalt und Messagebuilder
  int selectedTabIndex = 0;
  final List<DashboardPost> allPosts = [
    DashboardPost(
      title: "Community Meetup",
      type: 'Veranstaltung',
      dateTime: DateTime(2025, 5, 11, 18),
      username: "Max",
      imageUrl: 'https://images.pexels.com/photos/31592126/pexels-photo-31592126/free-photo-of-eichhornchen-auf-baumstamm-im-nebligen-wald.jpeg',
      description: 'Ein Treffen im Park zum gemeinsamen Austausch über Projekte.',
      location: 'Stadtpark Berlin',
    ),
    DashboardPost(
      title: "Homeoffice-Update",
      type: 'Ankündigung',
      dateTime: DateTime(2025, 5, 11, 18),
      username: "Max",
      description: 'Neue Regelungen zum Homeoffice treten ab Juni in Kraft.',
    ),
    DashboardPost(
      title: "Schulung Projektkommunikation",
      type: 'Veranstaltung',
      dateTime: DateTime(2025, 5, 11, 18),
      username: "Anna",
      isOfficial: true,
      description: 'Interne Schulung zur Projektkommunikation.',
      location: 'Raum 4.03, HQ Berlin',
    ),
    DashboardPost(
      title: "UX-Hilfe gesucht",
      type: 'Suche',
      dateTime: DateTime(2025, 5, 11, 18),
      username: "Tom",
      description: 'Suche Unterstützung für ein internes UX-Projekt.',
    ),
    DashboardPost(
      title: "Open Coffee Hour",
      type: 'Veranstaltung',
      dateTime: DateTime(2025, 5, 11, 18),
      username: "Jana",
      isRunning: true,
      description: 'Informeller Austausch mit Kollegen bei Kaffee.',
      location: 'Cafeteria EG',
    ),
    DashboardPost(
      title: "Buchtipp: Simon Sinek",
      type: 'Empfehle',
      dateTime: DateTime(2025, 5, 11, 18),
      username: "Ben",
      description: 'Ich empfehle das neue Buch von Simon Sinek zum Thema Leadership.',
    ),
  ];


  @override
  Widget build(BuildContext context) {
    List<DashboardPost> filtered = switch (selectedTabIndex) {
      0 => allPosts,
      1 => allPosts.where((p) => p.isOfficial).toList(),
      2 => allPosts.where((p) => p.type == 'Veranstaltung').toList(),
      3 => allPosts.where((p) => p.type == 'Empfehle').toList(),
      4 => allPosts.where((p) => p.type == 'Mitarbeitersuche').toList(),
      5 => allPosts.where((p) => p.type == 'Suche' || p.type == 'Biete').toList(),
      _ => allPosts,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          const SizedBox(height: 8),
          // Horizontale Filterleiste mit Maus-Support
          ScrollConfiguration(
            behavior: _MouseScrollHorizontalBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = selectedTabIndex == index;
                  final isOfficialTab = tabs[index].toLowerCase() == 'offiziell';

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(tabs[index]),
                      selected: isSelected,
                      onSelected: (_) => setState(() => selectedTabIndex = index),
                      selectedColor: isOfficialTab
                          ? AppColors.official
                          : AppColors.primary,
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return DashboardCard(post: filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 🖱 Ermöglicht horizontales Scrollen mit Mausrad
class _MouseScrollHorizontalBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
  };
}

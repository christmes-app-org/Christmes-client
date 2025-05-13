//TODO: Prüfen ob nach Matrix anbindung für Dashbaord noch relevant
class DashboardPost {
  final String title;
  final String type;
  final DateTime dateTime;
  final DateTime? endDateTime;
  final String username;
  final String? imageUrl;
  final bool isRunning;
  final bool isOfficial;
  final String description;
  final String? location;

  DashboardPost({
    required this.title,
    required this.type,
    required this.dateTime,
    this.endDateTime,
    required this.username,
    this.imageUrl,
    this.isRunning = false,
    this.isOfficial = false,
    required this.description,
    this.location,
  });

  String get formattedDateTime {
    return "So, ${_formatDate(dateTime)} - ${_formatTime(dateTime)}";
  }

  String get formattedDateRange {
    final start = _formatDate(dateTime) + " ${_formatTime(dateTime)}";
    final end = endDateTime != null
        ? " – ${_formatDate(endDateTime!)} ${_formatTime(endDateTime!)}"
        : "";
    return start + end;
  }

  String _formatDate(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";

  String _formatTime(DateTime dt) =>
      "${dt.hour.toString().padLeft(2, '0')}:00 - ${(dt.hour + 3).toString().padLeft(2, '0')}:00";

  // Optional: JSON support if needed for storage or API
  Map<String, dynamic> toJson() => {
    'title': title,
    'type': type,
    'dateTime': dateTime.toIso8601String(),
    'username': username,
    'imageUrl': imageUrl,
    'isRunning': isRunning,
    'isOfficial': isOfficial,
    'description': description,
    'location': location,
  };

  factory DashboardPost.fromJson(Map<String, dynamic> json) => DashboardPost(
    title: json['title'] ?? '',
    type: json['type'] ?? '',
    dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
    username: json['username'] ?? 'Unbekannt',
    imageUrl: json['imageUrl'],
    isRunning: json['isRunning'] ?? false,
    isOfficial: json['isOfficial'] ?? false,
    description: json['description'] ?? '',
    location: json['location'],
  );
}

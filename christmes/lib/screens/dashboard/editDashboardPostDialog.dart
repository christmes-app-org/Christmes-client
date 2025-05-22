// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../models/dashboardPost.dart';
import '../../models/userPermissionDashboard.dart';


class EditDashboardPostDialog extends StatefulWidget {
  final DashboardPost originalPost;
  final UserPermissions permissions;
  final void Function(DashboardPost updatedPost) onSave;

  const EditDashboardPostDialog({
    required this.originalPost,
    required this.permissions,
    required this.onSave,
  });

  @override
  State<EditDashboardPostDialog> createState() =>
      _EditDashboardPostDialogState();
}

class _EditDashboardPostDialogState extends State<EditDashboardPostDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endDateController;
  late TextEditingController _endTimeController;
  late TextEditingController _locationController;
  late bool _isOfficial;

  final _formKey = GlobalKey<FormState>();

  bool get isEvent => widget.originalPost.type.toLowerCase() == 'veranstaltung';

  @override
  void initState() {
    final start = widget.originalPost.dateTime;
    final end = widget.originalPost.endDateTime ?? start.add(Duration(hours: 3));

    _titleController = TextEditingController(text: widget.originalPost.title);
    _descController = TextEditingController(text: widget.originalPost.description);
    _startDateController = TextEditingController(text: start.toIso8601String().split('T').first);
    _startTimeController = TextEditingController(
        text: "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}");
    _endDateController = TextEditingController(text: end.toIso8601String().split('T').first);
    _endTimeController = TextEditingController(
        text: "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}");
    _locationController = TextEditingController(text: widget.originalPost.location ?? '');
    _isOfficial = widget.originalPost.isOfficial;
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      try {
        final startDate = DateTime.parse(_startDateController.text);
        final endDate = DateTime.parse(_endDateController.text);
        final startTimeParts = _startTimeController.text.split(":");
        final endTimeParts = _endTimeController.text.split(":");

        final startDateTime = DateTime(
          startDate.year, startDate.month, startDate.day,
          int.parse(startTimeParts[0]), int.parse(startTimeParts[1]),
        );

        final endDateTime = DateTime(
          endDate.year, endDate.month, endDate.day,
          int.parse(endTimeParts[0]), int.parse(endTimeParts[1]),
        );

        final updatedPost = DashboardPost(
          title: _titleController.text,
          type: widget.originalPost.type,
          dateTime: startDateTime,
          endDateTime: endDateTime,
          username: widget.originalPost.username,
          description: _descController.text,
          imageUrl: widget.originalPost.imageUrl,
          location: isEvent ? _locationController.text : widget.originalPost.location,
          isRunning: widget.originalPost.isRunning,
          isOfficial: _isOfficial,
        );

        widget.onSave(updatedPost);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datum oder Uhrzeit ungültig')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Beitrag bearbeiten', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Titel'),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Titel erforderlich' : null,
                ),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: 'Beschreibung'),
                ),
                if (isEvent) ...[
                  const SizedBox(height: 8),
                  Text('Beginn', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(labelText: 'Startdatum (YYYY-MM-DD)'),
                  ),
                  TextFormField(
                    controller: _startTimeController,
                    decoration: InputDecoration(labelText: 'Startzeit (HH:MM)'),
                  ),
                  const SizedBox(height: 8),
                  Text('Ende', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(labelText: 'Enddatum (YYYY-MM-DD)'),
                  ),
                  TextFormField(
                    controller: _endTimeController,
                    decoration: InputDecoration(labelText: 'Endzeit (HH:MM)'),
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Ort'),
                  ),
                ],
                if (widget.permissions.isAdmin)
                  CheckboxListTile(
                    value: _isOfficial,
                    onChanged: (val) =>
                        setState(() => _isOfficial = val ?? false),
                    title: Text("Als offizieller Beitrag markieren"),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Speichern'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/dashboardPost.dart' show DashboardPost;
import '../../models/userPermissionDashboard.dart' show UserPermissions;


class DashboardPostForm extends StatefulWidget {
  final UserPermissions permissions;
  final void Function(DashboardPost post) onSubmit;

  DashboardPostForm({
    required this.permissions,
    required this.onSubmit,
  });

  @override
  _DashboardPostFormState createState() => _DashboardPostFormState();
}

class _DashboardPostFormState extends State<DashboardPostForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isOfficial = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      try {
        final parsedDate = DateTime.parse(_dateController.text);

        final post = DashboardPost(
          title: _titleController.text,
          type: 'veranstaltung', // kann angepasst werden
          dateTime: parsedDate,
          username: 'Max', // ggf. später dynamisch setzen
          description: _descController.text,
          isOfficial: _isOfficial,
        );

        widget.onSubmit(post);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültiges Datum. Format: YYYY-MM-DD')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Datum (YYYY-MM-DD)'),
              ),
              if (widget.permissions.isAdmin)
                CheckboxListTile(
                  value: _isOfficial,
                  onChanged: (val) =>
                      setState(() => _isOfficial = val ?? false),
                  title: Text("Als offizieller Beitrag markieren"),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Beitrag erstellen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

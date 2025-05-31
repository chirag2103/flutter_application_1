import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<String> _notifications = [];

  void _addNotification() {
    setState(() {
      _notifications.insert(0, 'New notification at \${DateTime.now()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNotification,
            tooltip: 'Add Notification',
          ),
        ],
      ),
      body:
          _notifications.isEmpty
              ? const Center(child: Text('No new notifications'))
              : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(_notifications[index]),
                  );
                },
              ),
    );
  }
}

import 'package:flutter/material.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Planning Services"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a Planning Service",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            PlanningOptionCard(
              title: "2D Floor Plan",
              description:
                  "Get a detailed 2D floor plan based on your requirements.",
            ),
            PlanningOptionCard(
              title: "3D Floor Plan",
              description: "Get a realistic 3D view of your construction plan.",
            ),
            PlanningOptionCard(
              title: "Structural Design",
              description: "Receive structural designs for better planning.",
            ),
          ],
        ),
      ),
    );
  }
}

class PlanningOptionCard extends StatelessWidget {
  final String title;
  final String description;

  const PlanningOptionCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(description, style: theme.textTheme.bodyMedium),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.colorScheme.primary,
        ),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title selected')));
        },
      ),
    );
  }
}

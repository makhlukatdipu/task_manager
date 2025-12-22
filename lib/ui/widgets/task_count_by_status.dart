import 'package:flutter/material.dart';
class TaskCountByStatus extends StatelessWidget {
  final String title;
  final int count;
  const TaskCountByStatus({
    super.key, required this.title, required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          children: [
            Text(count.toString(),style: Theme.of(context).textTheme.titleLarge,),
            Text(title),
          ],
        ),
      ),
    );
  }
}
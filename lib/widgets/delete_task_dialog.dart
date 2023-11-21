import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../secvices/db_service.dart';

class DeleteTaskDialog extends StatefulWidget {
  final String taskId, taskName;
  const DeleteTaskDialog({super.key, required this.taskId, required this.taskName});

  @override
  State<DeleteTaskDialog> createState() => _DeleteTaskDialogState();
}

class _DeleteTaskDialogState extends State<DeleteTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Delete Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              Text(
                widget.taskName.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteTasks();
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future _deleteTasks() async {
    final DBService dbService = DBService();
    await dbService.deleteTask(taskId: widget.taskId)
        .then(
          (_) {
            const snackBar = SnackBar(content: Text('Task deleted successfully'));
            return ScaffoldMessenger.of(context).showSnackBar(snackBar);
          })
        .catchError(
          (error) {
            final snackBar = SnackBar(content: Text('Failed: $error'));
            return ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
  }
}

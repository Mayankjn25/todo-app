import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/profile_screen.dart';

import '../widgets/add_task_dialog.dart';
import '../widgets/delete_task_dialog.dart';
import '../widgets/update_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid = '';

  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fireStore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text('Todo List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => const ProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddTaskDialog();
            },
          );
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(12.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore
                .collection('tasks')
                .doc(uid)
                .collection('mytasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.brown,
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Text(
                  'No tasks to display',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                );
              } else {
                return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  IconData taskIcon = Icons.work;
                  String taskTag = data['taskTag'];
                  if (taskTag == 'School') {
                    taskIcon = Icons.school;
                  } else if (taskTag == 'Other') {
                    taskIcon =
                        CupertinoIcons.rectangle_fill_on_rectangle_angled_fill;
                  }
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFe8e8e8),
                          blurRadius: 5.0,
                          offset:
                              Offset(0, 5), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: Icon(
                            taskIcon,
                            color: Colors.brown[300],
                          )),
                      title: Text(
                        data['taskName'],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          data['taskDesc'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              onTap: () {
                                String taskId = (data['id']);
                                String taskName = (data['taskName']);
                                String taskDesc = (data['taskDesc']);
                                String taskTag = (data['taskTag']);
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => UpdateTaskDialog(
                                      taskId: taskId,
                                      taskName: taskName,
                                      taskDesc: taskDesc,
                                      taskTag: taskTag,
                                    ),
                                  ),
                                );
                              },
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text(
                                'Delete',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              onTap: () {
                                String taskId = (data['id']);
                                String taskName = (data['taskName']);
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => DeleteTaskDialog(
                                        taskId: taskId, taskName: taskName),
                                  ),
                                );
                              },
                            ),
                          ];
                        },
                      ),
                      dense: true,
                    ),
                  );
                }).toList());
              }
            },
          ),
        ),
      ),
    );
  }
}

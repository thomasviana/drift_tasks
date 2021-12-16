import 'package:drift_tasks/data/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'widgets/new_task_input_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCompleted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Tasks',
          ),
        ),
        actions: [
          _buildCompletedOnlySwitch(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildTaskList(context),
            ),
            const NewTaskInput(),
          ],
        ),
      ),
    );
  }

  Row _buildCompletedOnlySwitch() {
    return Row(
      children: [
        const Text('Completed only'),
        Switch(
            value: showCompleted,
            onChanged: (newValue) {
              setState(() {
                showCompleted = newValue;
              });
            })
      ],
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final dao = Provider.of<TaskDao>(context, listen: false);
    return StreamBuilder(
        stream: showCompleted ? dao.watchCompletedTasks() : dao.watchAllTasks(),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          final tasks = snapshot.data ?? [];
          print(tasks);
          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final itemTask = tasks[index];
                return _builListItem(itemTask, dao);
              });
        });
  }

  Widget _builListItem(Task itemTask, TaskDao dao) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (_) => dao.deleteTask(itemTask),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(itemTask.name),
        subtitle: Text(itemTask.dueDate?.toString() ?? 'No date'),
        value: itemTask.completed,
        onChanged: (newValue) {
          dao.updateTask(
            itemTask.copyWith(completed: newValue),
          );
        },
      ),
    );
  }
}

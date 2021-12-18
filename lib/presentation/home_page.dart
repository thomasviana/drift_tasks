import 'package:drift_tasks/data/drift_database.dart';
import 'package:drift_tasks/presentation/widgets/new_tag_input_widget.dart';
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
        title: const Text(
          'Tasks',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildTaskList(context)),
            const NewTaskInput(),
            const NewTagInput(),
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

  StreamBuilder<List<TaskWithTag>> _buildTaskList(BuildContext context) {
    final dao = Provider.of<TaskDao>(context);
    return StreamBuilder(
        stream: dao.watchAllTasks(),
        builder: (context, AsyncSnapshot<List<TaskWithTag>> snapshot) {
          final tasks = snapshot.data ?? [];
          print(tasks);
          return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final item = tasks[index];
                return _builListItem(item, dao);
              });
        });
  }

  Widget _builListItem(TaskWithTag item, TaskDao dao) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (_) => dao.deleteTask(item.task),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Delete',
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(item.task.name),
        subtitle: Text(item.task.dueDate?.toString() ?? 'No date'),
        secondary: _buildTag(item.tag),
        value: item.task.completed,
        onChanged: (newValue) {
          dao.updateTask(
            item.task.copyWith(completed: newValue),
          );
        },
      ),
    );
  }

  Column _buildTag(Tag? tag) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tag != null) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
          Text(
            tag.name,
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }
}

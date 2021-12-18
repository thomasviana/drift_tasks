import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/drift_database.dart';
import 'presentation/home_page.dart';

Future<void> main() async {
  // final db = AppDatabase(NativeDatabase.memory());
  // db.watchAllTasks.listen((event) {
  //   print('Task-item in database: $event');
  // });
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskDao>(
          create: (_) => db.taskDao,
        ),
        Provider<TagDao>(
          create: (_) => db.tagDao,
        ),
      ],
      child: const MaterialApp(
        title: 'Material App',
        home: HomePage(),
      ),
    );
  }
}

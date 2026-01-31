import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_project/viewmodel/file_history/file_event.dart';
import 'core/database/db_helper.dart';
import 'viewmodel/file_history/file_bloc.dart';
import 'view/history/history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FileBloc(DBHelper())..add(LoadFiles()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HistoryScreen(),
      ),
    );
  }
}

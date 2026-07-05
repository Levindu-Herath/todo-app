import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/models/energy_level.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/constants/storage_keys.dart';
import 'di/service_locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(EnergyLevelAdapter());
  await Hive.openBox<Task>(StorageKeys.taskBoxName);

  setupServiceLocator();
  runApp(const MyApp());
}
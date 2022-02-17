import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:github_repositories_list/connectivity/connectivity_controller.dart';
import 'package:github_repositories_list/routes/routes.dart';
import 'package:github_repositories_list/sqlLite/sql_lite_db_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlLiteDBManager.openDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _connectivity = ConnectivityController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(ConnectivityController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

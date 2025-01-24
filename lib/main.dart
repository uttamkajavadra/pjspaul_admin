import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/route/app_pages.dart';
import 'package:pjspaul_admin/route/app_routes.dart';
import 'package:pjspaul_admin/view/page/login/login_screen.dart';
import 'package:pjspaul_admin/view/page/main/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAo-9NLyX_yyx-pUyqyrPt0VGMij8fISIQ', 
      appId: '1:564517274234:web:4e5820b6b41937f79731c3', 
      messagingSenderId: '564517274234', 
      projectId: 'pjsm-paul',
      storageBucket: "pjsm-paul.firebasestorage.app",),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PJSPaul Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MainScreen(),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.main,
    );
  }
}

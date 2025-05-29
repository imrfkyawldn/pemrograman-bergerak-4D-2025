import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/habit_list_page.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  await checkConnection();

  runApp(const HabitApp());
}

Future<void> checkConnection() async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await NotificationService.showNotification(
        title: "Koneksi Internet",
        body: "Terhubung ke internet.",
      );
    } else {
      await NotificationService.showNotification(
        title: "Koneksi Terputus",
        body: "Tidak ada koneksi internet saat ini.",
      );
    }
  } catch (e) {
    debugPrint("Gagal memeriksa koneksi: $e");
  }
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Color(0xFF81C784), // hijau muda
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF388E3C), // hijau tua
          ),
        ),
      ),
      home: const HabitListPage(),
    );
  }
}

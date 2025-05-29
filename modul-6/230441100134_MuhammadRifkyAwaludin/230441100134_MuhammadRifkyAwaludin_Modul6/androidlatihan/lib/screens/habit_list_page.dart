import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../db/db_helper.dart' as db_helper;
import '../pages/update_habit_page.dart';
import '../models/habit_model.dart';
import '../pages/add_habit_page.dart';
import 'habit_detail_page.dart';
import '../services/notification_service.dart';

class HabitListPage extends StatefulWidget {
  const HabitListPage({super.key});

  @override
  State<HabitListPage> createState() => _HabitListPageState();
}

class _HabitListPageState extends State<HabitListPage> {
  List<Habit> _habits = [];
  bool _isLoading = true;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _initializeConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });

      if (result == ConnectivityResult.wifi) {
        NotificationService.showNotification(
          title: 'Koneksi Internet',
          body: 'Terhubung dengan WiFi',
        );
      } else if (result == ConnectivityResult.mobile) {
        NotificationService.showNotification(
          title: 'Koneksi Internet',
          body: 'Menggunakan data seluler',
        );
      } else {
        NotificationService.showNotification(
          title: 'Koneksi Internet',
          body: 'Tidak ada koneksi internet',
        );
      }
    });
  }

  Future<void> _initializeConnectivity() async {
    var result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);
    final habits = await db_helper.DBHelper.instance.getHabits();
    setState(() {
      _habits = habits.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteHabit(int? id) async {
    if (id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus habit ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await db_helper.DBHelper.instance.deleteHabit(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Habit dihapus")),
      );
      _loadHabits();
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData connectionIcon;
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        connectionIcon = Icons.wifi;
        break;
      case ConnectivityResult.mobile:
        connectionIcon = Icons.signal_cellular_alt;
        break;
      default:
        connectionIcon = Icons.signal_wifi_off;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Habit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              connectionIcon,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
              ? const Center(child: Text("Belum ada habit"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: _habits.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final habit = _habits[index];
                      final imageFile = File(habit.imagePath);
                      final hasImage = habit.imagePath.isNotEmpty && imageFile.existsSync();

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HabitDetailPage(habit: habit),
                          ),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: hasImage
                                    ? Image.file(
                                        imageFile,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.image_not_supported, size: 40),
                                      ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  habit.tittle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.green, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        habit.location.isNotEmpty ? habit.location : "-",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.green[600]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 8, bottom: 8, top: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Colors.green.shade400, width: 1.5),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: Colors.green[700],
                                        onPressed: () async {
                                          bool? updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => UpdateHabitPage(habit: habit)),
                                          );
                                          if (updated == true) _loadHabits();
                                        },
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        splashRadius: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Colors.green.shade400, width: 1.5),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.green,
                                        onPressed: () => _deleteHabit(habit.id),
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        splashRadius: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitPage()),
          );
          if (added == true) _loadHabits();
        },
        backgroundColor: Colors.green[700],
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

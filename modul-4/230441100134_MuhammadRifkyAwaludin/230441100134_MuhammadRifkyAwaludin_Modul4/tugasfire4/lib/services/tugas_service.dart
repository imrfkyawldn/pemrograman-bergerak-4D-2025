import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tugas_kuliah.dart';

class TugasService {
  final String baseUrl =
      "https://daftartugas-7fcef-default-rtdb.firebaseio.com/tugas";

  Future<List<TugasKuliah>> fetchTugas() async {
    final response = await http.get(Uri.parse("$baseUrl.json"));
    if (response.statusCode == 200) {
      if (response.body == "null") return [];
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.entries
          .map((e) => TugasKuliah.fromJson(e.value, e.key))
          .toList();
    } else {
      throw Exception('Gagal mengambil data tugas');
    }
  }

  Future<void> addTugas(TugasKuliah tugas) async {
    final response = await http.post(
      Uri.parse("$baseUrl.json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tugas.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan tugas');
    }
  }

  Future<void> updateTugas(TugasKuliah tugas) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${tugas.id}.json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tugas.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah tugas');
    }
  }

  Future<void> deleteTugas(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id.json"));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas');
    }
  }
}

class TugasKuliah {
  final String? id;
  final String namaTugas;
  final String deskripsi;
  final String status;
  final String tanggalMulai;
  final String tanggalTenggat;

  TugasKuliah({
    this.id,
    required this.namaTugas,
    required this.deskripsi,
    required this.status,
    required this.tanggalMulai,
    required this.tanggalTenggat,
  });

  factory TugasKuliah.fromJson(Map<String, dynamic> json) {
    return TugasKuliah(
      id: json['id'].toString(),
      namaTugas: json['nama_tugas'],
      deskripsi: json['deskripsi'],
      status: json['status'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalTenggat: json['tanggal_tenggat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama_tugas": namaTugas,
      "deskripsi": deskripsi,
      "status": status,
      "tanggal_mulai": tanggalMulai,
      "tanggal_tenggat": tanggalTenggat,
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      "id": id,
      "nama_tugas": namaTugas,
      "deskripsi": deskripsi,
      "status": status,
      "tanggal_mulai": tanggalMulai,
      "tanggal_tenggat": tanggalTenggat,
    };
  }
}

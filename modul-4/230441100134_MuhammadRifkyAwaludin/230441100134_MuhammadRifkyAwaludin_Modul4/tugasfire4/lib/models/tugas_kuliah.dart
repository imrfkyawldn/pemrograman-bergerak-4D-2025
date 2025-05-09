class TugasKuliah {
  String id;
  String namaTugas;
  String deskripsi;
  String tanggalMulai;
  String tanggalTenggat;
  String status;

  TugasKuliah({
    required this.id,
    required this.namaTugas,
    required this.deskripsi,
    required this.tanggalMulai,
    required this.tanggalTenggat,
    required this.status,
  });

  factory TugasKuliah.fromJson(Map<String, dynamic> json, String id) {
    return TugasKuliah(
      id: id,
      namaTugas: json['nama_tugas'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalTenggat: json['tanggal_tenggat'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_tugas': namaTugas,
      'deskripsi': deskripsi,
      'tanggal_mulai': tanggalMulai,
      'tanggal_tenggat': tanggalTenggat,
      'status': status,
    };
  }
}

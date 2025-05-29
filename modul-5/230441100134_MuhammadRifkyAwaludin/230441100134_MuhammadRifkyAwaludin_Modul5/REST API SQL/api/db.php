<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_tugas_kuliah"; // Ganti sesuai nama database kamu

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}
?>

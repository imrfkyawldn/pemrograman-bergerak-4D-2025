<?php
// Allow CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Jika method OPTIONS (preflight), cukup kirim status OK dan exit
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

include('db.php');

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getTugas();
        break;
    case 'POST':
        addTugas();
        break;
    case 'PUT':
        updateTugas();
        break;
    case 'DELETE':
        deleteTugas();
        break;
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method Not Allowed']);
        break;
}

function getTugas() {
    global $conn;
    $sql = "SELECT * FROM tugas_kuliah ORDER BY id DESC";
    $result = $conn->query($sql);

    $tugas = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $tugas[] = $row;
        }
    }
    echo json_encode($tugas);
}

function addTugas() {
    global $conn;
    $data = json_decode(file_get_contents('php://input'), true);

    $nama_tugas = $conn->real_escape_string($data['nama_tugas']);
    $deskripsi = $conn->real_escape_string($data['deskripsi']);
    $status = $conn->real_escape_string($data['status']);
    $tanggal_mulai = $conn->real_escape_string($data['tanggal_mulai']);
    $tanggal_tenggat = $conn->real_escape_string($data['tanggal_tenggat']);

    $sql = "INSERT INTO tugas_kuliah (nama_tugas, deskripsi, status, tanggal_mulai, tanggal_tenggat)
            VALUES ('$nama_tugas', '$deskripsi', '$status', '$tanggal_mulai', '$tanggal_tenggat')";

    if ($conn->query($sql) === TRUE) {
        http_response_code(201);
        echo json_encode(["message" => "Tugas berhasil ditambahkan"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Gagal menambahkan tugas", "error" => $conn->error]);
    }
}

function updateTugas() {
    global $conn;
    $data = json_decode(file_get_contents('php://input'), true);

    $id = intval($data['id']);
    $nama_tugas = $conn->real_escape_string($data['nama_tugas']);
    $deskripsi = $conn->real_escape_string($data['deskripsi']);
    $status = $conn->real_escape_string($data['status']);
    $tanggal_mulai = $conn->real_escape_string($data['tanggal_mulai']);
    $tanggal_tenggat = $conn->real_escape_string($data['tanggal_tenggat']);

    $sql = "UPDATE tugas_kuliah SET
                nama_tugas = '$nama_tugas',
                deskripsi = '$deskripsi',
                status = '$status',
                tanggal_mulai = '$tanggal_mulai',
                tanggal_tenggat = '$tanggal_tenggat'
            WHERE id = $id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Tugas berhasil diupdate"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Gagal mengupdate tugas", "error" => $conn->error]);
    }
}

function deleteTugas() {
    global $conn;
    $data = json_decode(file_get_contents('php://input'), true);

    $id = intval($data['id']);

    $sql = "DELETE FROM tugas_kuliah WHERE id = $id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Tugas berhasil dihapus"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Gagal menghapus tugas", "error" => $conn->error]);
    }
}
?>

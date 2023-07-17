<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Disposition, Content-Type, Content-Length, Accept-Encoding');
header('Content-Type: application/json');

require_once 'connection.php';
$rID = $_POST['id'];
// Set up the database connection
$connection = Database::setUpConnection();

// Execute the SQL query
$sql = "SELECT * FROM `quotation` WHERE `vendor_id`='$rID' ORDER BY date_time DESC";
$result = $connection->query($sql);

// Fetch data and store it in an array
$data = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

// Return the data as JSON response
header('Content-Type: application/json');
echo json_encode($data);

// Close the database connection
$connection->close();
?>

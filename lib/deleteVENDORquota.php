<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Disposition, Content-Type, Content-Length, Accept-Encoding');
header('Content-Type: application/json');

require "connection.php";
$rID = $_POST['rID'];

// Check if the required parameters are present
if ($rID !== null) {
    $pro = Database::iud("DELETE FROM `quotation` WHERE `quotation_id`='$rID';");

} else {
    echo 'failed';
}
?>

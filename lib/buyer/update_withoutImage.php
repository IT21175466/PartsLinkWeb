<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Disposition, Content-Type, Content-Length, Accept-Encoding');
header('Content-Type: application/json');

require_once 'connection.php';

// Set up the database connection
$connection = Database::setUpConnection();

// Execute the SQL query
$sql = "UPDATE `quotation` SET `part_name`='".$_POST['paraName']."',`part_no`='".$_POST['paraPrice']."',`description`='".$_POST['paraDescription']."',`country`='".$_POST['paraCountry']."',`model`='".$_POST['paraModel']."',`year_of_make`='".$_POST['paraYear']."' WHERE `quotation_id`='".$_POST['nid']."';";
$result = $connection->query($sql);
echo "done";

$connection->close();
?>

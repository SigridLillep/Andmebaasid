<?php
$instance = getenv('INSTANCE') ?: 'unknown';
$host = gethostname();

echo "<h1>Webhost: {$instance}</h1>";
echo "<p>Container: {$host}</p>";

$dbHost = getenv('DB_HOST');
$dbName = getenv('DB_NAME');
$dbUser = getenv('DB_USER');
$dbPass = getenv('DB_PASS');

try {
  $dsn = "pgsql:host=$dbHost;dbname=$dbName";
  $pdo = new PDO($dsn, $dbUser, $dbPass);
  $q = $pdo->query("SELECT now()");
  $row = $q->fetch();

  echo "<p>DB OK: {$row[0]}</p>";
} catch (Exception $e) {
  echo "<p>DB ERROR: {$e->getMessage()}</p>";
}

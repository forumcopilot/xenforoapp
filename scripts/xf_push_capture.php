<?php
// CAPTURE_FILE=<file> php -S 127.0.0.1:8765 scripts/xf_push_capture.php
// Stands in for the push backend in xf_push_wording_check.php: appends each
// request's JSON body (never its headers) to $CAPTURE_FILE and answers 200.
file_put_contents(getenv('CAPTURE_FILE'), file_get_contents('php://input') . "\n", FILE_APPEND);
header('Content-Type: application/json');
echo '{"message":"captured"}';

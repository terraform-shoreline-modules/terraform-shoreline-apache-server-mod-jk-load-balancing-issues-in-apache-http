resource "shoreline_notebook" "mod_jk_load_balancing_issues_in_apache_http" {
  name       = "mod_jk_load_balancing_issues_in_apache_http"
  data       = file("${path.module}/data/mod_jk_load_balancing_issues_in_apache_http.json")
  depends_on = [shoreline_action.invoke_curl_status_check,shoreline_action.invoke_ping_workers,shoreline_action.invoke_stop_and_start_apache,shoreline_action.invoke_new_lb_algorithm_update]
}

resource "shoreline_file" "curl_status_check" {
  name             = "curl_status_check"
  input_file       = "${path.module}/data/curl_status_check.sh"
  md5              = filemd5("${path.module}/data/curl_status_check.sh")
  description      = "Check the status of the worker nodes"
  destination_path = "/agent/scripts/curl_status_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ping_workers" {
  name             = "ping_workers"
  input_file       = "${path.module}/data/ping_workers.sh"
  md5              = filemd5("${path.module}/data/ping_workers.sh")
  description      = "Check the network connectivity between the load balancer and worker nodes"
  destination_path = "/agent/scripts/ping_workers.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_and_start_apache" {
  name             = "stop_and_start_apache"
  input_file       = "${path.module}/data/stop_and_start_apache.sh"
  md5              = filemd5("${path.module}/data/stop_and_start_apache.sh")
  description      = "Restart Apache HTTP server to see if the issue is resolved temporarily."
  destination_path = "/agent/scripts/stop_and_start_apache.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "new_lb_algorithm_update" {
  name             = "new_lb_algorithm_update"
  input_file       = "${path.module}/data/new_lb_algorithm_update.sh"
  md5              = filemd5("${path.module}/data/new_lb_algorithm_update.sh")
  description      = "Adjust the load balancing algorithm used by mod_jk to better suit the specific needs of the system and its traffic patterns."
  destination_path = "/agent/scripts/new_lb_algorithm_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_curl_status_check" {
  name        = "invoke_curl_status_check"
  description = "Check the status of the worker nodes"
  command     = "`chmod +x /agent/scripts/curl_status_check.sh && /agent/scripts/curl_status_check.sh`"
  params      = ["WORKER_NODE_2","WORKER_NODE_1","PORT"]
  file_deps   = ["curl_status_check"]
  enabled     = true
  depends_on  = [shoreline_file.curl_status_check]
}

resource "shoreline_action" "invoke_ping_workers" {
  name        = "invoke_ping_workers"
  description = "Check the network connectivity between the load balancer and worker nodes"
  command     = "`chmod +x /agent/scripts/ping_workers.sh && /agent/scripts/ping_workers.sh`"
  params      = ["WORKER_NODE_2","WORKER_NODE_1"]
  file_deps   = ["ping_workers"]
  enabled     = true
  depends_on  = [shoreline_file.ping_workers]
}

resource "shoreline_action" "invoke_stop_and_start_apache" {
  name        = "invoke_stop_and_start_apache"
  description = "Restart Apache HTTP server to see if the issue is resolved temporarily."
  command     = "`chmod +x /agent/scripts/stop_and_start_apache.sh && /agent/scripts/stop_and_start_apache.sh`"
  params      = []
  file_deps   = ["stop_and_start_apache"]
  enabled     = true
  depends_on  = [shoreline_file.stop_and_start_apache]
}

resource "shoreline_action" "invoke_new_lb_algorithm_update" {
  name        = "invoke_new_lb_algorithm_update"
  description = "Adjust the load balancing algorithm used by mod_jk to better suit the specific needs of the system and its traffic patterns."
  command     = "`chmod +x /agent/scripts/new_lb_algorithm_update.sh && /agent/scripts/new_lb_algorithm_update.sh`"
  params      = ["PATH_TO_MOD_JK_CONFIGURATION_FILE","DESIRED_LOAD_BALANCING_ALGORITHM"]
  file_deps   = ["new_lb_algorithm_update"]
  enabled     = true
  depends_on  = [shoreline_file.new_lb_algorithm_update]
}


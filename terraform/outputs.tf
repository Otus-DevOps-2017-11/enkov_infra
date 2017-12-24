output "app_external_ip" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "app1_external_ip" {
  value = "${google_compute_instance.app1.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "load_balancer_ip" {
  value = "${google_compute_global_forwarding_rule.default.ip_address}"
}

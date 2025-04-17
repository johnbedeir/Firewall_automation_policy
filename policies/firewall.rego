package main

deny[msg] if {
  input.resource_changes[_].type == "google_compute_firewall"
  input.resource_changes[_].change.after.source_ranges[_] == "0.0.0.0/0"
  input.resource_changes[_].change.after.allow[_].ports[_] == "22"
  msg := "Port 22 must not be open to the internet"
}

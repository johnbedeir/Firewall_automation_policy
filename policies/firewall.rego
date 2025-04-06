package main

deny[msg] {
  input.resource_type == "google_compute_firewall"
  input.mode         == "resource"

  # If a rule opens port 22 and has a public range
  some allow_rule
  allow_rule := input.config.allow[_]
  allow_rule.ports[_] == "22"
  input.config.source_ranges[_] == "0.0.0.0/0"

  msg := "Port 22 must not be exposed to the entire internet."
}

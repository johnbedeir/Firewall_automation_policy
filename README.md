# 🚀 GCP Firewall Automation with OPA Policy Enforcement

This project automates the deployment of GCP firewall rules using Terraform, integrated with a GitHub Actions CI pipeline that enforces security policies using [OPA (Open Policy Agent)](https://www.openpolicyagent.org/).

---

## 🧩 How It Works

- Terraform defines the infrastructure: a GCP firewall rule that allows HTTP (port 80).
- GitHub Actions:
  - Authenticates using a GCP service account.
  - Runs `terraform init`, `plan`, and `apply`.
  - Converts the Terraform plan to JSON.
  - Evaluates the plan against a custom OPA Rego policy.
- The OPA policy ensures insecure firewall rules (e.g., allowing port 22 to 0.0.0.0/0) are blocked.

---

## 📂 Project Structure

```

.
├── main.tf # Terraform config for firewall
├── variables.tf # Terraform input variables
├── terraform.tfvars # You need to create this one with the variables
├── policies/
│ └── firewall.rego # OPA policy to evaluate firewall changes
├── .github/
│ └── workflows/
│ └── ci.yml # GitHub Actions CI workflow

```

---

## 🔐 Required GitHub Secrets

You must define the following secrets in your repository:

| Secret Name                   | Description                                  |
| ----------------------------- | -------------------------------------------- |
| `GCP_SERVICE_ACCOUNT_KEY_B64` | Base64-encoded GCP service account JSON key  |
| `GCP_PROJECT_ID`              | Your GCP project ID (e.g., `my-project-123`) |
| `GCP_REGION`                  | GCP region (e.g., `us-central1`)             |

---

## 🛠️ How to Generate `GCP_SERVICE_ACCOUNT_KEY_B64`

```bash
base64 -i gcp-credentials.json | tr -d '\n' > gcp-key.b64
```

Then copy the content of `key.b64` and add it as the secret `GCP_SERVICE_ACCOUNT_KEY_B64`.

---

## ✅ Security Policy (OPA)

The `firewall.rego` policy blocks any firewall rule that:

- Opens **port 22**
- To the **entire internet** (`0.0.0.0/0`)

You can customize it to enforce your own network security rules.

---

## 📌 Notes

- The CI pipeline applies changes **only if the policy passes**.
- State is stored in a **GCS bucket** configured in `main.tf`.
- This is intended for **controlled CI/CD use** (with `-lock=false` to avoid state lock issues in GitHub Actions).

---

## 📷 Example Output

```bash
Plan: 1 to add, 0 to change, 0 to destroy.
OPA Policy Passed ✅
Terraform Apply Successful ✅
```

---

## 💬 Want to extend it?

- Add multiple firewall rules
- Enforce more OPA checks (e.g., restrict IP ranges, ports, protocols)
- Integrate Slack alerts on violations or deployment status

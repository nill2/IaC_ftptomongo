# ftptomongo Infrastructure as Code Repository

This repository contains Terraform configuration files to set up and manage the infrastructure for the "ftptomongo" project. It deploys a Google Kubernetes Engine (GKE) cluster and related resources using Google Cloud Platform (GCP).

## Table of Contents

- [ftptomongo Infrastructure as Code Repository](#ftptomongo-infrastructure-as-code-repository)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Cleanup](#cleanup)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contact](#contact)

## Prerequisites

Before you begin, make sure you have the following prerequisites:

- [Terraform](https://www.terraform.io/downloads.html) installed locally.
- A Google Cloud Platform (GCP) account with the service account created with t least the 'iam.serviceAccounts.create' permission to create a service account and other permissions like 'container.clusters.create' and 'container.clusters.get' to create and manage GKE clusters.
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured with appropriate credentials.
- A service account key file (JSON format) for GCP with permissions to create and manage resources. Should be named 'key-file.json' in the sub-directory './service-account'.

## Getting Started

Clone this repository to your local machine:

```shell
git clone https://github.com/your-username/ftptomongo-infrastructure.git
cd ftptomongo-infrastructure
```

## Configuration

In the `variables.tf` file, you can configure the following variables:

- `credentials`: The path to your service account key file.
- `cluster_name`: The name of the GKE cluster.
- `project`: Your GCP project ID.
- `project_id`: A description of your GCP project (optional).
- `location`: The GCP region where resources will be deployed.
- `zone`: The GCP zone for the GKE cluster.
- `initial_node_count`: The initial number of nodes in the GKE cluster.
- `machine_type`: The machine type for GKE nodes.
- `service_account_name`: The name of the service account to create.
- `service_account_ID`: The service account ID (leave empty for automatic generation).

## Usage

1. **Initialize Terraform**:

    Run the following command to initialize Terraform:

    ```shell
    terraform init
    ```

2. **Apply Configuration**:

    Apply the Terraform configuration to create the infrastructure:

    ```shell
    terraform apply
    ```

3. **Access Kubernetes Cluster**:

    After successful deployment, configure `kubectl` to access the GKE cluster:

    ```shell
    gcloud container clusters get-credentials ftptomongo-cluster --zone europe-west1-b --project smooth-verve-400915
    ```

    Replace the cluster name, zone, and project with your configuration.

4. **Verify Resources**:

    Check the status of your resources and nodes:

    ```shell
    kubectl get nodes
    ```

## Cleanup

To destroy the created resources and infrastructure, run:

```shell
terraform destroy
```

## Contributing

If you want to contribute to this project, please follow these guidelines.

CI is set up with Github Actions.
On a commit it will automatically check your branch with linters (pyling and flake8)
unit and e2e tests.

On each PR to MAIN branch docker image is automatically generated and deployed to ghcr.io

On each release python package is created and publiched to pypi

Check or run github actions [here](https://github.com/nill2/ftptomongo/actions)

Explore the workflows code [here](https://github.com/nill2/ftptomongo/tree/main/.github/workflows)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

You can reach out to the project maintainer by [email](mailto:danil.d.kabanov@gmail.com)

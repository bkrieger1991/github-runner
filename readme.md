[![Build and Push](https://github.com/bkrieger1991/github-runner/actions/workflows/build-and-push.yaml/badge.svg)](https://github.com/bkrieger1991/github-runner/actions/workflows/build-and-push.yaml)

# Custom GitHub Actions Runner (Docker)

This repository contains a Dockerized GitHub Actions Runner based on **Debian**. Unlike many standard runner images, this version is specifically designed for production environments using **Docker Swarm** or **Kubernetes**, as it supports passing the GitHub Registration Token via a **file path** (ideal for Docker Secrets).

Visit hub.docker.com: [https://hub.docker.com/r/flux1991/github-runner](https://hub.docker.com/r/flux1991/github-runner)

## Key Features

* **Debian-based:** Lightweight and stable execution environment.
* **Docker Secret Support:** Use `TOKEN_FILE` to point to a mounted secret instead of exposing the token as a plain environment variable.
* **Automated Registration:** The runner automatically registers itself with your repository or organization on startup.

## Image Details

* **Docker Hub:** `flux1991/github-runner:latest`
* **Base OS:** Debian (Latest stable)

## Usage

### Environment Variables

| Variable | Description | Required |
| :--- | :--- | :--- |
| `REPO_URL` | The full URL of your GitHub repository or organization. | Yes |
| `TOKEN_FILE` | Path to the file containing the GitHub Runner token (e.g., `/run/secrets/my_token`). | Yes (if `TOKEN` is not set) |
| `TOKEN` | The GitHub registration token (alternative to `TOKEN_FILE`). | Optional |
| `RUNNER_NAME` | The name of the runner to be displayed in GitHub. | Optional (Default: `docker-runner`) |

### Example: Docker Stack / Compose (Recommended)

This image shines when used with Docker Secrets to keep your tokens secure.

```yaml
version: '3.8'

services:
  runner:
    image: flux1991/github-runner:latest
    environment:
      - REPO_URL=https://github.com/your-username/your-repo
      - TOKEN_FILE=/run/secrets/my_github_token
      - RUNNER_NAME=my-secure-runner
    secrets:
      - my_github_token

secrets:
  my_github_token:
    external: true
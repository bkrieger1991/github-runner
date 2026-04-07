FROM debian:trixie-backports

# Define runnter version
ARG RUNNER_VERSION="2.333.1"

# Install dependencies
RUN apt update && apt install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create runner user (avoid using root)
RUN useradd -m runner
WORKDIR /home/runner

# Download and extract GitHub Runner
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install runner dependencies
RUN ./bin/installdependencies.sh

# Copy entrypoint script and set permissions
COPY entrypoint.sh /home/runner/entrypoint.sh
RUN chmod +x /home/runner/entrypoint.sh && chown runner:runner /home/runner/entrypoint.sh

USER runner

# Default environment variables (can be overridden at runtime)
ENV REPO_URL=""
ENV TOKEN=""
ENV TOKEN_FILE=""
ENV RUNNER_NAME=""

ENTRYPOINT ["./entrypoint.sh"]
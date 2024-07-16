# This Dockerfile is used to create a Docker image for Lidarr.
# It pulls an upstream image, sets up the environment, installs dependencies,
# installs Plex Media Server, and prepares the configuration.

# Define arguments for the upstream image and its digest for AMD64 architecture
ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

# Use the upstream image as the base image for this Dockerfile
FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}

# Expose port 8989 for Sonarr
EXPOSE 8989

# Define arguments and environment variables
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8989/tcp,8989/udp"

# Update the package list and install required dependencies
RUN apk add --no-cache libintl sqlite-libs icu-libs

ARG VERSION
ARG SBRANCH
ARG AMD64_URL
ARG PACKAGE_VERSION=${VERSION}

# Create a directory for the application binary and download Radarr
RUN set -e ;\
    mkdir "${APP_DIR}/bin" ;\
    curl -fsSL "${AMD64_URL}" | tar xzf - -C "${APP_DIR}/bin" --strip-components=1 && \
    rm -rf "${APP_DIR}/bin/Sonarr.Update" ;\
    rm -f "${APP_DIR}/bin/fpcalc"

# Create a package_info file with version and author information
RUN echo -e "PackageVersion=${PACKAGE_VERSION}\nPackageAuthor=[tainrs](https://github.com/tainrs)\nUpdateMethod=Docker\nBranch=${SBRANCH}" > "${APP_DIR}/package_info"

# Set appropriate permissions for the application directory
RUN set -e ;\
    chmod -R u=rwX,go=rX "${APP_DIR}" ;\
    chmod +x "${APP_DIR}/bin/Sonarr" "${APP_DIR}/bin/ffprobe"

# Copy the root directory to the container
COPY root/ /

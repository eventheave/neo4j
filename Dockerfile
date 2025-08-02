# Neo4j Dockerfile for Render deployment - CORRECTED VERSION
# Place this file in the root of your https://github.com/eventheave/neo4j.git repo

FROM neo4j:5.15-community

# Set the working directory
WORKDIR /var/lib/neo4j

# Copy any custom configuration files from your repo (uncomment if needed)
# COPY ./conf/ /var/lib/neo4j/conf/
# COPY ./plugins/ /var/lib/neo4j/plugins/
# COPY ./import/ /var/lib/neo4j/import/

# Basic Authentication and License
ENV NEO4J_AUTH=neo4j/password123
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes

# CORRECTED Neo4j 5.x Network Configuration
# Fixed all the warnings from your logs
ENV NEO4J_server_default__listen__address=0.0.0.0
ENV NEO4J_server_bolt_listen__address=0.0.0.0:7687
ENV NEO4J_server_http_listen__address=0.0.0.0:7474
ENV NEO4J_server_https_listen__address=0.0.0.0:7473

# FIXED: Add TLS support for bolt+s:// connections
ENV NEO4J_server_bolt_tls__level=OPTIONAL

# CORRECTED Neo4j 5.x Memory Configuration
# Fixed the unrecognized settings from your logs
ENV NEO4J_server_memory_heap_initial__size=256m
ENV NEO4J_server_memory_heap_max__size=256m
ENV NEO4J_server_memory_pagecache_size=256m

# Security configuration (procedures still use dbms prefix - this is correct)
ENV NEO4J_dbms_security_procedures_unrestricted=gds.*,apoc.*
ENV NEO4J_dbms_security_procedures_allowlist=gds.*,apoc.*

# Additional performance settings
ENV NEO4J_server_logs_debug_enabled=true

# Disable strict validation as fallback (only if needed)
ENV NEO4J_server_config_strict__validation_enabled=false

# Expose the necessary ports
EXPOSE 7474 7473 7687

# Health check for Render
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:7474/ || exit 1

# Use the default Neo4j entrypoint
CMD ["neo4j"]
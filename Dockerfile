# Neo4j Dockerfile for Render deployment - FIXED SIGNAL ISSUES
# Place this file in the root of your https://github.com/eventheave/neo4j.git repo

FROM neo4j:5.15-community

# Set the working directory
WORKDIR /var/lib/neo4j

# Run as neo4j user (not root) - fixes signal forwarding issues
USER neo4j

# Basic Authentication and License
ENV NEO4J_AUTH=neo4j/password123
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes

# Network Configuration - Listen on all interfaces
ENV NEO4J_server_default__listen__address=0.0.0.0
ENV NEO4J_server_bolt_listen__address=0.0.0.0:7687
ENV NEO4J_server_http_listen__address=0.0.0.0:7474

# Memory Configuration
ENV NEO4J_server_memory_heap_initial__size=256m
ENV NEO4J_server_memory_heap_max__size=256m
ENV NEO4J_server_memory_pagecache_size=256m

# Security configuration
ENV NEO4J_dbms_security_procedures_unrestricted=gds.*,apoc.*

# Disable strict validation
ENV NEO4J_server_config_strict__validation_enabled=false

# Expose the necessary ports
EXPOSE 7474 7473 7687

# Health check for Render
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:7474/ || exit 1

# Use the default Neo4j entrypoint
CMD ["neo4j"]
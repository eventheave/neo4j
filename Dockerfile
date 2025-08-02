# Neo4j Dockerfile for Render deployment
# Place this file in the root of your https://github.com/eventheave/neo4j.git repo

FROM neo4j:5.15-community

# Set the working directory
WORKDIR /var/lib/neo4j

# Copy any custom configuration files from your repo
# Uncomment and modify these lines based on your repo structure
# COPY ./conf/ /var/lib/neo4j/conf/
# COPY ./plugins/ /var/lib/neo4j/plugins/
# COPY ./import/ /var/lib/neo4j/import/

# Environment variables (these can be overridden by Render)
ENV NEO4J_AUTH=neo4j/password123
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes

# Network configuration for Render
# Neo4j 5.x configuration (current)
ENV NEO4J_server_default_listen_address=0.0.0.0
ENV NEO4J_server_default_advertised_address=localhost
ENV NEO4J_server_bolt_listen_address=0.0.0.0:7687
ENV NEO4J_server_http_listen_address=0.0.0.0:7474
ENV NEO4J_server_https_listen_address=0.0.0.0:7473

# If using Neo4j 4.x, use these instead:
# ENV NEO4J_dbms_default_listen_address=0.0.0.0
# ENV NEO4J_dbms_default_advertised_address=localhost  
# ENV NEO4J_dbms_connector_bolt_listen_address=0.0.0.0:7687
# ENV NEO4J_dbms_connector_http_listen_address=0.0.0.0:7474
# ENV NEO4J_dbms_connector_https_listen_address=0.0.0.0:7473

# Memory configuration optimized for Render (adjust based on your tier)
# Neo4j 5.x configuration
ENV NEO4J_server_memory_heap_initial_size=256m
ENV NEO4J_server_memory_heap_max_size=512m
ENV NEO4J_server_memory_pagecache_size=256m

# If using Neo4j 4.x, use these instead:
# ENV NEO4J_dbms_memory_heap_initial_size=256m
# ENV NEO4J_dbms_memory_heap_max_size=512m
# ENV NEO4J_dbms_memory_pagecache_size=256m

# Security and procedures configuration  
# Neo4j 5.x configuration
ENV NEO4J_server_security_procedures_unrestricted=gds.*,apoc.*
ENV NEO4J_server_security_procedures_allowlist=gds.*,apoc.*

# If using Neo4j 4.x, use these instead:
# ENV NEO4J_dbms_security_procedures_unrestricted=gds.*,apoc.*
# ENV NEO4J_dbms_security_procedures_allowlist=gds.*,apoc.*

# Performance settings
# Neo4j 5.x configuration  
ENV NEO4J_server_default_listen_address=0.0.0.0
ENV NEO4J_server_logs_debug_level=INFO

# If using Neo4j 4.x, use these instead:
# ENV NEO4J_dbms_connectors_default_listen_address=0.0.0.0
# ENV NEO4J_dbms_logs_debug_level=INFO

# If you have custom initialization scripts in your repo
# COPY ./scripts/ /docker-entrypoint-initdb.d/

# If you have custom Neo4j configuration
# COPY ./neo4j.conf /var/lib/neo4j/conf/neo4j.conf

# Expose the necessary ports
EXPOSE 7474 7473 7687

# Health check for Render
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:7474/ || exit 1

# Use the default Neo4j entrypoint
CMD ["neo4j"]
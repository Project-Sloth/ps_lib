CREATE TABLE IF NOT EXISTS ps_cache_metadata (
    cache_key VARCHAR(255) PRIMARY KEY,
    table_name VARCHAR(64),
    expires_at DATETIME,
    data JSON
);
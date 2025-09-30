import pytest
from sqlalchemy import text
from app.db import engine

def test_database_connection():
    """Test that the database connection works and can execute a simple query."""
    try:
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            value = result.scalar()
            print("Database connected successfully, test query result:", value)
            assert value == 1
    except Exception as e:
        pytest.fail(f"Failed to connect to database: {e}")
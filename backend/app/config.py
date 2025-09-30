import os
from dotenv import load_dotenv

load_dotenv(dotenv_path=".env")

class Settings:
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "postgresql+psycopg2://macbook@localhost:5432/vpn"
    )
    BACKEND_PORT: int = int(os.getenv("BACKEND_PORT", 9000))
    OPENVPN_DATA: str = os.getenv("OPENVPN_DATA", "./openvpn")

settings = Settings()
from fastapi import FastAPI
import uvicorn
from app.config import settings

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "ok", "db": settings.DATABASE_URL, "vpn_dir": settings.OPENVPN_DATA}

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=settings.BACKEND_PORT, reload=True)
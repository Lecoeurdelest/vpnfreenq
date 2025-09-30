from fastapi import FastAPI
import uvicorn
from app.config import settings

app = FastAPI(
    title="VPN Free NQ Backend",
    description="Backend service for managing OpenVPN configurations and users.",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

@app.get("/")
def read_root():
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=settings.BACKEND_PORT, reload=True)
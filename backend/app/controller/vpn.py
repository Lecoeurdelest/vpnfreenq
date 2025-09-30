from fastapi import APIRouter, Depends, HTTPException
from app.utils import run_script, check_status
from app.config import settings

router = APIRouter(prefix="/vpn", tags=["VPN Management"])

@router.post("/start")
def start_vpn():
    """Start the OpenVPN server."""
    output = run_script(settings.OPENVPN, "start.sh")
    if "not found" in output:
        raise HTTPException(status_code=404, detail=output)
    return {"message": "OpenVPN server started.", "output": output}
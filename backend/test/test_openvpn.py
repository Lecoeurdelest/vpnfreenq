import subprocess
import pytest

OPENVPN_CONTAINER = "openvpn"
OPENVPN_PORT_HEX = "04AA"  # UDP 1194

def run_cmd(cmd):
    """Helper to run a bash command in container and return stdout."""
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.stdout.strip(), result.returncode

@pytest.mark.parametrize("container_name", [OPENVPN_CONTAINER])
def test_container_running(container_name):
    """Check if container is running"""
    cmd = ["docker", "ps", "--filter", f"name={container_name}", "--format", "{{.Status}}"]
    output, code = run_cmd(cmd)
    assert output != "", f"Container '{container_name}' not found or not running"
    print(f"[*] Container '{container_name}' status: {output}")

def test_openvpn_process():
    """Check if OpenVPN is running as PID 1"""
    cmd = ["docker", "exec", OPENVPN_CONTAINER, "bash", "-c", "ls -la /proc/1/exe"]
    output, _ = run_cmd(cmd)
    assert "openvpn" in output.lower(), "OpenVPN process not found as PID 1"

    cmd_state = ["docker", "exec", OPENVPN_CONTAINER, "bash", "-c", "grep State /proc/1/status"]
    state_output, _ = run_cmd(cmd_state)
    print("[*] Process state:", state_output)
    assert state_output != "", "Failed to get process state"

def test_udp_port():
    """Check if UDP port 1194 is in use"""
    cmd = ["docker", "exec", OPENVPN_CONTAINER, "bash", "-c", f"cat /proc/net/udp | grep -i ':{OPENVPN_PORT_HEX}'"]
    output, _ = run_cmd(cmd)
    assert output != "", "UDP port 1194 not in use"
    print("[*] UDP 1194 is in use")

def test_tun_interface():
    """Check if TUN interface exists"""
    cmd = ["docker", "exec", OPENVPN_CONTAINER, "bash", "-c", "ip addr show | grep tun"]
    output, _ = run_cmd(cmd)
    assert output != "", "TUN interface not found"
    print("[*] TUN interface exists:\n", output)

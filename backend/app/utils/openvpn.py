import docker

client = docker.from_env()

def check_status(container) -> bool:
    try:
        cont = client.containers.get(container)
        return cont.status == "running"
    except docker.errors.NotFound:
        return False

def run_script(container: str, script: str) -> str:
    try:
        cont = client.containers.get(container)
        exec_log = cont.exec_run(cmd=script)
        return exec_log.output.decode('utf-8')
    except docker.errors.NotFound:
        return f"Container '{container}' not found."

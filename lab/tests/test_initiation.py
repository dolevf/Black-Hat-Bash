import docker
import pytest

DOCKER_CLIENT = docker.DockerClient(base_url='unix://var/run/docker.sock')

containers = [
    'c-jumpbox-01'
    # 'p-ftp-01',
    # 'p-web-01',
    # 'p-web-02'
    # 'c-backup-01',
    # 'c-db-01',
    # 'c-redis-01'
]

def test_check_containers_are_up():
    for container_name in containers:
        container = DOCKER_CLIENT.containers.get(container_name)

        container_state = container.attrs['State']

        assert container_state['Status'] == 'running'

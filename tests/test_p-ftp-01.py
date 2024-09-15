import socket
import requests

def check_port_80():
  response = requests.get('http://172.16.10.11/backup')
  assert response.ok
  assert 'index of /backup' in response.text

def test_port_21():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  result = sock.connect_ex(('172.16.10.11', 21))
  assert result == 0


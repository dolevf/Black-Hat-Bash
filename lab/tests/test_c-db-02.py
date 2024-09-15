import requests
import socket

def test_port_3306():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  result = sock.connect_ex(('10.1.0.16', 3306))
  assert result == 0


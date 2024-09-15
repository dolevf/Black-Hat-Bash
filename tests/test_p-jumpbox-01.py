import socket

def test_port_22():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  result = sock.connect_ex(('172.16.10.13', 22))
  assert result == 0


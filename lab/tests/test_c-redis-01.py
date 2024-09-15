import socket

def test_port_6379():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  result = sock.connect_ex(('10.1.0.14', 6379))
  assert result == 0

def test_port_22():
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  result = sock.connect_ex(('10.1.0.14', 22))
  assert result == 0


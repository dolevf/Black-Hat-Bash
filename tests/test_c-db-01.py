import requests
import socket

def test_port_80():
  response = requests.get('http://10.1.0.15/adminer.php')
  assert response.ok
  assert 'Adminer' in response.text


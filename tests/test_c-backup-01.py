import requests

def test_port_8080():
  response = requests.get('http://10.1.0.13:8080')
  assert response.ok


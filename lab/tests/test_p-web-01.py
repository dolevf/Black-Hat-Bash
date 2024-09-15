import requests

def test_port_8081():
  response = requests.get('http://172.16.10.10:8081')
  assert response.ok
  assert 'ACME Hyper Branding' in response.text

def test_upload_page():
  response = requests.get('http://172.16.10.10:8081/upload')
  assert response.ok
  assert 'Upload any image!' in response.text



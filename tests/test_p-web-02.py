import requests

def test_wordpress_accessible():
  response = requests.get('http://172.16.10.12')
  assert response.ok
  assert 'ACME Impact Alliance' in response.text

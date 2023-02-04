import requests
import pytest

def test_check_wordpress_is_provisioned():
    P_WEB_02_IP='172.16.10.11'
    
    r = requests.post('http://172.16.10.11/wp-admin/install.php?step=2', data={
        "weblog_title":"ACME Impact Alliance",
        "user_name":"admin",
        "admin_password":"wAWSD@ASw2",
        "admin_password2":"wAWSD@ASw2",
        "admin_email":"dbrown@acme-infinity-servers.com",
        "blog_public":0,
        "Submit":"Install WordPress",
        "language":None
    })

    assert 'WordPress has been installed.' in r.text or \
    'You appear to have already installed WordPress.' in r.text
    
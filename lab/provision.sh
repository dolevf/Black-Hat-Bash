#!/bin/bash

p_web_02() {
  local result

  # Provision WordPress (p-web-02)
  result=$(curl -s -X POST \
          -d 'weblog_title=ACME Impact Alliance&user_name=admin&admin_password=wAWSD@ASw2&admin_password2=wAWSD@ASw2&admin_email=dbrown@acme-impact-alliance.com&blog_public=0&Submit=Install WordPress&language=""' \
          "http://172.16.10.12/wp-admin/install.php?step=2")
  if ! echo "${result}" | grep -q "WordPress has been installed. Thank you"; then
    echo "Error provisioning WordPress (p-web-02)"
    return 1
  fi
  
  return 0
}

check_post_actions(){
  if ! p_web_02; then
    return 1
  fi

  return 0
}

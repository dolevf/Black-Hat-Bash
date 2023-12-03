#!/bin/bash
REPORT_NAME="security_tool_scanner-$(date +%d-%m-%y).txt"

check(){
  local tool
  local check_type
  local indicator
  local result

  tool="${1}"
  check_type="${2}"
  indicator="${3}"
  result="false"

  case "${check_type}" in
    file|directory)
      if check_file_or_directory "${indicator}"; then
        result="true"
      fi
    ;;
    process)
      if check_process "${indicator}"; then
        result="true"
      fi
    ;;
  esac

  if [[ "${result}" == "true" ]]; then
    generate_report "${tool}" "${check_type}" "${indicator}"
  fi
}

check_process(){
  local process_name 
  process_name="${1}"
    
  if pgrep "${process_name}"; then
    return 0
  fi

  return 1
}

check_file_or_directory(){
  local name
  name="${1}"
    
  if [[ -e "${name}" ]]; then
    return 0
  fi
  
  return 1
}

download_eicar_file(){
  wget -q "https://secure.eicar.org/eicar.com.txt"
}

generate_report(){
  if [[ ! -f "${REPORT_NAME}" ]]; then
    echo "tool, check_type, indicator" > "${REPORT_NAME}"
  fi
    
  echo "${1}, ${2}, ${3}" >> "${REPORT_NAME}"
}


check ossec process ossec
check apparmor directory /etc/apparmor.d
check chkrootkit directory /etc/chkrootkit
check auditd process auditd
check syslog process syslog
check syslog process rsyslog
check syslog process syslog-ng
check iptables process iptables
check ufw process ufw
check tripwire directory /etc/tripwire
check aide directory /etc/aide
check apparmor directory /etc/apparmor.d
check fluentbit directory /etc/fluent-bit
check rkhunter file /etc/rkhunter

if [[ -f "${REPORT_NAME}" ]]; then
  download_eicar_file
fi
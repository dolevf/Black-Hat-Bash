#!/bin/bash
IP_ADDRESSES="$*"
REPORT_FILE="vulnerability_report.html"
RUSTSCAN="/home/kali/tools/RustScan/target/release/rustscan"
  
if [[ -z "${IP_ADDRESSES}" ]]; then
  echo "No IP addresses were provided!"
  exit 1
fi

generate_html(){
  local table_body
  table_body="${1}"
  
  cat << EOF
<style>
  table, th, td {
    border:1px solid black;
  }
</style>

<html>
  <h3>Vulnerability Scanning Report using Bash</h3>
  <table>
    <tr>
      <th>IP and Port</th>
      <th>Vulnerability Description</th>
      <th>Tool Name</th>
      <th>Timestamp</th>
    <tr>
  ${table_body}
  </table>
</html>
EOF
}

echo "Performing an FTP vulnerability scan on ${IP_ADDRESSES}"

# Run a port scan with Nmap, scan for common web ports
# shellcheck disable=SC2086
result=$("${RUSTSCAN}" -p 21 -g -a ${IP_ADDRESSES})
html_table=""

echo "Running Nuclei and Nmap..."

while read -r line; do
  timestamp=$(date)
  ip=$(echo "${line}" | awk '{print $1}' | xargs)
  port=$(echo "${line}" | awk -F'->' '{print $2}' | tr -d '[]' | xargs)
  nuclei_result=$(nuclei -no-color -silent -u "${ip}" -tags ftp | awk '{print $1}' | grep -Po '\[\K[^]]*')
  nmap_result=$(nmap --script=ftp-anon -p "${port}" "${ip}" | grep ftp-anon | awk -F':' '{print $2}')
  
  html_table="$html_table 
    <tr>
      <td>${ip}:${port}</td> 
      <td>${nuclei_result}</td> 
      <td>Nuclei</td>  
      <td>${timestamp}</td>
    </tr>
    <tr>
      <td>${ip}:${port}</td> 
      <td>${nmap_result}</td> 
      <td>Nmap</td>  
      <td>${timestamp}</td>
    </tr>"
  
done <<< "${result}"

if [[ -n "${html_table}" ]]; then
  echo "Generating an HTML table."
  generate_html "${html_table}" > "${REPORT_FILE}"
  echo "Completed."
else
  echo "Something went wrong, HTML table is empty."
  exit 1
fi
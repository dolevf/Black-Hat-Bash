import subprocess

# Basic python webshell checker
result = subprocess.check_output('id', shell=True)

print(result.decode('utf-8'))

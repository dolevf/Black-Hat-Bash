 #!/usr/bin/bash

 #define an array
 names=("Ahmad" "Anas" "Hendie" "Loai" "Haider")

 echo "${names[*]}"

 unset names[3]
 echo ${names[3]}
 names[3]="Acaard"
 echo ${names[3]} 

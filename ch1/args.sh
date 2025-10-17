echo -e "Running ${0}...\nThe args are: $@ \nThere is $# args." 

#listing using a loop
for args in "$@" ;do echo "${args}" ; done

echo "----------"

for args in "$@"
do echo "${args}"
done

#!/usr/bin/bash 

let_mothod(){
  local num1 num2
  let num1="55 * 55"
  let num2="10 * 10"
  echo $((${num1}*${num2}))
}

double_parentheses_method(){
  local num1 num2
  num1=$((55*55))
  num2=$((10*10))
  echo $((${num1}*${num2}))
}
let_mothod
echo ""
double_parentheses_method

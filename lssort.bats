#!/usr/bin/env bats


#The lssort function takes zero or more arguments
#and returns a sort of the long listing of the
#contents of the current directory (ls -l).
#The sort of the listing is determined by the
#arguments.  All sorts are in increasing order.
#For example,
#lssort - with no arguments outputs ls -l | sort
#lssort size - outputs a sort of ls -l where the sort is
#       a numeric of the size  
#lssort month - outputs a sort of ls -l where the
#       sort is an alphabetic sort of the month
#lssort day - outputs a sort of ls -l where the
#       sort is a numeric sort of the day 
#lssort name - outputs a sort of ls -l where the
#       sort is an alphabetic of the file name
#More than one argument can be given.  For example,
#
#lssort size day - sorts first by size and then by day
#
#If an argument is not either day, size, month, or name
#then the function returns 1
lssort() {
  return 0
}

#test lssort with no arguments
@test "lssort" {
  correct="$(./lssort)"
  run lssort
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with day argument
@test "lssort day" {
  correct="$(./lssort day)"
  run lssort day
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with name argument
@test "lssort name" {
  correct="$(./lssort name)"
  run lssort name
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with size argument
@test "lssort size" {
  correct="$(./lssort size)"
  run lssort size 
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with month argument
@test "lssort month" {
  correct="$(./lssort month)"
  run lssort month
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with name month arguments
@test "lssort name month" {
  correct="$(./lssort name month)"
  run lssort name month
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with size name month arguments
@test "lssort size name month" {
  correct="$(./lssort size name month)"
  run lssort size name month
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with day size name month arguments
@test "lssort day size name month" {
  correct="$(./lssort day size name month)"
  run lssort day size name month
  echo "correct: $correct"
  echo "output: $output"
  [ "$output" == "$correct" ]
  [ $status -eq 0 ]
}

#test lssort with invalid argument
@test "lssort day size mon (mon is invalid parameter)" {
  run lssort day size mon
  [ $status -eq 1 ]
}


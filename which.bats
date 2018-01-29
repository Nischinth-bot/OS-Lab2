#!/usr/bin/env bats


#The which function takes one argument that is the
#name of a program. It then uses the value
#of the path variable to look for that program
#so that it prints the path to the program
#that would be executed if the name is typed
#at the shell prompt. (It does the same thing
#as the linux which command.)
#If the program cannot be found it echos
#"no $1"
#In either case, it returns 0.
#If no argument can be found, it prints
#usage: which <program>
#and returns 1.
which() {
#
# This can be used to print the error message: echo "usage: which <program>";
   return 0
}

#should output usage info and return 1 if
#no argument given
@test "which with no argument" {
   run which
   [ "$output" = "usage: which <program>" ]
   [ $status -eq 1 ] 
}

#should find the path to gcc
@test "which gcc" {
   run which "gcc"
   correct=$(/usr/bin/which gcc)
   echo "$output"
   [ "$output" = "$correct" ]
   [ $status -eq 0 ] 
}

#should find the path to python
@test "which python" {
   run which "python"
   correct=$(/usr/bin/which python)
   echo "$output"
   [ "$output" = "$correct" ]
   [ $status -eq 0 ] 
}

#should not find the path to blah and
#therefore output "no blah"
@test "which blah (should return: no blah)" {
   run which "blah"
   [ "$output" = "no blah" ]
   [ $status -eq 0 ] 
}

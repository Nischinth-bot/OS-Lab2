#!/usr/bin/env bats


#The which function takes one argument that is the
#name of a program. It then uses the value
#of the path variable to look for that program
#so that it prints the path to the program
#that would be executed if the name is typed
#at the shell prompt. (It does the same thing
#as the linux which command.)
#If the program can not be found it returns
#"no $1"
#In either case, it returns 0.
#If no argument can be found, it prints
#usage: which <program>
#and returns 1.

which(){
if [ "$#" -eq 0 ]; then 
    echo  "usage: which <program>" 
    return 1
    fi
echo "$PATH" | tr ":" "\n" > dirs.txt
for ln in `cat dirs.txt`; do
if [ -d "$ln" ]; then
var=$(explore "$ln" $1)
if ! [ "$var" = "" ]; then
    echo "$var"
    return 0
    fi
fi
done
echo "no $1"
return 0
}

explore()
{
    ls -l "$1" | grep "^d" | awk '{print $9}' > temp_dirs.txt
    ls -l "$1" | grep "^[-,l]" | awk '{print $9}' > temp_files.txt
    for file in `cat temp_files.txt`; do
    if [ "$file" = "$2" ]; then
        echo "$1/$file" 
        return
        fi
    done
    for dir in `cat temp_dirs.txt`; do
        explore "$1/$dir" $2
    done
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

#should find the path to pats
@test "which bats" {
   run which "bats"
   correct=$(/usr/bin/which bats)
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

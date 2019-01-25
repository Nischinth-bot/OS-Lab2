#!/usr/bin/env bats


#The find function takes as input a starting directory
#and a string  and returns the path to files found
#in the starting directory or subdirectory whose name contains
#the string.  By default, the find function will look
#for the string in 3 levels of directories.
#But the directory depth can also be supplied with a -d option.  
#For example: find /usr/local python 
#will look for all files whose name contains the string
#python in the directories:
#/usr/local, /usr/local/X, /usr/local/X/Y
#where X is any subdirectory of /usr/local and Y 
#represents any subdirectory of /usr/local/X
#In addition: find -d 2 /usr/local python
#looks for python in the directories /usr/local and
#/usr/local/X where X is any subdirectory of /usr/local
#
#If a -d option is provided, it must be the first argument
#and the second argument must be a number. The next
#argument after that has to be a path to a directory.
#The final argument must be all alphanumeric characters.
#If the arguments are invalid, the function returns 1.
#Otherwise the function displays the paths and returns 0.
#
#Hint: add a recursive function that is called by find.
find() {
  #use this as your error message:    echo "usage: find [-d <n>] path expr"
  return 0
}

#test passing a bad path to find
@test "find badpath expr" {
   run find "badpath" "expr"
   echo "status: $status"
   echo "output: $output"
   [ "$output" == "usage: find [-d <n>] path expr" ]
   [ $status -eq 1 ] 
}

#path is good, expression is bad (must be alphanumeric)
@test "find /usr/local expr*" {
   run find "/usr/local" "expr*"
   echo "status: $status"
   echo "output: $output"
   [ "$output" == "usage: find [-d <n>] path expr" ]
   [ $status -eq 1 ] 
}

#path is good, expression is bad (must be alphanumeric)
@test "find /usr/local exp^r" {
   run find "/usr/local" 'exp^r'
   echo "status: $status"
   echo "output: $output"
   [ "$output" == "usage: find [-d <n>] path expr" ]
   [ $status -eq 1 ] 
}

#depth isn't a number
@test "find -d n /usr/local expr" {
   run find "-d" "n" "/usr/local" "expr"
   echo "status: $status"
   echo "output: $output"
   [ "$output" == "usage: find [-d <n>] path expr" ]
   [ $status -eq 1 ] 
}

@test "find -d 1 /usr/bin python" {
   run find "-d" "1" "/usr/bin" "python"
   #your find should perform the same as this find command
   correct=$(/usr/bin/find -L /usr/bin -maxdepth 1 -name *python* 2>/dev/null | sort) 
   #output captured by bats is separated by a space
   #change space to a newline so it can be sorted
   sortOutput=$(echo $output | sed 's/ /\n/g' | sort )
   i=0
   lines=($sortOutput)
   correct=($correct)
   echo "line counts: ${#lines[@]} ${#correct[@]}"
   [ ${#lines[@]} -eq ${#correct[@]} ]
   while [ $i -lt ${#lines[@]} ]; do
      echo "lines: ${correct[$i]} ${lines[$i]}"
      [ "${correct[$i]}" = "${lines[$i]}" ]
      i=$[$i+1]
   done
   [ $status -eq 0 ] 
}

@test "find -d 3 /usr python" {
   run find "-d" "3" "/usr" "python"
   #your find should perform the same as this find command
   correct=$(/usr/bin/find -L /usr -maxdepth 3 -name *python* 2>/dev/null | sort )
   #output captured by bats is separated by a space
   #change space to a newline so it can be sorted
   sortOutput=$(echo $output | sed 's/ /\n/g' | sort )
   i=0
   lines=($sortOutput)
   correct=($correct)
   echo "line counts: ${#lines[@]} ${#correct[@]}"
   [ ${#lines[@]} -eq ${#correct[@]} ]
   while [ $i -lt ${#lines[@]} ]; do
      echo "lines: ${correct[$i]} ${lines[$i]}"
      [ "${correct[$i]}" = "${lines[$i]}" ]
      i=$[$i+1]
   done
   [ $status -eq 0 ] 
}

#!/usr/bin/env bats


#The find function takes as input a starting directory
#and a string  and returns the path to files found
#in the starting directory or subdirectory whose name contain
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
#The final argument must all be alphanumeric characters.
#If the arguments are invalid, the function returns 1.
#Otherwise the function displays the paths and returns 0.
#hint: add a recursive function that is called by find
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

@test "find -d 1 /usr/local python" {
   run find "-d" "1" "/usr/local" "python"
   echo "status: $status"
   echo "output: $output"
   [ "$output" == "/usr/local/python2.7.9" ]
   [ $status -eq 0 ] 
}

@test "find -d 2 /usr/local python" {
   run find "-d" "2" "/usr/local" "python"
   echo "status: $status"
   echo "output: $output"
   [ "${lines[0]}" = "/usr/local/python2.7.9" ]
   [ "${lines[1]}" = "/usr/local/bin/python" ]
   [ "${lines[2]}" = "/usr/local/bin/python2.7" ]
   [ "${lines[3]}" = "/usr/local/bin/python3" ]
   [ "${lines[4]}" = "/usr/local/bin/python3.3" ]
   [ "${lines[5]}" = "/usr/local/bin/python3.3-config" ]
   [ "${lines[6]}" = "/usr/local/bin/python3.3m" ]
   [ "${lines[7]}" = "/usr/local/bin/python3.3m-config" ]
   [ "${lines[8]}" = "/usr/local/bin/python3.4" ]
   [ "${lines[9]}" = "/usr/local/bin/python3.4-config" ]
   [ "${lines[10]}" = "/usr/local/bin/python3.4m" ]
   [ "${lines[11]}" = "/usr/local/bin/python3.4m-config" ]
   [ "${lines[12]}" = "/usr/local/bin/python3-config" ]
   [ "${lines[13]}" = "/usr/local/include/python3.3m" ]
   [ "${lines[14]}" = "/usr/local/include/python3.4m" ]
   [ "${lines[15]}" = "/usr/local/lib/libpython3.3m.a" ]
   [ "${lines[16]}" = "/usr/local/lib/libpython3.4m.a" ]
   [ "${lines[17]}" = "/usr/local/lib/python3.3" ]
   [ "${lines[18]}" = "/usr/local/lib/python3.4" ]
   [ "${lines[19]}" = "/usr/local/src/python" ]
   [ $status -eq 0 ] 
}

#provides same output as using -d 2 option
@test "find /usr/local python" {
   run find  "/usr/local" "python"
   echo "status: $status"
   echo "output: $output"
   [ "${lines[0]}" = "/usr/local/python2.7.9" ]
   [ "${lines[1]}" = "/usr/local/bin/python" ]
   [ "${lines[2]}" = "/usr/local/bin/python2.7" ]
   [ "${lines[3]}" = "/usr/local/bin/python3" ]
   [ "${lines[4]}" = "/usr/local/bin/python3.3" ]
   [ "${lines[5]}" = "/usr/local/bin/python3.3-config" ]
   [ "${lines[6]}" = "/usr/local/bin/python3.3m" ]
   [ "${lines[7]}" = "/usr/local/bin/python3.3m-config" ]
   [ "${lines[8]}" = "/usr/local/bin/python3.4" ]
   [ "${lines[9]}" = "/usr/local/bin/python3.4-config" ]
   [ "${lines[10]}" = "/usr/local/bin/python3.4m" ]
   [ "${lines[11]}" = "/usr/local/bin/python3.4m-config" ]
   [ "${lines[12]}" = "/usr/local/bin/python3-config" ]
   [ "${lines[13]}" = "/usr/local/include/python3.3m" ]
   [ "${lines[14]}" = "/usr/local/include/python3.4m" ]
   [ "${lines[15]}" = "/usr/local/lib/libpython3.3m.a" ]
   [ "${lines[16]}" = "/usr/local/lib/libpython3.4m.a" ]
   [ "${lines[17]}" = "/usr/local/lib/python3.3" ]
   [ "${lines[18]}" = "/usr/local/lib/python3.4" ]
   [ "${lines[19]}" = "/usr/local/src/python" ]
   [ $status -eq 0 ] 
}

@test "find -d 3 /usr/local python" {
   run find "-d" "3" "/usr/local" "python"
   echo "status: $status"
   echo "output: $output"
   [ "${lines[0]}" = "/usr/local/python2.7.9" ]
   [ "${lines[1]}" = "/usr/local/bin/python" ]
   [ "${lines[2]}" = "/usr/local/bin/python2.7" ]
   [ "${lines[3]}" = "/usr/local/bin/python3" ]
   [ "${lines[4]}" = "/usr/local/bin/python3.3" ]
   [ "${lines[5]}" = "/usr/local/bin/python3.3-config" ]
   [ "${lines[6]}" = "/usr/local/bin/python3.3m" ]
   [ "${lines[7]}" = "/usr/local/bin/python3.3m-config" ]
   [ "${lines[8]}" = "/usr/local/bin/python3.4" ]
   [ "${lines[9]}" = "/usr/local/bin/python3.4-config" ]
   [ "${lines[10]}" = "/usr/local/bin/python3.4m" ]
   [ "${lines[11]}" = "/usr/local/bin/python3.4m-config" ]
   [ "${lines[12]}" = "/usr/local/bin/python3-config" ]
   [ "${lines[13]}" = "/usr/local/bin/__pycache__/django-admin.cpython-34.pyc" ]
   [ "${lines[14]}" = "/usr/local/include/python3.3m" ]
   [ "${lines[15]}" = "/usr/local/include/python3.4m" ]
   [ "${lines[16]}" = "/usr/local/include/python3.3m/pythonrun.h" ]
   [ "${lines[17]}" = "/usr/local/include/python3.4m/pythonrun.h" ]
   [ "${lines[18]}" = "/usr/local/lib/libpython3.3m.a" ]
   [ "${lines[19]}" = "/usr/local/lib/libpython3.4m.a" ]
   [ "${lines[20]}" = "/usr/local/lib/python3.3" ]
   [ "${lines[21]}" = "/usr/local/lib/python3.4" ]
   [ "${lines[22]}" = "/usr/local/lib/pkgconfig/python-3.3m.pc" ]
   [ "${lines[23]}" = "/usr/local/lib/pkgconfig/python-3.3.pc" ]
   [ "${lines[24]}" = "/usr/local/lib/pkgconfig/python-3.4m.pc" ]
   [ "${lines[25]}" = "/usr/local/lib/pkgconfig/python-3.4.pc" ]
   [ "${lines[26]}" = "/usr/local/lib/pkgconfig/python3.pc" ]
   [ "${lines[27]}" = "/usr/local/python2.7.9/bin/python" ]
   [ "${lines[28]}" = "/usr/local/python2.7.9/bin/python2" ]
   [ "${lines[29]}" = "/usr/local/python2.7.9/bin/python2.7" ]
   [ "${lines[30]}" = "/usr/local/python2.7.9/bin/python2.7-config" ]
   [ "${lines[31]}" = "/usr/local/python2.7.9/bin/python2-config" ]
   [ "${lines[32]}" = "/usr/local/python2.7.9/bin/python-config" ]
   [ "${lines[33]}" = "/usr/local/python2.7.9/include/python2.7" ]
   [ "${lines[34]}" = "/usr/local/python2.7.9/lib/libpython2.7.a" ]
   [ "${lines[35]}" = "/usr/local/python2.7.9/lib/python2.7" ]
   [ "${lines[36]}" = "/usr/local/share/nano/python.nanorc" ]
   [ "${lines[37]}" = "/usr/local/src/python" ]
   [ $status -eq 0 ] 
}


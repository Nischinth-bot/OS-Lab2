#!/usr/bin/env bats


#The chgext function takes two arguments, a source extension
#and a destination extension. It changes the names of all 
#files with the source extension in the current directory
#to the destination extension. If the function is invoked
#without the proper number of arguments, it prints out the
#error message: usage: chgext <srcExt> <dstExt>
#and returns 1. Otherwise, it does the extension change
#and returns 0.
chgext() {
    if [ "$#" -ne 2 ]; then 
    echo -e "usage: chgext <srcExt> <dstExt>"
    return 1
    fi
    ls *.$1 > files.txt
    old_ext="."$1
    new_ext="."$2
    for ln in `cat files.txt`; do
    var=$(echo "$ln" | sed "s/$old_ext/$new_ext/g")
    mv $ln $var
    done

  return 0   
}

#test moving .C files to .cpp
@test "chgext C cpp (move .C to .cpp)" {
#  create files to test the script on
   touch 'file1.C'
   touch 'file2.C'
   touch 'file3.C'
   run chgext 'C' 'cpp'
   echo "$output"
   [ $status -eq 0 ] 
#  make sure that file1.cpp, file2.cpp, file3.cpp exist
   [ -e 'file1.cpp' ]
   [ -e 'file2.cpp' ]
   [ -e 'file3.cpp' ]
#  make sure that file1.C, file2.C, file3.C do not exist
   [ ! -e 'file1.C' ]
   [ ! -e 'file2.C' ]
   [ ! -e 'file3.C' ]
   rm -f "file1.C"
   rm -f "file2.C"
   rm -f "file3.C"
   rm -f "file1.cpp"
   rm -f "file2.cpp"
   rm -f "file3.cpp"
}

#test moving .cpp files to .C
@test "chgext cpp to C (move .cpp to .C)" {
#  create files to test the script on
   touch 'file1.cpp'
   touch 'file2.cpp'
   touch 'file3.cpp'
   run chgext 'cpp' 'C'
   [ $status -eq 0 ] 
#  make sure that file1.C, file2.C, file3.C exist
   [ -e 'file1.C' ]  
   [ -e 'file2.C' ]  
   [ -e 'file3.C' ]  
#  make sure that file1.cpp, file2.cpp, file3.cpp do not exist
   [ ! -e 'file1.cpp' ]
   [ ! -e 'file2.cpp' ]
   [ ! -e 'file3.cpp' ]
   rm -f "file1.C"
   rm -f "file2.C"
   rm -f "file3.C"
   rm -f "file1.cpp"
   rm -f "file2.cpp"
   rm -f "file3.cpp"
}

#test to make sure chgext looks for .C not just C
#as an extension
@test "chgext 'C' 'cpp' (no .C to move)" {
  #this file doesn't end with a .C
  #so shouldn't be moved
  touch 'fileC'
  run chgext 'C' 'cpp'
  echo $output
  [ $status -eq 0 ] 
  [ ! -e 'filecpp' ]
  [ -e 'fileC' ]
  rm 'fileC'
}

#test wrong number of arguments (one)
@test "chgext 'C' (wrong number of arguments)" {
  #wrong number of arguments
  run chgext 'C' 
  echo $output
  [ $status -eq 1 ] 
  [ "$output" == "usage: chgext <srcExt> <dstExt>" ]
}

#test wrong number of arguments (zero)
@test "chgext (wrong number of arguments)" {
  #wrong number of arguments
  run chgext  
  [ $status -eq 1 ] 
  [ "$output" == "usage: chgext <srcExt> <dstExt>" ]
}

#test wrong number of arguments (three)
@test "chgext 'a' 'b' 'c' (wrong number of arguments)" {
  #wrong number of arguments
  run chgext 'a' 'b' 'c' 
  [ $status -eq 1 ] 
  [ "$output" == "usage: chgext <srcExt> <dstExt>" ]
}

@test "remove any leftover files due to failing tests" {
   rm -f 'file1.C'
   rm -f 'file2.C'
   rm -f 'file3.C'
   rm -f 'file1.cpp'
   rm -f 'file2.cpp'
   rm -f 'file3.cpp'
   rm -f 'fileC'
   rm -f 'filecpp'
}


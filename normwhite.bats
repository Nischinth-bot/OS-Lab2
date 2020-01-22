#!/usr/bin/env bats

#The normwhite function takes as input the name of a text file, 
#reads the contents of the file line by line, and outputs each line after 
#normalizing whitespace.  Runs of spaces and/or tabs must be replaced by a 
#single space.  All end of line whitespace must be removed.
#If the text file exists, the function returns 0.
#
#If no argument can be found or the text file doesn't exist, it prints
#usage: normwhite <textfile>
#and returns 1.
normwhite() {
#
# This can be used to print the error message: echo "usage: normwhite <textfile>";
#
# We don't want echo to do the work for you so you should use: 
#     echo -e | sed
#
  if ! [ -f "$1" ]; then  
      echo "usage: normwhite <textfile>";
      return 1
      fi
  cat "$1" | sed -r 's/^\s+//g;s/(\s\s+)/ /g;s/\t/ /g; s/\s$//g'
  return 0
}

#run normwhite with no argument (should return 1)
@test "normwhite with no argument (should return 1) " {
   run normwhite 
   [ "$output" = "usage: normwhite <textfile>" ]
   [ $status -eq 1 ] 
}

#run normwhite with an invalid argument (should return 1)
@test "normwhite with bad argument (should return 1) " {
   run normwhite "nofile"
   [ "$output" = "usage: normwhite <textfile>" ]
   [ $status -eq 1 ] 
}

@test "normwhite input.txt " {
   echo -e "   a line    with    spaces  " > input.txt
   echo -e "a line\twith\t tabs\t" >> input.txt
   echo -e "multiple\n lines\n   here" >> input.txt
   run normwhite "input.txt"
   rm input.txt
   [ "${lines[0]}" = "a line with spaces" ]
   [ "${lines[1]}" = "a line with tabs" ]
   [ "${lines[2]}" = "multiple" ]
   [ "${lines[3]}" = "lines" ]
   [ "${lines[4]}" = "here" ]
   [ $status -eq 0 ] 
}



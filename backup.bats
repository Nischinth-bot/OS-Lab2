#!/usr/bin/env bats

#The backup function takes two arguments, a source directory
#and a destination directory, and creates a tar file out of
#the source directory and copies it into the destination
#directory.
#It creates the tar file using the command: tar cf <tarfilename> <srcdirname>
#The name of the tar file will be <srcdirname>-N.tgz
#where N is the number of the last tar file to be created plus 1.
#For example, if the function is invoked by the
#command: backup srcd destd
#then the first backup created will be named: srcd-0.tgz
#If it is called again with the same srcd then the second
#backup created will be named: srcd-1.tgz
#The third is srcd-2.tgz, etc.
#
#In addition, if after creating the backup there are four backups
#in the destination directory, the backup function deletes the
#oldest backup.  For example, after creating srcd-3.tgz,
#srcd-0.tgz gets deleted; after creating srcd-4.tgz, srcd-1.tgz
#gets deleted, etc.
#
#The function should also check the arguments to make sure they
#are both directories. If not, backup returns 1 and
#outputs the message: usage: backup <srcdir> <destdir> 
#Otherwise, backup returns 0 in addition to doing the backup.
backup() {
  if ! [[ -d "$1" ]] || ! [[ -d "$2" ]]; then
  echo "usage: backup <srcdir> <destdir>"
  return 1
  fi
  numtars=$(ls -l "$2" | grep ".tgz$" | wc -l)
  if [ $numtars -lt 3 ]; then
      var="$1-$numtars.tgz" 
      tar cf $var $1
      mv $var $2
      return 0
      else
          firstfile=$(ls "$2" | sort | grep "$1" | awk 'NR == 1')
          N=$(ls "$2" | sort | sed -r 's/^.*([0-9]).tgz$/\1/'| awk 'NR == 3')
          N=$((N + 1))
          rm "$2/$firstfile"
          var="$1-$N.tgz"
          tar cf $var $1
          mv $var $2
          return 0
          fi

}

#test creating one backup
@test "backup src bkup (one backup)" {
# This tests one simple backup
# It creates the files and then deletes
# them when done.
   mkdir src
   cp backup.bats src
   mkdir bkup
   run backup "src" "bkup"
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   rm -f -r bkup
   rm -f -r src
}

#test creating three backups
@test "backup src bkup (three backups)" {
# This tests three backup.
# It creates the files and then deletes
# them when done.
   mkdir src
   cp backup.bats src
   mkdir bkup
   run backup "src" "bkup"
   #give new file a chance to get old
   sleep 2
   echo $output
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   run backup "src" "bkup"
   #give new file a chance to get old
   sleep 2
   echo $output
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   [ -e "bkup/src-1.tgz" ]
   run backup "src" "bkup"
   echo $output
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   [ -e "bkup/src-1.tgz" ]
   [ -e "bkup/src-2.tgz" ]
   rm -f -r bkup
   rm -f -r src
}

#test creating four backups
@test "backup src bkup (four backups; oldest deleted)" {
# This tests three backup.
# It creates the files and then deletes
# them when done.
   mkdir src
   cp backup.bats src
   mkdir bkup
   run backup "src" "bkup"
   #give new file a chance to get old
   sleep 2
   echo $output
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   run backup "src" "bkup"
   #give new file a chance to get old
   sleep 2
   echo $output
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   [ -e "bkup/src-1.tgz" ]
   run backup "src" "bkup"
   sleep 2
   echo $output
   [ $status -eq 0 ]
   [ -e "bkup/src-0.tgz" ]
   [ -e "bkup/src-1.tgz" ]
   [ -e "bkup/src-2.tgz" ]

   #this should delete the oldest
   #and create a new one 
   run backup "src" "bkup"
   echo $output
   [ $status -eq 0 ]
   [ ! -e "bkup/src-0.tgz" ]
   [ -e "bkup/src-1.tgz" ]
   [ -e "bkup/src-2.tgz" ]
   [ -e "bkup/src-3.tgz" ]
   rm -f -r bkup
   rm -f -r src
}

#test calling backup with no arguments
@test "backup (missing arguments)" {
   run backup
   [ "$output" == "usage: backup <srcdir> <destdir>" ]
   [ $status -eq 1 ]
}

#test calling backup with bad argument
@test "backup src bkup (bkup directory doesn't exist)" {
   mkdir src
   cp backup.bats src
   run backup "src" "bkup"
   [ "$output" == "usage: backup <srcdir> <destdir>" ]
   [ $status -eq 1 ]
   rm -f -r src
}

#test calling backup with bad argument
@test "backup src bkup (src is a file; not a directory)" {
   touch src
   mkdir bkup
   cp backup.bats src
   run backup "src" "bkup"
   [ "$output" == "usage: backup <srcdir> <destdir>" ]
   [ $status -eq 1 ]
   rm -f -r src
   rm -f -r bkup
}

@test "remove any leftover files due to failing tests" {
   rm -f -r src
   rm -f -r bkup
}

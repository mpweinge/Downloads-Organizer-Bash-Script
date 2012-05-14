#Welcome to my first script
#Author: Michael Weingert
#Started: Friday, July 22, 2011

#STAGE 1 Completed: Friday, July 22, 2011
#STAGE 2 Completed: Friday, July 29, 2011
#STAGE 3 Completed: Saturday, July 30, 2011

#it all starts with a she-bang

#!/bin/bash

declare -i counter=0
cd ~/Downloads
PATTERN=*.imported
RESPONSE=""

for (( ;; ))
do
	echo "Stage 1: Remove all .imported files (from torrents)"
	echo "Continue? or Skip (C or S)"
	read var

	if [ $var = "C" ]; then
	echo "Good Choice"
	RESPONSE="true"
	break
	elif [ $var = "S" ]; then
	echo "MOVING ONTO THE NEXT STAGE GO GO GADGET"
	RESPONSE="false"
	break
	fi
done

if [ $RESPONSE = "true" ]; then
	FILES=$(find . -name "*.imported")
	if [ {FILES:-null}=null ]; then
	echo "No files to delete! Nices"
	RESPONSE="false"
	else
	echo "Some files to CLOBBER"
	fi
	
	if [ $RESPONSE="true" ]; then
		for file in $(find . -name "*.imported")
		do
			echo $file $counter
			counter=counter+1
			rm -v $file
		done
		echo "All files removed. Moving on"
	else
		echo "Moving on ... "
	fi
fi

echo "STAGE 2: Move all Movies (*.avi, *.mkv, *.wmv) to an Unwatched Movie folder"
for (( ;; ))
do
	echo "Type Y if you would like to organize movies or N"
	read stage2
	if [ $stage2 = "Y" ]; then
		RESPONSE="true"
		break
	elif [ $stage2 = "N" ]; then
		RESPONSE="false"
		break
	fi
done

AVIPATTERN=".avi"
MKVPATTERN=".mkv"
MP4PATTERN=".mp4"

#declare -i RECURSIONDEPTH
UPDIR="../"
UPPATTERN="/*"

function MovieFind {
for files in $1/*; do
	fileavi=${files%$AVIPATTERN}
	filemkv=${files%$MKVPATTERN}
	filemp4=${files%$MP4PATTERN}

	RECURSIONDEPTH=$2
	
	if [ "$fileavi" != "$files" ] || [ "$filemp4" != "$files" ] || [ "$filemkv" != "$files" ]; then
		fileUP=$files
		oneUP=${fileUP%$UPPATTERN}
		for (( i=1; i<$RECURSIONDEPTH; i++ )) ; do
			fileUP=${fileUP%$UPPATTERN}
		done
		if [ $RECURSIONDEPTH -eq 1 ]; then
			echo "Movie Name: "${fileUP}
		else
			echo "Movie Directory: "${fileUP}
			echo "Movie Name: "${files#$oneUP}
		fi
		EndDirec="~/Desktop/Unwatched_Movies/${fileUP#$PWD}"
		#COPY FOR NOW, change to MV to move instead -> much faster and will delete
		cp -R $fileUP ~/Desktop/Unwatched_Movies
		
	fi
		
	if [ -d "$files" ]; then
		let RECURSIONDEPTH=$RECURSIONDEPTH+1
		MovieFind $files $RECURSIONDEPTH
	fi
done
}


if [ $RESPONSE = "true" ]; then
	echo "Gathering list of movies ... "

	MovieFind $PWD 1
fi

echo "Stage 3 ... Moving 4chan pics to 4chan folder"
echo "Identifying 4chan pics by numbers 0-9 followed by .jpg, .gif, or .png"
			
for (( ;; ))
do
	echo "Type Y if you would like to organize 4chan movies or N"
	read stage2
	if [ $stage2 = "Y" ]; then
		RESPONSE="true"
		break
	elif [ $stage2 = "N" ]; then
		RESPONSE="false"
		break
	fi
done

CHANPATTERN="^/[0-9]{10,}\.(jpg|png|gif)$"

if [ $RESPONSE = "true" ]; then
	for files in $PWD/*; do
	file=${files#$PWD}
		if [[ $file =~ $CHANPATTERN ]]; then 
			echo $files
			EndDirec="/Users/Mikey/Desktop/Desktop_Documents/4chan"
			echo $EndDirec
			mv $files $EndDirec
		fi
	done
fi

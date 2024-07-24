rm *.wav manifest.txt
touch manifest.txt
x=1
while [ $x -le $1 ]
do
  	say -o $x $x
	ffmpeg -i $x.aiff $x.wav
	rm $x.aiff
	echo $x.wav >> manifest.txt
	x=$(( $x + 1 ))
done

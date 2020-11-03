#!/bin/bash

draw()
{
	echo "    1   2   3"
	echo "  |———|———|———|"
	echo "A | `cat board.txt | cut -c1 | tr "-" " " 2>/dev/null` | `cat board.txt | cut -c2 | tr "-" " " 2>/dev/null` | `cat board.txt | cut -c3 | tr "-" " " 2>/dev/null` |"
	echo "  |———|———|———|"
	echo "B | `cat board.txt | cut -c4 | tr "-" " " 2>/dev/null` | `cat board.txt | cut -c5 | tr "-" " " 2>/dev/null` | `cat board.txt | cut -c6 | tr "-" " " 2>/dev/null` |"
	echo "  |———|———|———|"
	echo "C | `cat board.txt | cut -c7 | tr "-" " " 2>/dev/null` | `cat board.txt | cut -c8 | tr "-" " " 2>/dev/null` | `cat board.txt | cut -c9 | tr "-" " " 2>/dev/null` |"
	echo "  |———|———|———|"
}

grid2num()
{
	case "$1" in
		a1|A1)
			printf "1"
			;;
		a2|A2)
			printf "2"
			;;
		a3|A3)
			printf "3"
			;;
		b1|B1)
			printf "4"
			;;
		b2|B2)
			printf "5"
			;;
		b3|B3)
			printf "6"
			;;
		c1|C1)
			printf "7"
			;;
		c2|C2)
			printf "8"
			;;
		c3|C3)
			printf "9"
			;;
	esac
}

num2grid()
{
	case "$1" in
		1)
			printf "A1"
			;;
		2)
			printf "A2"
			;;
		3)
			printf "A3"
			;;
		4)
			printf "B1"
			;;
		5)
			printf "B2"
			;;
		6)
			printf "B3"
			;;
		7)
			printf "C1"
			;;
		8)
			printf "C2"
			;;
		9)
			printf "C3"
			;;
	esac
}

prompt()
{
	draw
	printf "Choose your move: "
	read choice
	if [[ "$choice" =~ [a-cA-C][1-3] ]]
		then
			insert $choice
			return 0
		else
			echo "Invalid input. Try again. Example: a1, b3, C2, etc."
			echo "Choose your move: "
			return 1
		fi
}

insert()
{
	move=`echo $1`
	num=`grid2num $move`
	num_m1=$(($num-1))
	current=`cat board.txt | cut -c$num`

	if [[ "$current" == "-" ]]
	then
		#insert the move into database https://stackoverflow.com/a/24470008
		updated_board=`sed -E "s/^(.{$num_m1})-/\1X/" board.txt`
		rm board.txt
		echo $updated_board > board.txt
		#declare $move="x"
		return 0
	else
		echo "Invalid move. Square already occupied. Try again."
		echo "Choose your move: "
		return 1
	fi
}

# 10 player wins
# 20 opponent (computer) wins
# 30 no winner, moves still available
# 40 no winner, board full
check()
{
	board=`cat board.txt`

	h1=`echo $board | cut -c1``echo $board | cut -c2``echo $board | cut -c3`
	h2=`echo $board | cut -c4``echo $board | cut -c5``echo $board | cut -c6`
	h3=`echo $board | cut -c7``echo $board | cut -c8``echo $board | cut -c9`

	v1=`echo $board | cut -c1``echo $board | cut -c4``echo $board | cut -c7`
	v2=`echo $board | cut -c2``echo $board | cut -c5``echo $board | cut -c8`
	v3=`echo $board | cut -c3``echo $board | cut -c6``echo $board | cut -c9`

	sf=`echo $board | cut -c1``echo $board | cut -c5``echo $board | cut -c9`
	sb=`echo $board | cut -c3``echo $board | cut -c5``echo $board | cut -c7`

	if [[ "$h1" == "XXX" || "$h2" == "XXX" || "$h3" == "XXX" || "$v1" == "XXX" || "$v2" == "XXX" || "$v3" == "XXX" || "$sf" == "XXX" || "$sb" == "XXX" ]]
	then
		return 10
	elif [[ "$h1" == "OOO" || "$h2" == "OOO" || "$h3" == "OOO" || "$v1" == "OOO" || "$v2" == "OOO" || "$v3" == "OOO" || "$sf" == "OOO" || "$sb" == "OOO" ]]
	then
		return 20
	else
		if [ `echo $board | grep "-"` ]
		then
			return 30
		else
			return 40
		fi
	fi
}

echo "---------" > board.txt

while [ true ]
do
	prompt
	lastmove=`echo $?`
	check
	result=`echo $?`

	if [[ "$result" == 10 ]]
	then
		echo "You win!"
		printf "Play again? y|n: "
		read replay
		if [[ "$replay" == "y" ]]
		then
			echo "---------" > board.txt
		else
			echo "Bye!"
			exit 0
		fi
	fi
done



#if [ $result -eq 10 ]
#then
	# player wins
#else
	# computer makes a move
#	check
#	if [ $result -eq 20 ]
#	then
		# computer wins
#	fi
#fi





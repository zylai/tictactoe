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

replay=y

while [[ "$replay" == y ]]
do
	echo "---------" > board.txt
	result=30
	draw

	while [[ "$result" == "30" ]]
	do
		while [ true ]
		do
			printf "Choose your move: "
			read move

			num=`grid2num $move` 2>/dev/null
			num_m1=$(($num-1)) 2>/dev/null
			current=`cat board.txt 2>/dev/null | cut -c$num 2>/dev/null` 2>/dev/null

			if [[ "$move" =~ [a-cA-C][1-3] && "$current" == "-" ]]
			then
				#insert the move into database https://stackoverflow.com/a/24470008
				updated_board=`sed -E "s/^(.{$num_m1})-/\1X/" board.txt`
				rm board.txt
				echo $updated_board > board.txt
				break
			else
				echo "Invalid input or move. Try again."
			fi
		done

		check
		result=`echo $?`

		if [[ "$result" == "10" || "$result" == "40" ]]
		then
			case "$result" in
				10)
					echo "You win"
					printf "Play again? y|n: "
					read replay
					if [[ "$replay" == "y" || "$replay" == "Y" ]]
					then
						break
					else
						echo "Bye!"
						exit 0
					fi
					;;
				40)
					echo "Tie"
					printf "Play again? y|n: "
					read replay
					if [[ "$replay" == "y" || "$replay" == "Y" ]]
					then
						break
					else
						echo "Bye!"
						exit 0
					fi
					;;
			esac
		fi

		#computer's turn
		square=`cat board.txt | fold -w1 | grep -n "-" | sort -R | head -n1 | cut -c1`
		square_m1=$(($square-1))
		updated_board=`sed -E "s/^(.{$square_m1})-/\1O/" board.txt`
		rm board.txt
		echo $updated_board > board.txt

		check
		result=`echo $?`

		if [[ "$result" == "20" || "$result" == "40" ]]
		then
			case "$result" in
				20)
					echo "Opponent's move: `num2grid $square`"
					echo "You lost"
					printf "Play again? y|n: "
					read replay
					if [[ "$replay" == "y" || "$replay" == "Y" ]]
					then
						break
					else
						echo "Bye!"
						exit 0
					fi
					;;
				40)
					echo "Opponent's move: `num2grid $square`"
					echo "Tie"
					printf "Play again? y|n: "
					read replay
					if [[ "$replay" == "y" || "$replay" == "Y" ]]
					then
						break
					else
						echo "Bye!"
						exit 0
					fi
					;;
			esac
		fi
		draw
		echo "Opponent's move: `num2grid $square`"
	done
done

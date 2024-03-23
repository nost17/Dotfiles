#!/bin/bash

# Cat ascii
FIRST_LINE="  ／l、"
SECOND_LINE="（ﾟ､ ｡ ７ "
THIRD_LINE="  l、ﾞ~ヽ"
FOURTH_LINE="  じしf_, )ノ"


# variables for the info
user=$USER
wm=$XDG_SESSION_DESKTOP
#local pkg=$(pacman -Qq | wc -l)
os=$(lsb_release -sd)

# clear the quotes for the os
os=${os##[\"\']}
os=${os%%[\"\']}

if [[ $os == "Arch Linux" ]]; then
	pkg=$(pacman -Qq | wc -l)
elif [[ $os == "Void Linux" ]]; then
	pkg=$(xbps-query | wc -l)
else
	pkg=$(dpkg-query -f '.\n' -W | wc -l)
fi


# Colors
G=$'\e[0;32m'  # green
C=$'\e[0;36m'  # cyan
B=$'\e[0;34m'  # blue
BL=$'\e[0;37m' #black
R=$'\e[0;31m'  #red
P=$'\e[0;35m'
Y=$'\e[0;33m'
RB=$'\e[1;31m'
RESET=$'\e[0m'
BOLD=$'\e[1m'

# clear the terminal
# comment it if u dont want
tput clear

# function for the main thing
main ()
{
	
	
	
	
cat << EOF
                $RESET$B$BOLD $user@$HOSTNAME
$RESET   ／l、        $BOLD ------------------$RESET
$RESET （ﾟ､ ｡ ７      $R$BOLD User $RESET~ $BL$user
$RESET   |、ﾞ~ヽ      $C$BOLD OS   $RESET~ $BL$os
$RESET   じしf_, )ノ  $P$BOLD WM   $RESET~ $BL$wm
                $Y$BOLD Pkg  $RESET~ $BL$pkg

EOF
	# echo -e "  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁"
}

help ()
{
	echo "Try execute the command again with no parameters"
}

info ()
{
	cat << EOF
$RESET$B$BOLD $user@$HOSTNAME
$BOLD ------------------$RESET
$R$BOLD User $RESET~ $BL$user
$C$BOLD OS   $RESET~ $BL$os
$P$BOLD WM   $RESET~ $BL$wm
$Y$BOLD Pkg  $RESET~ $BL$pkg

EOF
}

pic ()
{
	chafa $PICLOC --size 20x20
}

# Run
case $1 in
	"")
		main
		;;
	"info")
		info
		;;
	-h|--help)
		help
		;;
	pic)
		if [[ $2 = "" ]]; then
			echo "Pls Insert 'Path/To/Picture'"
		else
			PICLOC=$2
			pic
			echo
			info
		fi
		;;
esac



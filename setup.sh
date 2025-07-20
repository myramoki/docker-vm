GITDIR="https://raw.githubusercontent.com/myramoki/builder-vm/main"
export GITDIR

SUDO_USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
export SUDO_USER_HOME

echo "
##
## Choose which setup you want to run:
##
##   S - Starter setup [only]
##   G - Github [only]
##   a - all [starter, github]
##
"

read -p "?? Select setup type: " respType

_basic() {
	printf "%s\n" $GITDIR/001-software.sh \
		$GITDIR/002-network.sh \
		$GITDIR/003-cifs.sh \
		$GITDIR/090-user.sh \
		$GITDIR/099-misc.sh
}

_github() {
	printf "%s\n" $GITDIR/201-github-ssh.sh
}

if [ -n "$respType" ]; then
	case $respType in
	S)	echo "# Processing Starter [only]"
		sh -c "$(curl $(_basic))"
		;;

	G)	echo "# Processing Github setup [only]"
		sh -c "$(curl $(_github))"
		;;

	a)	echo "# Automation"
		sh -c "$(curl $(_basic) $(_github))"
		;;
	esac
fi

if [ -e /tmp/dofinal ]; then
	sh -c "$(cat /tmp/dofinal)"
fi

if [ -e /tmp/doreboot ]; then
    read -t 5 -p "Press ENTER before reboot"
	reboot
fi

#!/bin/sh

CONFIG=~/.config
SCRIPTS=~/.local/bin

# TODO: print what has been installed

case "$1" in
	config)
		case "$2" in
			install)
				# create all directories
				# TODO: config is dependent on caller location, make independent
				# TODO: remove hidden, only here for zshrc
				fd --base-directory config --type directory \
					| xargs -I {} mkdir -p ~/.config/{}

				# link all config files
				fd --base-directory config --type file --hidden \
					| xargs -I {} ln -fs $(realpath config/{}) ~/.config/{}
				;;
			uninstall)
				# unlink all config files
				fd --base-directory config --type file --hidden \
					| xargs -I {} unlink ~/.config/{}
				;;
			*)
				echo "Usage: $(basename $0) config [install|uninstall]"
				exit 1
				;;
		esac
		;;
	scripts)
		case "$2" in
			install)
				# create bin directory
				[ -d $SCRIPTS ] \
					|| mkdir $SCRIPTS

				# link all shell scripts
				fd --base-directory scripts --type file \
					| xargs -I {} ln -fs $(realpath scripts/{}) $SCRIPTS/{}
				;;
			uninstall)
				# unlink all shell scripts
				fd --base-directory scripts --type file \
					| xargs -I {} unlink $SCRIPTS/{}

				;;
			*)
				echo "Usage: $(basename $0) scripts [install|uninstall]"
				exit 1
				;;
		esac

		# remove broken symlinks
		find -L $SCRIPTS -maxdepth 1 -type l -delete
		;;
	*)
		echo "Usage: $(basename $0) [config|scripts] [install|uninstall]"
		exit 1
		;;
esac

Ubuntu Gnome Flashback
-----
A short script that tries to make ubuntu 17.10 as close to discontinued flavor ubuntu gnome as possible
-----
Description:

This script does 3 things
1. Install gnome session and wallpapers
2. Clean ubuntu session to an extend that it does not break the system
3. Bootstrap new users to have the full gnome look and feel on first use

Usage:

To transform ubuntu 17.10's desktop to mostly gnome

	chmod 755 ubuntu-gnome.sh
	./ubuntu-gnome.sh
	or
	bash ubuntu-gnome.sh

To revert back to ubuntu

	chmod 755 ubuntu-gnome.sh
	./ubuntu-gnome.sh restore
	or
	bash ubuntu-gnome.sh restore
	

sh(dash) does not run the script properly, so don't sh ubuntu-gnome.sh


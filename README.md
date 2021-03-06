Ubuntu Gnome Flashback
-----
A short script that tries to make ubuntu 17.10 as close to discontinued flavor ubuntu gnome as possible
-----
Transform and Restore tested on 10/24/2017 with a fresh ubuntu 17.10 install
Important:

If you want to be absolutely safe during a release upgrade (say, 18.04 when it releases), run 

	bash ubuntu-gnome.sh restore
	
or

	./ubuntu-gnome.sh restore

as pointed out here http://community.ubuntu.com/t/restoring-ubuntu-gnome-experience-in-17-10-reference-steps/1016/7

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
	
Note:

sh(dash) does not run the script properly, so don't sh ubuntu-gnome.sh

Currently /usr/share/xsession/gnome-xorg.desktop does not properly launch a session without --session=gnome parameter was set for gnome-session while ubuntu-session was removed. The script does try to remedy that by editing the file but in case of an update of gnome-session breaks the system, a separated .desktop file was created to supply the session entry "Gnome on Xorg (Backup)".

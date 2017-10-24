#!/bin/bash
# by Katharine https://github.com/Kethen/
#restore ubuntu environment
function restore {
	echo "Restoring ubuntu session"
	sudo bash -c '
	echo "Do you wish to remove gnome-session as well? [y/N]"&&\
	read REMOVE_GNOME&&\
	if [ "$REMOVE_GNOME" = "y" ];\
	then
		echo "Removing gnome-session"&&\
		apt remove --purge gnome-session gnome-backgrounds gnome-tweak-tool -y&&\
		rm -f /usr/share/xsessions/gnome-xorg-backup.desktop;\
	fi;\
	#restore gdm theme to ubuntu theme
	update-alternatives --install /usr/share/gnome-shell/theme/gdm3.css gdm3.css /usr/share/gnome-shell/theme/gnome-shell.css 5&&\
	usermod gdm -s /bin/bash&&\
	su gdm -c "gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/warty-final-ubuntu.png"&&\
	su gdm -c "gsettings set org.gnome.desktop.screensaver picture-uri file:///usr/share/backgrounds/warty-final-ubuntu.png"&&\
	usermod gdm -s /bin/false&&\
	#reinstall packages
	apt install ubuntu-desktop -y&&\
	#remove extra files created too bootstrap gnome theming settings
	rm -f /usr/share/ubuntu-gnome-init.sh /etc/xdg/autostart/ubuntu-gnome-init.desktop&&\
	echo "Done, please reboot to see changes"&&\
	echo "If you had removed gnome-session, you current wallpaper might be missing"&&\
	echo "Do not worry just set it back manually"
	'
}

#transform ubuntu environment to close to pure gnome
function transform {
	echo "Warning: This could ruin your desktop environment if you don't read the following clearly"
	echo "This script works for a fresh ubuntu 17.10 install as of 10/24/2017"
	echo "This might or might not work properly for future ubuntu versions"
	echo "Incase your installation is not a FRESH INSTALL of 17.10 or not even 17.10, be cautious when you perform \'apt autoremove\' in the future. Run that after this script and carefully examine packages that your system is trying to get rid of. \'apt install\' packages you wish to keep to mark them as manually installed"
	echo "Please run restore before a distribution upgrade"
	echo "Todo: See if it dies after a distribution upgrade without a restore"
	echo ""
	echo "do you wish to continue?[y/N]"
	read kbd
	if ! [ "$kbd" = "y" ]
	then
		echo "Canceled"
		exit 0
	fi
	sudo bash -c '
	#apt update
	apt update&&\
	#install gnome session and remove ubuntu session
	apt install gnome-session -y&&\
	apt install gnome-tweak-tool -y&&\
	apt remove --purge ubuntu-session -y&&\
	apt remove --purge ubuntu-web-launchers gnome-shell-extension-ubuntu-dock -y&&\
	apt remove --purge gsettings-ubuntu-schemas -y&&\
	#fix gnome xorg session launch .desktop file
	GNOME_DESKTOP_FILE=/usr/share/xsessions/gnome-xorg.desktop;\
	GNOME_DESKTOP_FILE_DUP=/usr/share/xsessions/gnome-xorg-backup.desktop;\
	sed -i "/Exec=/d" $GNOME_DESKTOP_FILE&&\
	echo "Exec=gnome-session --session=gnome" >> $GNOME_DESKTOP_FILE&&\
	echo "TryExec=gnome-session" >> $GNOME_DESKTOP_FILE&&\
	#create a just in case desktop file if the one with fix applied gets replaced by a package update
	cp -a $GNOME_DESKTOP_FILE $GNOME_DESKTOP_FILE_DUP&&\
	sed -i "/Name=/d" $GNOME_DESKTOP_FILE_DUP&&\
	echo "Name=GNOME on Xorg (Backup)" >> $GNOME_DESKTOP_FILE_DUP&&\
	#setting gdm theme
	update-alternatives --install /usr/share/gnome-shell/theme/gdm3.css gdm3.css /usr/share/gnome-shell/theme/gnome-shell.css 15&&\
	usermod gdm -s /bin/bash&&\
	su gdm -c "gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/gnome/adwaita-day.jpg"&&\
	su gdm -c "gsettings set org.gnome.desktop.screensaver picture-uri file:///usr/share/backgrounds/gnome/adwaita-lock.jpg"&&\
	usermod gdm -s /bin/false&&\
	#theme
	apt remove --purge dmz-cursor-theme ubuntu-artwork ubuntu-sounds -y&&\
	apt install gnome-backgrounds -y&&\
	apt remove --purge adium-theme-ubuntu light-themes -y&&\
	#bootstrap gnome theming with a script
	GNOME_SETTINGS_INIT=/usr/share/ubuntu-gnome-init.sh;\
	echo "if ! [ -f ~/.config/ubuntu-gnome-initialized ] && [ \"\$XDG_CURRENT_DESKTOP\" = \"GNOME\" ]" > $GNOME_SETTINGS_INIT&&\
	echo "then" >> $GNOME_SETTINGS_INIT&&\
	echo "gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/gnome/adwaita-day.jpg" >> $GNOME_SETTINGS_INIT&&\
	echo "gsettings set org.gnome.desktop.screensaver picture-uri file:///usr/share/backgrounds/gnome/adwaita-lock.jpg" >> $GNOME_SETTINGS_INIT&&\
	echo "gsettings set org.gnome.Terminal.Legacy.Settings theme-variant dark" >> $GNOME_SETTINGS_INIT&&\
	echo "gsettings set org.gnome.Terminal.Legacy.Settings new-terminal-mode tab" >> $GNOME_SETTINGS_INIT&&\
	echo "gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,close" >> $GNOME_SETTINGS_INIT&&\
	echo "touch ~/.config/ubuntu-gnome-initialized" >> $GNOME_SETTINGS_INIT&&\
	echo "fi" >> $GNOME_SETTINGS_INIT&&\
	#launch that script with a desktop file in /etc/xdg/autostart
	GNOME_SETTINGS_INIT_DESKTOP_FILE=/etc/xdg/autostart/ubuntu-gnome-init.desktop;\
	echo "[Desktop Entry]" > $GNOME_SETTINGS_INIT_DESKTOP_FILE&&\
	echo "Type=Application" >> $GNOME_SETTINGS_INIT_DESKTOP_FILE&&\
	echo "Name=Ubuntu Gnome First Time Initialization" >> $GNOME_SETTINGS_INIT_DESKTOP_FILE&&\
	echo "Exec=bash $GNOME_SETTINGS_INIT" >> $GNOME_SETTINGS_INIT_DESKTOP_FILE&&\
	echo "Done, please reboot to see changes"
	'
}
if [ "$1" = "restore" ]
then
	restore
	exit 0
fi
transform
exit 0


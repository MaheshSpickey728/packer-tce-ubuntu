#!/bin/sh

#--------------------------------------------------------------------------------------
# Ubuntu - First set of OS customization 
#        - Install GNOME Desktop
#--------------------------------------------------------------------------------------

echo "#--------------------------------------------------------------"
echo "# Starting 23-install-gnome.sh" 
echo "#--------------------------------------------------------------"

apt-get install -y gnome-session gdm3
apt-get install -y xterm

systemctl isolate graphical.target
systemctl set-default graphical.target
# systemctl set-default multi-user.target

# Disable sleep mode
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 
echo "IdleAction=ignore" >> /etc/systemd/logind.conf 

rm '/etc/systemd/system/default.target'
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'

#--------------------------------------------------------------------------------------
# Additional settings for user juliusn
#--------------------------------------------------------------------------------------

cat << EOF > /home/juliusn/.xinitrc.gnome
exec /usr/bin/gnome-session &
xrdb -merge /home/juliusn/.Xresources
EOF

mkdir -p /home/juliusn/.vnc
cat << EOF > /home/juliusn/.vnc/xstartup.gnome
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec /usr/bin/gnome-session &
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
xrdb -merge /home/juliusn/.Xresources
xsetroot -solid grey
vncconfig -iconic &
EOF

cat << EOF > /home/juliusn/.Xresources
xterm*faceName: Bitstream Vera Serif Mono
xterm*faceSize: 11
xterm*vt100*geometry: 80x40
xterm*BorderWidth: 15
xterm*BorderColor: rgb:fc/fc/54
xterm*ScrollBar: true
xterm*RightScrollBar: true
xterm*Thickness: 10
xterm*saveLines: 16384
xterm*loginShell: true
xterm*charClass: 33:48,35:48,37:48,43:48,45-47:48,64:48,95:48,126:48
xterm*termName: xterm-color
xterm*eightBitInput: false
xterm*VisualBell: true
xterm*font: -*-fixed-medium-r-*-*-15-*-*-*-*-*-iso8859-*
xterm*foreground: white
xterm*background: darkblue
xterm*color0: rgb:00/00/00
xterm*color1: rgb:a8/00/00
xterm*color2: rgb:00/a8/00
xterm*color3: rgb:a8/54/00
xterm*color4: rgb:00/00/a8
xterm*color5: rgb:a8/00/a8
xterm*color6: rgb:00/a8/a8
xterm*color7: rgb:a8/a8/a8
xterm*color8: rgb:54/54/54
xterm*color9: rgb:fc/54/54
xterm*color10: rgb:54/fc/54
xterm*color11: rgb:fc/fc/54
xterm*color12: rgb:54/54/fc
xterm*color13: rgb:fc/54/fc
xterm*color14: rgb:54/fc/fc
xterm*color15: rgb:fc/fc/fc
EOF

cp /home/juliusn/.xinitrc.gnome /home/juliusn/.xinitrc
cp /home/juliusn/.vnc/xstartup.gnome /home/juliusn/.vnc/xstartup
chmod 755 /home/juliusn/.vnc/xstartup* /home/juliusn/.xinitrc* /home/juliusn/.Xresources
chown -R juliusn:juliusn /home/juliusn/.vnc /home/juliusn/.xinitrc* /home/juliusn/.Xresources

# dbus-update-activation-environment --systemd DISPLAY --verbose

echo "Done 23-install-gnome.sh"
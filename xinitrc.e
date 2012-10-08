#!/bin/sh

# Basic X setup
xrdb ~/.Xresources

# Agents
create_zenv_file() {
	touch /dev/shm/zenv_agents
	chgrp wheel /dev/shm/zenv_agents
	chmod 660 /dev/shm/zenv_agents
}
if ! pgrep gpg-agent >/dev/null; then
	create_zenv_file 2>/dev/null
	gpg-agent >>/dev/shm/zenv_agents --daemon --pinentry-program $(which pinget)
fi
if ! pgrep ssh-agent >/dev/null; then
	create_zenv_file 2>/dev/null
	ssh-agent | grep -v '^echo' >>/dev/shm/zenv_agents
fi
source /dev/shm/zenv_agents

# systemd/e17 session
export XDG_DATA_DIRS="${HOME}/.xdg:/usr/share/enlightenment:/usr/share"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/session_bus_socket"
exec ck-launch-session /usr/lib/systemd/systemd --user

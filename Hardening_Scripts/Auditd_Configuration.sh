 auditd_configuration() }
  echo "
# Removes any existing auditd rules
-D
# Sets the buffer size, which may need to be increased, depending on the load of your system.
-b 8192
# Failure Mode 1, prints a failure message.
-f 2
# Audits the audit logs.
-w /var/log/audit/ -k auditlog
# Modifies the audit configuration,that occurs during the audit.
-w /etc/libaudit.conf -p wa -k auditconfig
-w /etc/audit/ -p wa -k auditconfig
-w /etc/audisp/ -p wa -k audispconfig
# Audits, user, group, and password databases
-w /etc/group -p wa -k etcgroup
-w /etc/passwd -p wa -k etcpasswd
-w /etc/gshadow -k etcgroup
-w /etc/shadow -k etcpasswd
-w /etc/security/opasswd -k opasswd
 Monitor user and group tools
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/addgroup -p x -k group_modification
-w /usr/sbin/adduser -p x -k user_modification
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/groupmod -p x -k group_modification
# Monitors usage of passwd command
-w /usr/bin/passwd -p x -k passwd_modification
# Schedules cronjobs
-w /etc/cron.monthly/ -p wa -k cron
-w /etc/cron.hourly/ -p wa -k cron
-w /etc/crontab -p wa -k cron
-w /etc/cron.weekly/ -p wa -k cron
-w /etc/cron.d/ -p wa -k cron
-w /etc/cron.deny -p wa -k cron
-w /etc/cron.daily/ -p wa -k cron
-w /etc/cron.allow -p wa -k cron
-w /var/spool/cron/crontabs/ -k cron
# Configures login and stored information
-w /etc/login.defs -p wa -k login
-w /etc/securetty -p wa -k login
-w /var/log/faillog -p wa -k login
-w /var/log/lastlog -p wa -k login
-w /var/log/tallylog -p wa -k login
# Network configuration
-w /etc/network/ -p wa -k network
-w /etc/hosts -p wa -k hosts
# Library search paths
-w /etc/ld.so.conf -p wa -k libpath
# Kernel parameters and module loading and unloading
-w /etc/sysctl.conf -p wa -k sysctl
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/insmod -k modules
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/modprobe -k modules
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/rmmod -k modules
-a always,exit -F arch=b64 -S finit_module -S init_module -S delete_module -F auid!=-1 -k modules
-a always,exit -F arch=b32 -S finit_module -S init_module -S delete_module -F auid!=-1 -k modules
# System startup scripts
-w /etc/init.d/ -p wa -k init
-w /etc/init/ -p wa -k init
-w /etc/inittab -p wa -k init
# SSH configuration
-w /etc/ssh/sshd_config -k sshd
# Hostname
-a exit,always -F arch=b32 -S sethostname -k hostname
-a exit,always -F arch=b64 -S sethostname -k hostname
# Captures all failures to access on critical elements
-a exit,always -F arch=b64 -S open -F dir=/usr/local/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/var -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/sbin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/home -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/sbin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/srv -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/etc -F success=0 -k unauthedfileacess
# Logs all commands executed by root
-a exit,always -F arch=b64 -F euid=0 -S execve -k rootcmd
-a exit,always -F arch=b32 -F euid=0 -S execve -k rootcmd
# Su and Sudo
-w /etc/sudoers -p rw -k priv_esc
-w /usr/bin/sudo -p x -k priv_esc
-w /bin/su -p x -k priv_esc
# Poweroffs and reboots tools
-w /sbin/shutdown -p x -k power
-w /sbin/halt -p x -k power
-w /sbin/poweroff -p x -k power
-w /sbin/reboot -p x -k power
# Monitors for use of audit management tools
-w /sbin/auditd -p x -k audittools
-w /sbin/auditctl -p x -k audittools
# Prevents chrony from overwhelming the logs
-a never,exit -F arch=b64 -S adjtimex -F auid=unset -F uid=chrony -F subj_type=chronyd_t
# Ignore End of Event records 
-a always,exclude -F msgtype=EOE
# Ignore current working directory records
-a always,exclude -F msgtype=CWD
# VMWare tools
-a exit,never -F arch=b32 -S fork -F success=0 -F path=/usr/lib/vmware-tools -F subj_type=initrc_t -F exit=-2
-a exit,never -F arch=b64 -S fork -F success=0 -F path=/usr/lib/vmware-tools -F subj_type=initrc_t -F exit=-2
# High Volume Event Filter 
-a exit,never -F arch=b32 -F dir=/dev/shm -k sharedmemaccess
-a exit,never -F arch=b64 -F dir=/dev/shm -k sharedmemaccess
-a exit,never -F arch=b32 -F dir=/var/lock/lvm -k locklvm
-a exit,never -F arch=b64 -F dir=/var/lock/lvm -k locklvm
# Modprobe configuration
-w /etc/modprobe.conf -p wa -k modprobe
# KExec usage 
-a always,exit -F arch=b64 -S kexec_load -k KEXEC
-a always,exit -F arch=b32 -S sys_kexec_load -k KEXEC
# Special files
-a exit,always -F arch=b32 -S mknod -S mknodat -k specialfiles
-a exit,always -F arch=b64 -S mknod -S mknodat -k specialfiles
# Mount operations
-a always,exit -F arch=b64 -S mount -S umount2 -F auid!=-1 -k mount
-a always,exit -F arch=b32 -S mount -S umount -S umount2 -F auid!=-1 -k mount
# Change swap 
-a always,exit -F arch=b64 -S swapon -S swapoff -F auid!=-1 -k swap
-a always,exit -F arch=b32 -S swapon -S swapoff -F auid!=-1 -k swap
# Time
-a exit,always -F arch=b32 -S adjtimex -S settimeofday -S clock_settime -k time
-a exit,always -F arch=b64 -S adjtimex -S settimeofday -S clock_settime -k time
# Local time zone
-w /etc/localtime -p wa -k localtime
# Stunnel
-w /usr/sbin/stunnel -p x -k stunnel
# Sudoers file changes
-w /etc/sudoers -p wa -k actions
# Makes the configuration immutable
-e 2
" > /etc/audit/rules.d/audit.rules
  systemctl enable auditd.service
  service auditd restart
}
auditd_configuratio

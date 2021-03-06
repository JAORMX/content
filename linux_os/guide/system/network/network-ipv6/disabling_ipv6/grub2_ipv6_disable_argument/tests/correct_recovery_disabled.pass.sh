#!/bin/bash
# platform = Red Hat Enterprise Linux 7

# Correct the form of default kernel command line in GRUB /etc/default/grub and applies value through Grubby
if grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=.*ipv6\.disable=.*"'  '/etc/default/grub' ; then
	# modify the GRUB command-line if an ipv6.disable= arg already exists
	sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)ipv6\.disable=[^[:space:]]*\(.*"\)/\1 ipv6\.disable=1 \2/'  '/etc/default/grub'
else
	# no ipv6.disable=arg is present, append it
	sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 ipv6\.disable=1"/'  '/etc/default/grub'
fi

# removing the parameter from the no recovery kernel parameters as well
sed -i 's/\(^GRUB_CMDLINE_LINUX=".*\)ipv6\.disable=[^[:space:]]*\(.*"\)/\1 \2/'  '/etc/default/grub'

# disabling recovery
sed -i 's/\(^.*GRUB_DISABLE_RECOVERY=\).*/\1true/' '/etc/default/grub'

#if the line is not present at all, add it
if ! grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=.*$' '/etc/default/grub'; then
	echo 'GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"' >> /etc/default/grub
fi

grubby --update-kernel=ALL --args="ipv6.disable=1"

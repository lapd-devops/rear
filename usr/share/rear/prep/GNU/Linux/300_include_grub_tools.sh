#
# FIXME: I <jsmeix@suse.de> do not understand what the next comment means.
# Where is the "check if we're using grub2 before doing something"?
#
# GRUB2 has much more commands than the legacy grub command, including modules
# check if we're using grub2 before doing something.

test -d $VAR_DIR/recovery || mkdir -p $VAR_DIR/recovery

# Because usr/sbin/rear sets 'shopt -s nullglob' the 'echo -n' command
# outputs nothing if nothing matches the bash globbing pattern '/boot/grub*'
local grubdir="$( echo -n /boot/grub* )"
# Use '/boot/grub' as fallback if nothing matches '/boot/grub*'
test -d "$grubdir" || grubdir='/boot/grub'

if has_binary grub-probe ; then
    grub-probe -t device $grubdir >$VAR_DIR/recovery/bootdisk 2>/dev/null || return 0
elif has_binary grub2-probe ; then
    grub2-probe -t device $grubdir >$VAR_DIR/recovery/bootdisk 2>/dev/null || return 0
fi

# Missing programs in the PROGS array are ignored:
PROGS=( "${PROGS[@]}"
        grub-bios-setup      grub2-bios-setup
        grub-install         grub2-install
        grub-mkconfig        grub2-mkconfig
        grub-mkdevicemap     grub2-mkdevicemap
        grub-mkimage         grub2-mkimage
        grub-mkpasswd-pbkdf2 grub2-mkpasswd-pbkdf2
        grub-mkrelpath       grub2-mkrelpath
        grub-probe           grub2-probe
        grub-reboot          grub2-reboot
        grub-set-default     grub2-set-default
        grub-setup           grub2-setup )

COPY_AS_IS=( "${COPY_AS_IS[@]}" /etc/default/grub /etc/grub.d/* /etc/grub*.cfg /boot/grub* /usr/lib/grub* /usr/share/grub* )


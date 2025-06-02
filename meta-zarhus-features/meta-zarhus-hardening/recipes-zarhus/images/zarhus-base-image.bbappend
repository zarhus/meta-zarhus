require hardening.inc

# disable root account
EXTRA_USERS_PARAMS:append = " usermod -L -e 1 root;"

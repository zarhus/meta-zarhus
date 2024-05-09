require zarhus-base-image.inc

inherit extrausers

EXTRA_USERS_PARAMS = "usermod -p '${ROOT_PASSWD}' root;"

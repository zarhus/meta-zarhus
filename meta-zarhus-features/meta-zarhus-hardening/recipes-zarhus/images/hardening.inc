# nooelint: oelint.vars.duplicate
DEPENDS:append = " openssl-native"
# nooelint: oelint.var.multiinherit
inherit extrausers
EXTRA_USERS_PARAMS:append = " useradd -p '' -mG sudo user;  passwd-expire user;"

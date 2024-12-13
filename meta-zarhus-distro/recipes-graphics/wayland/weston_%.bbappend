require tls-dir.inc

PACKAGECONFIG:append:dbg = " rdp"

do_install:append:dbg() {
    openssl genrsa -out cakey.pem 2048
    openssl req -new -x509 -nodes -days 365000 -key cakey.pem -out cacert.pem -subj "/CN=rdp"
    openssl genrsa -out tls.key 2048
    openssl req -new -key tls.key -out tls.csr -subj "/CN=rdp"
    openssl x509 -req -days 365 -in tls.csr -out tls.crt -CA cacert.pem -CAkey cakey.pem
    install -d "${D}${TLS_DIR}"
    install -m 0644 tls.crt "${D}${TLS_DIR}/tls.crt"
    install -m 0644 tls.key "${D}${TLS_DIR}/tls.key"
}

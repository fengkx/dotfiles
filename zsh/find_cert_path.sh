#!/bin/bash

function find_cert_file() {
    # From https://github.com/alexcrichton/openssl-probe
    cert_dirs=(
        "/var/ssl"
        "/usr/share/ssl"
        "/usr/local/ssl"
        "/usr/local/openssl"
        "/usr/local/etc/openssl"
        "/usr/local/share"
        "/usr/lib/ssl"
        "/usr/ssl"
        "/etc/openssl"
        "/etc/pki/ca-trust/extracted/pem"
        "/etc/pki/tls"
        "/etc/ssl"
        "/etc/certs"
        "/opt/etc/ssl"
        "/data/data/com.termux/files/usr/etc/tls"
        "/boot/system/data/ssl"
    )

    cert_filenames=(
        "cert.pem"
        "certs.pem"
        "ca-bundle.pem"
        "cacert.pem"
        "ca-certificates.crt"
        "certs/ca-certificates.crt"
        "certs/ca-root-nss.crt"
        "certs/ca-bundle.crt"
        "CARootCertificates.pem"
        "tls-ca-bundle.pem"
    )

    for dir in "${cert_dirs[@]}"; do
        if [[ -d $dir ]]; then
            for file in "${cert_filenames}"; do
                full_path="${dir}/${file}"
                if [[ -f $full_path ]]; then
                    echo $full_path
                fi
            done
        fi
        
    done
}


function setup_nodejs_openssl_env() {
        if [[ $NODE_OPTIONS != *"--use-openssl-ca"* ]]; then
            export NODE_OPTIONS="${NODE_OPTIONS} --use-openssl-ca"
        fi
        if [[ ! -n $SSL_CERT_FILE ]]; then
            cert_file=$(find_cert_file)
            export SSL_CERT_FILE="${cert_file}"
        fi
    
}

setup_nodejs_openssl_env
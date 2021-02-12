#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install libffi-dev gnupg2

if [ -z "${TOXENV}" ]; then
    sudo apt-get -y install gpgsm libassuan-dev libgpg-error-dev swig

    # build/install gpgme 1.10.0 manually
    wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.10.0.tar.bz2
    tar -xvf gpgme-1.10.0.tar.bz2
    pushd gpgme-1.10.0
    ./configure \
        --prefix="$(python -c 'import sys; print(sys.prefix)')" \
        --disable-fd-passing \
        --disable-static \
        --disable-gpgsm-test \
        --infodir=/usr/share/info \
        --with-gpg=/usr/bin/gpg \
        --with-gpgsm=/usr/bin/gpgsm \
        --with-gpgconf=/usr/bin/gpgconf
    make
    sudo make install
    sudo ldconfig
    popd

    gpgconf --kill gpg-agent
    gpg-agent --daemon --homedir tests/gnupghome
fi

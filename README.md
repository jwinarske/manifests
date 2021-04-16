 # Manifest files for building Linux images via Yocto

Setup packages for build

    sudo apt-get install gawk wget git-core diffstat unzip texinfo build-essential chrpath socat cpio python python3 pip3 pexpect libsdl1.2-dev xterm make xsltproc docbook-utils fop dblatex xmlto python-git libssl-dev pv

Install Google repo

    mkdir -p ~/.bin
    PATH="${HOME}/.bin:${PATH}"
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    chmod a+rx ~/.bin/repo

Download the BSP source:

    PATH=${PATH}:~/bin
    mkdir rpi64_yocto
    cd rpi64_yocto
    repo init -u https://github.com/jwinarske/manifests.git -b dunfell -m rpi64.xml
    repo sync
    
Configure

    source sources/poky/oe-init-build-env rpi4-64
    bitbake-layers add-layer \
    ../sources/meta-raspberrypi \
    ../sources/meta-openembedded/meta-oe \
    ../sources/meta-openembedded/meta-multimedia \
    ../sources/meta-openembedded/meta-networking \
    ../sources/meta-openembedded/meta-python \
    ../sources/meta-openembedded/meta-perl \
    ../sources/meta-security \
    ../sources/meta-qt5 \
    ../sources/meta-rpi64 \
    ../sources/meta-clang \
    ../sources/meta-rust \
    ../sources/meta-flutter

Build Recipe

    bitbake flutter-engine

Build Image

    bitbake core-image-weston


Restarting a Development Session

    cd rpi64_yocto
    source sources/poky/oe-init-build-env rpi4-64

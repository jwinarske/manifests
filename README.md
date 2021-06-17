 # Manifest files for building Linux images via Yocto

Setup packages for build

    sudo apt-get install gawk wget git-core diffstat unzip texinfo build-essential chrpath socat cpio python python3 pip3 pexpect libsdl1.2-dev xterm make xsltproc docbook-utils fop dblatex xmlto python-git libssl-dev pv

Install Google repo

    mkdir -p ~/.bin
    PATH="${HOME}/.bin:${PATH}"
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    chmod a+rx ~/.bin/repo
    export PATH=${PATH}:~/bin

### Raspberry Pi3/4 (64-bit)

```
export MACHINE=raspberrypi4-64
```

or

```
export MACHINE=raspberrypi3-64
```

You may need to decrease setup-environment variable GPU_MEM to meet your specific needs.

### DRM

```
mkdir rpi_64_yocto && cd rpi_64_yocto
repo init -u https://github.com/jwinarske/manifests.git -m rpi64.xml -b dunfell
repo sync -j20
source ./setup-environment $MACHINE
echo -e 'CORE_IMAGE_EXTRA_INSTALL += " \' >> conf/local.conf
echo -e '  flutter-pi \' >> conf/local.conf
echo -e '  flutter-drm-gbm-backend \' >> conf/local.conf
echo -e '"\n' >> conf/local.conf
bitbake core-image-minimal
```

### Wayland

```
mkdir rpi_64_yocto && cd rpi_64_yocto
repo init -u https://github.com/jwinarske/manifests.git -m rpi64.xml -b dunfell
repo sync -j20
source ./setup-environment $MACHINE
DISTRO_FEATURES_append = " wayland"
echo -e 'CORE_IMAGE_EXTRA_INSTALL += " \' >> conf/local.conf
echo -e '  flutter-wayland \' >> conf/local.conf
echo -e '  flutter-wayland-client \' >> conf/local.conf
echo -e '  flutter-weston-desktop-shell \' >> conf/local.conf
echo -e '  flutter-weston-desktop-shell-virtual-keyboard \' >> conf/local.conf
echo -e '"\n' >> conf/local.conf
bitbake core-image-weston
```

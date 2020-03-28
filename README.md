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
    mkdir rpi_juce_yocto
    cd rpi_juce_yocto
    repo init -u https://github.com/jwinarske/manifests.git -b zeus -m rpi-juce.xml
    repo sync -j8
    
Configure

    . ./sources/poky/oe-init-build-env rpi4-64
    bitbake-layers add-layer ../sources/meta-raspberrypi ../sources/meta-webkit ../sources/meta-security ../sources/meta-openembedded/meta-oe ../sources/meta-openembedded/meta-multimedia ../sources/meta-openembedded/meta-networking ../sources/meta-openembedded/meta-python ../sources/meta-openembedded/meta-perl ../sources/meta-juce
    cp ../sources/meta-juce/conf/rpi4-64-wayland.template conf/local.conf

Build Recipe

    bitbake juce-binarybuilder

Build Image

    bitbake core-image-weston


Restarting a Development Session

    cd rpi_juce_yocto
    . ./sources/poky/oe-init-build-env rpi4-64


Use `lsblk` to find your storage device

Issue `lsblk`, then plug in your device, issue `lsblk` again.  It should be obvious which it is.


Image MMC card (Don't paste the below without adjusting for your MMC device...)

    sudo dd if=./tmp/deploy/images/raspberrypi4-64/core-image-weston-raspberrypi4-64.rpi-sdimg of=/dev/sdc bs=4M
    sync


If your ISP blocks www.example.com -> CenturyLink

    ERROR:  OE-core's config sanity checker detected a potential misconfiguration.
        Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).
        Following is the list of potential problems / advisories:

        Fetcher failure for URL: 'https://www.example.com/'. URL https://www.example.com/ doesn't work.
        Please ensure your host's network is configured correctly,
        or set BB_NO_NETWORK = "1" to disable network access if
        all required sources are on local disk.

Append variable to conf/local.conf

    echo 'CONNECTIVITY_CHECK_URIS = "https://www.google.com/"' >> conf/local.conf
    

#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

case "$PACKER_BUILDER_TYPE" in
parallels-iso|parallels-pvm)
    mkdir -p /tmp/parallels;

    if [ $(uname -r | cut -c1) -eq 5 ]
    then
      # Enable writing for parallel tools
      mkdir -p /tmp/parallels_ro;
      mount -o loop $HOME_DIR/prl-tools-lin.iso /tmp/parallels_ro;
      cp -rf /tmp/parallels_ro/. /tmp/parallels/.;

      # Patch prl-fs driver to be able to build against 5.x kernel
      PRL_TOOLS_PATH=/tmp/parallels;
      chmod 775 $PRL_TOOLS_PATH/kmods/;
      mkdir -p $PRL_TOOLS_PATH/kmods/prl_mod/;
      tar -zxvf $PRL_TOOLS_PATH/kmods/prl_mod.tar.gz -C $PRL_TOOLS_PATH/kmods/prl_mod/;
      sed -i 's/MS_RDONLY/SB_RDONLY/g' $PRL_TOOLS_PATH/kmods/prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c;
      sed -i 's/MS_MANDLOCK/SB_MANDLOCK/g' $PRL_TOOLS_PATH/kmods/prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c;
      sed -i 's/MS_SYNCHRONOUS/SB_SYNCHRONOUS/g' $PRL_TOOLS_PATH/kmods/prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c;
      sed -i 's/MS_SYNCHRONOUS/SB_SYNCHRONOUS/g' $PRL_TOOLS_PATH/kmods/prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c;
      sed -i 's/MS_NOATIME/SB_NOATIME/g' $PRL_TOOLS_PATH/kmods/prl_mod/prl_fs/SharedFolders/Guest/Linux/prl_fs/super.c;
      chmod 775 $PRL_TOOLS_PATH/kmods/prl_mod.tar.gz;
      rm -f $PRL_TOOLS_PATH/kmods/prl_mod.tar.gz;
      (cd $PRL_TOOLS_PATH/kmods/prl_mod/ && tar -zcvf ../prl_mod.tar.gz ./);
      rm -rf $PRL_TOOLS_PATH/kmods/prl_mod;
    else
      mount -o loop $HOME_DIR/prl-tools-lin.iso /tmp/parallels;
    fi

    VER="`cat /tmp/parallels/version`";
    echo "Parallels Tools Version: $VER";

    /tmp/parallels/install --install-unattended-with-deps \
      || (code="$?"; \
          echo "Parallels tools installation exited $code, attempting" \
          "to output /var/log/parallels-tools-install.log"; \
          cat /var/log/parallels-tools-install.log; \
          exit $code);

    if [ $(uname -r | cut -c1) -eq 5 ]
    then
      umount /tmp/parallels_ro;
      rm -rf /tmp/parallels_ro;
      rm -rf /tmp/parallels;
    else
      umount /tmp/parallels;
      rm -rf /tmp/parallels;
    fi

    rm -f $HOME_DIR/*.iso;

    # Parallels Tools for Linux includes native auto-mount script,
    # which causes losing some of Vagrant-relative shared folders.
    # So, we should disable this behavior.
    # https://github.com/Parallels/vagrant-parallels/issues/325#issuecomment-418727113
    auto_mount_script='/usr/bin/prlfsmountd'
    if [ -f "${auto_mount_script}" ]; then
        echo -e '#!/bin/sh\n'\
        '# Shared folders auto-mount is disabled by Vagrant ' \
        > "${auto_mount_script}"
    fi
    ;;
esac

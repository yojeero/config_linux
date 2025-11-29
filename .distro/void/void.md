# anon, root
# voidlinux

void-installer

# -------------------------------------------------
# Void Linux system is using Musl or Glibc
# --------------------------------------------------
bash
ldd --version

# If the package is listed, it's likely you're running a Musl-based system. 
bash
xbps-query -Rs musl

# -------------------------------------------------
# Install Visual Studio Code on Void Linux
# --------------------------------------------------
wget https://update.code.visualstudio.com/latest/linux-x64/stable -O vscode.tar.gz
tar -xzf vscode.tar.gz
sudo mv VSCode-linux-x64 /opt/vscode
sudo ln -s /opt/vscode/bin/code /usr/local/bin/code

code

# Install Node.js and npm on Void Linux
sudo xbps-install -S nvm
nvm install --lts
nvm use --lts
npm install -g pnpm serve vite

# -------------------------------------------------
# XBPS
# --------------------------------------------------

xbps-install -Syu - update all packages on the system
xbps-remove -Oo - clean out the cache directory and remove unnecessary packages
xbps-query -R - show information about the package available in the repositories
xbps-query -Rf — provide a list of package files available in the repositories
xbps-query -Ro /bin/ls - Find packages that own the /bin/ls file in the repositories
xbps-query -Rs - search for packages in repositories that match the pattern using pkgver and short_desc objects
xbps-pkgdb -m manual - make the package persistent (will not be recognized as an orphan)
xbps-remove -R - remove the package and all unnecessary dependencies that were installed

### Adding repositories via the command line

xbps-query --repository=<url> ...
xbps-install --repository=<url> ...

### Search for files and packages

xbps-query -Rs - search for packages in repositories
xbps-query -s - search for installed packages
xbps-query -f - files provided by the package
xbps-query -l | awk '{ print }' | xargs -n1 xbps-uhelper getpkgname - get a list of all installed packages, without indicating their version
xbps-query -l - query a list of installed packages
xbps-query -L - see repository URLs during synchronization
xbps-query -m - list installed packages that were installed manually
xbps-query -H - list of blocked packages
xbps-query -O - list orphan packages
xbps-query pkgname — package information
xbps-query -f - show a list of package files
xbps-query -x - show required dependencies
xbps-query -X - show required inverse dependencies
xbps-query -o - packages matching the file with the specified template(s) (ownedby mode)

### xbps-install - installing and updating packages

xbps-install -S - synchronize repositories with the mirror
xbps-install -Su - system update
xbps-install -u - update all packages
xbps-install -u package - update a specific package
xbps-install package - package installation
xbps-install package1 package2 package3 - install multiple packages

### xbps-remove - removing packages

xbps-remove - remove a package
xbps-remove -R - remove package with dependencies
xbps-remove -o - orphan packages
xbps-remove -O - clear cache

### xbps-reconfigure — configuration package
xbps-reconfigure [-f] <package name> — configuration package
-a - configure all packages
-f - force setting

### xbps-pkgdb - checks for errors in packages and pkgdb

The xbps-pkgdb utility can be used to check for errors in packages and the package database. It is also used to update the format of the package database (if there have been changes to it). It works exactly like xbps-reconfigure and expects a package name or -a, --all for all packages.

xbps-pkgdb -u - update pkgdb format to the latest version
xbps-pkgdb -a - check for errors in installed packages and in pkgdb
xbps-pkgdb <package> | -a —
xbps-pkgdb -m hold <package> - lock the package version during system update
xbps-pkgdb -m unhold <package> - remove the lock
xbps-pkgdb -m repolock <package> - repolock a package
xbps-pkgdb -m repounlock <package> - remove re-lock
xbps-pkgdb -m auto <package> - put the package in auto mode (install as a dependency)
xbps-pkgdb -m manual <package> - put the package into manual mode (will not be detected as lost)

Xbps components

xbps-create - XBPS utility for creating binary packages
xbps-dgraph - XBPS utility for creating scatter plots
xbps-install - XBPS utility for installing and updating packages
xbps-pkgdb - XBPS utility for reporting and fixing problems with pkgdb
xbps-query - XBPS utility for querying package and repository information
xbps-reconfigure - XBPS utility for configuring installed packages
xbps-remove - XBPS utility for removing packages
xbps-rindex - XBPS utility for processing local binary package repositories

# -------------------------------------------------
# Install packages from sources
# --------------------------------------------------
One of the reasons for choosing this distribution was the ability to build from source, like in Arch & Gentoo, but my packages did not want to be built. While I was editing, I found something wrong and xbps-src started working - in the downloaded folder there is a file README.md, which contains the requirements (Requirements), this process is described in more detail. The build process started after installing the “curl” package.

The xbps-src tool itself is a Bash shell script that allows you to build packages from the Void repository on GitHub into binaries that you can install using XBPS. You will mainly use it to install packages that are not available in the official Void repositories. First of all, make sure you have git. If not, run this command in a terminal. According to the remark above, I’ll also add curl here

doas xbps-install -S git curl
Then you will need to clone the Void package repository from GitHub

git clone https://github.com/void-linux/void-packages.git
This will create a void-packages directory with a source tree of all the Void packages in srcpkgs.

Then go to the created directory and install the binary loader needed to build binary packages in isolation.

cd void-packages
./xbps-src binary-bootstrap

#enable restricted packages
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf

#start the operation
./xbps-src pkg name-package
The process described above places the built binary package into a directory. The assembled package is also installed via XBPS

#Here are the binary files
/home/user/void-packages/hostdir/binpkgs
/home/user/void-packages/hostdir/binpkgs/nonfree

#Installation
sudo xbps-install --repository=hostdir/binpkgs package-name
sudo xbps-install --repository=hostdir/binpkgs/nonfree package-name

#Search for this target package via xbps-query
xbps-query -Rs pkg_name


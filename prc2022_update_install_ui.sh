#!/bin/sh
echo ""
echo "Updating APT and installing curl..."
apt update && apt install curl -y
echo ""

echo "stopping node.js if running..."
killall -9 node*
echo ""

echo "Installing NPM (Node Package Manager) if not already installed..."
apt install npm -y
echo ""

echo "NodeJS version if installed (or to be updated)..."
node -v
echo ""

#echo "Forcing system to recognize npm/curl changes via unseen terminal command"
#echo "This avoids having to restart the terminal rendering this process moot"
#. ~/.profile
#echo ""

echo "Clear NPM Cache..."
npm cache clean -f
echo ""

echo "Installing yarn package manager..."
npm install -g yarn
echo ""

echo "Installing Node's version manager 'n'..."
npm install -g n
echo ""

echo "Installing most recent stable node.js release..."
n latest
echo ""

echo "Pruning previous versions of nodeJS installed by 'n'..."
n prune
echo ""

echo "stopping node.js if running..."
killall -9 node*
echo ""

echo "removing old files"
rm -R UI
echo ""

echo "cloning git repositories for Qortal UI"
git clone https://github.com/qortal/UI
echo ""

cd UI
cd qortal-ui

echo "installing dependencies and linking with yarn link for build process"
yarn install
echo ""

cd ../qortal-ui-core

yarn install
# Break any previous links
yarn unlink
yarn link
echo ""

cd ../qortal-ui-crypto

yarn install
# Break any previous links
yarn unlink
yarn link
echo ""

cd ../qortal-ui-plugins

yarn install
# Break any previous links
yarn unlink
yarn link
echo ""

cd ../qortal-ui

yarn link qortal-ui-core
echo ""
yarn link qortal-ui-crypto
echo ""
yarn link qortal-ui-plugins
echo ""

echo "starting build process...this may take a while...please be patient!"
yarn run build
echo ""

echo "BUILD COMPLETE! You can now make use of the new UI!"

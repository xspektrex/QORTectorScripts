#!/bin/sh
echo "stopping node.js if running"
killall -9 node
echo ""

cd UI
cd qortal-ui
echo "Removing previous package links..."
yarn unlink qortal-ui-core
yarn unlink qortal-ui-crypto
yarn unlink qortal-ui-plugins
echo ""

echo "Removing previous individual links..."
cd ../qortal-ui-core
# Break any previous links
yarn unlink

cd ../qortal-ui-crypto
# Break any previous links
yarn unlink

cd ../qortal-ui-plugins
# Break any previous links
yarn unlink
echo ""
#cd ../qortal-ui
#echo "Removing qortal-ui-core package..."
#yarn remove qortal-ui-core
#echo ""

#echo "Removing qortal-ui-crypto package..."
#yarn remove qortal-ui-crypto
#echo ""

#echo "Removing qortal-ui-plugins package..."
#yarn remove qortal-ui-plugins
#echo ""

echo "Removing Yarn..."
npm uninstall -g yarn
echo ""

echo "Removing Node's package manager 'n'..."
npm uninstall -g n
echo ""

echo "Removing NPM and node.JS ..."
npm uninstall -g npm

echo "Removing Curl..."
apt remove curl
echo ""

echo "Cleaning up APT..."
apt autoremove
apt purge
echo ""

cd ../..
echo "Removing UI folder..."
rm -R UI
echo ""

echo "UI has now been uninstalled, Goodbye!"

cd /tmp || exit 1

rm -rf hyperion

git clone https://github.com/SDL-Hercules-390/hyperion.git

cd hyperion || exit 1

./configure

make -j"$(nproc)"

checkinstall -y 
--install=no 
--pkgname=hyperion 
--pkgversion="4.9.1" 
--pkgrelease="1" 
--backup=no 
--deldoc=yes 
--fstrans=no 
--default


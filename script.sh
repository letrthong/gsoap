ROOT=$PWD
mkdir -p genarate
cd    genarate
echo "The wsdl2h WSDL/schema converter and data binding tool."
wsdl2h -s -o calc.h  ../wsdl/calc.wsdl.xml

echo "The soapcpp2 stub/skeleton compiler and code generator."
mkdir -p client
cd client

echo "The soapcpp2 for client"
soapcpp2 -j -CL -I/path/to/gsoap/import ../calc.h

cd ../
mkdir -p server
cd server
echo "The soapcpp2 for Server"
soapcpp2 -j -SL -I/path/to/gsoap/import ../calc.h

echo $ROOT
cd $ROOT

echo ""
echo "compile code for Client"
g++ -FLAGS -o client -I ./genarate/client/   ./src/calcclient.cpp    ./genarate/client/soapC.cpp  ./genarate/client/soapcalcProxy.cpp -L ./lib -lgsoap++

echo ""
echo "compile code for Server"
g++ -FLAGS -o server -I ./genarate/server/   ./src/calcserver.cpp    ./genarate/server/soapC.cpp  ./genarate/server/soapcalcService.cpp -L ./lib -lgsoap++

ls 

echo ""
echo "Testing the library"

killall -9 server
echo "Starting server at port 8080"
./server 8080  &

echo ""
echo "Test sum 2 + 5"
./client add 2 5

echo ""
echo "Test Mul 2*5"
./client mul 2 5


echo "\nclean up"
rm -rf ./genarate
#rm server client



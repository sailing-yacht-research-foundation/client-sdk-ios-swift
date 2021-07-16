green="\033[1;32m"
black="\033[1;30m"

echo "$green"
echo "Please make sure Jazzy is installed https://github.com/realm/jazzy"

echo "\n\rGenerating Location docs"
echo "$black"

jazzy -m SYRFLocation -x -workspace,SYRFClient.xcworkspace,-scheme,SYRFLocation
rm -r ./SYRFLocation/docs
mv ./docs ./SYRFLocation

echo "$green"
echo "\n\rGenerating Geospatial docs"
echo "$black"

jazzy -m SYRFGeospatial -x -workspace,SYRFClient.xcworkspace,-scheme,SYRFGeospatial
rm -r ./SYRFGeospatial/docs
mv ./docs ./SYRFGeospatial

echo "$green"
echo "\n\rGenerating Time docs"
echo "$black"

jazzy -m  SYRFTime -x -workspace,SYRFClient.xcworkspace,-scheme,SYRFTime
rm -r ./SYRFTime/docs
mv ./docs ./SYRFTime
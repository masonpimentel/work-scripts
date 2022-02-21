cp -rfp ../ ~/Scripts
echo "1. Terminal initialization file? (pre-Catalina Mac this was /Users/<username>/.bash_profile, after it became /Users/<username>/.zshrc)"
read termInit
cat scriptsMaintenance/recPath | tail -n +3 > $termInit
echo "2. Mac username (path of user root, ex. /Users/mason.pimentel - enter mason.pimentel)"
read username
sed -i '' "s/pathgoeshere/$username/" workflow/l

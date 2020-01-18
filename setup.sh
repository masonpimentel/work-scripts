# 1. add recPath to shell initialization
# 2. 

echo "1. Terminal initialization file? (pre-Catalina Mac this was /Users/<username>/.bash_profile, after it became /Users/<username>/.zshrc)"
read termInit
cat scriptsMaintenance/recPath | tail -n +3 > $termInit
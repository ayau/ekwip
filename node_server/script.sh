pkill -f node;
git pull;
cake build;
nohup cake run > server.log 2>&1 &

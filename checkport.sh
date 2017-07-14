lsof -n -iTCP:$1 | grep LISTEN

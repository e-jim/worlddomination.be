.PHONY: deploy

all: _check_dependancies
	hyde/ve/bin/hyde -g

run: _check_dependancies
	(sleep 1.5 && firefox localhost:8080) &
	hyde/ve/bin/hyde -w || (hyde/ve/bin/pip install -r hyde/requirements.txt && hyde/ve/bin/hyde -w)

deploy:
	which git-up > /dev/null || (sudo pip install git-up)
	git up
	cd hyde && git up
	git add . -A
	git commit -am "update"
	make all
	rsync -r deploy/* root@worlddomination.be:/var/www/my_webapp
	git push

rsync:
	rsync -r deploy/* bram@worlddomination.be:www/

loop: _check_dependancies
	(sleep 2 && firefox localhost:8080) &
	hyde/ve/bin/hyde -g -k -w || (hyde/ve/bin/pip install -r hyde/requirements.txt && hyde/ve/bin/hyde -g -k -w)

push:
	git up
	git add .
	git commit -am "update"
	git push

_check_dependancies:
	[ -e "hyde" ] || (git clone git@github.com:Psycojoker/hyde.git && cd hyde/ && virtualenv ve && ve/bin/pip install -r requirements.txt && ve/bin/python setup.py develop)

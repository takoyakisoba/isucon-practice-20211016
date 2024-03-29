.PHONY: gogo build stop-services start-services truncate-logs bench kataribe

gogo: stop-services build truncate-logs start-services bench

build:
	make -C go build -o isucholar

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isucholar.go.service
	ssh db sudo systemctl stop mysql

start-services:
	ssh db sudo systemctl start mysql
	sudo systemctl start isucholar.go.service
	sudo systemctl start nginx

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	ssh db sudo truncate --size 0 /var/log/mysql/mysql-slow.log

kataribe:
	sudo cat /var/log/nginx/access.log | ./kataribe

bench:
	sudo -u ubuntu ssh bench "sudo /home/isucon/benchmarker/bin/benchmarker -target 52.69.9.115 -tls"

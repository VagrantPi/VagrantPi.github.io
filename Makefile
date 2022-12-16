REPO_NAME=VagrantPi/VagrantPi.github.io

# all: build

docker_build:
	docker build -t vagrantpi/jekyll-builder:latest .
  
build:
	jekyll build
	cp -rf _site/tags/* tags/

docker_run_env:
	docker run -it -d --name VagrantPi.github.io -v /Users/kais/WS/mine/VagrantPi.github.io:/tmp -p 4000:4000 vagrantpi/jekyll-builder:latest 
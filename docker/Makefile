build: Dockerfile
	docker build -t appliedsnar:latest .

run:
	docker run --rm -i appliedsnar:latest

push:
	docker tag appliedsnar:latest gvegayon/appliedsnar:latest
	docker push gvegayon/appliedsnar:latest

# Run the container mapping the current folder to /appliedsnar
# and run the container in interactive mode
dev:
	docker run --rm -it -v $(PWD)/..:/appliedsnar appliedsnar:latest
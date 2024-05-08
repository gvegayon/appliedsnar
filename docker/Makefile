build: Dockerfile
	docker build -t appliedsnar:latest .

run:
	docker run --rm -i appliedsnar:latest

push:
	docker tag appliedsnar:latest gvegayon/appliedsnar:latest
	docker push gvegayon/appliedsnar:latest

# Run the container mapping the current folder to /appliedsnar
# and run the container in interactive mode. Also, expose the localhost
# port 8787 to the container port 8787.
dev:
	docker run --rm -it \
		-p 8787:8787 \
		-v $(PWD)/..:/appliedsnar appliedsnar:latest
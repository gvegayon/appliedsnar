build: Dockerfile
	docker build -t appliedsnar:latest .

run:
	docker run --rm -i appliedsnar:latest

push:
	docker tag appliedsnar:latest gvegayon/appliedsnar:latest
	docker push gvegayon/appliedsnar:latest
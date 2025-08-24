ifndef CNTBUILDER
  CNTBUILDER=podman
endif

build: Containerfile
	$(CNTBUILDER) build -t appliedsnar:latest .

run:
	$(CNTBUILDER) run --rm -i appliedsnar:latest

push:
	$(CNTBUILDER) tag appliedsnar:latest gvegayon/appliedsnar:latest && \
	$(CNTBUILDER) push gvegayon/appliedsnar:latest

# Run the container mapping the current folder to /appliedsnar
# and run the container in interactive mode. Also, expose the localhost
# port 8787 to the container port 8787.
dev:
	$(CNTBUILDER) run --rm -it \
		-p 8787:8787 \
		-v $(PWD)/..:/appliedsnar appliedsnar:latest
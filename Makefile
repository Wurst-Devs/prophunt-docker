build:
	docker build -t prophunt .

launch: build
	docker run -d \
		-p 27015:27015/udp \
		--mount type=bind,source="$(CURDIR)/server.cfg",target=/gmodds/garrysmod/cfg/server.cfg,readonly \
		--mount type=bind,source="$(CURDIR)/maps",target=/gmodds/garrysmod/maps \
		--name prophunt \
		prophunt
	docker logs -f prophunt

stop:
	docker kill prophunt
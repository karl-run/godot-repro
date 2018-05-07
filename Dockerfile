FROM karlrun/godot-docker:latest

MAINTAINER Karl J. Overå <karl@karl.run>

RUN mkdir ~/repro \
    && git clone https://github.com/karl-run/godot-repro.git ~/repro

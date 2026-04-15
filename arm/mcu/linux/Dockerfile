FROM --platform=linux/arm/v7 alpine
# RUN apk add tmux
# RUN apk add gdb
# make to be able to run amforth make targets
RUN apk add make
# need cpp to be able to preprocess cpp-core.frt test suite
RUN apk add gcc
RUN ln -s /amforth/arm/mcu/linux/build/amforth.elf /usr/local/bin/amforth

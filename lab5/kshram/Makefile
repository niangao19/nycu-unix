
obj-m     += kshram.o
ccflags-y += -DEXPORT_SYMTAB

 
all: check_fork check_msg check_resize
	make -C ../dist/modulebuild M=$(PWD) modules

check_fork: check_fork.c
	$(CROSS_COMPILE)gcc -o $@ $< -Wall -static

check_msg: check_msg.c
	$(CROSS_COMPILE)gcc -o $@ $< -Wall -static

check_resize: check_resize.c
	$(CROSS_COMPILE)gcc -o $@ $< -Wall -static

clean:
	make -C ../dist/modulebuild M=$(PWD) clean
	rm check_resize
	rm check_msg
	rm check_fork
install: all
	mkdir -p ../rootfs/modules
	cp kshram.ko check_fork check_msg check_resize ../rootfs/modules

#include <stdio.h>
#include <stdint.h>

typedef int (*printf_ptr_t)(const char *format, ...);



void solver(printf_ptr_t fptr) {
	char ptr[8] = {'\0'};
	
	// ptr array
	//fptr("&ptr+%x: %p, val = %llx\n", 0x0, ptr, *(uint64_t *)ptr);
	// canary 
	fptr("canary -> &ptr+%x: %p, val = %llx\n", 0x08, ptr+0x08, *(uint64_t *)(ptr+0x08));
	// rbp
	fptr("rbp -> &ptr+%x: %p, val = %llx\n", 0x10, ptr+0x10, *(uint64_t *)(ptr+0x10));
	// return address
	fptr("ra -> &ptr+%x: %p, val = %llx\n", 0x18, ptr+0x18, *(uint64_t *)(ptr+0x18));

}

int main() {
	char fmt[16] = "** main = %p\n";
	printf(fmt, main);
	solver(printf);
	return 0;
}

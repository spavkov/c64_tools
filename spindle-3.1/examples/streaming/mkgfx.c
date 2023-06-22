#include <err.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

uint8_t vm[1000], d800[1000];

int main(int argc, char **argv) {
	uint16_t addr;
	FILE *f;
	int x, y;

	if(argc != 3) {
		errx(1, "Usage: %s file address", argv[0]);
	}
	addr = strtol(argv[2], 0, 16);

	f = fopen(argv[1], "rb");
	if(!f) {
		err(1, "%s", argv[1]);
	}

	fseek(f, 2, SEEK_SET);
	fread(vm, 1, 1000, f);
	fseek(f, 0x402, SEEK_SET);
	fread(d800, 1, 1000, f);

	fclose(f);

	fputc(addr & 0xff, stdout);
	fputc(addr >> 8, stdout);

	for(x = 0; x < 40; x++) {
		for(y = 0; y < 25; y++) {
			fputc(vm[y * 40 + x], stdout);
			fputc(d800[y * 40 + x], stdout);
		}
	}

	return 0;
}

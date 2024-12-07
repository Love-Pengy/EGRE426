#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ADDR_SIZE 20

int blockSize = 0;
int blockAmt = 0;
int associativity = 0;
char inputFileName[1024] = "";

// tag index offset
struct address {
  uint32_t fullAddress;
  uint32_t tag;
  uint32_t index;
  uint32_t offset;
};

int hexMapping(char input) {
  switch (tolower(input)) {
  case 'a':
    return (10);
  case 'b':
    return (11);
  case 'c':
    return (12);
  case 'd':
    return (13);
  case 'e':
    return (14);
  case 'f':
    return (15);
  default:
    return (input - 48);
  }
}

int calcOffsetBits(void) { return ((int)(log2((double)blockSize))); }

int calcIndexBits(void) { return ((int)(log2((double)blockAmt))); }

void calcAddress(struct address *addr) {

  int numOffsetBits = calcOffsetBits();
  int numIndexBits = calcIndexBits();
  printf("offset: %d, index: %d\n", numOffsetBits, numIndexBits);
  uint32_t tmpAddress = addr->fullAddress;
  int mask = 0;

  for (int i = 0; i < numOffsetBits; i++) {
    mask |= (1 << i);
  }
  addr->offset = (tmpAddress)&mask;
  tmpAddress >>= numOffsetBits;

  mask = 0;
  for (int i = 0; i < numIndexBits; i++) {
    mask |= (1 << i);
  }
  addr->index = (tmpAddress)&mask;
  tmpAddress >>= numIndexBits;

  addr->tag = tmpAddress;
}

void calcHitMiss(int *hit, int *miss, FILE *fptr) {
  struct address currAddr;
  currAddr.fullAddress = 0;
  unsigned char currHex = 0;
  int *cache = malloc(sizeof(int) * MAX_ADDR_SIZE);
  uint8_t specifier = 0b00;
  bool active = false;
  char buffer[5] = "";
  int i = 0;
  while (!feof(fptr)) {
    currAddr.tag = 0;
    currAddr.index = 0;
    currAddr.offset = 0;
    i = 0;
    memset(buffer, '\0', 5);
    while (!isspace(currHex = fgetc(fptr)) && !feof(fptr)) {
      if (!(specifier == 0b10)) {
        specifier += 0b1;
        continue;
      }
      active = true;
      buffer[i] = currHex; 
      i++;
      //currAddr.fullAddress |= hexMapping(currHex);
    }
    if(active){
      for(int i = 0; i < strlen(buffer); i++){
        currAddr.fullAddress |= (hexMapping(buffer[i]) << (((strlen(buffer)-1) - i) * 4)); 
      }
      calcAddress(&currAddr);
      printf("%d\n", currAddr.tag);
    }
    memset(&currAddr, 0, sizeof(struct address));
    specifier = 0b00; 
    active = false;
  }
  free(cache);
}

void throwCmdLineError(char *error) {
  fprintf(stderr, "ERROR: %s\n", error);
  exit(EXIT_FAILURE);
}

bool startsWithHyphen(char *input) {
  if (input[0] == '-') {
    return (true);
  }
  return (false);
}

void cmdLineParser(char **input) {
  int arrayLength = -1;
  bool fileSpecified = false;

  while (input[++arrayLength] != NULL) {
  }

  for (int i = 1; i < arrayLength; i++) {
    if (strcmp(input[i], "-help") == 0) {
      printf("Usage: cache [options] address_file\n");
      printf("\n where options include:\n");
      printf("    -help  display this usage message\n");
      printf("    -assoc <val>  specifies associativity where val is te amount "
             "of ways\n");
      printf("    -blocksize <val>  specifies block size \n");
      printf("    -blockAmt <val>  specifies amount of blocks\n");

      exit(EXIT_SUCCESS);
    } else if (strcmp(input[i], "-assoc") == 0) {
      i++;
      if (((i) < arrayLength) && !startsWithHyphen(input[i])) {
        associativity = atoi(input[i]);
      }
      // case for when there are no moreleft
      else {
        throwCmdLineError("Associativity Input Value Not Specified");
      }
    } else if (strcmp(input[i], "-blocksize") == 0) {
      i++;
      if ((i < arrayLength) && !startsWithHyphen(input[i])) {
        blockSize = atoi(input[i]);
      }
      // case for when there are no more left
      else {
        throwCmdLineError("Block Size Val Not Specified");
      }
    } else if (strcmp(input[i], "-blockamt") == 0) {
      i++;
      if ((i < arrayLength) && !startsWithHyphen(input[i])) {
        blockAmt = atoi(input[i]);
      }
    } else {
      if (fileSpecified) {
        throwCmdLineError("Multiple Files Specified");
      } else {
        strncpy(inputFileName, input[i], strlen(input[i]));
        fileSpecified = true;
      }
    }
  }
  if (!fileSpecified) {
    throwCmdLineError("File Not Specified");
  }
}

int main(int argc, char **argv) {

  cmdLineParser(argv);

  FILE *fptr = fopen(inputFileName, "r");
  if (fptr == NULL) {
    printf("%s\n", strerror(errno));
    exit(EXIT_FAILURE);
  }

  int *hit = malloc(sizeof(int));
  int *miss = malloc(sizeof(int));
  calcHitMiss(hit, miss, fptr);

  return (0);
}

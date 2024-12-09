#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_ADDR_SIZE 20

int blockSize = 0;
int blockAmt = 0;
int associativity = 0;
char inputFileName[1024] = "";
bool verbose = 0;

typedef enum { DIRECT, RANDOM, LRU } rPolicy;

rPolicy replacementPolicy = DIRECT;

typedef struct {
  int32_t tag;
  int use;
  int val;
} cacheTag;

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

void printCache(cacheTag **cache) {

  // print cache
  /*switch (replacementPolicy) {*/
  /*case (LRU):*/
  for (int i = 0; i < associativity; i++) {
    printf("%d: { ", i);
    for (int j = 0; j < pow(2, calcIndexBits()); j++) {
      printf("%d ", cache[i][j].val);
    }
    printf("}\n");
  }
}

void calcHitMiss(int *hit, int *miss, FILE *fptr) {
  int hitVal = 0;
  bool replaced = false;
  int missVal = 0;
  struct address currAddr;
  currAddr.fullAddress = 0;
  unsigned char currHex = 0;

  uint8_t specifier = 0b00;
  bool active = false;
  char buffer[5] = "";
  bool currHit = false;
  int i = 0;

  // ====== filler ============
  cacheTag **cacheArr = malloc(sizeof(cacheTag *) * associativity);
  if (replacementPolicy == LRU) {
    for (int i = 0; i < associativity; i++) {
      cacheArr[i] = malloc(sizeof(cacheTag) * ((int)pow(2, calcIndexBits())));
      for (int j = 0; j < (int)pow(2, calcIndexBits()); j++) {
        cacheArr[i][j].tag = -100;
        cacheArr[i][j].use = -1;
        cacheArr[i][j].val = 0;
      }
    }
  } else {
    for (int i = 0; i < associativity; i++) {
      cacheArr[i] = malloc(sizeof(cacheTag) * ((int)pow(2, calcIndexBits())));
      for (int j = 0; j < (int)pow(2, calcIndexBits()); j++) {
        cacheArr[i][j].tag = -100;
        cacheArr[i][j].val = 0;
      }
    }
  }
  //===========================

  //--------------------------------------------------------------------
  // Filler To Test Cache
  /*for (int i = 0; i < associativity; i++) {*/
  /*  cacheArr[i] = malloc(sizeof(int) * ((int)pow(2, calcIndexBits())));*/
  /*  for (int j = 0; j < (int)pow(2, calcIndexBits()); j++) {*/
  /*    if ((j % 2) == 0) {*/
  /*      cacheArr[i][j] = 0x111;*/
  /*    } else {*/
  /*      cacheArr[i][j] = 0x1111;*/
  /*    }*/
  /*  }*/
  /*}*/
  //-------------------------------------------------------------------

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
      // currAddr.fullAddress |= hexMapping(currHex);
    }
    if (active) {
      for (int i = 0; i < strlen(buffer); i++) {
        currAddr.fullAddress |=
            (hexMapping(buffer[i]) << (((strlen(buffer) - 1) - i) * 4));
      }
      calcAddress(&currAddr);
      // check for hit
      for (int i = 0; i < associativity; i++) {
        if (cacheArr[i][currAddr.index].tag == currAddr.tag) {
          currHit = true;
        }
      }
      // replace functionality
      if (!currHit) {
        switch (replacementPolicy) {
        case (DIRECT):
          cacheArr[0][currAddr.index].tag = currAddr.tag;
          cacheArr[0][currAddr.index].val = currAddr.fullAddress;
          break;
        case (RANDOM):
          cacheArr[rand() % associativity][currAddr.index].tag = currAddr.tag;
          cacheArr[rand() % associativity][currAddr.index].val =
              currAddr.fullAddress;
          break;
        case (LRU):
          replaced = false;
          for (int i = 0; i < associativity; i++) {
            if (cacheArr[i][currAddr.index].use == -1) {
              cacheArr[i][currAddr.index].tag = currAddr.tag;
              cacheArr[i][currAddr.index].val = currAddr.fullAddress;
              cacheArr[i][currAddr.index].use = associativity;
              for (int j = 0; j < associativity; j++) {
                if (cacheArr[j][currAddr.index].use != -1) {
                  cacheArr[j][currAddr.index].use--;
                }
              }
              replaced = true;
              break;
            }
          }
          if (!replaced) {
            for (int i = 0; i < associativity; i++) {
              if (cacheArr[i][currAddr.index].use == 0) {
                cacheArr[i][currAddr.index].tag = currAddr.tag;
                cacheArr[i][currAddr.index].val = currAddr.fullAddress;
                cacheArr[i][currAddr.index].use = associativity;
              } else {
                cacheArr[i][currAddr.index].use--;
              }
            }
          }
        }
      }
      currHit ? hitVal++ : missVal++;
      currHit = false;
      memset(&currAddr, 0, sizeof(struct address));
      specifier = 0b00;
      active = false;
    }
    *hit = hitVal;
    *miss = missVal;
  }
  if (verbose) {
    printCache(cacheArr);
  }
  for (int i = 0; i < associativity; i++) {
    free(cacheArr[i]);
  }
  free(cacheArr);
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
      printf("    -v <val>  0 -> don't print cache\n");
      printf("              1 -> print cache\n");
      printf("    -blockamt <val>  specifies amount of blocks\n");
      printf("    -policy <val>  0 -> direct\n");
      printf("                   1 -> random\n");
      printf("                   2 -> LRU\n");
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
    } else if (strcmp(input[i], "-policy") == 0) {
      i++;
      if ((i < arrayLength) && !startsWithHyphen(input[i])) {
        replacementPolicy = atoi(input[i]);
      }
    } else if (strcmp(input[i], "-v") == 0) {
      i++;
      if ((i < arrayLength) && !startsWithHyphen(input[i])) {
        verbose = atoi(input[i]);
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
  srand(time(NULL));
  cmdLineParser(argv);

  FILE *fptr = fopen(inputFileName, "r");
  if (fptr == NULL) {
    printf("%s\n", strerror(errno));
    exit(EXIT_FAILURE);
  }

  int *hit = malloc(sizeof(int));
  int *miss = malloc(sizeof(int));
  *hit = 0;
  *miss = 0;
  calcHitMiss(hit, miss, fptr);
  printf("hit: %d, miss: %d\n", *hit, *miss);
  printf("hit rate: %.2f%%\n", ((double)(*hit / (double)(*miss + *hit))) * 100);
  printf("miss rate: %.2f%%\n",
         ((double)(*miss / (double)(*hit + *miss))) * 100);
  free(hit);
  free(miss);
  fclose(fptr);
  return (0);
}

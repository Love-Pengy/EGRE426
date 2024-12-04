#include "globals.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
        associtivity = atoi(input[i]);
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
        inputFileName = input[i];
        fileSpecified = true;
      }
    }
  }
  if (!fileSpecified) {
    throwCmdLineError("File Not Specified");
  }
}

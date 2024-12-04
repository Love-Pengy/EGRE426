#include <stdbool.h>
#include "globals.h" 
#include "cmdLineReader.h"
#include <stdio.h>

int main(int argc, char** argv){
  cmdLineParser(argv); 
  printf("OUTPUT: %d, %d, %d, %s\n", associtivity, blockSize, blockAmt, inputFileName);     
  return(0);
}


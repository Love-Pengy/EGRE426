#include <stdio.h>
#define inArrSize 3

int main(void) {
  int inArr[4];
  inArr[0] = 1;
  inArr[1] = 2;
  inArr[2] = 3;
  inArr[3] = 4;
  
  int outArr[4] = {0};
  for (int i = 3; i > -1; i--) {
    outArr[inArrSize - i] = inArr[i];
    printf("%d | %d\n", outArr[inArrSize -i], inArrSize-i);
  }

  for(int i = 0; i < 4; i++){
    printf("%d\n", outArr[i]);
  }
}

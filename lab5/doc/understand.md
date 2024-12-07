# Command Line Args

+ Block Size 
+ Number Of Blocks In Cache
+ Associatvity 
    + 1 for direct 
    + 2 for two way set associative 
    + etc
+ **EC**
    + Implement both random and LRU policies when appropriate

# Works

+ Given series of byte addresses from text file one address per line
+ Compute hit or miss rate given args and  

## Direct Mapping
    + You have a tag and a block
    + 
# Notes

+ know if its present in cache/memory 
    + this is a hit
 
+ associativity 
    + one way 
        + not split
    + two way 
        + split into two caches 
        + if its 256 bit cache split evenly to 128 and 128 
    + address is tag index and offset
        + slide 18 for addressing 
    + tag is the remainder of the bits  
    + tag msb then index then offset

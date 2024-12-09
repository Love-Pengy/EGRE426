generate: 
		gcc cache.c -Wall -lm -g -o cache
		mkdir -p bin
		mv cache bin/

runA: 
		./bin/cache -assoc 1 -blocksize 1 -blockamt 16 -policy 0 -v 1 ./tests/aTest 

memrunA: 
		valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./bin/cache -assoc 1 -blocksize 1 -blockamt 16 -policy 0 -v 1 ./tests/aTest 

runB: 
		./bin/cache -assoc 2 -blocksize 1 -blockamt 8 -policy 2 -v 1 ./tests/bTest 

memrunB: 
		valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./bin/cache -assoc 2 -blocksize 1 -blockamt 8 -policy 2 -v 1 ./tests/bTest 

run2Small: 
		./bin/cache -assoc 1 -blocksize 16 -blockamt 256 -policy 0 -v 0 ./tests/addresses.txt 
		
memrun2Small: 
		valgrind --leak-check=full --show-leak-kinds=all ./bin/cache -assoc 1 -blocksize 16 -blockamt 256 -policy 0 -v 0 ./tests/addresses.txt 

run2Large: 
		./bin/cache -assoc 1 -blocksize 256 -blockamt 256 -policy 0 -v 0 ./tests/addresses.txt 

memrun2Large: 
		valgrind --leak-check=full --show-leak-kinds=all ./bin/cache -assoc 1 -blocksize 256 -blockamt 256 -policy 0 -v 0 ./tests/addresses.txt 

testA: 
	gcc cache.c -Wall -lm -g -o cache
	mkdir -p bin
	mv cache bin/
	gdb --args ./bin/cache -assoc 1 -blocksize 1 -blockamt 16 -policy 0 -v 1 ./tests/aTest 

testB: 
	gcc cache.c -Wall -lm -g -o cache
	mkdir -p bin
	mv cache bin/
	gdb --args ./bin/cache -assoc 2 -blocksize 1 -blockamt 16 -policy 2 -v 1 ./tests/bTest 

	

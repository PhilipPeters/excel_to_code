libexamplespreadsheet.dylib: examplespreadsheet.o
	gcc -shared -o libexamplespreadsheet.dylib examplespreadsheet.o

examplespreadsheet.o:
	gcc -fPIC -c examplespreadsheet.c

clean:
	rm examplespreadsheet.o
	rm libexamplespreadsheet.dylib

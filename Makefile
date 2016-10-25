.PHONY: clean build

clean:
	rm -f extensions/*.cpp extensions/*.c extensions/*.h imgui/*.so

build:
	python setup.py develop

rebuild: clean build
	echo 'Done!'


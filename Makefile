.PHONY: clean

clean:
	rm -f extensions/*.cpp extensions/*.c extensions/*.h imgui/*.so

rebuild: clean
	python setup.py develop


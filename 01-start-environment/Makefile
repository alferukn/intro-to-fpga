all: run

run:
	@mkdir -p build
	@iverilog -g2012 -o build/hello_world hello_world.sv
	@vvp build/hello_world
	@rm -rf build


clean:
	@rm -rf build
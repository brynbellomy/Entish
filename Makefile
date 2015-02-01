
PRODUCT_NAME=Entish
XCTOOL=/usr/local/bin/xctool -scheme $(PRODUCT_NAME) -workspace $(PRODUCT_NAME).xcworkspace -reporter pretty

all: build

build: build/Products/Debug/$(PRODUCT_NAME).framework

test:
	$(XCTOOL) test

clean:
	rm -rf ./build
	pod clean

build/Products/Debug/$(PRODUCT_NAME).framework:
	$(XCTOOL) build

# $(XCTOOL) build -reporter json-compilation-database > ./compile_commands.json

# build/Products/Debug/$(PRODUCT_NAME).framework:
# 	$(XCTOOL) build \
# 		| NODE_PATH=/usr/local/lib/node_modules \
# 		  /usr/local/bin/node ./format-build-json.js

PRODUCT_NAME=Entish
XCTOOL=/usr/local/bin/xctool -scheme $(PRODUCT_NAME) -workspace $(PRODUCT_NAME).xcworkspace -reporter pretty

DOCS_OUTPUT_DIR=~/projects/_swift/_docs/$(PRODUCT_NAME)
GITHUB_URL=https://github.com/brynbellomy/$(PRODUCT_NAME)
PODSPEC_PATH=./$(PRODUCT_NAME).podspec
SRC_ROOT=./

all: build

docs: .FORCE-DOCS

.FORCE-DOCS:
	mkdir -p $(DOCS_OUTPUT_DIR)

	jazzy 	-o $(DOCS_OUTPUT_DIR) \
		    -a 'bryn austin bellomy' \
			-u 'https://github.com/brynbellomy' \
			-m $(PRODUCT_NAME) \
			-g $(GITHUB_URL) \
			--podspec $(PODSPEC_PATH) \
			--source-directory $(SRC_ROOT)



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
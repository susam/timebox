# Install test tools.
install_kcov:
	apt-get update
	apt-get install g++ pkg-config libcurl4-gnutls-dev libelf-dev libdw-dev zlib1g-dev
	git clone https://github.com/SimonKagstrom/kcov.git
	mkdir kcov/build
	cd kcov/build && cmake .. && make && make install

install_shells:
	apt-get update
	apt-get install ksh zsh posh yash


# Run tests.
test: .FORCE
	sh test/test

alltest: test unixtest posixtest

unixtest:
	bash test/test
	ksh test/test
	zsh test/test

posixtest:
	dash test/test
	posh test/test
	yash test/test


# Measure code coverage. 
coverage: .FORCE
	rm -rf coverage
	kcov --exclude-path=test/test coverage test/test

coveralls:
	rm -rf coverage
	kcov --coveralls-id=$$TRAVIS_JOB_ID --exclude-path=test/test coverage test/test


# Cleanup
clean:
	rm -rf coverage


# Meta
.FORCE:


# vim: noet

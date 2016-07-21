Todo Developer Notes
====================

Tests
-----
All discussion about tests in this section assume that the tests are
being run on a Debian or Debian based system. On other systems, the
commands in Makefile may need to be modified appropriately. The Linux/OS
X *timebox* script, however, can run on any POSIX conformant Unix or
Linux system with any POSIX conformant shell without any changes to the
script.

The Windows timebox.cmd script is not discussed in this document at all.
There are no tests for it.

### Setup Test Environment ###
Change the current directory to the top level directory of this project
and enter the following command as root to install kcov. It is used to
measure code coverage of the tests.

    make install_kcov

Enter the following command to install the shells required for testing
cross-shell compatibility.
	
	make install_shells

### Run Tests ###
Change current directory to the top level directory of this project and
enter the following command to run a quick test with sh.

	make test

Now enter the following command to run a complete test with sh, bash,
ksh, dash and yash.

	make alltest

Finally enter the following command to measure code coverage.

    make coverage

Open coverage/index.html with a web browser to see the code coverage
results.

### About the Tests ###
All tests for this project are present in the *test* directory relative
to the top level directory of this project.

This project does not use an external testing tool or library to run the
tests. This project comes with its own very basic and minimal test
runner which can be found at *test/test*. It is a shell script that may
be run with any POSIX conformant shell.

For example, to run the tests with bash, enter the following command.

    bash test/test

As another example, to run the tests with ksh, enter the following
command.

    ksh test/test

See *Makefile* for more details on how the tests are run.

The test runner script at *test/test* follows very simple rules to
discover and run tests.

  1. First it looks for a file *test/setup* and executes it in the same
     shell that invoked the test runner *test/test*. Any test
     initialization code should go here.
  2. Then it looks for files that match the wildcard pattern `test/test_*`
     relative to the current directory. These are considered to be test
     scripts. Therefore, the test runner must be run from the top level
     directory of the project.
  2. Each test script is executed in the same shell that invoked the
     test runner *test/test*. Thus, all functions defined in each test
     script become available in the shell that runs the test runner.
  3. Each test script is searched for functions with alphanumeric names
     that begin with `test_`. These are considered to be test functions.
  4. After all test functions have been discovered, each test function is
     executed.
  5. If a test function returns with an exit status of 0, the test is
     considered to have passed, otherwise it is considered to
     have failed.
  6. Before executing each test function, an empty directory is created
     at "$TWORK". The TWORK environment variable is set to test/work.
  7. After executing each test function, the "$TWORK" directory is
     removed automatically. Therefore, any temporary working files
     required during testing may be written to "$TWORK" by the test
     functions.

It is an error if two test functions have the same name, even if the two
functions are in different test scripts. Each test function defined
within the *test* directory must have a distinct name.

If all tests pass, the test runner prints the number of tests that
passed and exits with an exit status of 0. If one or more tests fail,
then the test runner prints the number of tests that passed followed by
the number of tests that failed and exits with an exit status of 1.

See the test runner *test/test* for more details.


Release
-------
The following tasks need to be performed for every release of a new
version. These tasks should be performed with the project's top-level
directory as the current directory.

  - Update copyright notice in LICENSE.md.
  - Update copyright notice in timebox.cmd.
  - Update copyright notice in timebox.
  - Update copyright notice in tests.
  - Update `COPYRIGHT` in timebox.cmd.
  - Update `COPYRIGHT` in timebox.
  - Update `VERSION` in timebox.cmd.
  - Update `VERSION` in timebox.
  - Update version in download URLs in README.md at two places.
  - Update CHANGES.md.
  - Run tests.

        make test
        make alltest
        make coverage
        firefox coverage/index.html &

  - Confirm that code coverage looks good.
  - Tag the release.

        git tag -a <VERSION> -m "Timebox <VERSION>"
        git push
        git push --tags

  - Upload timebox.cmd and timebox to GitHub release page.

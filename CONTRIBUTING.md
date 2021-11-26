# Contributing

Some useful things to know:
* The shell script is built with [Bashly](https://bashly.dannyb.co/). If you have `docker`, `./run` will automatically pull and use the bashly docker image. Otherwise, you should install bashly manually and ensure it's in your PATH.
* To run the local copy of `git-draft`, use the `./run` script (i.e. instead of `git draft foo`, use `./run foo`). This will automatically rebuild the script before running the command, ensuring that it picks up any code changes.
* Test your changes with `./test`. This will execute all of the scripts in the `tests/` directory and compare their output with the examples. If the output differs from what's expected, it will interactively ask whether to accept the changes or fail the test.
* Note that the tests are slightly flaky, every now and again a pipeline will run in a different order and the tests will complain that two commands are flipped. Rerunning usually makes the problem go away.
* There's a useful script in `.git-hooks/pre-commit` which will make sure you're using `git-draft` and running tests when making commits in this repo. To use it, copy it into `.git/hooks/`.

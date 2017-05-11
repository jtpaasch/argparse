# Argument parsing for Bash

Declare allowed flags/options/arguments, parse, and go.

Requirements:
* Git
* Make
* Bash


## Install it in your project

Clone the project into your own project in a reasonable place,
e.g., inside $PROJECT_ROOT/vendor/argparse.


## Usage

The general pattern of usage goes like this:
 * Import this package at the top of your script.
 * Declare all allowed flags/options/arguments you want to accept.
 * Parse the parameters provided from the command line.
 * Use the values in your script.


### Import argparse.bash

In your own script, e.g., `test.bash` source the file:

    #!/usr/bin/env bash

    . $PROJECT_ROOT/vendor/argparse/libexec/bin/argparse.bash

### Declare allowed parameters

Declare any flags/options/arguments you want your program
to allow. For instance, to have your program accept
`--verbose` and `--fail-fast` flags:

    flag__id__0="--verbose"
    flag__help__0="Display verbose output?"

    flag__id__1="--fail-fast"
    flag__help__1="Exit on first error?"

The `flag__id__X` value tells the parser what to look for
on the command line, and the `flag__help__X` value tells
the parser what to put in the auto-generated help. The
number at the ends (e.g. `0` or `1` in this case)
group them together. 

Options follow the same pattern:

    opt__id__0="--username"
    opt__help__0="A username to login with."

    opt__id__1="--output"
    opt__help__1="A file to write output to."
    opt__value__1="out.log"

Note that you can set a default for an option by setting
a value (e.g., `out.log` for `opt__value__1`).

Positional arguments follow suit:

    arg__id__0="identifier"
    arg__help__0="A unique identifier/name."

    arg__id__1="CIDR"
    arg__help__1="A valid CIDR range."

You can also provide a description of the program:

    command_description="My little utility."

### Parse

Now you can parse the parameters:

    parse_args "$@"

This will populate your flags, options, and arguments
with values. You can access them like this:

    echo "flag 0: $flag__value__0"
    echo "opt 0: $opt__value__0"
    echo "opt 1: $opt__value__1"
    echo "arg 0: $arg__value__0"


### Execute your script

Look at the auto-generated help:

    bash test.bash --help

Now try calling your script with some parameters:

    bash test.bash --verbose --username sally my-thing 10.0.0.0/16

Try forgetting a required parameter:

    bash test.bash my-thing

Try leaving off an option's value:

    bash test.bash --username


## Setup locally

Clone the repo somewhere, e.g.,:

    mkdir -p projects
    cd projects
    git clone https://github.com/jtpaasch/argparse.git

Then go into the repo, and install it:

    cd argparse
    make install


## Tests

To run tests, go into the repo and run this:

    make test

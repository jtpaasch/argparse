# Argparse for bash

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

### Declare allowed flags/options/arguments

Then declare any flags/options/arguments you want your program
to allow. For instance, to add flags `--verbose` and `--fail-fast`:

    flag__id__0="--verbose"
    flag__help__0="Display verbose output?"

    flag__id__1="--fail-fast"
    flag__help__1="Exit on first error?"

Options follow the same pattern (you can set default values too):

    opt__id__0="--username"
    opt__help__0="A username to login with."

    opt__id__1="--output"
    opt__help__1="A file to write output to."
    opt__value__1="out.log"

Positional arguments follow the same pattern too:

    arg__id__0="identifier"
    arg__help__0="A unique identifier/name."

    arg__id__1="CIDR"
    arg__help__1="A valid CIDR range."

You can also provide a description of the program:

    command_description="My little utility."

### Parse them

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

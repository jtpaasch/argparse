#!/usr/bin/env bash
#
# Utility for parsing command line arguments.
#
# To use it, declare the allowed flags, options, and arguments,
# then run the `parse_args()` function.
#
# To declare flags, e.g., `--verbose` and `--fail-fast`:
#
#   flag__id__0="--verbose"
#   flag__help__0="Display verbose output?"
#
#   flag__id__1="--fail-fast"
#   flag__help__1="Exit on first error?"
#
# To declare options (with or without defaults):
#
#   opt__id__0="--output"
#   opt__help__0="A file to write output to."
#   opt__value__0="out.txt"  # default
#
#   opt__id__1="--user"
#   opt__help__1="A username to login with."
#
# To declare positional (required) arguments:
#
#   arg__id__0="name"
#   arg__help__0="A unique name for the resource."
#
#   arg__id__1="greeting"
#   arg__help__1="A greeting to display on login."
#
# To specify a description of the command for
# the auto-generated help, declare a `command_description`:
#
#   command_description="My custom bash tool."
#
# Once all those things are declared, you can
# parse the arguments:
#
#   parse_args "$@"
#
# After that, each flag/opt/arg will have a value.
# For instance:
#
#   echo "flag 0: $flag__value__0"
#   echo "opt 0: $opt__value__0"
#   echo "arg 0: $arg__value__0"
#   echo "arg 1: $arg__value__1"
#
# To display auto-generated help, call the script
# with `-h` or `--help`.


# DESCRIPTION
#   Get a flag's help text.
#
# ARGUMENTS
#   $1: The desired flag's index (X in $flag__help__X).
get_flag_help() {
    local key="flag__help__$1"
    echo "${!key}"
}

# DESCRIPTION
#   Get an option's help text.
#
# ARGUMENTS
#   $1: The desired option's index (X in $opt__help__X).
get_opt_help() {
    local key="opt__help__$1"
    echo "${!key}"
}

# DESCRIPTION
#   Get an argument's help text.
#
# ARGUMENTS
#   $1: The desired argument's index (X in $arg__help__X).
get_arg_help() {
    local key="arg__help__$1"
    echo "${!key}"
}

# DESCRIPTION
#   Get a flag's value.
#
# ARGUMENTS
#   $1: The desired flag's index (X in $flag__value__X).
get_flag_value() {
    local key="flag__value__$1"
    echo "${!key}"
}

# DESCRIPTION
#   Get an option's value.
#
# ARGUMENTS
#   $1: The desired option's index (X in $opt__value__X).
get_opt_value() {
    local key="opt__value__$1"
    echo "${!key}"
}

# DESCRIPTION
#   Get an argument's value.
#
# ARGUMENTS
#   $1: The desired argument's index (X in $arg__value__X).
get_arg_value() {
    local key="arg__value__$1"
    echo "${!key}"
}

# DESCRIPTION
#   Set a flag's value.
#
# ARGUMENTS
#   $1: The desired flag's index (X in $flag__value__X).
#   $2: The value to set it to.
set_flag_value() {
    printf -v "flag__value__$1" %s "$2"
}

# DESCRIPTION
#   Set an option's value.
#
# ARGUMENTS
#   $1: The desired option's index (X in $opt__value__X).
#   $2: The value to set it to.
set_opt_value() {
    printf -v "opt__value__$1" %s "$2"
}

# DESCRIPTION
#   Set an argument's value.
#
# ARGUMENTS
#   $1: The desired argument's index (X in $arg__value__X).
#   $2: The value to set it to.
set_arg_value() {
    printf -v "arg__value__$1" %s "$2"
}

# DESCRIPTION
#   Given a flag's id, find its index.
#
# ARGUMENTS
#   $1: The flag's id (the value of $flag__id__X).
get_flag_index() {
    local index;
    local value;
    for key in ${!flag__id__*}; do
        value=${!key}
        if [ "$1" == "$value" ]; then
            index="${key#*flag__id__}"
            break
        fi
    done
    echo $index
}

# DESCRIPTION
#   Given an option's id, find its index.
#
# ARGUMENTS
#   $1: The option's id (the value of $opt__id__X).
get_opt_index() {
    local index;
    local value;
    for key in ${!opt__id__*}; do
        value=${!key}
        if [ "$1" == "$value" ]; then
            index="${key#*opt__id__}"
            break
        fi
    done
    echo $index
}

# DESCRIPTION
#   Find the lowest argument index that has no value.
get_arg_index() {
    local index
    local current_index
    local value_key
    local value
    for key in ${!arg__id__*}; do
        current_index="${key#*arg__id__}"
        value_key="arg__value__$current_index"
        value=${!value_key}
        if [ -z "$value" ]; then
            index=$current_index
            break
        fi
    done
    echo $index
}

# DESCRIPTION
#   Given flags/options/arguments, parse the provided arguments
#   and fill in their values. If invalid options or arguments
#   are found, return with an exit code of 1.
#
# ARGUMENTS
#   "$@": All the arguments provided on the command line.
parse_args() {
    local args=("$@")
    local index=0
    
    local next_index
    local next_item

    local skip

    local flag_index
    local opt_index

    for item in "${args[@]}"; do

        if [ "$item" == "-h" ] || [ "$item" == "--help" ]; then
            usage
            return 1
        fi

        next_index=$(($index + 1))
        next_item="${args[$next_index]}"

        if [ "$skip" == "true" ]; then
            skip=""
            index=$next_index
            continue
        fi
        
        flag_index=$(get_flag_index "$item")
        if [ ! -z $flag_index ]; then
            set_flag_value "$flag_index" "true"
        fi

        opt_index=$(get_opt_index "$item")
        if [ ! -z $opt_index ]; then
            if [ -z "$next_item" ]; then
                echo "Error: $item requires a value. See $script --help."
                return 1
            fi
            set_opt_value "$opt_index" "$next_item"
            skip="true"
        fi

        arg_index=$(get_arg_index)
        if [ "${item:0:1}" != "-" ] && [ ! -z $arg_index ]; then
            set_arg_value "$arg_index" "$item"
        fi

        if [ "${item:0:1}" == "-" ] && \
               [ -z $flag_index ] && \
               [ -z $opt_index ]; then
            echo "Error: unrecognized option: $item. See $script --help."
            return 1
        fi

        if [ "${item:0:1}" != "-" ] && [ -z $arg_index ]; then
            echo "Error: unrecognized argument: $item. See $script --help."
            return 1
        fi
        
        index=$next_index

    done

    local current_index
    local id
    local value
    local value_key

    for key in ${!arg__id__*}; do
        id=${!key}
        current_index="${key#*arg__id__}"
        value_key="arg__value__$current_index"
        value=${!value_key}
        if [ -z "$value" ]; then
            echo "Error: missing required argument: $id. See $script --help."
            return 1
        fi
    done
}

# DESCRIPTION
#   Generate usage/help for the command.
usage() {

    local current_index
    local help
    local id
    
    echo -n "USAGE: $script [FLAGS] [OPTIONS] "
    for key in ${!arg__id__*}; do
        id=${!key}
        echo -n "$id "
    done
    echo
    
    if [ ! -z "$command_description" ]; then
        echo ""
        echo "  $command_description"
    fi

    echo ""
    echo "FLAGS"
    echo "  -h/--help -- Display this information and exit."

    for key in ${!flag__id__*}; do
        id=${!key}
        current_index="${key#*flag__id__}"
        help=$(get_flag_help $current_index)
        echo "  $id -- $help"
    done

    echo ""
    echo "OPTIONS"

    for key in ${!opt__id__*}; do
        id=${!key}
        current_index="${key#*opt__id__}"
        help=$(get_opt_help $current_index)
        echo "  $id TEXT -- $help"
    done

    echo ""
    echo "ARGUMENTS"

    for key in ${!arg__id__*}; do
        id=${!key}
        current_index="${key#*arg__id__}"
        help=$(get_arg_help $current_index)
        echo "  $id -- $help"
    done

}

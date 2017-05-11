#!/usr/bin/env bash
#
# Tests for libexec/bin/argparse.bash

. libexec/bin/argparse.bash

@test "Test get_flag_help" {
    local flag__help__foo="bar"
    run get_flag_help "foo"
    [ "$output" == "bar" ]
}

@test "Test get_opt_help" {
    local opt__help__foo="bar"
    run get_opt_help "foo"
    [ "$output" == "bar" ]
}

@test "Test get_arg_help" {
    local arg__help__foo="bar"
    run get_arg_help "foo"
    [ "$output" == "bar" ]
}

@test "Test get_flag_value" {
    local flag__value__foo="bar"
    run get_flag_value "foo"
    [ "$output" == "bar" ]
}

@test "Test get_opt_value" {
    local opt__value__foo="bar"
    run get_opt_value "foo"
    [ "$output" == "bar" ]
}

@test "Test get_arg_value" {
    local arg__value__foo="bar"
    run get_arg_value "foo"
    [ "$output" == "bar" ]
}

@test "Test set_flag_value" {
    local flag__value__foo="false"
    set_flag_value "foo" "true"
    [ "$flag__value__foo" == "true" ]
}

@test "Test set_opt_value" {
    local opt__value__foo="foo"
    set_opt_value "foo" "bar"
    [ "$opt__value__foo" == "bar" ]
}

@test "Test set_arg_value" {
    local arg__value__foo="foo"
    set_arg_value "foo" "bar"
    [ "$arg__value__foo" == "bar" ]
}

@test "Test get_flag_index" {
    local flag__id__0="-a"
    local flag__id__1="-b"
    run get_flag_index "-b"
    [ "$output" == "1" ]
}

@test "Test get_opt_index" {
    local opt__id__0="-a"
    local opt__id__1="-b"
    run get_opt_index "-b"
    [ "$output" == "1" ]
}

@test "Test get_arg_index" {
    local arg__id__0="foo"
    local arg__value__0="bar"
    local arg__id__1="biz"
    local arg__value__1=""
    run get_arg_index
    [ "$output" == "1" ]
}

@test "Test help" {
    run parse_args "--help"
    [[ "${output[0]}" == "USAGE:"* ]]
}

@test "Test flag" {
    local flag__id__verbose="-v"
    parse_args "-v"
    [ "$flag__value__verbose" == "true" ]
}

@test "Test unrecognized flag" {
    run parse_args "-j"
    [ $status -ne 0 ]
    [[ "$output" == "Error:"* ]]
}

@test "Test option" {
    local opt__id__username="-u"
    parse_args "-u" "sally"
    [ "$opt__value__username" == "sally" ]
}

@test "Test option with missing value" {
    local opt__id__username="-u"
    run parse_args "-u"
    [ $status -ne 0 ]
    [[ "$output" == "Error:"* ]]
}

@test "Test unrecognized option" {
    run parse_args "-t" "thomas"
    [ $status -ne 0 ]
    [[ "$output" == "Error:"* ]]
}

@test "Test positional argument" {
    local arg__id__name="name"
    parse_args "foo"
    [ "$arg__value__name" == "foo" ]
}

@test "Test missing positional argument" {
    local arg__id__name="name"
    run parse_args
    [ $status -ne 0 ]
    [[ "$output" == "Error:"* ]]
}

@test "Test unrecognized positional argument" {
    run parse_args "sally"
    [ $status -ne 0 ]
    [[ "$output" == "Error:"* ]]
}

@test "Test usage" {
    run usage
    [[ "$output" == "USAGE:"* ]]
}

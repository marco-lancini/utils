#!/bin/bash
set -o nounset # No referencing undefined variables
set -o errexit # No ignoring failing commands

# Manual: http://www.gnu.org/software/bash/manual/bashref.html
# Guide:  http://linuxconfig.org/bash-scripting-tutorial

# Declaring a variable
VARIABLE="Some string"

# Using the variable
#   When you use the variable itself (assign, export): write its name without $
#   If you want to use variable's value, you should use $.
#   Note that ' (single quote) won't expand the variables!
echo $VARIABLE    # Some string
echo "$VARIABLE"  # Some string
echo '$VARIABLE'  # $VARIABLE

A=$(ls)           # A=`ls`

# String substitution in variables
#   This will substitute the first occurance of "Some" with "A"
echo ${VARIABLE/Some/A}

# Bultin variables
echo "Last program return value: $?"
echo "Script's PID: $$"
echo "Number of arguments: $#"
echo "Scripts arguments: $@"
echo "Scripts arguments separeted in different variables: $1 $2..."

# Reading a value from input
echo "What's your name?"
read NAME
echo Hello, $NAME!

# Conditional execution
echo "Always executed" || echo "Only executed if first command fail"
echo "Always executed" && echo "Only executed if first command does NOT fail"

# Expressions
echo $(( 10 + 5 ))

# Bash is a shell, so it works in a context of current directory
ls

# Commands can be substituted within other commands using $( ), or ` `
echo "There are $(ls | wc -l) items here."


#############################################################################
# ESCAPING
#############################################################################
# Escaping meta characters
#   When meta character such us "$" is escaped with "\" it will be read literally
echo \$BASH_VAR
#   Backslash has also special meaning and it can be suppressed with yet another "\"
echo "\\"

# Single quotes
#   Will suppress special meaning of every meta characters
#   Therefore meta characters will be read literally

# Double Quotes
#   Will suppress special meaning of every meta characters except "$", "\" and "`"
#   Any other meta characters will be read literally
#   If we need to use double quotes within double quotes bash can read them literally when escaping them with "\"
echo "It's $BASH_VAR  and \"$BASH_VAR\" using backticks: `date`"
    # It's ZZ and "ZZ" using backticks: 10/10/12


#############################################################################
# CONDITIONALS
#############################################################################
# IF
if [ $NAME -ne $USER ]
then
    echo "Your name is you username"
else
    echo "Your name isn't you username"
fi

# FOR
for VARIABLE in `seq 3`; do
    echo "$VARIABLE"
done

for f in $( ls /var/ ); do
    echo $f
done

# WHILE
while [ $COUNT -gt 0 ]; do
    echo Value of count is: $COUNT
    let COUNT=COUNT-1
done

# UNTIL
until [ $COUNT -gt 5 ]; do
        echo Value of count is: $COUNT
        let COUNT=COUNT+1
done

# CASE
echo "What is your preferred programming / scripting language"
echo "1) bash"
echo "2) perl"
echo "3) phyton"
echo "4) c++"
echo "5) I do not know !"
read case;
case $case in
    1) echo "You selected bash";;
    2) echo "You selected perl";;
    3) echo "You selected phyton";;
    4) echo "You selected c++";;
    5) exit
esac

# ARRAY
#   Declare array with 4 elements
ARRAY=( 'Debian Linux' 'Redhat Linux' Ubuntu Linux )
#   Get number of elements in the array
ELEMENTS=${#ARRAY[@]}
#   echo each element in array
for (( i=0;i<$ELEMENTS;i++)); do
    echo ${ARRAY[${i}]}
done


#############################################################################
# FUNCTIONS
#############################################################################
function foo ()
{
    echo "Arguments work just like script arguments: $@"
    echo "And: $1 $2..."
    echo "This is a function"
    echo $1
    echo $2

    return 0
}

# or simply
bar ()
{
    echo "Another way to declare functions!"
    return 0
}

# Calling your function
foo "My name is" $NAME


#############################################################################
# REDIRECTIONS
#############################################################################
# STDOUT from bash script to STDERR
echo "Redirect this STDOUT to STDERR" 1>&2

# STDERR from bash script to STDOUT
cat $1 2>&1

# STDERR to file
ls file1 file2 2> STDERR


# STDOUT to STDERR
#   Both STDOUT and STDERR will be redirected to file "STDERR_STDOUT".
ls file1 file2 2> STDERR_STDOUT 1>&2

# STDERR to STDOUT
ls file1 file2 > STDERR_STDOUT 2>&1

# STDERR and STDOUT to file
$ ls file1 file2 &> STDERR_STDOUT
#   or
ls file1 file2 >& STDERR_STDOUT


# You can also redirect a command output, input and error output
#   The output error will overwrite the file if it exists
#   if you want to concatenate them, use ">>" instead.
python2 hello.py < "input.in"
python2 hello.py > "output.out"
python2 hello.py 2> "error.err"


#############################################################################
# CHECKS
#############################################################################
# Arithmetic Comparisons
    -lt <
    -gt >
    -le <=
    -ge >=
    -eq ==
    -ne !=

# String Comparisons
    =       equal
    !=      not equal
    <       less then
    >       greater then
    -n s1   string s1 is not empty
    -z s1   string s1 is empty

# Bash File Testing
    -b filename         Block special file
    -c filename         Special character file
    -d directoryname    Check for directory existence
    -e filename         Check for file existence
    -f filename         Check for regular file existence not a directory
    -G filename         Check if file exists and is owned by effective group ID
    -g filename         true if file exists and is set-group-id
    -k filename         Sticky bit
    -L filename         Symbolic link
    -O filename         True if file exists and is owned by the effective user id.
    -r filename         Check if file is a readable
    -S filename         Check if file is socket
    -s filename         Check if file is nonzero size
    -u filename         Check if file set-ser-id bit is set
    -w filename         Check if file is writable
    -x filename         Check if file is executable

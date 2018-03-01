# NMTran Parser

This parser can read an NMTRAN file and then potentially be used to
manipulate the file or translate it to another representation.

To do this it requires a pre-processing step to transform elements
that cannot be easily disambiguated by the parser and then the parser
itself is run.

The parser is implemented using Antlr4.

## Build

To build just run maven:

```bash
mvn clean verify
```

## Pre-processing

The pre-processing step identifies fields that are strings, but which
can only be determined as such by the keyword they are associated with.
For example the in the following case where the text after the problem 
statement is a string.

```
$PROB this is the prob statment
``` 

In this case the string is quoted so that it can be more easily parsed as a
string by the grammar.

Other cases handled are the name of the data file after the `$DATA` keyword
and certain options that have string values, such as `FILE=foo.dat`.


## Potential Issues

1. Some option keywords may not follow the standard ID rules used by NMTRAN. 
For example `-2LL` is a valid option name, but not a valid identifier.  
The grammar deals with this as a hack and recognises ID and text starting with
'-' and a number as an option keyword.  This works, but there may be other
non-standard option keywords with different conventions that may cause this
heuristic to fail.  A better approach may be to pre-process all possible
option keywords and prefix them with a special character that can be 
recognised by the grammar.

1. Related to the above is the fact that in some cases keywords recognised by
the lexer may be permissible to use as variable IDs.  In which case some
valid NMTRAN files may fail with this grammar.  if this becomes an issue,
then the solution is likely to be pre-processing the option keywords - asi
described above.  This would reduce the number of keywords the lexer needs
to recognise.

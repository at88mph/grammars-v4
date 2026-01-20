# ADQL (2.1)

## What is it?
**ADQL**: **A**stronomical **D**ata **Q**uery **L**anguage

ADQL is the language used by the [IVOA](http://www.ivoa.net/) to represent
astronomical queries posted to VO services (e.g.
[TAP](http://www.ivoa.net/documents/TAP/)). It is based on the Structured Query
Language (SQL), especially on [SQL-92](https://en.wikipedia.org/wiki/SQL-92)
(see also an online
[BNF version](https://ronsavage.github.io/SQL/sql-92.bnf.html) for an easy
navigation). The IVOA has a number of tabular data sets and many of them are
stored in relational databases, making SQL a convenient access means. Thus, a
subset of the SQL grammar has been extended to support queries that are
specific to astronomy.

## Grammars
All grammar was pulled and converted from the BNF ([Backus-Naur Form](https://www.sciencedirect.com/topics/computer-science/backus-naur-form)) [version of the specification](https://raw.githubusercontent.com/ivoa-std/ADQL/refs/heads/master/adql.bnf).

## Status?
The last stable version of the specification is
**[REC-ADQL-2.1](https://www.ivoa.net/documents/ADQL/20231215/REC-ADQL-2.1.html)**.

See also the section
[Releases](https://github.com/ivoa-std/ADQL/releases) of this GitHub Repository.
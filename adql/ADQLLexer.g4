lexer grammar ADQLLexer;

options {
    caseInsensitive = true;
}

/*
 * ============================
 * Keywords (ADQL + SQL)
 * ============================
 */

/* ADQL reserved words */
ABS         : 'ABS';
ACOS        : 'ACOS';
AREA        : 'AREA';
ASIN        : 'ASIN';
ATAN        : 'ATAN';
ATAN2       : 'ATAN2';
BIGINT      : 'BIGINT';
BOX         : 'BOX';
CEILING     : 'CEILING';
CENTROID    : 'CENTROID';
CIRCLE      : 'CIRCLE';
CONTAINS    : 'CONTAINS';
COORD1      : 'COORD1';
COORD2      : 'COORD2';
COORDSYS    : 'COORDSYS';
COS         : 'COS';
COT         : 'COT';
DEGREES     : 'DEGREES';
DISTANCE    : 'DISTANCE';
EXP         : 'EXP';
FLOOR       : 'FLOOR';
ILIKE       : 'ILIKE';
INTERSECTS  : 'INTERSECTS';
IN_UNIT     : 'IN_UNIT';
LOG         : 'LOG';
LOG10       : 'LOG10';
MOD         : 'MOD';
OFFSET      : 'OFFSET';
PI          : 'PI';
POINT       : 'POINT';
POLYGON     : 'POLYGON';
POWER       : 'POWER';
RADIANS     : 'RADIANS';
REGION      : 'REGION';
RAND        : 'RAND';
ROUND       : 'ROUND';
SIN         : 'SIN';
SQRT        : 'SQRT';
TOP         : 'TOP';
TAN         : 'TAN';
TRUNCATE    : 'TRUNCATE';

/* SQL reserved words */
SELECT      : 'SELECT';
FROM        : 'FROM';
WHERE       : 'WHERE';
GROUP       : 'GROUP';
BY          : 'BY';
HAVING      : 'HAVING';
ORDER       : 'ORDER';
ASC         : 'ASC';
DESC        : 'DESC';
INSERT      : 'INSERT';
UPDATE      : 'UPDATE';
DELETE      : 'DELETE';
INTO        : 'INTO';
VALUES      : 'VALUES';
JOIN        : 'JOIN';
LEFT        : 'LEFT';
RIGHT       : 'RIGHT';
FULL        : 'FULL';
INNER       : 'INNER';
OUTER       : 'OUTER';
ON          : 'ON';
USING       : 'USING';
AS          : 'AS';
AND         : 'AND';
OR          : 'OR';
NOT         : 'NOT';
IN          : 'IN';
BETWEEN     : 'BETWEEN';
LIKE        : 'LIKE';
IS          : 'IS';
NULL        : 'NULL';
EXISTS      : 'EXISTS';
DISTINCT    : 'DISTINCT';
ALL         : 'ALL';
UNION       : 'UNION';
EXCEPT      : 'EXCEPT';
INTERSECT   : 'INTERSECT';
CAST        : 'CAST';
COUNT       : 'COUNT';
AVG         : 'AVG';
MIN         : 'MIN';
MAX         : 'MAX';
SUM         : 'SUM';
TRUE        : 'TRUE';
FALSE       : 'FALSE';
TIMESTAMP   : 'TIMESTAMP';
LOWER       : 'LOWER';
UPPER       : 'UPPER';
NATURAL     : 'NATURAL';
CASE        : 'CASE';
WHEN        : 'WHEN';
THEN        : 'THEN';
ELSE        : 'ELSE';
END         : 'END';

/*
 * ============================
 * Operators and punctuation
 * ============================
 */

LPAREN      : '(';
RPAREN      : ')';
LBRACK      : '[';
RBRACK      : ']';
COMMA       : ',';
DOT         : '.';
ASTERISK    : '*';
PLUS        : '+';
MINUS       : '-';
SLASH       : '/';
PERCENT     : '%';
SEMICOLON   : ';';
COLON       : ':';
QUESTION    : '?';
VERTICAL_BAR: '|';

EQ          : '=';
NEQ         : '<>' | '!=';
LT          : '<';
LTE         : '<=';
GT          : '>';
GTE         : '>=';

CONCAT      : '||';
DOUBLE_DOT  : '..';

/*
 * ============================
 * Literals
 * ============================
 */

STRING_LITERAL
    : '\'' ( '\'\'' | ~'\'' )* '\''
    ;

NUMERIC_LITERAL
    : DIGIT+ ( '.' DIGIT* )? ( 'E' [+-]? DIGIT+ )?
    | '.' DIGIT+ ( 'E' [+-]? DIGIT+ )?
    ;

/*
 * ============================
 * Identifiers
 * ============================
 */

/* Delimited identifiers */
DELIMITED_IDENTIFIER
    : '"' ( '""' | ~'"' )* '"'
    ;

/* Regular identifiers */
IDENTIFIER
    : LETTER ( LETTER | DIGIT | '_' )*
    ;

/*
 * ============================
 * Comments and whitespace
 * ============================
 */

LINE_COMMENT
    : '--' ~[\r\n]* -> skip
    ;

WS
    : [ \t\r\n]+ -> skip
    ;

/*
 * ============================
 * Fragments
 * ============================
 */

fragment DIGIT
    : [0-9]
    ;

fragment LETTER
    : [A-Z]
    ;

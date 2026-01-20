/*
ADQL Grammar.
Copyright (c) 2026, ROE (http://www.roe.ac.uk/)

This information is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This information is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// $antlr-format alignTrailingComments true, columnLimit 150, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine true, allowShortBlocksOnASingleLine true, minEmptyLines 0, alignSemicolons ownLine
// $antlr-format alignColons trailing, singleLineOverrulesHangingColon true, alignLexerCommands true, alignLabels true, alignTrailers true

lexer grammar ADQLLexer;

options {
    caseInsensitive = true;
}

/* =====================
 * Keywords
 * ===================== */

ABS         : 'ABS';
ACOS        : 'ACOS';
ALL         : 'ALL';
AND         : 'AND';
AREA        : 'AREA';
AS          : 'AS';
ASC         : 'ASC';
ASIN        : 'ASIN';
ATAN        : 'ATAN';
ATAN2       : 'ATAN2';
BETWEEN     : 'BETWEEN';
BIGINT      : 'BIGINT';
BOX         : 'BOX';
BY          : 'BY';
CAST        : 'CAST';
CENTROID    : 'CENTROID';
CIRCLE      : 'CIRCLE';
CONTAINS    : 'CONTAINS';
COUNT       : 'COUNT';
COORD1      : 'COORD1';
COORD2      : 'COORD2';
COORDSYS    : 'COORDSYS';
COS         : 'COS';
DESC        : 'DESC';
DISTINCT    : 'DISTINCT';
DOUBLE      : 'DOUBLE';
EXISTS      : 'EXISTS';
FROM        : 'FROM';
GROUP       : 'GROUP';
HAVING      : 'HAVING';
ILIKE       : 'ILIKE';
IN          : 'IN';
INTERSECTS  : 'INTERSECTS';
INTERVAL    : 'INTERVAL';
IS          : 'IS';
LIKE        : 'LIKE';
NOT         : 'NOT';
NULL        : 'NULL';
OFFSET      : 'OFFSET';
OR          : 'OR';
ORDER       : 'ORDER';
POINT       : 'POINT';
POLYGON     : 'POLYGON';
REGION      : 'REGION';
SELECT      : 'SELECT';
TOP         : 'TOP';
UNION       : 'UNION';
WHERE       : 'WHERE';

/* =====================
 * Operators & Symbols
 * ===================== */

CONCAT      : '||';

NEQ         : '!=' | '<>';
LTE         : '<=';
GTE         : '>=';

EQ          : '=';
LT          : '<';
GT          : '>';

PLUS        : '+';
MINUS       : '-';
STAR        : '*';
SLASH       : '/';
PERCENT     : '%';

LPAREN      : '(';
RPAREN      : ')';
LBRACK      : '[';
RBRACK      : ']';
COMMA       : ',';
DOT         : '.';
COLON       : ':';
SEMICOLON   : ';';
QUESTION    : '?';
PIPE        : '|';

/* =====================
 * Literals
 * ===================== */

STRING_LITERAL
    : '\'' ( '\'\'' | ~'\'' )* '\''
    ;

NUMERIC_LITERAL
    : DIGIT+ ('.' DIGIT+)? EXPONENT?
    | '.' DIGIT+ EXPONENT?
    ;

fragment EXPONENT
    : [E] [+-]? DIGIT+
    ;

/* =====================
 * Identifiers
 * ===================== */

DELIMITED_IDENTIFIER
    : '"' ( '""' | ~'"' )* '"'
    ;

IDENTIFIER
    : LETTER (LETTER | DIGIT | '_')*
    ;

/* =====================
 * Fragments
 * ===================== */

fragment DIGIT  : [0-9];
fragment LETTER : [A-Z_];

/* =====================
 * Whitespace & Comments
 * ===================== */

WS
    : [ \t\r\n]+ -> skip
    ;

LINE_COMMENT
    : '--' ~[\r\n]* -> skip
    ;

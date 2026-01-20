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

parser grammar ADQLParser;

options {
    tokenVocab = ADQLLexer;
}

/* =====================
 * Entry point
 * ===================== */

adqlQuery
    : selectExpression EOF
    ;

/* =====================
 * SELECT
 * ===================== */

selectExpression
    : selectQuery orderByClause? offsetClause?
    ;

queryExpression
    : selectExpression | joinedTable
    ;

querySetPrimary
    : selectQuery | LPAREN selectExpression RPAREN
    ;

querySetExpression
    : querySetTerm | querySetTerm UNION ALL? querySetExpression | querySetTerm EXCEPT ALL? querySetExpression
    ;

querySetTerm
    : querySetPrimary | querySetTerm INTERSECT ALL? querySetExpression
    ;

selectQuery
    : SELECT setQuantifier? setLimit? selectList fromClause whereClause?
      groupByClause? havingClause?
    ;

selectList
    : STAR
    | selectSublist (COMMA selectSublist)*
    ;

selectSublist
    : valueExpression (AS? identifier)?
    | identifier DOT STAR
    ;

/* =====================
 * FROM / WHERE
 * ===================== */

fromClause
    : FROM tableReference (COMMA tableReference)*
    ;

tableReference
    : tableName correlationSpecification?
    | LPAREN selectExpression RPAREN correlationSpecification
    ;

whereClause
    : WHERE searchCondition
    ;

/* =====================
 * Expressions
 * ===================== */

searchCondition
    : searchCondition OR booleanTerm
    | booleanTerm
    ;

joinColumnList
    : selectList
    ;

namedColumnsJoin
    : USING LPAREN joinColumnList RPAREN
    ;

joinCondition
    : ON searchCondition
    ;

joinSpecification
    : joinCondition | namedColumnsJoin
    ;

outerJoinType
    : LEFT
    | RIGHT
    | FULL
    ;

joinType
    : INNER | outerJoinType OUTER?
    ;

joinedTable
    : qualifiedJoin | LPAREN joinedTable RPAREN
    ;

qualifiedJoin
    : tableReference NATURAL? joinType JOIN tableReference joinSpecification?
    ;

booleanTerm
    : booleanTerm AND booleanFactor
    | booleanFactor
    ;

booleanFactor
    : NOT? predicate
    ;

predicate
    : comparisonPredicate
    | betweenPredicate
    | inPredicate
    | likePredicate
    | existsPredicate
    | predicateGeometryFunction
    | nullPrediate
    ;

predicateGeometryFunction
    : intersectsFunction
    | containsFunction
    ;

comparisonPredicate
    : valueExpression comparisonOperator valueExpression
    ;

betweenPredicate
    : valueExpression NOT? BETWEEN valueExpression AND valueExpression
    ;

inPredicate
    : valueExpression NOT? IN (subquery | LPAREN valueExpression (COMMA valueExpression)* RPAREN)
    ;

intersectsFunction
    : INTERSECTS LPAREN
        geometryValueExpression COMMA geometryValueExpression
      RPAREN
    ;

containsFunction
    : CONTAINS LPAREN
        geometryValueExpression COMMA geometryValueExpression
      RPAREN
    ;

likePredicate
    : valueExpression NOT? (LIKE | ILIKE) valueExpression
    ;

existsPredicate
    : EXISTS subquery
    ;

nullPrediate
    : valueExpression IS NOT? NULL
    ;


/* =====================
 * Value expressions
 * ===================== */

valueExpression
    : numericExpression
    | STRING_LITERAL
    | NULL
    | functionCall
    | columnReference
    | LPAREN valueExpression RPAREN
    ;

numericExpression
    : numericExpression (PLUS | MINUS) term
    | term
    ;

term
    : term (STAR | SLASH) factor
    | factor
    ;

factor
    : (PLUS | MINUS)? numericPrimary
    ;

numericPrimary
    : NUMERIC_LITERAL
    | aggregateFunction
    | coord1Function
    | coord2Function
    | coordsysFunction
    | functionCall
    | columnReference
    ;


/* =====================
 * Functions
 * ===================== */

functionCall
    : identifier LPAREN (valueExpression (COMMA valueExpression)*)? RPAREN
    ;

aggregateFunction
    : COUNT LPAREN STAR RPAREN
    | COUNT LPAREN setQuantifier? valueExpression RPAREN
    | AVG   LPAREN setQuantifier? numericExpression RPAREN
    | SUM   LPAREN setQuantifier? numericExpression RPAREN
    | MIN   LPAREN setQuantifier? valueExpression RPAREN
    | MAX   LPAREN setQuantifier? valueExpression RPAREN
    ;

intervalFunction
    : INTERVAL LPAREN numericExpression COMMA numericExpression RPAREN
    ;

centroidFunction
    : CENTROID LPAREN geometryValueExpression RPAREN
    ;

circleFunction
    : CIRCLE LPAREN
        (STRING_LITERAL COMMA)?
        numericExpression COMMA numericExpression COMMA numericExpression
      RPAREN
    ;

pointFunction
    : POINT LPAREN
        (STRING_LITERAL COMMA)? numericExpression COMMA numericExpression
      RPAREN
    ;

boxFunction
    : BOX LPAREN
        numericExpression COMMA numericExpression COMMA
        numericExpression COMMA numericExpression
      RPAREN
    ;

coord1Function
    : COORD1 LPAREN geometryValueExpression RPAREN
    ;

coord2Function
    : COORD2 LPAREN geometryValueExpression RPAREN
    ;

coordsysFunction
    : COORDSYS LPAREN geometryValueExpression RPAREN
    ;

polygonFunction
    : POLYGON LPAREN
        (STRING_LITERAL COMMA)?
        numericExpression (COMMA numericExpression)+
      RPAREN
    ;

regionFunction
    : REGION LPAREN STRING_LITERAL RPAREN
    ;

geometryFunction
    : centroidFunction
    | pointFunction
    | circleFunction
    | coordsysFunction
    | boxFunction
    | polygonFunction
    | regionFunction
    | intervalFunction
    ;

geometryValueExpression
    : geometryFunction
    | columnReference
    | LPAREN geometryValueExpression RPAREN
    ;


/* =====================
 * Misc
 * ===================== */

columnReference
    : identifier (DOT identifier)?
    ;

identifier
    : IDENTIFIER
    | DELIMITED_IDENTIFIER
    ;

comparisonOperator
    : EQ | NEQ | LT | LTE | GT | GTE
    ;

orderByClause
    : ORDER BY orderByTerm (COMMA orderByTerm)*
    ;

orderByTerm
    : valueExpression (ASC | DESC)?
    ;

offsetClause
    : OFFSET NUMERIC_LITERAL
    ;

setQuantifier
    : DISTINCT | ALL
    ;

setLimit
    : TOP NUMERIC_LITERAL
    ;

groupByClause
    : GROUP BY valueExpression (COMMA valueExpression)*
    ;

havingClause
    : HAVING searchCondition
    ;

correlationSpecification
    : AS? identifier
    ;

tableName
    : (schemaName DOT)? identifier
    ;

schemaName
    : identifier
    ;

subquery
    : LPAREN queryExpression RPAREN
    ;

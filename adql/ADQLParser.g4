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

////////////////////////////////////////////////////////////
// Entry point
////////////////////////////////////////////////////////////

adqlQuery
    : selectStatement EOF
    ;

////////////////////////////////////////////////////////////
// SELECT
////////////////////////////////////////////////////////////

selectStatement
    : SELECT setQuantifier? setLimit?
      selectList
      fromClause
      whereClause?
      groupByClause?
      havingClause?
      orderByClause?
      offsetClause?
    ;

setQuantifier
    : DISTINCT
    | ALL
    ;

setLimit
    : TOP unsignedNumericLiteral
    ;

selectList
    : ASTERISK
    | selectItem (COMMA selectItem)*
    ;

selectItem
    : valueExpression asClause?
    | qualifier DOT ASTERISK
    ;

asClause
    : AS? identifier
    ;

////////////////////////////////////////////////////////////
// FROM / JOIN
////////////////////////////////////////////////////////////

fromClause
    : FROM tableReference (COMMA tableReference)*
    ;

qualifier
    : tableName | correlationSpecification
    ;

derivedTable
    : tableSubquery
    ;

tablePrimary
    : tableName correlationSpecification?
    | derivedTable correlationSpecification
    | LPAREN tableReference RPAREN
    ;

tableReference
    : tablePrimary (joinClause)*
    ;

joinClause
    : NATURAL? joinType? JOIN tablePrimary joinSpecification?
    ;

joinedTable
    : qualifiedJoin
    | LPAREN joinedTable RPAREN
    ;

qualifiedJoin
    : tablePrimary NATURAL? joinType? JOIN tablePrimary joinSpecification?
    ;

tableName
    : (schemaName DOT)? identifier
    ;

tableSubquery
    : subquery
    ;

schemaName
    : identifier
    ;

correlationSpecification
    : AS? identifier
    ;

joinType
    : INNER
    | LEFT OUTER?
    | RIGHT OUTER?
    | FULL OUTER?
    ;

joinSpecification
    : joinCondition
    | namedColumnsJoin
    ;

joinCondition
    : ON columnReference
    ;

namedColumnsJoin
    : USING LPAREN identifierList RPAREN
    ;

identifierList
    : identifier (COMMA identifier)*
    ;

////////////////////////////////////////////////////////////
// WHERE / predicates
////////////////////////////////////////////////////////////

identifier
    : IDENTIFIER
    ;

whereClause
    : WHERE searchCondition
    ;

searchCondition
    : booleanTerm
    | searchCondition OR booleanTerm
    ;

booleanTerm
    : booleanFactor
    | booleanTerm AND booleanFactor
    ;

booleanFactor
    : NOT? booleanPrimary
    ;

booleanPrimary
    : predicate
    | LPAREN searchCondition RPAREN
    ;

columnName
    : identifier
    ;

columnReference
    : (qualifier DOT)? columnName
    ;

predicate
    : comparisonPredicate
    | betweenPredicate
    | inPredicate
    | likePredicate
    | nullPredicate
    | existsPredicate
    | geometryPredicate
    ;

comparisonPredicate
    : valueExpression comparisonOperator valueExpression
    ;

comparisonOperator
    : EQ | NEQ | LT | LTE | GT | GTE
    ;

betweenPredicate
    : valueExpression NOT? BETWEEN valueExpression AND valueExpression
    ;

inPredicate
    : valueExpression NOT? IN inPredicateValue
    ;

inPredicateValue
    : subquery
    | LPAREN valueExpression (COMMA valueExpression)* RPAREN
    ;

likePredicate
    : valueExpression NOT? (LIKE | ILIKE) valueExpression
    ;

nullPredicate
    : valueExpression IS NOT? NULL
    ;

existsPredicate
    : EXISTS subquery
    ;

queryExpression
    : selectStatement | joinedTable
    ;

subquery
    : LPAREN queryExpression RPAREN
    ;

////////////////////////////////////////////////////////////
// Geometry predicates
////////////////////////////////////////////////////////////

geometryPredicate
    : INTERSECTS LPAREN valueExpression COMMA valueExpression RPAREN
    | CONTAINS   LPAREN valueExpression COMMA valueExpression RPAREN
    ;

////////////////////////////////////////////////////////////
// GROUP / HAVING / ORDER
////////////////////////////////////////////////////////////

groupByClause
    : GROUP BY groupByItem (COMMA groupByItem)*
    ;

groupByItem
    : columnReference
    | valueExpression
    ;

havingClause
    : HAVING searchCondition
    ;

orderByClause
    : ORDER BY orderByItem (COMMA orderByItem)*
    ;

orderByItem
    : valueExpression (ASC | DESC)?
    ;

offsetClause
    : OFFSET unsignedNumericLiteral
    ;

////////////////////////////////////////////////////////////
// Expressions
////////////////////////////////////////////////////////////

valueExpression
    : NULL
    | numericExpression
    | stringExpression
    | geometryValueExpression
    | countFunction
    | caseFoldingFunction
    | LPAREN valueExpression RPAREN
    ;

numericExpression
    : numericExpression PLUS term
    | numericExpression MINUS term
    | term
    ;

term
    : term ASTERISK factor
    | term SLASH factor
    | factor
    ;

factor
    : (PLUS | MINUS)? numericPrimary
    ;

unsignedNumericLiteral
    : NUMERIC_LITERAL
    ;

numericPrimary
    : unsignedNumericLiteral
    | columnReference
    | numericFunction
    | LPAREN numericExpression RPAREN
    ;

stringExpression
    : stringPrimary
    ;

stringLiteral
    : STRING_LITERAL
    ;

stringPrimary
    : stringLiteral
    | stringFunction
    | columnReference
    ;

////////////////////////////////////////////////////////////
// Geometry
////////////////////////////////////////////////////////////

geometryValueExpression
    : geometryFunction
    | columnReference
    ;

geometryFunction
    : pointFunction
    | circleFunction
    | polygonFunction
    | centroidFunction
    | regionFunction
    | userDefinedFunction
    ;

caseFoldingFunction
    : LOWER LPAREN stringExpression RPAREN
    | UPPER LPAREN stringExpression RPAREN
    ;

stringFunction
    : stringGeometryFunction
    | caseFoldingFunction
    | userDefinedFunction
    ;

stringGeometryFunction
    : coordsysFunction
    ;

areaFunction
    : AREA LPAREN geometryValueExpression RPAREN
    ;

coord1Function
    : COORD1 LPAREN coordValue RPAREN
    ;

coord2Function
    : COORD2 LPAREN coordValue RPAREN
    ;

coordsysFunction
    : COORDSYS LPAREN geometryValueExpression RPAREN
    ;

distanceFunction
    : DISTANCE LPAREN coordValue COMMA coordValue RPAREN
    | DISTANCE LPAREN numericExpression COMMA numericExpression COMMA numericExpression COMMA numericExpression RPAREN
    ;

countFunction
    : COUNT LPAREN (ASTERISK | DISTINCT? valueExpression) RPAREN
    ;

nonPredicateGeometryFunction
    : areaFunction
    | coord1Function
    | coord2Function
    | distanceFunction
    ;

pointFunction
    : POINT LPAREN stringLiteral COMMA numericExpression COMMA numericExpression RPAREN
    ;

circleCentre
    : coordinates
    | coordValue
    ;

circleFunction
    : CIRCLE LPAREN (stringLiteral COMMA)? circleCentre COMMA numericExpression RPAREN
    ;

polygonFunction
    : POLYGON LPAREN polygonVertices RPAREN
    ;

pointValue
    : pointFunction
    | centroidFunction
    | userDefinedFunction
    ;

coordValue
    : pointValue
    | columnReference
    ;

coordinates
    : numericExpression COMMA numericExpression
    ;

polygonVertices
    : coordinates COMMA coordinates COMMA coordinates (COMMA coordinates)*
    | numericExpression COMMA numericExpression COMMA numericExpression (COMMA numericExpression)*
    ;

centroidFunction
    : CENTROID LPAREN geometryValueExpression RPAREN
    ;

regionFunction
    : REGION LPAREN stringLiteral RPAREN
    ;

numericFunction
    : trigFunction
    | mathFunction
    | inUnitFunction
    | numericGeometryFunction
    | userDefinedFunction
    ;

numericGeometryFunction
    : geometryPredicate
    | nonPredicateGeometryFunction
    ;

trigFunction
    : ACOS LPAREN numericExpression RPAREN
    | ASIN LPAREN numericExpression RPAREN
    | ATAN LPAREN numericExpression RPAREN
    | ATAN2 LPAREN numericExpression COMMA numericExpression RPAREN
    | COS LPAREN numericExpression RPAREN
    | COT LPAREN numericExpression RPAREN
    | SIN LPAREN numericExpression RPAREN
    | TAN LPAREN numericExpression RPAREN
    ;

mathFunction
    : ABS LPAREN numericExpression RPAREN
    | CEILING LPAREN numericExpression RPAREN
    | DEGREES LPAREN numericExpression RPAREN
    | EXP LPAREN numericExpression RPAREN
    | FLOOR LPAREN numericExpression RPAREN
    | LOG LPAREN numericExpression RPAREN
    | LOG10 LPAREN numericExpression RPAREN
    | MOD LPAREN numericExpression COMMA numericExpression RPAREN
    | PI LPAREN RPAREN
    | POWER LPAREN numericExpression COMMA numericExpression RPAREN
    | RADIANS LPAREN numericExpression RPAREN
    | RAND LPAREN (unsignedNumericLiteral)? RPAREN
    | ROUND LPAREN numericExpression (COMMA factor)? RPAREN
    | SQRT LPAREN numericExpression RPAREN
    | TRUNCATE LPAREN numericExpression (COMMA factor)? RPAREN
    ;

inUnitFunction
    : IN_UNIT LPAREN numericExpression COMMA stringLiteral RPAREN
    ;

userDefinedFunction
    : identifier LPAREN (valueExpression (COMMA valueExpression)*)? RPAREN
    ;

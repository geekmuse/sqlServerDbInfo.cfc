# SQL Server DB Info ColdFusion Custom Tag

by [Bradley Campbell][1]

The sqlServerDbinfo.cfc is a ColdFusion component that is intended to extend the ColdFusion's
stock `<cfdbinfo>` tag to be more compatible with SQL Server.

## Features

* Extends `<cfdbinfo>` where it seems appropriate.
* Falls back to `<cfdbinfo>`-like behavior where extension seems unnecessary.
* Return values are structured just like those of `<cfdbinfo>`, so you can replace `<cfdbinfo>` calls in your code as appropriate without having to refactor to account for differently-structured return values.

## Usage

1. `<cfinvoke component="sqlServerDbinfo" method="columns" datasource="myDSN" tableName="tblName" returnvariable="res">` from any regular CFM file.
2. Treat the `res` result variable the same way you would treat the return variable of a `<cfdbinfo>` call.

## Comparison with `<cfdbinfo>`

Every attempt has been made to keep the syntax and parameters of methods of this CFC as closely aligned with those of `<cfdbinfo>` as possible.  For example, the corollary of: 

```coldfusion
<cfdbinfo
  datasource="myDSN"
  name="res"
  type="columns"
  table="tblName"
/>
```
is

```coldfusion
<cfinvoke 
  component="sqlServerDbinfo" 
  method="columns" 
  datasource="myDSN" 
  tableName="tblName" 
  returnvariable="res"
/>
```

## Why?

* Honestly, to cover my own perceived implementation gaps of the `<cfdbinfo>` tag with SQL Server.  Maybe I've spent too much time baking in the MySQL/phpmyadmin sun :)

[1]: http://blog.bradleyscampbell.net
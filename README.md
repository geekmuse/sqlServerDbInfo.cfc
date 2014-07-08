# SQL Server DB Info ColdFusion CFC

by [Bradley Campbell][1]

The sqlServerDbinfo.cfc is a ColdFusion component that is intended to extend the ColdFusion's
stock `<cfdbinfo>` tag to be more compatible with SQL Server.

## Features

* Extends `<cfdbinfo>` where it seems appropriate.
* Falls back to `<cfdbinfo>`-like behavior where extension seems unnecessary.
* Return values are structured just like those of `<cfdbinfo>`, so you can replace `<cfdbinfo>` calls in your code as appropriate without having to refactor to account for differently-structured return values.  The metadata is returned in the traditionally empty (for SQL Server) _REMARKS_ column.

## Usage

1. `<cfinvoke component="sqlServerDbinfo" method="columns" datasource="myDSN" tableName="tblName" returnvariable="res">` from any regular CFM file.
2. Treat the `res` result variable the same way you would treat the return variable of a `<cfdbinfo>` call.
3. Currently the _tables_ and _columns_ `type` attribute parameters are supported.  I plan to implement support for all parameters eventually.

## Caveats

* Currently the `pattern`, `username`, and `password` attributes are currently unsupported.  I plan to implement `pattern`, but not necessarily `username` and `password` (I use DSNs exclusively).  If time permits, I will implement `username` and `password`.
* You must have _at least_ ColdFusion **9.0.1** to use this CFC.  9.0.1 added support for the `dbinfo` method in CFScript.
* Tested on ColdFusion Enterprise 9.0.1 with SQL Server 2008 R2.  I will try to test with subsequent versions of SQL Server and CF as time permits.

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
* The argument could be made that this sort of metadata could be stored in additional tables in the database.  While this is true, I think it ignores the notion of a self-documenting database (through internal mechanisms) and goes against the idea of `<cfdbinfo>` altogether; that is, that we're getting data about the database from the database (not from an ancillary table structure that we've set up ourselves).

[1]: http://blog.bradleyscampbell.net
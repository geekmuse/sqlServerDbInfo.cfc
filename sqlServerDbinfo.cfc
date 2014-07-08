<cfscript>
component
  output="false"
  hint="I provide extensions to <cfdbinfo>-like operations for SQL Server"
  {
    /**
     *  @description Emulates the <cfdbinfo> tag with type = "columns", but uses SQL Server's "Description" property to populate the "Remarks" column
     *  @output false
     */
    public query function columns(required string datasource, required string tableName) {
      stockDbInfo = new dbinfo(datasource=arguments.datasource).columns(table=arguments.tableName);
      dbColNames = valueList(stockDbInfo.COLUMN_NAME);
      q = new Query();
      q.setDatasource(arguments.datasource);
      q.addParam(name="sql_server_table_name", cfsqltype="cf_sql_varchar", value=arguments.tableName);
      q.addParam(name="sql_server_column_names", cfsqltype="cf_sql_varchar", list="yes", value=dbColNames);
      // Look for column metadata in the SYS tables
      q.setSQL("SELECT sep.value [Description] FROM sys.tables st INNER JOIN sys.columns sc ON st.object_id = sc.object_id LEFT JOIN sys.extended_properties sep ON st.object_id = sep.major_id AND sc.column_id = sep.minor_id AND sep.name = 'MS_Description' WHERE st.name = :sql_server_table_name AND sc.name IN ( :sql_server_column_names );");
      res = q.execute();
      resQ = res.getResult();
      // Compare our query with that of the dbinfo query object.
      //  For matches that are found, insert our found data back into the dbinfo query object
      for (i=1; i lte stockDbInfo.recordCount; i++) {
        stockDbInfo["Remarks"][i] = resQ["Description"][i];
      }
      return (stockDbInfo);
    }

    /**
    * @description Emulates the <cfdbinfo> tag with type = "tables", but uses SQL Server's fn_listextendedproperty function to get extended attributes of tables
    * @output false
    */
    public query function tables(required string datasource) {
      stockDbInfo = new dbinfo(datasource=arguments.datasource).tables();
      q = new Query();
      q.setDatasource(arguments.datasource);
      q.setSQL("SELECT objname, name, value FROM fn_listextendedproperty(NULL, 'schema', 'dbo', 'table', default, NULL, NULL);");
      res = q.execute();
      resQ = res.getResult();
      // Build up a struct of metadata for each table (a table can have more than one entry)
      //  Accordingly, a struct of structs is built
      tablesMeta = structNew();
      for (i=1; i lte resQ.recordCount; i++) {
        obj = resQ["Objname"][i];
        if (!structKeyExists(tablesMeta, obj)) {
          structInsert(tablesMeta, obj, structNew());
          structInsert(tablesMeta[obj], resQ["Name"][i], resQ["Value"][i]);
        } else {
          structInsert(tablesMeta[obj], resQ["Name"][i], resQ["Value"][i]);
        }
      }
      // Flatten each interior struct and store it back on its original key,
      //  overwriting the original struct
      for (k in tablesMeta) {        
        structJsonData = serializeJSON(tablesMeta[k]);
        structDelete(tablesMeta, k);
        structInsert(tablesMeta, k, structJsonData);
      }

      // Compare found metadata values in tablesMeta to original dbinfo query.
      //  If metadata was found for a table, insert it into the appropriate
      //  position in the dbinfo query object.
      for (i=1; i lte stockDbInfo.recordCount; i++) {
        obj = stockDbInfo["TABLE_NAME"][i];
        if (structKeyExists(tablesMeta, obj)) {
          stockDbInfo["Remarks"][i] = tablesMeta[obj];
        }
      }
      return (stockDbInfo);
    }

}
</cfscript>

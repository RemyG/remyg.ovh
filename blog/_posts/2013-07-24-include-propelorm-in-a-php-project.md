---
title: Include PropelORM in a PHP project
date: 2013-07-24T18:00:06+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - PHP
  - PropelORM
deprecated: true
---

[PropelORM](http://propelorm.org/) is an open-source Object-Relational Mapping (ORM) for PHP5. It allows you to access your database using a set of objects, providing a simple API for storing and retrieving data.

In this article, I'll explain how to use PropelORM in an existing PHP project.

<!--more-->

## Download and installation

If your project is using [Git](http://git-scm.com/):

* go to the root of the project:
```
cd myproject
```
* download Propel as a submodule of your project (if you want to download Propel in ```myproject/application/plugins/propel```):
```
git submodule add https://github.com/propelorm/Propel.git application/plugins/propel
```
* commit the submodule:
```
git commit -m "Added PropelORM as a submodule"
```

If your project doesn't use Git:

* go to the subdirectory ```application/plugins``` in your project and create a directory ```propel```:
```
cd myproject/application/plugins
mkdir propel
```
* download the latest version of PropelORM as a [ZIP file](https://github.com/propelorm/Propel/zipball/master) or a [TAR.GZ file](https://github.com/propelorm/Propel/tarball/master)
* extract the content of the archive in the newly created ```myproject/application/plugins/propel``` folder

PropelORM uses a script to generate the mapping code. You have to create a symbolic link to the script in the ```application``` directory of your project:
```
cd myproject/application
ln -s plugins/propel/generator/bin/propel-gen propel-gen
```

## Configuration

Create a file ```myproject/application/build.properties``` which will contain the basic information about the project and DB connection:
```
cd myproject/application
touch build.properties
```

This file contains:

```
# Project name
propel.project = project_name
# Connection parameters
propel.database = mysql
# If you want to automatically update the DB, set the following values:
propel.database.url = mysql:host=db_host;dbname=db_name
propel.database.user = db_user
propel.database.password = db_password
```

## DB schema creation

The DB schema is defined in the file ```myproject/application/schema.xml```. You can find on the PropelORM documentation everything you need to build your DB schema: [creation of the file](http://propelorm.org/documentation/02-buildtime.html#describing-your-database-as-xml-schema) and *schema format*.

## Code generation

Once these files are created and contain the correct data, you can use the ```propel-gen``` script to generate the mapping source.

### To generate the Object Model

```
cd myproject/application
./propel-gen om
```

### To generate the SQL file

```
cd myproject/application
./propel-gen sql
```

### To update the DB with the SQL file (need the DB connection info)

```
cd myproject/application
./propel-gen insert-sql
```

## Runtime connection settings creation

For PropelORM to be able to be linked to the DB when running, you'll need to create a configuration file that defines the DB connection.

```
cd myproject/application
touch runtime-conf.xml
```

This file must contains a configuration like:

```
<?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?>
<config>
  <propel>
    <datasources default=&quot;project_name&quot;>
      <datasource id=&quot;project_name&quot;>
        <adapter>mysql</adapter> <!-- sqlite, mysql, mssql, oracle, or pgsql -->
        <connection>
          <dsn>mysql:host=db_host;dbname=db_name</dsn>
          <user>db_user</user>
          <password>db_password</password>
        </connection>
      </datasource>
    </datasources>
  </propel>
</config>
```

The content of the file is described in the PropelORM documentation: [Writing The XML Runtime Configuration](http://propelorm.org/documentation/02-buildtime.html#writing-the-xml-runtime-configuration).

Notice how the id attribute of the ```<datasource>``` tag matches the connection name defined in the ```<database>``` tag of the ```schema.xml```. This is how Propel maps a database description to a connection.

To build the runtime conf:
```
cd myproject/application
./propel-gen convert-conf
```

To run the 3 commands (om, sql, and convert-conf):
```
cd myproject/application
./propel-gen
```

## Including PropelORM in your PHP code

Include in a setup/config file:
```
<?php
// Include the main Propel script
require_once '/path/to/propel/runtime/lib/Propel.php';
// Initialize Propel with the runtime configuration
Propel::init("/path/to/bookstore/build/conf/rgcms-conf.php");
// Add the generated 'classes' directory to the include path
set_include_path("/path/to/bookstore/build/classes" . PATH_SEPARATOR . get_include_path());
```


## Using PropelORM inside your project

You can find how to use PropelORM on [the official documentation](http://propelorm.org/documentation/).

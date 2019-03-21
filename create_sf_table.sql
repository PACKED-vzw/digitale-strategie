DROP DATABASE IF EXISTS digitale_strategie_hasselt;

CREATE DATABASE digitale_strategie_Hasselt; /* only do this the first time
+ change it to the name you want */

use digitale_strategie_Hasselt; 

CREATE TABLE siegfried( 
    filename VARCHAR(255),
    filesize BIGINT,
    modified VARCHAR(255),
    errors VARCHAR(255),
    md5 CHAR(32),
    namespace CHAR(6),
    id VARCHAR(10),
    format VARCHAR(100),
    version VARCHAR(100),
    mime VARCHAR(100),
    basis VARCHAR(255),
    warning TEXT,
    server VARCHAR(100),
    organisation VARCHAR(50),
    PRIMARY KEY (filename, modified) /* not md5 because of duplicate files. this is also why 
    it's a composite primary key. 
    primary key to prevent accidentally importing the same csv file. */
);
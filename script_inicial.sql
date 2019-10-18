SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP DATABASE IF EXISTS imdb;
CREATE DATABASE imdb;
USE imdb;

-- types e attributes foram retirados pois são muito inconstantes
DROP TABLE IF EXISTS takas;
CREATE TABLE takas (
    titleId  VARCHAR(30) NOT NULL,
    ordering  INT NOT NULL,
    title VARCHAR(30),
    region VARCHAR(3),
    language VARCHAR(15),
    isOriginalTitle TINYINT NOT NULL,
    PRIMARY KEY (titleId,ordering)
);

CREATE INDEX `fk_takas_ordering` ON `imdb`.`takas` (`ordering` ASC) VISIBLE;


DROP TABLE IF EXISTS tbasics;
CREATE TABLE tbasics (
    tconst  VARCHAR(30) NOT NULL,
    titleType  VARCHAR(30) NOT NULL,
    primaryTitle VARCHAR(30),
    originalTitle VARCHAR(3),
    isAdult TINYINT,
    startYear INT(4),
    endYear INT(4),
    runtimeMinutes INT,
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS nbasics;
CREATE TABLE nbasics (
    nconst  VARCHAR(30) NOT NULL,
    primaryName  VARCHAR(30) NOT NULL,
    birthYear INT(4),
    PRIMARY KEY (nconst)
);

DROP TABLE IF EXISTS tgenres;
CREATE TABLE tgenres (
    id_genres  INT NOT NULL auto_increment,
    genres VARCHAR(15),
    PRIMARY KEY (id_genres)
);

DROP TABLE IF EXISTS tgenres_basics;
CREATE TABLE tgenres_basics (
    id_genres  INT NOT NULL,
    tconst  VARCHAR(30) NOT NULL,
	FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    FOREIGN KEY(id_genres) REFERENCES tgenres(id_genres),
    PRIMARY KEY (id_genres,tconst)
);



DROP TABLE IF EXISTS tepisode;
CREATE TABLE tepisode (
    tconst  VARCHAR(30) NOT NULL,
    parentTconst  VARCHAR(30) NOT NULL,
    seasonNumber INT,
    episodeNumber INT,
    FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    PRIMARY KEY (tconst, parentTconst)
);

DROP TABLE IF EXISTS tprincipals;
CREATE TABLE tprincipals (
    tconst  VARCHAR(30) NOT NULL,
    ordering  INT NOT NULL,
    nconst VARCHAR(30) NOT NULL,
    category VARCHAR(30) NOT NULL,
    job VARCHAR(30) NOT NULL,
    characters VARCHAR(30) NOT NULL,
    FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    FOREIGN KEY(ordering) REFERENCES takas(ordering),
    FOREIGN KEY(nconst) REFERENCES nbasics(nconst),
    PRIMARY KEY (tconst, ordering, nconst)
);

DROP TABLE IF EXISTS tratings;
CREATE TABLE tratings (
    tconst  VARCHAR(30) NOT NULL,
    averageRating  FLOAT,
    numVotes INT,
    FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS knownForTitles ;
CREATE TABLE knownForTitles  (
    nconst  VARCHAR(30) NOT NULL,
    tconst VARCHAR(30) NOT NULL,
    FOREIGN KEY(nconst) REFERENCES nbasics(nconst),
    FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    PRIMARY KEY (tconst, nconst)
);

DROP TABLE IF EXISTS profession;
CREATE TABLE profession (
    id_profession INT NOT NULL auto_increment,
    professionName VARCHAR(30),
    PRIMARY KEY (id_profession)
);

DROP TABLE IF EXISTS primaryProfession;
CREATE TABLE primaryProfession (
    nconst  VARCHAR(30) NOT NULL,
    id_profession INT NOT NULL,
    FOREIGN KEY(nconst) REFERENCES nbasics(nconst),
    FOREIGN KEY(id_profession) REFERENCES profession(id_profession),
    PRIMARY KEY (id_profession, nconst)
);


DROP TABLE IF EXISTS twriters;
CREATE TABLE twriters (
    nconst  VARCHAR(30) NOT NULL,
    tconst  VARCHAR(30) NOT NULL,
    FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    FOREIGN KEY(nconst) REFERENCES nbasics(nconst),
    PRIMARY KEY (nconst,tconst)
);

DROP TABLE IF EXISTS tdirectors;
CREATE TABLE tdirectors (
    nconst  VARCHAR(30) NOT NULL,
    tconst  VARCHAR(30) NOT NULL,
    FOREIGN KEY(tconst) REFERENCES tbasics(tconst),
    FOREIGN KEY(nconst) REFERENCES nbasics(nconst),
    PRIMARY KEY (nconst,tconst)
);

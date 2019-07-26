
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
PRAGMA foreign_keys = ON;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  parent_id INTEGER,
  questions_id INTEGER NOT NULL,
  users_replying_id INTEGER NOT NULL,
  body VARCHAR(255),

  FOREIGN KEY (users_replying_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)  
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,

  FOREIGN KEY (users_id) REFERENCES users(id),
  FOREIGN KEY (questions_id) REFERENCES questions(id)
);
  -- id INTEGER PRIMARY KEY,
  -- fname VARCHAR(255),
  -- lname VARCHAR(255)
INSERT INTO 
  users (fname, lname)
VALUES
  ('Jimny','Pham'),
  ('Jeff','Bui'),
  ('Gordon','Ramsay'),
  ('Lebron','TheGoat'),
  ('Anthony','Davis');

  -- id INTEGER PRIMARY KEY,
  -- title VARCHAR(255),
  -- body VARCHAR(255)
INSERT INTO 
  questions (title,body,author_id)
VALUES 
  ('why?','how?',5),
  ('Remove the top toolbar from wkwebview keyboard','Im currently creating an app based out of a WKWebView and every time a keyboard pops up a toolbar above it shows like this:',4),
  ('App keeps crashing when login button is clicked','When I click the Login or Register button the app completely crashes. ',3),
  ('How to extend multiple modules and read from one file?',"Is it possible to create one file that will use as an extension to 3rd party libraries ? I've tried to create a global-modifying-module.d.ts file even though the linter gives me the",2),
  ('How can I extend JVM bytecode?','I want to create a programming language that compiles to its own bytecode format and a VM that interprets it. ',1);


INSERT INTO 
  question_follows (users_id,questions_id)
VALUES
  (1,3),
  (2,2),
  (3,1),
  (4,5),
  (1,5),
  (2,5),
  (3,5),

  (5,4);


INSERT INTO 
  replies (parent_id,questions_id,users_replying_id,body)
VALUES
 (null,1,1,"who dis"),
 (null,1,2,"dummy user"),
 (1,1,4,"I'm a child response"),
 (null,3,3,"dummy user")
 ;

 INSERT INTO 
  question_likes (questions_id, users_id)
 VALUES
  (1, 5),
  (1, 4),
  (2, 3),
  (3, 3),
  (4, 1),
  (4, 2);


 

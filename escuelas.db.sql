BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "distrito" (
	"DistritoId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("DistritoId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "turno" (
	"TurnoId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("TurnoId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "prioridad" (
	"PrioridadId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("PrioridadId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "curso" (
	"CursoId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("CursoId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "escuela" (
	"EscuelaId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(200) NOT NULL UNIQUE,
	"DistritoId"	INTEGER NOT NULL,
	"AutoridadId"	INTEGER NOT NULL,
	"Domicilio"	NVARCHAR(70),
	"Ciudad"	NVARCHAR(40),
	"CodigoPostal"	NVARCHAR(10),
	"Telefono"	NVARCHAR(24) NOT NULL UNIQUE,
	"Email"	NVARCHAR(60) NOT NULL UNIQUE,
	"LocationGeo"	NVARCHAR(40),
	"EduEspecial"	BOOLEAN NOT NULL DEFAULT 0 CHECK("EduEspecial" IN (0, 1)),
	FOREIGN KEY("DistritoId") REFERENCES "distrito"("DistritoId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	PRIMARY KEY("EscuelaId" AUTOINCREMENT),
	FOREIGN KEY("AutoridadId") REFERENCES "personal"("PersonalId") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "categoria" (
	"CatId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("CatId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "funcion" (
	"FuncionId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("FuncionId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "personal" (
	"PersonalId"	INTEGER NOT NULL,
	"Apellido"	NVARCHAR(20) NOT NULL,
	"Nombre"	NVARCHAR(20) NOT NULL,
	"CatId"	INTEGER NOT NULL,
	"FuncionId"	INTEGER NOT NULL,
	"Telefono"	NVARCHAR(24),
	"Email"	NVARCHAR(60),
	"DocEspecial"	BOOLEAN NOT NULL DEFAULT 0 CHECK("DocEspecial" IN (0, 1)),
	"Conduccion"	BOOLEAN NOT NULL DEFAULT 0 CHECK("Conduccion" IN (0, 1)),
	"Apoyo"	BOOLEAN NOT NULL DEFAULT 0 CHECK("Apoyo" IN (0, 1)),
	PRIMARY KEY("PersonalId" AUTOINCREMENT),
	FOREIGN KEY("FuncionId") REFERENCES "funcion"("FuncionId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	UNIQUE("Apellido","Nombre"),
	FOREIGN KEY("CatId") REFERENCES "categoria"("CatId") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "ciclo" (
	"CicloId"	INTEGER NOT NULL,
	"Nombre"	NVARCHAR(40),
	PRIMARY KEY("CicloId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "unidad_especial" (
	"UnidadId"	INTEGER NOT NULL,
	"EscuelaId"	INTEGER NOT NULL,
	"TurnoId"	INTEGER NOT NULL,
	"CicloId"	INTEGER NOT NULL,
	"ConduccionId"	INTEGER NOT NULL,
	"Periodo"	NVARCHAR(10) NOT NULL,
	"Descripcion"	NVARCHAR(40),
	PRIMARY KEY("UnidadId" AUTOINCREMENT),
	FOREIGN KEY("TurnoId") REFERENCES "turno"("TurnoId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY("ConduccionId") REFERENCES "personal"("PersonalId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	UNIQUE("EscuelaId","Periodo","TurnoId","CicloId"),
	FOREIGN KEY("CicloId") REFERENCES "ciclo"("CicloId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY("EscuelaId") REFERENCES "escuela"("EscuelaId") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "unidad_items" (
	"UnidadLineId"	INTEGER NOT NULL,
	"UnidadId"	INTEGER NOT NULL,
	"DocenteId"	INTEGER NOT NULL,
	FOREIGN KEY("DocenteId") REFERENCES "personal"("PersonalId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY("UnidadId") REFERENCES "unidad_especial"("UnidadId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	PRIMARY KEY("UnidadLineId" AUTOINCREMENT),
	UNIQUE("UnidadId","DocenteId")
);
CREATE TABLE IF NOT EXISTS "inspeccion" (
	"InspeccionId"	INTEGER NOT NULL,
	"UnidadId"	INTEGER NOT NULL,
	"InspeccionDate"	DATETIME NOT NULL,
	"Observacion"	NVARCHAR(500),
	"PrioridadId"	INTEGER NOT NULL,
	"Apoyo"	BOOLEAN NOT NULL CHECK("Apoyo" IN (0, 1)),
	PRIMARY KEY("InspeccionId" AUTOINCREMENT),
	FOREIGN KEY("UnidadId") REFERENCES "unidad_especial"("UnidadId") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "inspeccion_apoyo" (
	"InspeccionLineId"	INTEGER NOT NULL,
	"InspeccionId"	INTEGER NOT NULL,
	"ApoyoId"	INTEGER NOT NULL,
	PRIMARY KEY("InspeccionLineId" AUTOINCREMENT),
	UNIQUE("InspeccionId","ApoyoId"),
	FOREIGN KEY("InspeccionId") REFERENCES "inspeccion"("InspeccionId") ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY("ApoyoId") REFERENCES "personal"("PersonalId") ON DELETE NO ACTION ON UPDATE NO ACTION
);
INSERT INTO "distrito" VALUES (1,'Distrito 1');
INSERT INTO "distrito" VALUES (2,'Distrito 2');
INSERT INTO "distrito" VALUES (3,'Distrito 3');
INSERT INTO "distrito" VALUES (4,'Distrito 4');
INSERT INTO "distrito" VALUES (5,'Distrito 5');
INSERT INTO "turno" VALUES (1,'Mañana');
INSERT INTO "turno" VALUES (2,'Tarde');
INSERT INTO "turno" VALUES (3,'Doble Turno');
INSERT INTO "prioridad" VALUES (1,'Alta');
INSERT INTO "prioridad" VALUES (2,'Media');
INSERT INTO "prioridad" VALUES (3,'Baja');
INSERT INTO "curso" VALUES (1,'1 A');
INSERT INTO "curso" VALUES (2,'1 B');
INSERT INTO "curso" VALUES (3,'2 A');
INSERT INTO "curso" VALUES (4,'2 B');
INSERT INTO "curso" VALUES (5,'3 A');
INSERT INTO "escuela" VALUES (1,'Escuela 20',1,11,'','','','25251111','esc20@gmail.com','',0);
INSERT INTO "escuela" VALUES (2,'Escuela 30',1,12,'','','','25252222','esc30@gmail.com','',0);
INSERT INTO "escuela" VALUES (3,'Escuela 40',3,14,'','','','35252222','esc40@gmail.com','',0);
INSERT INTO "escuela" VALUES (4,'Escuela 50',3,13,'','','','45252222','esc50@gmail.com','',0);
INSERT INTO "escuela" VALUES (5,'Escuela 60',2,21,'','','','25257777','esc60@gmail.com','',0);
INSERT INTO "escuela" VALUES (6,'Escuela 70',2,22,'','','','34347777','esc70@gmail.com','',0);
INSERT INTO "escuela" VALUES (7,'Escuela 45 "Manuel Belgrano"',5,14,'Galicia 1500','CABA','1407','85857889','manubelg@gmail.com','',1);
INSERT INTO "escuela" VALUES (8,'Escuela 28 "Alberdi"',4,21,'','','','','','',0);
INSERT INTO "categoria" VALUES (0,'Sin Categoria');
INSERT INTO "categoria" VALUES (1,'Docente');
INSERT INTO "categoria" VALUES (2,'Directivo');
INSERT INTO "categoria" VALUES (3,'Conduccion');
INSERT INTO "categoria" VALUES (4,'Apoyo');
INSERT INTO "funcion" VALUES (0,'Sin Funcion');
INSERT INTO "funcion" VALUES (1,'Maestro');
INSERT INTO "funcion" VALUES (2,'Psicologo');
INSERT INTO "funcion" VALUES (3,'PsicoPedagogo');
INSERT INTO "funcion" VALUES (4,'Motricidad');
INSERT INTO "funcion" VALUES (5,'ViceDirector');
INSERT INTO "funcion" VALUES (6,'Director');
INSERT INTO "personal" VALUES (0,'Sin','Nombre',0,0,'','',0,0,0);
INSERT INTO "personal" VALUES (1,'Funes','Juan',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (2,'Diaz','Laura',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (3,'Paredes','Eduardo',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (4,'Paredes','Maria',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (5,'Rava','Juan',1,1,'71112222','rava@gmail.com',1,0,0);
INSERT INTO "personal" VALUES (6,'Ponce','Laura',1,1,'81112222','ponce@gmail.com',1,0,0);
INSERT INTO "personal" VALUES (7,'Pinti','Jaime',1,1,'91112222','pinti@gmail.com',1,0,0);
INSERT INTO "personal" VALUES (8,'Manso','Maria',1,1,'99112222','manso@gmail.com',1,0,0);
INSERT INTO "personal" VALUES (9,'Ramirez','Juan',1,1,'25112222','ramirez@gmail.com',0,0,0);
INSERT INTO "personal" VALUES (10,'Ramirez','Julia',1,1,'25118887','jramirez@gmail.com',0,0,0);
INSERT INTO "personal" VALUES (11,'Pazos','Paula',2,6,'','',0,1,0);
INSERT INTO "personal" VALUES (12,'Salas','Leonardo',2,6,'','',0,1,0);
INSERT INTO "personal" VALUES (13,'Russo','Luis',2,6,'','',0,1,0);
INSERT INTO "personal" VALUES (14,'Madero','Jimena',2,6,'','',0,1,0);
INSERT INTO "personal" VALUES (15,'Branco','Maria',3,3,'','',0,0,0);
INSERT INTO "personal" VALUES (16,'Zappa','Lina',4,3,'','',0,0,1);
INSERT INTO "personal" VALUES (17,'Caruso','Jose',4,3,'','',0,0,1);
INSERT INTO "personal" VALUES (18,'Perez','Camila',4,4,'','',0,0,1);
INSERT INTO "personal" VALUES (19,'Lamarca','Carlos',4,4,'','',0,0,1);
INSERT INTO "personal" VALUES (20,'Ramon','Caminos',3,4,'','',0,0,0);
INSERT INTO "personal" VALUES (21,'Lazo','Juan',2,6,'','',0,1,0);
INSERT INTO "personal" VALUES (22,'Saba','Juan',2,6,'','',0,1,0);
INSERT INTO "personal" VALUES (23,'Saba','Ana',2,5,'','',0,1,0);
INSERT INTO "personal" VALUES (24,'Lineo','Jose',2,5,'','',0,1,0);
INSERT INTO "personal" VALUES (25,'Manes','Laura',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (26,'Casals','Jorge',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (27,'Ramirez','Luis',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (28,'Daniele','Luis',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (29,'Fraga','Mario',1,1,'+541145237291','fragam@gmail.com',1,0,0);
INSERT INTO "personal" VALUES (30,'Linares','Rosa',4,2,'','',0,0,1);
INSERT INTO "personal" VALUES (31,'Pazos','Leandro',1,1,'','',1,0,0);
INSERT INTO "personal" VALUES (32,'Simone','Mercedes',2,5,'','',0,1,0);
INSERT INTO "personal" VALUES (33,'Salom','Enriqueta',4,4,'','',0,0,1);
INSERT INTO "personal" VALUES (34,'Sapag','Laura',1,1,'','',1,0,0);
INSERT INTO "ciclo" VALUES (1,'Primer Ciclo');
INSERT INTO "ciclo" VALUES (2,'Segundo Ciclo');
INSERT INTO "unidad_especial" VALUES (1,1,1,1,15,'Año 2022','Esc.20-Mañana-C1-2022');
INSERT INTO "unidad_especial" VALUES (2,1,2,1,15,'Año 2022','Esc.20-Tarde-C1-2022');
INSERT INTO "unidad_especial" VALUES (3,3,1,1,15,'Año 2022','Esc.40-Mañana-C1-2022');
INSERT INTO "unidad_especial" VALUES (4,3,1,2,15,'Año 2022','Esc.40-Mañana-C2-2022');
INSERT INTO "unidad_especial" VALUES (5,4,1,2,21,'Año 2022','Esc.50-Mañana-C2-2022');
INSERT INTO "unidad_especial" VALUES (6,2,2,2,24,'Año 2022','Esc.30-Tarde-C2-2022');
INSERT INTO "unidad_especial" VALUES (7,6,1,1,32,'Año 2022','Esc.70-Mañana-C1-2022');
INSERT INTO "unidad_especial" VALUES (8,5,1,1,32,'Año 2022','Esc.60-Mañana-C1-2022');
INSERT INTO "unidad_especial" VALUES (9,7,1,2,32,'Año 2022','Esc.45-Mañana-C2-2022');
INSERT INTO "unidad_items" VALUES (1,1,1);
INSERT INTO "unidad_items" VALUES (2,1,2);
INSERT INTO "unidad_items" VALUES (3,2,3);
INSERT INTO "unidad_items" VALUES (4,2,4);
INSERT INTO "unidad_items" VALUES (5,3,5);
INSERT INTO "unidad_items" VALUES (6,3,6);
INSERT INTO "unidad_items" VALUES (7,4,7);
INSERT INTO "unidad_items" VALUES (8,4,8);
INSERT INTO "unidad_items" VALUES (9,5,7);
INSERT INTO "unidad_items" VALUES (10,5,8);
INSERT INTO "unidad_items" VALUES (11,6,27);
INSERT INTO "unidad_items" VALUES (12,6,28);
INSERT INTO "unidad_items" VALUES (13,7,29);
INSERT INTO "unidad_items" VALUES (14,7,31);
INSERT INTO "unidad_items" VALUES (15,8,28);
INSERT INTO "unidad_items" VALUES (16,8,27);
INSERT INTO "unidad_items" VALUES (17,9,31);
INSERT INTO "unidad_items" VALUES (18,9,34);
INSERT INTO "inspeccion" VALUES (1,1,'2022-05-01 12:00:00','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet commodo nulla facilisi nullam vehicula ipsum a. Commodo elit at imperdiet dui accumsan sit. Diam quam nulla porttitor massa id. Eu lobortis elementum nibh tellus. Pretium quam vulputate dignissim suspendisse in est ante in nibh. Ultrices sagittis orci a scelerisque purus semper. Sit amet est placerat in egestas erat imperdiet sed euismod. Et molestie ac feugiat sed lectus vestibulum. Scelerisque purus semper eget duis at tellus at urna condimentum. Leo urna molestie at elementum eu facilisis sed odio morbi. Proin nibh nisl condimentum id venenatis a. Viverra nibh cras pulvinar mattis. Tincidunt eget nullam non nisi est sit amet facilisis. Nunc sed velit dignissim sodales ut eu sem integer vitae. Lacus vestibulum sed arcu non odio. Rhoncus urna neque viverra justo nec ultrices dui sapien eget.',1,0);
INSERT INTO "inspeccion" VALUES (2,1,'2022-05-05 12:00:00','Non consectetur a erat nam at lectus urna duis. Dictum varius duis at consectetur lorem donec. Amet venenatis urna cursus eget nunc scelerisque viverra mauris. Sit amet luctus venenatis lectus magna. Faucibus interdum posuere lorem ipsum. Non quam lacus suspendisse faucibus interdum. Ut tortor pretium viverra suspendisse potenti nullam ac. Mattis nunc sed blandit libero volutpat sed. Amet massa vitae tortor condimentum lacinia.',1,1);
INSERT INTO "inspeccion" VALUES (3,1,'2022-05-10 12:00:00','Tempor id eu nisl nunc mi. Lacus sed turpis tincidunt id aliquet risus. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien. Nec nam aliquam sem et. Sed pulvinar proin gravida hendrerit lectus. In vitae turpis massa sed elementum tempus egestas. Pellentesque nec nam aliquam sem et tortor. Tortor consequat id porta nibh. Commodo ullamcorper a lacus vestibulum sed. Dui accumsan sit amet nulla facilisi morbi tempus iaculis urna. Ut enim blandit volutpat maecenas volutpat blandit aliquam. Tempor commodo ullamcorper a lacus vestibulum sed arcu non.',1,1);
INSERT INTO "inspeccion" VALUES (4,3,'2022-05-10 12:00:00','Justo nec ultrices dui sapien eget mi proin sed libero. Lobortis mattis aliquam faucibus purus in massa tempor nec. Eget nullam non nisi est sit amet facilisis magna etiam. Ultrices sagittis orci a scelerisque purus semper eget duis. Gravida rutrum quisque non tellus orci ac. Blandit volutpat maecenas volutpat blandit. Adipiscing commodo elit at imperdiet dui accumsan sit. Amet massa vitae tortor condimentum lacinia. Tortor condimentum lacinia quis vel eros donec ac. Turpis egestas pretium aenean pharetra magna ac placerat vestibulum.',1,0);
INSERT INTO "inspeccion" VALUES (5,4,'2022-05-05 12:00:00','Cursus mattis molestie a iaculis. Tristique senectus et netus et. Posuere ac ut consequat semper viverra nam libero justo laoreet. Fermentum odio eu feugiat pretium nibh ipsum consequat. Sit amet cursus sit amet dictum sit amet. Ullamcorper sit amet risus nullam. Rhoncus est pellentesque elit ullamcorper. Etiam tempor orci eu lobortis elementum. Mi tempus imperdiet nulla malesuada pellentesque elit. Quam quisque id diam vel quam elementum pulvinar. Maecenas accumsan lacus vel facilisis volutpat est velit. Ut placerat orci nulla pellentesque dignissim. Metus dictum at tempor commodo ullamcorper a lacus vestibulum.',1,0);
INSERT INTO "inspeccion" VALUES (6,4,'2022-05-10 12:00:00','Lacus laoreet non curabitur gravida arcu ac tortor dignissim convallis. Auctor urna nunc id cursus metus aliquam. Commodo viverra maecenas accumsan lacus vel facilisis volutpat. Dui vivamus arcu felis bibendum ut tristique et. Eget velit aliquet sagittis id consectetur purus ut faucibus. Mauris cursus mattis molestie a iaculis at erat. Tincidunt id aliquet risus feugiat in ante metus dictum. Aenean sed adipiscing diam donec adipiscing tristique. Sit amet mauris commodo quis imperdiet massa. Mauris vitae ultricies leo integer. Est lorem ipsum dolor sit amet consectetur adipiscing elit pellentesque. Diam sollicitudin tempor id eu nisl.',1,1);
INSERT INTO "inspeccion" VALUES (7,1,'2022-05-16 01:57:00','Libero enim sed faucibus turpis in eu mi bibendum. At risus viverra adipiscing at in tellus integer feugiat. Non sodales neque sodales ut etiam. Dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim. Fringilla ut morbi tincidunt augue interdum velit. Enim diam vulputate ut pharetra sit amet aliquam id diam. Volutpat odio facilisis mauris sit. Augue eget arcu dictum varius duis. Netus et malesuada fames ac turpis egestas maecenas pharetra. Tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Blandit libero volutpat sed cras ornare. Nullam ac tortor vitae purus faucibus ornare.',1,1);
INSERT INTO "inspeccion" VALUES (8,4,'2022-05-16 01:58:00','Accumsan lacus vel facilisis volutpat est velit. Ligula ullamcorper malesuada proin libero. Cursus mattis molestie a iaculis at erat pellentesque. Et malesuada fames ac turpis egestas. Risus nullam eget felis eget nunc lobortis. Massa enim nec dui nunc. Vivamus arcu felis bibendum ut tristique et egestas quis ipsum. Nisi est sit amet facilisis magna etiam tempor orci eu. Varius vel pharetra vel turpis nunc eget lorem dolor. Quisque egestas diam in arcu cursus euismod quis. Aliquam id diam maecenas ultricies mi eget mauris pharetra et. Libero volutpat sed cras ornare arcu dui. Ipsum dolor sit amet consectetur adipiscing elit pellentesque habitant morbi. Massa sapien faucibus et molestie ac feugiat sed lectus vestibulum. Pellentesque dignissim enim sit amet venenatis urna cursus eget.',2,0);
INSERT INTO "inspeccion" VALUES (9,4,'2022-05-16 12:01:00','Turpis massa tincidunt dui ut. Magna fringilla urna porttitor rhoncus dolor. Purus sit amet luctus venenatis lectus magna fringilla urna porttitor. Egestas diam in arcu cursus. Sagittis orci a scelerisque purus semper eget. Risus in hendrerit gravida rutrum quisque non tellus orci. Urna duis convallis convallis tellus id interdum. Diam quam nulla porttitor massa id neque. Nullam ac tortor vitae purus faucibus ornare suspendisse sed nisi. At urna condimentum mattis pellentesque id. Ultrices dui sapien eget mi. Hac habitasse platea dictumst vestibulum rhoncus. Sed cras ornare arcu dui. Turpis egestas maecenas pharetra convallis. Et ultrices neque ornare aenean euismod. Duis at consectetur lorem donec massa sapien faucibus. Semper auctor neque vitae tempus quam. Feugiat in fermentum posuere urna nec tincidunt.',1,1);
INSERT INTO "inspeccion" VALUES (10,4,'2022-05-16 14:56:00','Tortor at risus viverra adipiscing at in tellus integer feugiat. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum enim. Posuere urna nec tincidunt praesent semper feugiat. Sit amet risus nullam eget felis eget nunc lobortis. Vitae proin sagittis nisl rhoncus mattis rhoncus urna neque viverra. Faucibus interdum posuere lorem ipsum dolor sit amet. Ut venenatis tellus in metus vulputate eu. Gravida dictum fusce ut placerat orci nulla pellentesque. Amet est placerat in egestas erat imperdiet sed euismod nisi. Sit amet consectetur adipiscing elit pellentesque. Augue ut lectus arcu bibendum. Elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus. Tristique et egestas quis ipsum suspendisse. Scelerisque in dictum non consectetur a. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Augue interdum velit euismod in pellentesque massa placerat. Arcu ac tortor dignissim convallis aenean et. Augue eget arcu dictum varius duis.',3,1);
INSERT INTO "inspeccion" VALUES (11,2,'2022-05-16 14:57:00','Pellentesque nec nam aliquam sem. Sed velit dignissim sodales ut eu sem integer. Sed ullamcorper morbi tincidunt ornare massa eget egestas. Sit amet massa vitae tortor condimentum. Diam donec adipiscing tristique risus nec. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet. Elit duis tristique sollicitudin nibh sit amet commodo. In nisl nisi scelerisque eu ultrices vitae auctor. In nisl nisi scelerisque eu ultrices vitae auctor eu.',2,0);
INSERT INTO "inspeccion" VALUES (12,5,'2022-05-20 01:20:00','Tristique nulla aliquet enim tortor at auctor. Sed elementum tempus egestas sed sed risus pretium quam vulputate. Vitae proin sagittis nisl rhoncus mattis. Ultricies integer quis auctor elit sed vulputate mi sit amet. Elementum pulvinar etiam non quam lacus suspendisse. Cursus in hac habitasse platea dictumst quisque sagittis. Enim neque volutpat ac tincidunt vitae semper quis lectus nulla. Volutpat lacus laoreet non curabitur gravida. Dolor sed viverra ipsum nunc aliquet bibendum enim facilisis gravida. Habitant morbi tristique senectus et netus et malesuada. Convallis posuere morbi leo urna molestie at elementum eu. Fames ac turpis egestas maecenas pharetra. Vitae elementum curabitur vitae nunc sed velit dignissim. At elementum eu facilisis sed. Elementum nisi quis eleifend quam adipiscing vitae proin sagittis. Phasellus faucibus scelerisque eleifend donec pretium vulputate sapien nec. Turpis massa sed elementum tempus egestas sed sed. Sapien nec sagittis aliquam malesuada bibendum arcu vitae.',3,1);
INSERT INTO "inspeccion" VALUES (13,7,'2022-05-20 14:25:00','Porttitor lacus luctus accumsan tortor. Vestibulum rhoncus est pellentesque elit ullamcorper. Viverra adipiscing at in tellus integer feugiat. Ultricies mi quis hendrerit dolor. Enim diam vulputate ut pharetra sit amet aliquam. Nisl pretium fusce id velit ut tortor. Iaculis nunc sed augue lacus viverra. Nisi vitae suscipit tellus mauris a diam maecenas sed. Id faucibus nisl tincidunt eget nullam non. Convallis convallis tellus id interdum velit laoreet id. Eleifend donec pretium vulputate sapien nec sagittis. Diam vel quam elementum pulvinar etiam non quam. Est placerat in egestas erat imperdiet sed euismod nisi porta. Ut etiam sit amet nisl purus in mollis nunc. Quis blandit turpis cursus in.',2,1);
INSERT INTO "inspeccion" VALUES (14,7,'2022-05-20 22:35:00','Urna et pharetra pharetra massa massa ultricies. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi tristique. Quis commodo odio aenean sed adipiscing diam donec adipiscing tristique. Massa id neque aliquam vestibulum morbi blandit cursus. Non enim praesent elementum facilisis. Id eu nisl nunc mi. Diam vulputate ut pharetra sit amet. Ipsum dolor sit amet consectetur. Risus sed vulputate odio ut enim blandit volutpat maecenas volutpat. Et sollicitudin ac orci phasellus. Dui accumsan sit amet nulla facilisi morbi tempus iaculis. Amet nisl purus in mollis. Tincidunt eget nullam non nisi.',2,0);
INSERT INTO "inspeccion" VALUES (15,9,'2022-05-25 23:02:00','Viverra vitae congue eu consequat ac felis donec et. Ac tortor vitae purus faucibus ornare suspendisse sed nisi. Non odio euismod lacinia at quis risus sed. Vitae turpis massa sed elementum tempus. At elementum eu facilisis sed. Purus sit amet volutpat consequat mauris nunc congue nisi. Arcu non odio euismod lacinia at quis risus. Turpis egestas maecenas pharetra convallis posuere morbi. Tristique magna sit amet purus gravida quis blandit. Sed vulputate mi sit amet mauris commodo quis. Feugiat scelerisque varius morbi enim nunc faucibus a. Viverra adipiscing at in tellus integer. Turpis massa tincidunt dui ut ornare lectus sit amet. Cursus eget nunc scelerisque viverra mauris in. Facilisis volutpat est velit egestas dui id ornare arcu. In dictum non consectetur a. A erat nam at lectus urna duis.',2,1);
INSERT INTO "inspeccion" VALUES (16,9,'2022-05-27 10:43:00','Dignissim convallis aenean et tortor at risus. Ut morbi tincidunt augue interdum velit euismod in pellentesque massa. Aenean et tortor at risus. Hendrerit dolor magna eget est lorem ipsum dolor. Sit amet est placerat in egestas erat imperdiet. Semper quis lectus nulla at volutpat diam ut venenatis tellus. Aliquet bibendum enim facilisis gravida. Commodo sed egestas egestas fringilla phasellus faucibus scelerisque eleifend donec. Rhoncus est pellentesque elit ullamcorper dignissim cras tincidunt lobortis feugiat. Integer eget aliquet nibh praesent tristique magna sit amet. Lectus proin nibh nisl condimentum id venenatis a. Amet luctus venenatis lectus magna fringilla.',2,1);
INSERT INTO "inspeccion" VALUES (17,5,'2022-05-29 21:28:00','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra. Et tortor consequat id porta. In nulla posuere sollicitudin aliquam. Rhoncus aenean vel elit scelerisque mauris pellentesque. Mauris augue neque gravida in fermentum et sollicitudin. At elementum eu facilisis sed odio morbi quis commodo. Rhoncus mattis rhoncus urna neque viverra justo nec ultrices. Praesent tristique magna sit amet purus gravida quis. Etiam erat velit scelerisque in dictum non consectetur a. Massa eget egestas purus viverra accumsan in nisl nisi. Nisl suscipit adipiscing bibendum est ultricies. Varius duis at consectetur lorem. Consectetur purus ut faucibus pulvinar elementum integer enim. Consectetur adipiscing elit ut aliquam purus. Porttitor eget dolor morbi non. In iaculis nunc sed augue. Aliquam malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Nibh praesent tristique magna sit. Aliquet lectus proin nibh nisl condimentum.',2,1);
INSERT INTO "inspeccion" VALUES (18,5,'2022-05-30 21:29:00','Venenatis urna cursus eget nunc scelerisque viverra mauris. Turpis in eu mi bibendum neque egestas congue quisque. Tellus elementum sagittis vitae et leo duis ut. Nibh tortor id aliquet lectus proin nibh nisl condimentum. Suscipit adipiscing bibendum est ultricies integer. Mattis ullamcorper velit sed ullamcorper morbi. Netus et malesuada fames ac turpis egestas integer. Turpis egestas sed tempus urna. Cras ornare arcu dui vivamus arcu felis bibendum ut tristique.',2,1);
INSERT INTO "inspeccion" VALUES (19,8,'2022-05-31 21:30:00','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo a diam sollicitudin tempor id eu nisl nunc. Enim neque volutpat ac tincidunt. Placerat in egestas erat imperdiet. Consectetur purus ut faucibus pulvinar elementum integer enim neque. Dui faucibus in ornare quam viverra orci sagittis eu volutpat. Mauris ultrices eros in cursus turpis. Integer feugiat scelerisque varius morbi enim nunc faucibus a pellentesque. Amet nisl suscipit adipiscing bibendum est. In nulla posuere sollicitudin aliquam ultrices sagittis. Massa vitae tortor condimentum lacinia. Donec et odio pellentesque diam volutpat commodo sed egestas. Felis eget nunc lobortis mattis aliquam faucibus purus in massa. Dignissim convallis aenean et tortor at risus viverra adipiscing at. Consequat id porta nibh venenatis cras. Est ullamcorper eget nulla facilisi etiam dignissim diam quis. Faucibus turpis in eu mi.',3,0);
INSERT INTO "inspeccion" VALUES (20,7,'2022-05-31 21:32:00','Ornare quam viverra orci sagittis eu volutpat odio facilisis mauris. Eget nulla facilisi etiam dignissim diam quis enim lobortis. Tortor consequat id porta nibh venenatis cras sed felis eget. Arcu ac tortor dignissim convallis aenean et tortor at risus. Id cursus metus aliquam eleifend mi in nulla posuere. Vitae purus faucibus ornare suspendisse sed nisi lacus sed viverra. Purus viverra accumsan in nisl. Sed enim ut sem viverra aliquet. Lorem ipsum dolor sit amet. Ultrices in iaculis nunc sed augue lacus. Elementum facilisis leo vel fringilla est ullamcorper eget nulla facilisi. Lectus quam id leo in vitae turpis massa sed elementum. Amet est placerat in egestas erat imperdiet sed.',3,0);
INSERT INTO "inspeccion" VALUES (21,4,'2022-05-31 21:33:00','Duis convallis convallis tellus id interdum velit laoreet id donec. Augue eget arcu dictum varius duis at. Nunc aliquet bibendum enim facilisis gravida neque. Nibh mauris cursus mattis molestie a. Auctor urna nunc id cursus. Accumsan lacus vel facilisis volutpat est velit egestas dui id. A scelerisque purus semper eget duis at tellus at urna. Urna molestie at elementum eu facilisis sed odio. Sed libero enim sed faucibus. Donec pretium vulputate sapien nec sagittis aliquam malesuada. Et tortor consequat id porta. Nunc eget lorem dolor sed viverra ipsum nunc. Placerat vestibulum lectus mauris ultrices eros in cursus.',2,0);
INSERT INTO "inspeccion" VALUES (22,9,'2022-05-31 14:43:00','Pulvinar sapien et ligula ullamcorper malesuada proin libero nunc. Pharetra diam sit amet nisl suscipit adipiscing. Quisque non tellus orci ac auctor augue mauris augue neque. Dui accumsan sit amet nulla. Risus nec feugiat in fermentum posuere urna nec. Nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur. Vulputate sapien nec sagittis aliquam malesuada. Mauris a diam maecenas sed enim ut sem viverra. Velit ut tortor pretium viverra suspendisse. Et ligula ullamcorper malesuada proin libero nunc consequat interdum varius. Massa massa ultricies mi quis hendrerit. Eget nunc scelerisque viverra mauris in aliquam sem fringilla ut.',1,1);
INSERT INTO "inspeccion" VALUES (23,6,'2022-05-31 15:11:00','Facilisis volutpat est velit egestas dui id ornare arcu odio. Molestie ac feugiat sed lectus vestibulum. Vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare. Porttitor massa id neque aliquam. Quis hendrerit dolor magna eget est. Libero volutpat sed cras ornare arcu dui vivamus arcu felis. Mattis ullamcorper velit sed ullamcorper. Facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum dui. Neque laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt. Turpis egestas sed tempus urna et pharetra pharetra massa massa. Cras semper auctor neque vitae tempus quam. Pellentesque pulvinar pellentesque habitant morbi tristique senectus et. Sit amet nisl purus in mollis nunc sed id.',2,0);
INSERT INTO "inspeccion" VALUES (24,1,'2022-05-31 15:15:00','Magna eget est lorem ipsum dolor sit amet consectetur. Lobortis feugiat vivamus at augue eget arcu. Morbi leo urna molestie at elementum eu facilisis. A diam maecenas sed enim ut sem viverra. Facilisis leo vel fringilla est ullamcorper eget nulla facilisi etiam. Nibh sit amet commodo nulla facilisi nullam vehicula. Netus et malesuada fames ac turpis egestas. Sit amet aliquam id diam maecenas. Et magnis dis parturient montes nascetur ridiculus. Nisl purus in mollis nunc sed id. Eleifend donec pretium vulputate sapien nec sagittis aliquam malesuada bibendum.',1,1);
INSERT INTO "inspeccion" VALUES (25,5,'2022-05-31 15:17:00','Non tellus orci ac auctor augue mauris augue neque. Non sodales neque sodales ut etiam sit. Ultrices neque ornare aenean euismod. Nulla posuere sollicitudin aliquam ultrices sagittis orci a scelerisque. Dui faucibus in ornare quam viverra orci sagittis eu volutpat. Molestie at elementum eu facilisis sed odio morbi quis. Cras sed felis eget velit aliquet. In nisl nisi scelerisque eu. Tellus orci ac auctor augue mauris augue neque.',1,1);
INSERT INTO "inspeccion" VALUES (26,1,'2022-05-31 15:17:00','Tortor id aliquet lectus proin nibh nisl condimentum. Semper eget duis at tellus at urna condimentum mattis. Scelerisque varius morbi enim nunc faucibus a pellentesque sit amet. Amet purus gravida quis blandit turpis cursus in hac. Purus non enim praesent elementum facilisis leo vel. Tortor at risus viverra adipiscing at in tellus integer feugiat. Sagittis orci a scelerisque purus semper eget duis. Vel pharetra vel turpis nunc eget.',1,0);
INSERT INTO "inspeccion" VALUES (27,5,'2022-06-01 15:43:00','Amet mauris commodo quis imperdiet massa tincidunt nunc pulvinar sapien. Accumsan sit amet nulla facilisi morbi tempus iaculis urna. Nunc mi ipsum faucibus vitae aliquet nec ullamcorper. Aliquet eget sit amet tellus cras adipiscing. Viverra ipsum nunc aliquet bibendum enim facilisis gravida. Bibendum at varius vel pharetra vel turpis nunc eget lorem. Volutpat lacus laoreet non curabitur gravida arcu ac tortor dignissim.',1,1);
INSERT INTO "inspeccion" VALUES (28,6,'2022-06-01 15:45:00','Dolor magna eget est lorem. Viverra vitae congue eu consequat. Libero volutpat sed cras ornare arcu dui. Dui nunc mattis enim ut tellus elementum sagittis. Semper feugiat nibh sed pulvinar proin gravida hendrerit. Tortor aliquam nulla facilisi cras fermentum odio eu feugiat. Feugiat scelerisque varius morbi enim nunc faucibus. Cursus sit amet dictum sit. Vestibulum lectus mauris ultrices eros in cursus. Sapien nec sagittis aliquam malesuada bibendum.',1,1);
INSERT INTO "inspeccion" VALUES (29,1,'2022-05-31 23:05:00','Enim blandit volutpat maecenas volutpat blandit aliquam etiam erat velit. Vestibulum mattis ullamcorper velit sed ullamcorper. In nibh mauris cursus mattis molestie a iaculis. Nisi scelerisque eu ultrices vitae auctor eu augue. Vel turpis nunc eget lorem dolor. Pulvinar pellentesque habitant morbi tristique senectus et netus et malesuada. Et ultrices neque ornare aenean euismod elementum nisi quis.',1,1);
INSERT INTO "inspeccion" VALUES (30,1,'2022-05-31 23:08:00','Lorem ipsum dolor sit amet consectetur adipiscing elit ut aliquam. Et ultrices neque ornare aenean euismod elementum nisi quis. Morbi tincidunt ornare massa eget. Fames ac turpis egestas sed. Arcu non sodales neque sodales ut etiam sit amet nisl. In cursus turpis massa tincidunt dui ut. Pellentesque habitant morbi tristique senectus et netus et malesuada fames. Risus commodo viverra maecenas accumsan.',1,1);
INSERT INTO "inspeccion" VALUES (31,5,'2022-05-31 23:10:00','Elementum pulvinar etiam non quam lacus suspendisse. Sit amet justo donec enim diam vulputate ut. Mi ipsum faucibus vitae aliquet nec ullamcorper sit amet risus. Pretium vulputate sapien nec sagittis aliquam malesuada. Mattis ullamcorper velit sed ullamcorper morbi. Nec dui nunc mattis enim ut tellus elementum sagittis vitae. Etiam erat velit scelerisque in dictum non consectetur a erat.',1,1);
INSERT INTO "inspeccion" VALUES (32,7,'2022-06-07 19:10:00','Viverra maecenas accumsan lacus vel facilisis. Sit amet massa vitae tortor condimentum lacinia. Sed cras ornare arcu dui vivamus arcu felis bibendum. Nunc scelerisque viverra mauris in aliquam. Cursus sit amet dictum sit. Vulputate odio ut enim blandit volutpat maecenas volutpat blandit. Elementum facilisis leo vel fringilla. Aliquam eleifend mi in nulla posuere sollicitudin aliquam. Egestas congue quisque egestas diam. Consequat ac felis donec et. Duis ut diam quam nulla porttitor massa id. Pellentesque id nibh tortor id aliquet lectus proin. Platea dictumst quisque sagittis purus sit amet volutpat.',1,1);
INSERT INTO "inspeccion" VALUES (33,1,'2022-06-14 15:31:00','Nisl purus in mollis nunc sed id semper. Elementum curabitur vitae nunc sed. Iaculis eu non diam phasellus vestibulum lorem sed risus ultricies. Lectus proin nibh nisl condimentum id venenatis a condimentum. Sagittis vitae et leo duis ut. Volutpat sed cras ornare arcu dui vivamus. Leo integer malesuada nunc vel risus commodo viverra maecenas accumsan. Amet commodo nulla facilisi nullam vehicula ipsum a arcu. Aliquam id diam maecenas ultricies mi eget mauris. Sit amet porttitor eget dolor. Viverra adipiscing at in tellus integer.',1,1);
INSERT INTO "inspeccion_apoyo" VALUES (1,1,0);
INSERT INTO "inspeccion_apoyo" VALUES (2,2,16);
INSERT INTO "inspeccion_apoyo" VALUES (3,2,17);
INSERT INTO "inspeccion_apoyo" VALUES (4,3,18);
INSERT INTO "inspeccion_apoyo" VALUES (5,4,0);
INSERT INTO "inspeccion_apoyo" VALUES (6,5,0);
INSERT INTO "inspeccion_apoyo" VALUES (7,6,18);
INSERT INTO "inspeccion_apoyo" VALUES (8,6,19);
INSERT INTO "inspeccion_apoyo" VALUES (9,7,17);
INSERT INTO "inspeccion_apoyo" VALUES (10,7,18);
INSERT INTO "inspeccion_apoyo" VALUES (11,7,19);
INSERT INTO "inspeccion_apoyo" VALUES (12,8,0);
INSERT INTO "inspeccion_apoyo" VALUES (13,9,16);
INSERT INTO "inspeccion_apoyo" VALUES (14,9,17);
INSERT INTO "inspeccion_apoyo" VALUES (15,9,18);
INSERT INTO "inspeccion_apoyo" VALUES (16,10,18);
INSERT INTO "inspeccion_apoyo" VALUES (17,11,0);
INSERT INTO "inspeccion_apoyo" VALUES (18,12,17);
INSERT INTO "inspeccion_apoyo" VALUES (19,12,18);
INSERT INTO "inspeccion_apoyo" VALUES (20,13,33);
INSERT INTO "inspeccion_apoyo" VALUES (21,14,0);
INSERT INTO "inspeccion_apoyo" VALUES (22,15,33);
INSERT INTO "inspeccion_apoyo" VALUES (23,15,19);
INSERT INTO "inspeccion_apoyo" VALUES (24,16,17);
INSERT INTO "inspeccion_apoyo" VALUES (25,16,33);
INSERT INTO "inspeccion_apoyo" VALUES (26,17,18);
INSERT INTO "inspeccion_apoyo" VALUES (27,17,16);
INSERT INTO "inspeccion_apoyo" VALUES (28,18,18);
INSERT INTO "inspeccion_apoyo" VALUES (29,18,16);
INSERT INTO "inspeccion_apoyo" VALUES (30,19,0);
INSERT INTO "inspeccion_apoyo" VALUES (31,20,0);
INSERT INTO "inspeccion_apoyo" VALUES (32,21,0);
INSERT INTO "inspeccion_apoyo" VALUES (33,22,18);
INSERT INTO "inspeccion_apoyo" VALUES (34,22,33);
INSERT INTO "inspeccion_apoyo" VALUES (35,23,0);
INSERT INTO "inspeccion_apoyo" VALUES (36,24,30);
INSERT INTO "inspeccion_apoyo" VALUES (37,25,17);
INSERT INTO "inspeccion_apoyo" VALUES (38,26,0);
INSERT INTO "inspeccion_apoyo" VALUES (39,27,18);
INSERT INTO "inspeccion_apoyo" VALUES (40,28,16);
INSERT INTO "inspeccion_apoyo" VALUES (41,29,19);
INSERT INTO "inspeccion_apoyo" VALUES (42,29,30);
INSERT INTO "inspeccion_apoyo" VALUES (43,30,18);
INSERT INTO "inspeccion_apoyo" VALUES (44,30,30);
INSERT INTO "inspeccion_apoyo" VALUES (45,31,18);
INSERT INTO "inspeccion_apoyo" VALUES (46,31,33);
INSERT INTO "inspeccion_apoyo" VALUES (47,32,19);
INSERT INTO "inspeccion_apoyo" VALUES (48,32,30);
INSERT INTO "inspeccion_apoyo" VALUES (49,33,18);
INSERT INTO "inspeccion_apoyo" VALUES (50,33,17);
CREATE VIEW "vw_inspeccion_cab" as
SELECT
   i.InspeccionId,
   i.UnidadId,
   unidad_especial.Descripcion as Nombre_Unidad,
   i.InspeccionDate,
   i.Observacion,
   prioridad.Nombre as Prioridad,
   i.Apoyo
FROM
inspeccion i
INNER JOIN unidad_especial ON unidad_especial.UnidadId = i.UnidadId
INNER JOIN prioridad ON prioridad.PrioridadId = i.PrioridadId;
CREATE VIEW "vw_docente_especial" as
select 
p.PersonalId,
p.Apellido,
p.Nombre,
p.Apellido || ', ' || p.Nombre as Nombre_Completo,
p.Telefono,
p.Email,
categoria.Nombre as Categoria,
funcion.Nombre as Funcion,
p.DocEspecial,
p.Conduccion,
p.Apoyo
FROM
   personal p
INNER JOIN categoria ON categoria.CatId = p.CatId
INNER JOIN funcion ON funcion.FuncionId = p.FuncionId
where p.DocEspecial = 1;
CREATE VIEW "vw_apoyo_especial" as
select 
p.PersonalId,
p.Apellido,
p.Nombre,
p.Apellido || ', ' || p.Nombre as Nombre_Completo,
p.Telefono,
p.Email,
categoria.Nombre as Categoria,
funcion.Nombre as Funcion,
p.DocEspecial,
p.Conduccion,
p.Apoyo
FROM
   personal p
INNER JOIN categoria ON categoria.CatId = p.CatId
INNER JOIN funcion ON funcion.FuncionId = p.FuncionId
where p.Apoyo = 1;
CREATE VIEW "vw_conduccion" as
select 
p.PersonalId,
p.Apellido,
p.Nombre,
p.Apellido || ', ' || p.Nombre as Nombre_Completo,
p.Telefono,
p.Email,
categoria.Nombre as Categoria,
funcion.Nombre as Funcion,
p.DocEspecial,
p.Conduccion,
p.Apoyo
FROM
   personal p
INNER JOIN categoria ON categoria.CatId = p.CatId
INNER JOIN funcion ON funcion.FuncionId = p.FuncionId
where p.Conduccion = 1;
CREATE VIEW "vw_unidad_especial" as
SELECT
   ue.UnidadId,
   ue.Periodo,
   ue.Descripcion,
   escuela.Nombre as Escuela,
   ue.ConduccionId,
   personal.Apellido as Ap_Conduccion,
   personal.Nombre as Nom_Conduccion,
   personal.Apellido || ', ' || personal.Nombre as Conduccion,
   turno.Nombre as Turno,
   ciclo.Nombre as Ciclo,
   unidad_items.UnidadLineId as LineaDet,
   unidad_items.DocenteId,
   vw_docente_especial.Nombre_Completo
FROM
   unidad_especial ue
INNER JOIN escuela ON escuela.EscuelaId = ue.EscuelaId 
INNER JOIN personal ON personal.PersonalId = ue.ConduccionId
INNER JOIN turno ON turno.TurnoId = ue.TurnoId
INNER JOIN ciclo ON ciclo.CicloId = ue.CicloId
INNER JOIN unidad_items ON unidad_items.UnidadId = ue.UnidadId
INNER JOIN vw_docente_especial ON vw_docente_especial.PersonalId  = unidad_items.DocenteId;
CREATE VIEW "vw_inspeccion" as
SELECT
   i.InspeccionId,
   i.UnidadId,
   unidad_especial.Descripcion as Nombre_Unidad,
   i.InspeccionDate,
   i.Observacion,
   prioridad.Nombre as Prioridad,
   i.Apoyo,
   inspeccion_apoyo.InspeccionLineId as LineaDet,
   inspeccion_apoyo.ApoyoId,
   CASE
		WHEN i.Apoyo = 0 THEN 
			'Sin Apoyo'
		ELSE
			personal.Apellido || ", " || personal.Nombre
		END Nombre_Completo
FROM
   inspeccion i
INNER JOIN unidad_especial ON unidad_especial.UnidadId = i.UnidadId
INNER JOIN prioridad ON prioridad.PrioridadId = i.PrioridadId
INNER JOIN inspeccion_apoyo ON inspeccion_apoyo.InspeccionId = i.InspeccionId
INNER JOIN personal ON personal.PersonalId = inspeccion_apoyo.ApoyoId;
CREATE VIEW "vw_escuela" as
SELECT
   e.EscuelaId,
   e.Nombre,
   e.DistritoId,
   distrito.Nombre as Distrito,
   e.AutoridadId,
   personal.Apellido || ', ' || personal.Nombre as Nombre_Completo,
   e.Domicilio,
   e.Telefono,
   e.Email,
   e.LocationGeo,
   e.EduEspecial
FROM
escuela e
INNER JOIN distrito ON distrito.DistritoId = e.DistritoId
INNER JOIN personal ON personal.PersonalId = e.AutoridadId;
CREATE VIEW "vw_inspeccion_all" as
SELECT
   i.InspeccionId,
   i.UnidadId,
   unidad_especial.Descripcion as Nombre_Unidad,
   i.InspeccionDate,
   substr(i.InspeccionDate,1,4)||substr(i.InspeccionDate,6,2)||substr(i.InspeccionDate,9,2) as Fecha,
   i.Observacion,
   prioridad.Nombre as Prioridad,
   i.Apoyo,
   unidad_especial.EscuelaId,
   escuela.Nombre as Escuela,
   distrito.Nombre as Distrito,
   unidad_especial.TurnoId,
   turno.Nombre as Turno,
   unidad_especial.CicloId,
   ciclo.Nombre as Ciclo,
   inspeccion_apoyo.InspeccionLineId as LineaDet,
   inspeccion_apoyo.ApoyoId,
   CASE
		WHEN i.Apoyo = 0 THEN 
			'Sin Apoyo'
		ELSE
			personal.Apellido || ", " || personal.Nombre
		END Nombre_Completo,
   personal.CatId as Cat_ApyId,
   categoria.Nombre as Cat_Apoyo,
   personal.FuncionId as Func_ApyId,
   funcion.Nombre as Funcion_Apoyo
FROM
   inspeccion i
INNER JOIN unidad_especial ON unidad_especial.UnidadId = i.UnidadId
inner join escuela on escuela.EscuelaId = unidad_especial.EscuelaId
inner join distrito on distrito.DistritoId = escuela.DistritoId
inner join turno on turno.TurnoId = unidad_especial.TurnoId
inner join ciclo on ciclo.CicloId = unidad_especial.CicloId
INNER JOIN prioridad ON prioridad.PrioridadId = i.PrioridadId
INNER JOIN inspeccion_apoyo ON inspeccion_apoyo.InspeccionId = i.InspeccionId
INNER JOIN personal ON personal.PersonalId = inspeccion_apoyo.ApoyoId
inner join categoria on categoria.CatId = personal.CatId
inner join funcion on funcion.FuncionId = personal.FuncionId;
CREATE VIEW "vw_inspeccion_nodet" as
SELECT
   i.InspeccionId,
   i.UnidadId,
   unidad_especial.Descripcion as Nombre_Unidad,
   i.InspeccionDate,
   substr(i.InspeccionDate,1,4)||substr(i.InspeccionDate,6,2)||substr(i.InspeccionDate,9,2) as Fecha,
   i.Observacion,
   prioridad.Nombre as Prioridad,
   i.Apoyo,
   unidad_especial.EscuelaId,
   escuela.Nombre as Escuela,
   distrito.Nombre as Distrito,
   unidad_especial.TurnoId,
   turno.Nombre as Turno,
   unidad_especial.CicloId,
   ciclo.Nombre as Ciclo   
FROM
   inspeccion i
INNER JOIN unidad_especial ON unidad_especial.UnidadId = i.UnidadId
inner join escuela on escuela.EscuelaId = unidad_especial.EscuelaId
inner join distrito on distrito.DistritoId = escuela.DistritoId
inner join turno on turno.TurnoId = unidad_especial.TurnoId
inner join ciclo on ciclo.CicloId = unidad_especial.CicloId
INNER JOIN prioridad ON prioridad.PrioridadId = i.PrioridadId;
COMMIT;

/* Simple C program that connects to MySQL Database server */
#include <mysql.h>
#include <stdio.h>
main() {
   MYSQL *conn;
   MYSQL_RES *res;
   MYSQL_ROW row;

	/* CONFIGURACION DE SERVIDOR Y BASE DE DATOS */
   char *server = "5.231.69.226";
   char *user = "alex";
   char *password = "alex"; 
   char *database = "devPreview";


   conn = mysql_init(NULL);

   /* Conectar a la Base de Datos */
   if (!mysql_real_connect(conn, server,
         user, password, database, 0, NULL, 0)) {
      fprintf(stderr, "%s\n", mysql_error(conn));
      exit(1);
   }
   /* Envia consulta SQL */
   if (mysql_query(conn, "show tables")) {
      fprintf(stderr, "%s\n", mysql_error(conn));
      exit(1);
   }
   res = mysql_use_result(conn);
   /* Muestra por pantalla las tablas */
   printf("MySQL Tables in mysql database:\n");
   while ((row = mysql_fetch_row(res)) != NULL)
      printf("%s \n", row[0]);
   
   /* Cerrar conexión a la BD */
   mysql_free_result(res);
   mysql_close(conn);
}

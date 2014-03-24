/***************************************************************************
/*
/* Script que comprueba la IP real de la RaspBerry Pi
/* Ejemplo de librería CURL
/* 
/**************************************************************************/

#include <stdio.h>
#include <curl/curl.h>

int main(void)
{
  CURL *curl;
  CURLcode res;

  curl_global_init(CURL_GLOBAL_ALL);

  curl = curl_easy_init();
  if(curl) {
    /* Introducir la dirección del servidor que contiene la función de la petición POST */
    curl_easy_setopt(curl, CURLOPT_URL, "http://ip.servidor.remoto/directorio/index.php");
    /* Introducir los parámetros */
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "command1=arg1&command2=arg2");
    /* Resultado */
    res = curl_easy_perform(curl);
    if(res != CURLE_OK)
      fprintf(stderr, "IP-Check. El programa ha fallado: %s\n",
              curl_easy_strerror(res));
    curl_easy_cleanup(curl);
  }
  curl_global_cleanup();
  return 0;
}

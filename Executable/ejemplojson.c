#include <stdlib.h>
#include <string.h>

#include <jansson.h>
#include <curl/curl.h>

#define BUFFER_SIZE  (256 * 1024)
#define URL_FORMAT   "http://api.openweathermap.org/data/2.5/weather?q=%s&lang=%s&mode=json"
#define URL_SIZE   256


/* Return the offset of the first newline in text or the length of
   text if there's no newline */
//static char *request(const char *url);
struct coordinate{
	float lat;
	float lon;	
};

struct system{
	float message;
	const char *country;
	int sunrise;
	int sunset;
};

struct weat{
	float id;
	const char *main;	
	const char *description;
	const char *icon;
};
struct Cmain{
	float temp;
	int pressure;
	int humidity;
	float temp_min;
	float temp_max;	
};

struct Cwind{
	float speed;
	int deg;
};
struct Csnow{
	float h;
};
struct Crain{
	float h;
};
struct Ccloud{
	int all;
};

struct Cclima{
	struct system sys;
	struct weat weather;
	struct Cmain main;
	struct Cwind wind;	
};
struct write_result
{
    char *data;
    int pos;
};


static size_t write_response(void *ptr, size_t size, size_t nmemb, void *stream)
{
    struct write_result *result = (struct write_result *)stream;

    if(result->pos + size * nmemb >= BUFFER_SIZE - 1)
    {
        fprintf(stderr, "error: too small buffer\n");
        return 0;
    }

    memcpy(result->data + result->pos, ptr, size * nmemb);
    result->pos += size * nmemb;

    return size * nmemb;
}



static char *request(const char *url)
{
    
    CURL *curl = NULL;
    CURLcode status;
    char *data = NULL;
    long code;

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(!curl)
        goto error;

    data = malloc(BUFFER_SIZE);
    if(!data)
        goto error;

    struct write_result write_result = {
        .data = data,
        .pos = 0
    };

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_response);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &write_result);

    status = curl_easy_perform(curl);
    if(status != 0)
    {
        fprintf(stderr, "error: unable to request data from %s:\n", url);
        fprintf(stderr, "%s\n", curl_easy_strerror(status));
        goto error;
    }

    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &code);
    if(code != 200)
    {
        fprintf(stderr, "error: server responded with code %ld\n", code);
        goto error;
    }

    curl_easy_cleanup(curl);
    curl_global_cleanup();

    /* zero-terminate the result */
    data[write_result.pos] = '\0';

    return data;

error:
    if(data)
        free(data);
    if(curl)
        curl_easy_cleanup(curl);
    curl_global_cleanup();
    return NULL;
}


int main(int argc, char *argv[])
{
    struct Cclima clima;
    int i;
    char *text;
    char url[URL_SIZE];

    json_t *root;
    json_error_t error;

    if(argc > 3 || argc < 2)
    {
        fprintf(stderr, "usage: %s USEr\n\n", argv[0]);
        fprintf(stderr, " clima city o clima city,country\n\n");
	fprintf(stderr, "o also clima city,country language \n\n");
        return 2;
    }
    if(argv[2]=="" || argv[2]=="sp")
	snprintf(url,URL_SIZE,URL_FORMAT,argv[1],"sp");
	else
	snprintf(url,URL_SIZE,URL_FORMAT,argv[1],argv[2]);
	text = request(url);
	if(!text)
	return 1;
	root = json_loads(text,0,&error);
	free(text);
	if(!root)
	{
    		fprintf(stderr, "error: on line %d: %s\n", error.line, error.text);
    		return 1;
	}
	
	
	if(!json_is_object(root))
	{
		fprintf(stderr,"error: root is not an array\n");
		return 1;		
	}
	
	json_t *coord,*lon,*lat,*sys,*message,*country,*sunrise,*sunset,*weather,*id,*main,*description;
	json_t *icon,*base,*temp,*temp_min,*temp_max,*pressure,*humidity,*wind,*speed,*deg;
	json_t *snow,*rain,*clouds,*all,*dt,*name,*cod;
	json_t *h,*h1;
	const char *tmain,*tcountry,*tdescription,*ticon,*tbase,*tname;
	const char *tmessage;
	float t3h,t31h,ttemp,ttemp_min,ttemp_max,tlat;
	float tspeed,tlon;
	int tsunrise,tsunset,tpressure,thumidity,tdeg,tall,tdt,tide1,tide2,tcod;
	//begin search in root	
	
	coord = json_object_get(root, "coord");
	//buscando en coord
	if(!json_is_object(coord))
	{
		fprintf(stderr,"error: coord is not an object\n");
		return 1;		
	}
	lon = json_object_get(coord, "lon");	
		
	if(!json_is_number(lon))
	{
		fprintf(stderr,"error: lon is not an float\n");
		return 1;		
	}
       	//clima.coord.lon = json_number_value(lon);
	
	lat = json_object_get(coord, "lat");
	if(!json_is_number(lat))
	{
		fprintf(stderr,"error: lat is not an float\n");
		return 1;		
	}
	//clima.coord.lat = json_number_value(lat);
		
	//termina la busqueda en coord
	
	//busqueda en sys
	sys = json_object_get(root, "sys");
	if(!json_is_object(sys))
	{
		fprintf(stderr,"error: sys is not an object\n");
		return 1;		
	}
	
	message = json_object_get(sys,"message");
	if(!json_is_number(message))
	{
		fprintf(stderr,"error: message is not an float\n");
		return 1;		
	}
	//clima.sys.message=json_number_value(message);
	
	country=json_object_get(sys,"country");
	if(!json_is_string(country))
	{
		fprintf(stderr,"error: country is not an float\n");
		return 1;		
	}
	
	//clima.sys.country=json_string_value(country);///errorS		

		
	sunrise=json_object_get(sys,"sunrise");
	if(!json_is_number(sunrise))
	{
		fprintf(stderr,"error: sunrise is not an float\n");
		return 1;		
	}
	clima.sys.sunrise=json_number_value(sunrise);	

	sunset=json_object_get(sys,"sunset");
	if(!json_is_number(sunset))
	{
		fprintf(stderr,"error: sunset is not an float\n");
		return 1;		
	}
	
	clima.sys.sunset=json_number_value(sunset);
		
	
	//termina la busquedad en sys
	//empieza la busquedad en weather
	
	weather = json_object_get(root, "weather");
	if(!json_is_array(weather))
	{
		fprintf(stderr,"error: weather is not an float\n");
		return 1;		
	}
	
	for(i = 0; i < json_array_size(weather); i++)
	{
		json_t *data;		
		data= json_array_get(weather,i);
		//buscar en data
		id=json_object_get(data,"id");		
		if(!json_is_number(id))
		{
			fprintf(stderr,"error: id is not an float\n");
			return 1;		
		}
		
		//clima.weather.id=json_number_value(id);
		
		main=json_object_get(data,"main");	
		if(!json_is_string(main))
		{
			fprintf(stderr,"error: main is not an float\n");
			return 1;		
		}	
		clima.weather.main=json_string_value(main);//errorS
		
		description=json_object_get(data,"description");
		if(!json_is_string(description))
		{
			fprintf(stderr,"error: description is not an float\n");
			return 1;		
		}	
		clima.weather.description=json_string_value(description);
				
		icon=json_object_get(data,"icon");
		if(!json_is_string(icon))
		{
			fprintf(stderr,"error: icon is not an float\n");
			return 1;		
		}
		//clima.weather.icon=json_string_value(icon);
		//acabo busqueda en data
	}
	
	//acaba busqueda en weather
	
	//empieza base
	base = json_object_get(root, "base");
	if(!json_is_string(base))
		{
			fprintf(stderr,"error: base is not an float\n");
			return 1;		
		}
	
	//clima.base=json_string_value(base);
	//acaba la busqueda en base
	
	//empieza busqueda en main
	main = json_object_get(root, "main");
	if(!json_is_object(main))
		{
			fprintf(stderr,"error: main is not an float\n");
			return 1;		
		}	
	
	temp=json_object_get(main,"temp");
	if(!json_is_number(temp))
		{
			fprintf(stderr,"error: temp is not an float\n");
			return 1;		
		}
	clima.main.temp=json_number_value(temp);
	
	pressure=json_object_get(main,"pressure");
	if(!json_is_number(pressure))
		{
			fprintf(stderr,"error: pressure is not an float\n");
			return 1;		
		}
	//clima.main.pressure=json_number_value(pressure);
	
	humidity=json_object_get(main,"humidity");
	if(!json_is_number(humidity))
		{
			fprintf(stderr,"error: humidity is not an float\n");
			return 1;		
		}
	clima.main.humidity=json_number_value(humidity);		
	temp_min=json_object_get(main,"temp_min");
	if(!json_is_number(temp_min))
		{
			fprintf(stderr,"error: temp_min is not an float\n");
			return 1;		
		}
	clima.main.temp_min=json_number_value(temp_min);	
		
	
	temp_max=json_object_get(main,"temp_max");
	if(!json_is_number(temp_max))
		{
			fprintf(stderr,"error: temp_max is not an float\n");
			return 1;		
		}
	clima.main.temp_max=json_number_value(temp_max);	
		
	//acaba busqueda en main
	//empieza la busqueda en wind	
	wind = json_object_get(root, "wind");
	
	if(!json_is_object(wind))
		{
			fprintf(stderr,"error: wind is not an float\n");
			return 1;		
		}	
	
	speed=json_object_get(wind,"speed");
	if(!json_is_number(speed))
		{
			fprintf(stderr,"error: speed is not an float\n");
			return 1;		
		}
	clima.wind.speed=json_number_value(speed);	
	
	deg=json_object_get(wind,"deg");
	if(!json_is_number(deg))
		{
			fprintf(stderr,"error: deg is not an float\n");
			return 1;		
		}
	//clima.wind.deg=json_number_value(deg);
	//termina la busqueda en wind
	//empieza la busqueda em snow
	snow = json_object_get(root, "snow");
	if(json_is_object(snow))
	{	/*{
			fprintf(stderr,"error: snow is not an float\n");
			return 1;		
		}*/	
	h=json_object_get(snow,"3h");
	if(!json_is_number(h))
		{
			fprintf(stderr,"error: 3h is not an float\n");
			return 1;		
		}
	//clima.snow.h=json_number_value(h);
	}
	//termina la busqueda en snow
	
	//begin search rain
	rain = json_object_get(root,"rain");
	if(json_is_object(rain))
	{	/*{
			fprintf(stderr,"error: snow is not an float\n");
			return 1;		
		}*/	
		
	h1=json_object_get(rain,"3h");
	if(!json_is_number(h1))
		{
			fprintf(stderr,"error: 3h is not an float\n");
			return 1;		
		}
	//clima.rain.h=json_number_value(h1);
	}
	//end search rain

	//empieza la busqueda en clouds
	clouds = json_object_get(root, "clouds");
	if(!json_is_object(clouds))
		{
			fprintf(stderr,"error: clouds is not an float\n");
			return 1;		
		}	
	all=json_object_get(clouds,"all");
	if(!json_is_number(all))
		{
			fprintf(stderr,"error: all is not an float\n");
			return 1;		
		}
	//clima.cloud.all=json_number_value(all);
	//termina la busqueda en clouds
	//empieza la busqueda en dt
	dt = json_object_get(root, "dt");
	if(!json_is_number(dt))
		{
			fprintf(stderr,"error: dt is not an float\n");
			return 1;		
		}
	//clima.dt=json_number_value(dt);
	//termina la busqueda en dt

	//empieza la busqueda en id
	id = json_object_get(root, "id");
	if(!json_is_number(id))
		{
			fprintf(stderr,"error: id is not an float\n");
			return 1;		
		}
	//clima.id=json_number_value(id);
	//termina la busqueda en id
	//empieza la busqueda en name
	name = json_object_get(root, "name");
	if(!json_is_string(name))
		{
			fprintf(stderr,"error: name is not an float\n");
			return 1;		
		}
	//clima.name=json_string_value(name);//errorS
	//termina la busqueda en name
	//empieza la busqueda en cod
	cod = json_object_get(root, "cod");
	if(!json_is_number(cod))
		{
			fprintf(stderr,"error: cod is not an float\n");
			return 1;		
		}
	
	printf("sunrise %d\n",clima.sys.sunrise);
	printf("sunset %d\n",clima.sys.sunset);
	printf("main %s\n",clima.weather.main);	
	printf("description %s\n",clima.weather.description);
	printf("temperature %.2f\n",clima.main.temp);
	printf("humidity %d\n",clima.main.humidity);
	printf("temp min %.2f\n",clima.main.temp_min);
	printf("temp max %.2f\n",clima.main.temp_max);
	printf("speed %.2f\n",clima.wind.speed);
	
	json_decref(root);
	return 0;
	
}

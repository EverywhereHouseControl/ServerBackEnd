var campos = 1;
var items = 1;

function agregarHabitacion(){
	campos = campos + 1;
	var NvoCampo= document.createElement("div");
	NvoCampo.id= "divcampo_"+(campos);
	NvoCampo.innerHTML= 
		"</br>" +
		"<div align='center'>" +
		"<table>" +
		"   <tr>" +
		"     <td nowrap='nowrap'>" +
		"     	<h3>Nombre de la habitación: </h3>" +
		"        <input type='text' size='50' class='input username' name='articu_" + campos + "' id='articu_" + campos + "'>" +
		"     </td>" +
		"	</tr>" +
	/**--	"   <tr>" +
		"	  <td nowrap='nowrap'>" +
		"        <label>Agrega tantos items como tenga esta habitación</label>" +
		"        <a href='JavaScript:agregarItem(" + campos +");'> Agregar Item </a>" +
		"     </td>" +
		"   </tr>" + **/
		"</table>" +
		"</div>" +
		"</br>";
	var contenedor= document.getElementById("contenedorcampos");
    contenedor.appendChild(NvoCampo);
    agregarItem();
  }
  
 function agregarItem(){
	items = items + 1;
	var NvoCampo= document.createElement("div");
	NvoCampo.id= "divitems_"+(items);
	NvoCampo.innerHTML= 
		"<div align='center'>" +
		"<table align='center'>" +
		"   <tr align='center'>" +
		"     <td nowrap='nowrap'>" +
		"     <h4 align='center'>Selecciona un Item</h4>" +
		"     </td>" +
		"   </tr>" +
		" 	<tr align='center'>" +
		"        <td style='margin-left:4px;'><img src='images/retro_tv-50.png' alt='TV' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='images/dvdIco.png' alt='DVD' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='images/remote_control-50.png' alt='Minicadean' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='images/remote_control-50.png' alt='Puerta' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='images/lamp-50.png' alt='Luces' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='images/temperature-100.png' alt='Calefaccion' height='42' width='42'></td> "+
		"	</tr>" +
		" 	<tr align='center'>" +
		"        <td align='center'><input type='checkbox' name='sex' value='TV'></td> "+
		"        <td align='center'><input type='checkbox' name='sex' value='DVD'></td> "+
		"        <td align='center'><input type='checkbox' name='sex' value='male'></td> "+
		"        <td align='center'><input type='checkbox' name='sex' value='male'></td> "+
		"        <td align='center'><input type='checkbox' name='sex' value='male'></td> "+
		"        <td align='center'><input type='checkbox' name='sex' value='male'></td> "+
		"	</tr>" +
		" 	<tr align='center'>" +
		"        <td align='center'><label>TV</label></td> "+
		"        <td align='center'><label>DVD</label></td> "+
		"        <td align='center'><label>Minicadena</label></td> "+
		"        <td align='center'><label>Puerta Garage</label></td> "+
		"        <td align='center' ><label>Luces</label></td> "+
		"        <td align='center' ><label>Calefacción</label></td> "+
		"	</tr>" +
		"	<tr>" +
		"     <td nowrap='nowrap'>" +
		"        <a href='JavaScript:quitarCampo(" + campos +");'> Quitar </a>" +
		"     </td>" +
		"	</tr>" +
		"</table>" +
		"</div>";
	var contenedor= document.getElementById("contenedorcampos");
    contenedor.appendChild(NvoCampo);
  }


function quitarCampo(iddiv){
  var eliminar = document.getElementById("divcampo_" + iddiv);
  var eliminar2 = document.getElementById("divitems_" + iddiv);
  var contenedor= document.getElementById("contenedorcampos");
  contenedor.removeChild(eliminar);
  contenedor.removeChild(eliminar2);
}

function quitarItem(iddiv){
  var eliminar = document.getElementById("divitems_" + iddiv);
  var contenedor= document.getElementById("contenedorcampos");
  contenedor.removeChild(eliminar);
}
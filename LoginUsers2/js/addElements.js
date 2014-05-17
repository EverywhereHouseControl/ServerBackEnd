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
		"     	<label>Nombre de la habitación: </label>" +
		"        <input type='text' size='50' name='articu_" + campos + "' id='articu_" + campos + "'>" +
		"     </td>" +
		"     <td nowrap='nowrap'>" +
		"        <a href='JavaScript:quitarCampo(" + campos +");'> Quitar </a>" +
		"     </td>" +
		"	</tr>" +
		"   <tr>" +
		"	  <td nowrap='nowrap'>" +
		"        <label>Agrega tantos items como tenga esta habitación</label>" +
		"        <a href='JavaScript:agregarItem(" + campos +");'> Agregar Item </a>" +
		"     </td>" +
		"   </tr>" +
		"</table>" +
		"</div>";
	var contenedor= document.getElementById("contenedorcampos");
    contenedor.appendChild(NvoCampo);
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
		"     <label align='center'>Selecciona un Item</label>" +
		"     </td>" +
		"   </tr>" +
		" 	<tr align='center'>" +
		"        <td style='margin-left:4px;'><img src='radio-100.png' alt='TV' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='../images/radio-100.png' alt='DVD' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='../images/phone3-100.png' alt='Minicadean' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='../images/radio-100.png' alt='Puerta' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='../images/office_lamp-100.png' alt='Luces' height='42' width='42'></td> "+
		"        <td style='margin-left:4px;'><img src='../images/temperature-100.png' alt='Calefaccion' height='42' width='42'></td> "+
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
		"</table>" +
		"</div>";
	var contenedor= document.getElementById("contenedorcampos");
    contenedor.appendChild(NvoCampo);
  }


function quitarCampo(iddiv){
  var eliminar = document.getElementById("divcampo_" + iddiv);
  var contenedor= document.getElementById("contenedorcampos");
  contenedor.removeChild(eliminar);
}

function quitarItem(iddiv){
  var eliminar = document.getElementById("divitems_" + iddiv);
  var contenedor= document.getElementById("contenedorcampos");
  contenedor.removeChild(eliminar);
}
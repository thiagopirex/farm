// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-datepicker.pt-BR
//= require leaflet
//= require leaflet.draw
//= require leaflet-geodesy
//= require leaflet-measure
//= require Leaflet.Coordinates-0.1.5.min
//= require_tree .

// adicionar medidas diretamente no mapa: https://github.com/ljagis/leaflet-measure
// layers control: http://leafletjs.com/examples/layers-control/example.html

function reloadMap() {
	map.remove();
    drawMap();
}

function addReloadControl(map) {
	var reloadControl = L.control();

    reloadControl.onAdd = function (map) {
        this._div = L.DomUtil.create('div', 'info');
        this.update();
        return this._div;
    };

    reloadControl.update = function (props) {
        this._div.innerHTML = '<img style="cursor:pointer" id="collapse" title="Recarregar mapa" width="40px" height="40px" src="/images/reload.png" onclick="reloadMap()"/>';
    };

    reloadControl.addTo(map);
}

function addCollapseControl(map) {
	var collapseControl = L.control();

    collapseControl.onAdd = function (map) {
        this._div = L.DomUtil.create('div', 'info');
        this.update();
        return this._div;
    };

    collapseControl.update = function (props) {
        this._div.innerHTML = '<img id="collapse" width="42px" height="42px" title="Ampliar mapa" style="background-color: white; cursor:pointer;" src="/images/collapse-right.png" onclick="showHideMapProperties()"/>';
    };

    collapseControl.addTo(map);
	
}

function showHideMapProperties() {	
	if($('#sidebar').hasClass('open')) {
		$('#sidebar').removeClass('col-md-4');
		$('#sidebar').removeClass('open');
		$('#sidebar').addClass('hidden');
		$("#map").css("width", "100%");
		$('#map').addClass('col-md-12');
		$('#map').removeClass('col-md-8');
		reloadMap();
		$("#collapse").attr("title", "Reduzir mapa");
		$("#collapse").attr("src", "/images/collapse-left.png");
	} else {
	    $('#sidebar').addClass('col-md-4');
		$('#sidebar').addClass('open');
		$('#sidebar').removeClass('hidden');
		$("#map").css("width", "75%");
		$('#map').removeClass('col-md-12');
		$('#map').addClass('col-md-8');
		reloadMap();
		$("#collapse").attr("title", "Ampliar mapa");
		$("#collapse").attr("src", "/images/collapse-right.png");
	}
}



function replaceAll(str, find, replace) {
	return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function escapeRegExp(str) {
	return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

var centro = [-15.85, -46.08];
var zoomDefault = 7;
var zoomPropriedade = 15;

// load a tile layer
var esri = L.tileLayer('//server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
	attribution: 'Esri'
});

var google = L.tileLayer('http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',{
    subdomains:['mt0','mt1','mt2','mt3'],
    attribution: 'Google'
});

var googleTerrain = L.tileLayer('http://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',{
    maxZoom: 20,
    subdomains:['mt0','mt1','mt2','mt3']
});

//opções de layers
var baseMaps = {
	"Esri": esri,
	"Google": google,
	"Google Terrain": googleTerrain
};

var measureOptions = {
	position: 'topright',
	primaryLengthUnit: 'meters', 
	secondaryLengthUnit: 'kilometers',
	primaryAreaUnit: 'hectares',
	activeColor: '#ABE67E',
	localization: 'pt_BR'
};

var LeafIcon = L.Icon.extend({
	    options: {
	       iconSize:     [20, 30]
	    }
	});
	
var sedeIcon = new LeafIcon({
    iconUrl: '/images/marker-icon2-green.png',
    iconSize: [40, 55]
});

var aguaEdicaoIcon = new LeafIcon({
    iconUrl: '/images/marker-icon2-red.png'
});

function getMapOptionsWithLayers(stringGeometry, layers) {
	return {
		center: getCentro(stringGeometry),
      	zoom: getZoom(stringGeometry),
		layers: layers
    };
}

// 
function getMapOptions(stringGeometry) {
	return {
		center: getCentro(stringGeometry),
      	zoom: getZoom(stringGeometry),
		layers: [google] //layer default
    };
}

function getZoom(stringGeometry) {
	var retorno = zoomDefault;
	if (stringGeometry != "") {
		retorno = zoomPropriedade;
  	}
  	return retorno;
}

function getCentro(stringGeometry) {
	var retorno = centro;
	if (stringGeometry != "") {
  		var string = replaceAll(stringGeometry, "&quot;", "\"");
		var feature = JSON.parse(string);
  		var lat = feature.geometry.coordinates[0];
  		var lng = feature.geometry.coordinates[1];
  		retorno = [lng, lat];
  	}
  	return retorno;
}

function adicionarPoligonoArea(stringGeometria, map) {
	adicionarPoligonoArea(stringGeometria, map, "", "");
}

function adicionarPoligonoArea(stringGeometria, map, link, img) {
	if (stringGeometria != "") {
		stringGeometria = replaceAll(stringGeometria, "&quot;", "\"");
		var features = JSON.parse(stringGeometria);
		var geoJson = L.geoJson(features);
		
		
		
		var geoJson = L.geoJson(features, {
			onEachFeature: function (feature, layer) {
				//Color: cor da borda
				//fillColor: cor do preenchimento
				layer.setStyle({color: '#00FFFF'}); //azul
				var prop = feature.properties;
				var href = "";
				if (link != null && link != "") {
					href = link;
				}
				var nome = "Nome: " + prop.nome;
				var situacao = "<br/>Condição: " + prop.situacao;
				if (prop.situacao == "Ruim") {
					layer.setStyle({color: 'red', fillColor: 'red'});
					situacao = "<br/>Condição: <b>" + prop.situacao + "</b>";
				}
				var anim = prop.animais;
				var qntDiasComAnimais = "";
				if (anim == '0') {
					anim = "nenhum";
				} else {
					layer.setStyle({color: '#177011', fillColor: '#177011'}); //com animais - verde escuro
					qntDiasComAnimais = "<br/>Qnt de dias com animais: " + prop.qntDiasComAnimais;
				}
				layer.addTo(map);
				var historico = "<br/>Última alteração: " + prop.historico;
				var animais = "<br/>Qnt Animais: " + anim;
				var pastagemAtual = "<br/>Pastagem: " + prop.pastagem;
				var analises = "<br/>Análises efetuadas: " + prop.analises;
				var area = "</br>Área Total: " + (toHectare(LGeo.area(layer))).toFixed(2) + " hectares"; 
				 
				layer.bindPopup(
					img +
					"</br>" + "</br>" +
					nome + 
					situacao +
					animais + 
					qntDiasComAnimais +
					pastagemAtual +
					area + 
					analises +
					historico +
					href);
				
		   }
		});
		
		// geoJson.addTo(map);
	}
}

function getAreaPoligonoHectare(stringGeometria) {
	var retorno = 0;
	if (stringGeometria != "") {
		stringGeometria = replaceAll(stringGeometria, "&quot;", "\"");
		var features = JSON.parse(stringGeometria);
		var geoJson = L.geoJson(features);
		
		
		var geoJson = L.geoJson(features, {
			onEachFeature: function (feature, layer) {
				retorno = toHectare(LGeo.area(layer));
			}
		});
	}
	return retorno;
}

function addLayerPontoAgua(stringGeometria, img, link, layerDestination) {
	if (stringGeometria != "") {
		stringGeometria = replaceAll(stringGeometria, "&quot;", "\"");
		var features = JSON.parse(stringGeometria);
		var geoJson = L.geoJson(features);
		
		
		var geoJson = L.geoJson(features, {
			onEachFeature: function (feature, layer) {
				var prop = feature.properties;
				var href = "";
				if (link != null && link != "") {
					href = link;
				}
				var tipo = "Fonte de Água: " + prop.tipo;
				 
				layer.bindPopup(
					img +
					"</br>" + "</br>" +
					tipo + 
					"</br>" + "</br>" +
					href);
				layer.addTo(layerDestination);
		   }
		});
	
	}
}

function toKmQuadrado(value) {
	return value / 1000000;
}

function toHectare(value) {
	return value / 10000;
	
}


//https://github.com/MrMufflon/Leaflet.Coordinates
function addLatLng(map){
	L.control.coordinates({
			position:"bottomright",
			decimals:6,
			decimalSeperator:",",
			labelTemplateLat:"Lat: {y}",
			labelTemplateLng:"Lng: {x}"
		}).addTo(map);
	L.control.coordinates({
		position:"bottomright",
		useDMS:true,
		labelTemplateLat:"N {y}",
		labelTemplateLng:"E {x}",
		useLatLngOrder:true
	}).addTo(map);
}

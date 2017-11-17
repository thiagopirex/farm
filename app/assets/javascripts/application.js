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
//= require bootstrap.min
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

function replaceAll(str, find, replace) {
	return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function escapeRegExp(str) {
	return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

var centro = [-15.85, -46.08];
var zoomDefault = 4;
var zoomPropriedade = 14;

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
	position: 'bottomleft',
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
    iconUrl: '/images/marker-icon2-green.png'
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
	adicionarPoligonoArea(stringGeometria, map, "");
}

function adicionarPoligonoArea(stringGeometria, map, link) {
	if (stringGeometria != "") {
		stringGeometria = replaceAll(stringGeometria, "&quot;", "\"");
		var features = JSON.parse(stringGeometria);
		var geoJson = L.geoJson(features);
		
		
		var geoJson = L.geoJson(features, {
			onEachFeature: function (feature, layer) {
				layer.setStyle({color: '#00FFFF'});
				layer.addTo(map);
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
				if (anim == '0') {
					anim = "nenhum";
				}
				var historico = "<br/>Última alteração: " + prop.historico;
				var animais = "<br/>Qnt Animais: " + anim;
				var pastagemAtual = "<br/>Pastagem: " + prop.pastagem;
				var analises = "<br/>Análises efetuadas: " + prop.analises;
				var area = "</br>Área Total: " + (toHectare(LGeo.area(layer))).toFixed(2) + " hectares"; 
				 
				layer.bindPopup(
					nome + 
					situacao +
					animais + 
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

import { Controller } from "@hotwired/stimulus"
import L from "leaflet"
import "leaflet-measure"

// Connects to data-controller="map"
export default class extends Controller {
  
  zoomDefault = 7;
  zoomPropriedade = 15;
  centro = [-15.85, -46.08];

  //Definições 
  esriLayer = L.tileLayer('//server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
    attribution: 'Esri'
  });
  googleLayer = L.tileLayer('http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',{
      subdomains:['mt0','mt1','mt2','mt3'],
      attribution: 'Google'
  });
  googleTerrainLayer = L.tileLayer('http://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',{
      maxZoom: 20,
      subdomains:['mt0','mt1','mt2','mt3']
  });

  sedeIcon = L.icon({
    iconUrl: '/images/marker-icon2-green.png',   // caminho da imagem
    iconSize: [35, 45],                   // largura, altura
    iconAnchor: [12, 41],                 // ponto do ícone que "toca" o mapa
    popupAnchor: [7, -40],                // onde abre o popup
    shadowSize: [41, 41]
  })

  connect() {
    this.map = L.map(this.element).setView(this.centro, this.zoomDefault)
    this.googleLayer.addTo(this.map)

    this.layersControl = L.control.layers(
      {"Esri": this.esriLayer,
      "Google": this.googleLayer,
      "Google Terrain": this.googleTerrainLayer
      }, {}).addTo(this.map)

     this.measureControl = L.control.measure({
      position: 'topright',
      primaryLengthUnit: 'meters', 
      secondaryLengthUnit: 'kilometers',
      primaryAreaUnit: 'hectares',
      activeColor: '#ABE67E'
    });
    this.measureControl.addTo(this.map);
  }

  connect2() {
    const layersDefault = [this.googleLayer];
    const mapOptions = this.getMapOptionsWithLayers("", layersDefault);

    // Cria o mapa apenas neste elemento
    this.map = L.map(this.element, mapOptions).setView(this.getCentro(""), this.zoomDefault);

    this.baseLayers = L.control.layers({
      "Esri": this.esriLayer,
      "Google": this.googleLayer,
      "Google Terrain": this.googleTerrainLayer
    });
    this.baseLayers.addTo(this.map);

   
  }

  disconnect() {
    // remove o mapa ao sair da página, evitando erro "already initialized"
    if (this.baseLayers) {
      this.baseLayers.remove();
      this.baseLayers = null;
    }

    if (this.measureControl) {
      this.measureControl.remove();
      this.measureControl = null;
    }

    if (this.map) {
      this.map.remove();
      this.map = null;
    }
  }

  getMap() {
    return this.map;
  }

  getZoom(stringGeometry) {
    const retorno = zoomDefault;
    if (stringGeometry != "") {
      retorno = zoomPropriedade;
    }
    return retorno;
  }

  _old_getMapOptionsWithLayers(stringGeometry, layers) {
    return {
        center: this.getCentro(stringGeometry),
        zoom: this.getZoom(stringGeometry),
        layers: layers
      };
  }

  parseStringToJSON(string) {
    return JSON.parse(string.replace(/&quot;/g, '"'))
  }

  getCentro(stringGeometry) {
    var retorno = this.centro;
    if (stringGeometry != "") {
      var feature = this.parseStringToJSON(stringGeometry)
      var lat = feature.geometry.coordinates[0];
      var lng = feature.geometry.coordinates[1];
      retorno = [lng, lat];
    }
  	return retorno;
  }
  getZoom(stringGeometry) {
    var retorno = this.zoomDefault;
    if (stringGeometry != "") {
      retorno = this.zoomPropriedade;
      }
      return retorno;
  }

  addLayerSede(stringJsonPoint) {
    // criar layerGroup
    const layerSede = L.layerGroup()

    // adicionar overlay ao controle existente
		this.layersControl.addOverlay(layerSede, "Sede")

    // adicionar ao mapa
		this.getMap().addLayer(layerSede)

		if (stringJsonPoint != "") {
      var centroide = this.getCentro(stringJsonPoint)
			L.marker(centroide, {icon: this.sedeIcon}).bindPopup('Sede da propriedade').addTo(layerSede);
			this.getMap().setView(centroide, this.zoomPropriedade)
      layerSede.addTo(this.getMap())
		}
	}

  addMalhaAgua(layerGroup, id, stringJsonLine) {
    if (stringJsonLine != "") {
      var features = this.parseStringToJSON(stringJsonLine)
      var geoJson = L.geoJson(features, {
        onEachFeature: function (feature, layer) {
          var prop = feature.properties;
          var href = "";
          if (id && id != "") {
            href = "<a href='/malha_aguas/" + id + "/edit'>Editar</a>";
            href = href + " | <a data-confirm='Tem certeza?' rel='nofollow' data-method='delete' href='/malha_aguas/" + id + "'>Excluir</a>"
          }
          layer.bindPopup(href);
          layer.addTo(layerGroup);
        }
      });
      layerGroup.addTo(this.getMap())
    }
	}

  addArea(layerGroup, id, stringJsonGeometry) {
	  this.adicionarPoligonoArea(stringJsonGeometry, layerGroup, id);
    var j = this.parseStringToJSON(stringJsonGeometry)
    return this.metersToHectare(turf.area(j))
  }

  adicionarPoligonoArea(stringJsonGeometry, id, img) {
    if (stringJsonGeometry != "") {
      var features = this.parseStringToJSON(stringJsonGeometry)
      var geoJson = L.geoJson(features, {
        onEachFeature: function (feature, layer) {
          //Color: cor da borda
          //fillColor: cor do preenchimento
          layer.setStyle({color: '#00FFFF'}); //azul
          var prop = feature.properties;
          var href = "";
          if (id && id != "") {
            href = "</br><a href='/areas/" + id + "'>Detalhar</a>";
            href = href + " | <a href='/areas/" + id + "/edit'>Editar</a>";
            href = href + " | <a data-confirm='Tem certeza?' rel='nofollow' data-method='delete' href='/areas/" + id + "'>Excluir</a>"
          }
          var nome = "Nome: " + prop.nome;
          var situacao = "<br/>Condição: " + prop.situacao;
          if (prop.situacao == "Ruim") {
            layer.setStyle({color: 'red', fillColor: 'red'});
            situacao = "<br/>Condição: <b>" + prop.situacao + "</b>";
          }
          var anim = prop.animais;
          var qntDiasComAnimais = "";
          var indiceOcupacao = "";
          var areaHa = (this.metersToHectare(turf.area(feature))).toFixed(2);
          var area = "</br>Área Total: " + areaHa + " hectares";
          var historico = "<br/>Última alteração: " + prop.historico;
          var pastagemAtual = "<br/>Pastagem: " + (!prop.pastagem ? "não informada": prop.pastagem);
          var analises = "<br/>Análises efetuadas: " + prop.analises;
          if (anim == '0') {
            anim = " sem ocupação";
          } else {
            layer.setStyle({color: '#177011', fillColor: '#177011'}); //com animais - verde escuro
            qntDiasComAnimais = "<br/>Qnt de dias com animais: " + prop.qntDiasComAnimais;
            indiceOcupacao = "<br/>Índice de ocupação: " + (prop.animais/areaHa).toFixed(2) + " UA/ha";
          }
          layer.addTo(this.getMap());
          var animais = "<br/>Qnt Animais: " + anim;
          layer.bindPopup(
            img +
            "</br>" + "</br>" +
            nome + 
            situacao +
            pastagemAtual +
            animais + 
            area + 
            indiceOcupacao +
            qntDiasComAnimais +
            analises +
            historico +
            href);
        }.bind(this) 
      });
    }
  }

//   getAreaPoligonoHectare(stringJsonGeometria) {
// 	var retorno = 0;
// 	if (stringGeometria != "") {
// 		stringGeometria = replaceAll(stringGeometria, "&quot;", "\"");
// 		var features = JSON.parse(stringGeometria);
// 		var geoJson = L.geoJson(features);
		
		
// 		var geoJson = L.geoJson(features, {
// 			onEachFeature: function (feature, layer) {
// 				retorno = toHectare(LGeo.area(layer));
// 			}
// 		});
// 	}
// 	return retorno;
// }

  metersToHectare(value) {
    return value / 10000;
  }

  addCollapseControl() {
    var collapseControl = L.control();

      collapseControl.onAdd = function () {
          this._div = L.DomUtil.create('div', 'info');
          this.update();
          return this._div;
      };

      collapseControl.update = function (props) {
          this._div.innerHTML = '<img id="collapse" width="42px" height="42px" title="Ampliar mapa" style="background-color: white; cursor:pointer;" src="/images/collapse-right.png" onclick="showHideMapProperties()"/>';
      };

      collapseControl.addTo(this.getMap());
    
  }

  // addReloadControl(map) {
  //   var reloadControl = L.control();

  //   reloadControl.onAdd = function (map) {
  //       this._div = L.DomUtil.create('div', 'info');
  //       this.update();
  //       return this._div;
  //   };

  //   reloadControl.update = function (props) {
  //       this._div.innerHTML = '<img style="cursor:pointer" id="collapse" title="Recarregar mapa" width="40px" height="40px" src="/images/reload.png" onclick="reloadMap()"/>';
  //   };

  //   reloadControl.addTo(map);
  // }
}

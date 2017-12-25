L.Control.Coordinates=L.Control.extend({options:{position:"bottomright",decimals:4,decimalSeperator:".",labelTemplateLat:"Lat: {y}",labelTemplateLng:"Lng: {x}",labelFormatterLat:void 0,labelFormatterLng:void 0,enableUserInput:!0,useDMS:!1,useLatLngOrder:!1,centerUserCoordinates:!1,markerType:L.marker,markerProps:{}},onAdd:function(t){this._map=t;var e="leaflet-control-coordinates",i=this._container=L.DomUtil.create("div",e),n=this.options;this._labelcontainer=L.DomUtil.create("div","uiElement label",i),this._label=L.DomUtil.create("span","labelFirst",this._labelcontainer),this._inputcontainer=L.DomUtil.create("div","uiElement input uiHidden",i);var a,o;return n.useLatLngOrder?(o=L.DomUtil.create("span","",this._inputcontainer),this._inputY=this._createInput("inputY",this._inputcontainer),a=L.DomUtil.create("span","",this._inputcontainer),this._inputX=this._createInput("inputX",this._inputcontainer)):(a=L.DomUtil.create("span","",this._inputcontainer),this._inputX=this._createInput("inputX",this._inputcontainer),o=L.DomUtil.create("span","",this._inputcontainer),this._inputY=this._createInput("inputY",this._inputcontainer)),a.innerHTML=n.labelTemplateLng.replace("{x}",""),o.innerHTML=n.labelTemplateLat.replace("{y}",""),L.DomEvent.on(this._inputX,"keyup",this._handleKeypress,this),L.DomEvent.on(this._inputY,"keyup",this._handleKeypress,this),t.on("mousemove",this._update,this),t.on("dragstart",this.collapse,this),t.whenReady(this._update,this),this._showsCoordinates=!0,n.enableUserInput&&L.DomEvent.addListener(this._container,"click",this._switchUI,this),i},_createInput:function(t,e){var i=L.DomUtil.create("input",t,e);return i.type="text",L.DomEvent.disableClickPropagation(i),i},_clearMarker:function(){this._map.removeLayer(this._marker)},_handleKeypress:function(t){switch(t.keyCode){case 27:this.collapse();break;case 13:this._handleSubmit(),this.collapse();break;default:this._handleSubmit()}},_handleSubmit:function(){var t=L.NumberFormatter.createValidNumber(this._inputX.value,this.options.decimalSeperator),e=L.NumberFormatter.createValidNumber(this._inputY.value,this.options.decimalSeperator);if(void 0!==t&&void 0!==e){var i=this._marker;i||(i=this._marker=this._createNewMarker()).on("click",this._clearMarker,this);var n=new L.LatLng(e,t);i.setLatLng(n),i.addTo(this._map),this.options.centerUserCoordinates&&this._map.setView(n,this._map.getZoom())}},expand:function(){this._showsCoordinates=!1,this._map.off("mousemove",this._update,this),L.DomEvent.addListener(this._container,"mousemove",L.DomEvent.stop),L.DomEvent.removeListener(this._container,"click",this._switchUI,this),L.DomUtil.addClass(this._labelcontainer,"uiHidden"),L.DomUtil.removeClass(this._inputcontainer,"uiHidden")},_createCoordinateLabel:function(t){var e,i,n=this.options;return n.customLabelFcn?n.customLabelFcn(t,n):(e=n.labelLng?n.labelFormatterLng(t.lng):L.Util.template(n.labelTemplateLng,{x:this._getNumber(t.lng,n)}),i=n.labelFormatterLat?n.labelFormatterLat(t.lat):L.Util.template(n.labelTemplateLat,{y:this._getNumber(t.lat,n)}),n.useLatLngOrder?i+" "+e:e+" "+i)},_getNumber:function(t,e){return e.useDMS?L.NumberFormatter.toDMS(t):L.NumberFormatter.round(t,e.decimals,e.decimalSeperator)},collapse:function(){if(!this._showsCoordinates&&(this._map.on("mousemove",this._update,this),this._showsCoordinates=!0,this.options,L.DomEvent.addListener(this._container,"click",this._switchUI,this),L.DomEvent.removeListener(this._container,"mousemove",L.DomEvent.stop),L.DomUtil.addClass(this._inputcontainer,"uiHidden"),L.DomUtil.removeClass(this._labelcontainer,"uiHidden"),this._marker)){var t=this._createNewMarker(),e=this._marker.getLatLng();t.setLatLng(e);var i=L.DomUtil.create("div","");L.DomUtil.create("div","",i).innerHTML=this._ordinateLabel(e);var n=L.DomUtil.create("a","",i);n.innerHTML="Remove",n.href="#";var a=L.DomEvent.stopPropagation;L.DomEvent.on(n,"click",a).on(n,"mousedown",a).on(n,"dblclick",a).on(n,"click",L.DomEvent.preventDefault).on(n,"click",function(){this._map.removeLayer(t)},this),t.bindPopup(i),t.addTo(this._map),this._map.removeLayer(this._marker),this._marker=null}},_switchUI:function(t){L.DomEvent.stop(t),L.DomEvent.stopPropagation(t),L.DomEvent.preventDefault(t),this._showsCoordinates?this.expand():this.collapse()},onRemove:function(t){t.off("mousemove",this._update,this)},_update:function(t){var e=t.latlng,i=this.options;e&&(e=e.wrap(),this._currentPos=e,this._inputY.value=L.NumberFormatter.round(e.lat,i.decimals,i.decimalSeperator),this._inputX.value=L.NumberFormatter.round(e.lng,i.decimals,i.decimalSeperator),this._label.innerHTML=this._createCoordinateLabel(e))},_createNewMarker:function(){return this.options.markerType(null,this.options.markerProps)}}),L.control.coordinates=function(t){return new L.Control.Coordinates(t)},L.Map.mergeOptions({coordinateControl:!1}),L.Map.addInitHook(function(){this.options.coordinateControl&&(this.coordinateControl=new L.Control.Coordinates,this.addControl(this.coordinateControl))}),L.NumberFormatter={round:function(t,e,i){var n=L.Util.formatNum(t,e)+"",a=n.split(".");if(a[1]){for(var o=e-a[1].length;o>0;o--)a[1]+="0";n=a.join(i||".")}return n},toDMS:function(t){var e=Math.floor(Math.abs(t)),i=60*(Math.abs(t)-e),n=Math.floor(i),a=60*(i-n),o=Math.round(a);60==o&&(n++,o="00"),60==n&&(e++,n="00"),10>o&&(o="0"+o),10>n&&(n="0"+n);var r="";return 0>t&&(r="-"),""+r+e+"&deg; "+n+"' "+o+"''"},createValidNumber:function(t,e){if(t&&t.length>0){var i=t.split(e||".");try{var n=Number(i.join("."));return isNaN(n)?void 0:n}catch(a){return}}}};
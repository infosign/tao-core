﻿//import mx.controls.*;import lu.tao.utils.Event;import com.eXULiS.lib.defsRepository;import com.eXULiS.lib.*;//import xpath.*;import com.eXULiS.SVG.*;//import XML2Object;/*** SVG 2 SWF sub parser for Defs tag* @author Raynald Jadoul* @description Translates SVG syntax in Flash native components* @usage data = new SVGdefs2Flash().parseXML(anXML);*/class com.eXULiS.SVG.SVGdefs2Flash extends XML {    private var oResult:Object = new Object ();    private var oXML:XML;	private var canvas_mc:MovieClip;	private var targetExecutionLayer_mc:MovieClip;	private var objBroadcaster;	private var objListeners:Array;	private var objDefsRepository_ref:defsRepository;/*** * Constructor* * initializes the canvas movie clip*/	function SVGdefs2Flash(target_mc:MovieClip, base_mc:MovieClip) {		trace("SVGdefs2Flash: canvas initialized to " + target_mc._name);		canvas_mc = target_mc;		targetExecutionLayer_mc = base_mc;	}	public function destroy(){		for(var vCpt=0;vCpt < canvas_mc._exulis._objDescendants.length;vCpt++){			canvas_mc._exulis._objDescendants[vCpt].destroy();		}		canvas_mc.removeMovieClip();	}/*** @method get xml* @description return the xml passed in the parseXML method* @usage theXML = SVGdefs2Flash.xml*/    public function get xml():XML{        return oXML        }/*** @method public parseXML* @description return the parsed Object* @usage SVGdefs2Flash.parseXML( theXMLtoParse );* @param sFile XML* @returns an Object with the contents of the passed XML*/    public function parseXML (sXML:XML):Object {		trace("SVGdefs2Flash: SVG parsing started on node " + sXML.firstChild.nodeName);		this.oResult = new Object ();		this.oXML = sXML;		this.oResult = this.translateXML();		return this.oResult;    }// here we connect the canvas to the SVG construction// here SVGcircle    private function svg_circle(node:XML,current_mc){		trace("SVGdefs2Flash: SVG circle (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGcircle(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGdesc    private function svg_desc(node:XML,current_mc){        trace("SVGdefs2Flash: SVG desc (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGdesc(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGellipse    private function svg_ellipse(node:XML,current_mc){		trace("SVGdefs2Flash: SVG ellipse (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGellipse(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGg - g element is used for grouping    private function svg_g(node:XML,current_mc){        trace("SVGdefs2Flash: SVG grouping (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGg(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGimage    private function svg_image(node:XML,current_mc){        trace("SVGdefs2Flash: SVG image (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGimage(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGline    private function svg_line(node:XML,current_mc){		trace("SVGdefs2Flash: SVG line (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGline(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGlinearGradient    private function svg_linearGradient(node:XML,current_mc){		trace("SVGdefs2Flash: SVG linearGradient (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGlinearGradient(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGmarker    private function svg_marker(node:XML,current_mc){        trace("SVGdefs2Flash: SVG marker (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGmarker(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGpath    private function svg_path(node:XML,current_mc){		trace("SVGdefs2Flash: SVG path (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGpath(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGpolygon    private function svg_polygon(node:XML,current_mc){        trace("SVGdefs2Flash: SVG polygon (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGpolygon(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGpolyline    private function svg_polyline(node:XML,current_mc){        trace("SVGdefs2Flash: SVG polyline (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGpolyline(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGradialGradient    private function svg_radialGradient(node:XML,current_mc){		trace("SVGdefs2Flash: SVG radialGradient (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGradialGradient(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGrect    private function svg_rect(node:XML,current_mc){        trace("SVGdefs2Flash: SVG rect (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGrect(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGtext    private function svg_text(node:XML,current_mc){        trace("SVGdefs2Flash: SVG text (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGtext(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }// here SVGtspan    private function svg_tspan(node:XML,current_mc){        trace("SVGdefs2Flash: SVG tspan (" + node.attributes["id"] + ") triggered on " + current_mc._exulis.id + " on depth: " + current_mc._childNextDepth);		var object_obj = new SVGtspan(current_mc,node);		var local_mc = object_obj.create();		return local_mc;    }/*** @method private translateXML* @description core of the SVGdefs2Flash class*/        private function translateXML (from, path, name, position, current_mc) {		var local_mc:MovieClip;		var nodes;		var node;		var old_path;		if (path == undefined) {			trace("SVGdefs2Flash: SVG translation started on " + canvas_mc._name);			current_mc = canvas_mc;			path = this;			name = "oResult";		}		path = path[name];		if (from == undefined) {			from = new XML (this.xml.toString());			from.ignoreWhite = true;		}		if (from.hasChildNodes ()) {			nodes = from.childNodes;			if (position != undefined) {				old_path = path;				path = path[position];			}			while (nodes.length > 0) {				node = nodes.shift ();				if (node.nodeName != undefined) {					var __obj__ = new Object ();					__obj__.attributes = node.attributes;					__obj__.data = node.firstChild.nodeValue;					if (position != undefined) {						old_path = path;					}					if (path[node.nodeName] == undefined) {						path[node.nodeName] = new Array ();					}					path[node.nodeName].push (__obj__);					name = node.nodeName;					position = path[node.nodeName].length - 1;// GUI factory begins here					switch (node.nodeName){						case "circle":							local_mc = svg_circle(node,current_mc);							break;						case "defs":							local_mc = current_mc; // no need to re-enter defs parsing 'cause we're already in!							break;						case "desc":							local_mc = svg_desc(node,current_mc);							break;						case "ellipse":							local_mc = svg_ellipse(node,current_mc);							break;						case "g":							local_mc = svg_g(node,current_mc); // container							break;						case "image":							local_mc = svg_image(node,current_mc);							break;						case "line":							local_mc = svg_line(node,current_mc);							break;						case "linearGradient":							local_mc = svg_linearGradient(node,current_mc);							break;						case "marker":							local_mc = svg_marker(node,current_mc);							break;						case "path":							local_mc = svg_path(node,current_mc);							break;						case "polygon":							local_mc = svg_polygon(node,current_mc);							break;						case "polyline":							local_mc = svg_polyline(node,current_mc);							break;						case "radialGradient":							local_mc = svg_radialGradient(node,current_mc);							break;						case "rect":							local_mc = svg_rect(node,current_mc);							break;						case "text":							local_mc = svg_text(node,current_mc);							break;						case "tspan":							local_mc = svg_tspan(node,current_mc);							break;						case "svg":							local_mc = current_mc;							break;// elements not yet implemented/*						case "stop":							local_mc = xul_stop(node,current_mc);							break;						case "symbol":							local_mc = xul_symbol(node,current_mc);							break;						case "textPath":							local_mc = xul_textpath(node,current_mc);							break;						case "title":							local_mc = xul_title(node,current_mc);							break;						case "use":							local_mc = xul_use(node,current_mc);							break;*/// here unhandled tags						default:							trace("SVGdefs2Flash: SVG tag undefined: " + node.nodeName);							local_mc = current_mc;					}//					local_mc._visible = false;				}				if (node.hasChildNodes ()) {					this.translateXML (node, path, name, position,local_mc);				}			}		}		return this.oResult;	}}
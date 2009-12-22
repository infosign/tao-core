﻿import net.tekool.utils.Relegate;import com.eXULiS.lib.*;class com.eXULiS.lib.ItemSpreadSheetController {		public var spreadDisplayer:ItemSpreadSheetView;	private var spreadModel:ItemSpreadSheetModel;		private var currentNode_xml:XML;		private var currentDatas_xml:XML;			private var currentPath_str:String;			// xul windows contener	private var refWindow_mc:MovieClip;			private var listeners_ar:Array;		private var headerH_nbr:Number;		private var chboxCol_bool:Boolean;		private var numbersCol_bool:Boolean;		private var colorLineByEven_bool:Boolean;			public function ItemSpreadSheetController(spreadSheetModel,refWindow_mc:MovieClip,headerH:String,chboxCol:String,numbers:String,colorLineByEven_bool:String)	{		trace("BLACKspreadSheet CONSTRUCTOR [ItemSpreadSheetController]");		this.refWindow_mc=refWindow_mc;		spreadModel=spreadSheetModel;		trace("BLACKspreadSheet -------------------> "+refWindow_mc);				headerH_nbr= (Number(headerH)) ? Number(headerH) : undefined;			chboxCol_bool = (chboxCol=="true") ? true : false;		numbersCol_bool = (numbers=="false") ? false : true;		this.colorLineByEven_bool= (colorLineByEven_bool=="true") ? true:false;						spreadModel.addController(this);				initArrays();				trace("BLACKspreadSheet spreadModel.getXMLState() -------> "+spreadModel.getXMLState());				if (spreadModel.getXMLState())		{			init();		}										}						private function init():Void	{							currentDatas_xml=spreadModel.viewXMLCurrentState();				trace("BLACKspreadSheet init datas "+currentDatas_xml);		trace("BLACKspreadSheet init refWindow "+refWindow_mc);								spreadDisplayer=new ItemSpreadSheetView(refWindow_mc,this);		trace("BLACKspreadSheet init"+currentDatas_xml);		spreadDisplayer.displaySpreadSheet(currentDatas_xml,headerH_nbr,chboxCol_bool,numbersCol_bool,colorLineByEven_bool);			}				private function initArrays():Void	{		listeners_ar=new Array();	}		public function addlisteners(listeners):Boolean	{				// test if controller is not already in		for (var i in listeners_ar)		{			if (listeners_ar[i]==listeners)			{				trace("[ItemSpreadSheetController] > [addController] this controller already in");				return false;			}		}						listeners_ar.push(listeners);	}			public function listenersNotify(size_nbr):Void	{				for (var a in listeners_ar)		{			listeners_ar[a].updateScroll();		}	}				private function deletelisteners(listeners):Void	{				for (var a=0;a<listeners_ar.length;a++)		{			if (listeners_ar[a]==listeners)			{				listeners_ar.splice(a,1);			}		}				}				public function test()	{				trace("ZETEST CONTROLLER OK");	}						private function resetItemSpreadSheet():Void	{			}		private function emptyArray(array)	{		while (array.length>0)		{			array.pop();					}	}		private function removeClip(array)	{		for (var mc in array)		{			array[mc].removeMovieClip();					}	}	}
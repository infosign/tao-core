/**
 * TaoGridClass is an easy way to display tao grid with the jqGrid jquery widget 
 * 
 * @example new TaoGridClass('#grid-container', 'myData.php', {});
 * @see TaoGridClass.defaultOptions for options example
 * 
 * @require jquery >= 1.3.2 [http://jquery.com/]
 * @require jqgrid = 4.1.0 [http://www.trirand.com/blog/]
 * 
 * @author Cédric Alfonsi, <taosupport@tao.lu>
 */ 


/**
 * Constructor
 * @param {String} selector the jquery selector of the tree container
 * @param {Object} model the model of the grid as defined by the server side script (see 
 * @param {String} dataUrl the url to call, it must provide the json data to populate the tree 
 * @param {Object} options
 */
function TaoGridClass(selector, model, dataUrl, options)
{
	this.selector = selector;
	this.jqGrid = null;
	this.model = model;
	this.data = new Array(); 			//displayed data (before preformating)
	this.dataUrl = dataUrl;
	this.jqGridModel = new Array();
	this.jqGridColumns = new Array();
	this.adapters = new Array();		//adapters used in this grid
	this.options = $.extend([], TaoGridClass.defaultOptions, options);
	
	//Default dimension
	if(this.options.height==null){
		this.options.height = $(this.selector).parent().height();
	}
	if(this.options.width == null){
		this.options.width = $(this.selector).parent().width();
	}
	
	this.initModel();
	this.initGrid();
}

/**
 * Init the jqGridModel
 */
TaoGridClass.prototype.initModel = function()
{
	var columnsWeight = 0;
	var gridWidth = this.options.width;
	
	//pre model analysis
	for(var id in this.model){
		var weight = typeof this.model[id]['weight'] != 'undefined' ? this.model[id]['weight'] : 1;
		columnsWeight += weight;
	}
	
	//jqgrid model
	var i = 0;
	for(var id in this.model){

		//position of the column
		var position = typeof this.model[id].position != 'undefined' ? this.model[id].position: i;
		//create elements in tabs
		if(position!=i){
			this.jqGridColumns.splice(position,0,null);
			this.jqGridModel.splice(position,0,null);
		}
		
		//add a column
		this.jqGridColumns[position] = this.model[id]['title']

		//add the model relative to the column
		this.jqGridModel[position] = {
			name		:this.model[id]['id']
			, index		:this.model[id]['id']
			, align		:typeof this.model[id]['align'] != 'undefined' ? this.model[id]['align'] : 'left'
		};

		//a specific formatter has to be applied to the column
		if(typeof this.model[id]['widget'] != 'undefined' && this.model[id]['widget']!='Label'){
			//get adapter for the given widget
			var adapter = this.getAdapter(this.model[id]['widget']);
			//reference the adapter
			this.adapters[this.model[id]['id']] = adapter;
			//add adapter function to the column model options
			this.jqGridModel[position]['formatter'] = adapter.formatter;
		}
		
		// @todo DEVEL CODE
		if(this.model[id]['title'] == 'variables'){
			var adapterClass = window['TaoGridActivityVariablesAdapter'];
			this.jqGridModel[position]['formatter'] = adapterClass.formatter;
		}

		//fix the width of the column functions of its weight
		var weight = typeof this.model[id]['weight'] != 'undefined' ? this.model[id]['weight'] : 1;
		var width = ((gridWidth * weight) / columnsWeight) - 4; /* -5 padding margin of the cell container */
		//console.log('Et alors la width ca donne quoi '+gridWidth+" "+width);
		this.jqGridModel[position]['width'] = width;
		
		i++;
	}
}

/**
 * Init the grid
 */
TaoGridClass.prototype.initGrid = function()
{
	//if data url, data have to be formated to fit the following sample
	//	$test = array(
	//		"page"		=> 1
	//		, "total"	=> 1
	//		, "records"	=> 10
	//		, "rows" 	=> $returnValue
	//	);
	
	var self = this;
	this.jqGrid = $(this.selector).jqGrid({
		url			: this.dataUrl,
	    datatype	: "json",
	    mtype		: 'GET',
		colNames	: this.jqGridColumns, 
		colModel	: this.jqGridModel, 
		shrinkToFit	: true,
		//width		: parseInt($("#result-list").parent().width()) - 15, 
		//sortname	: 'id', 
		//sortorder	: "asc", 
		caption		: this.options.title,
		jsonReader: {
			repeatitems : false,
			id: "0"
		},
		height 		: this.options.height - 54,
		//witdh 		: this.options.width,
		autowidth	: true,
		onSelectRow: function(id){
		    if(self.options.callback.onSelectRow != null){
		    	self.options.callback.onSelectRow(id);
		    }
		}
		
	});
}

/**
 * Get formatter relative to a widget
 * @param {String} widget Name of the widget
 */
TaoGridClass.prototype.getAdapter = function(widget)
{
	var returnValue = null;
	
	var adapterClassName = 'TaoGrid'+widget+'Adapter';
	var adapterClass = window[adapterClassName];
	if(!adapterClass){
		throw new Error('Tao grid adapter (TaoGrid'+widget+'Adapter) does not exist');
	}
	returnValue = adapterClass;
	
	return returnValue;
}

/**
 * Get formatters relative to a column
 * @param {String|Array} widget Array of widgets or widget
 */
/*TaoGridClass.prototype.getAdapters = function(widgets)
{
	var returnValue = new Array();
	
	if(widgets instanceof Array){
		for(var i in widget){
			returnValue.push(this.getAdapter(widgets[i]));
		}
	}else{
		returnValue.push(this.getAdapter(widgets));
	}
	
	return returnValue;
}*/

/**
 * Empty the grid
 */
TaoGridClass.prototype.empty = function()
{
	var gridBody = $(this.selector).children("tbody");
	var firstRow = gridBody.children("tr.jqgfirstrow");
	gridBody.empty().append(firstRow);
	this.data = new Array();
}


/**
 * Delete a row
 * @param {Array} data 
 */
TaoGridClass.prototype.delete = function(rowId)
{
	jQuery(this.selector).jqGrid('delRowData', rowId);
}

/**
 * Refresh data
 * @param {Array} data 
 */
TaoGridClass.prototype.refresh = function(data)
{
	for(var rowId in data){
		this.data[rowId] = null;
		this.data[rowId] = data[rowId];

		for(var columnId in this.adapters){
			if(typeof this.adapters[columnId].preFormatter != 'undefined'){
				this.data[rowId][columnId] = this.adapters[columnId].preFormatter(this, this.data[rowId], rowId, columnId);
			}
		}
		
		console.log(jQuery(this.selector));
		console.dir(this.data[rowId]);
		jQuery(this.selector).jqGrid('setRowData', rowId, this.data[rowId]);
		
		for(var columnId in this.adapters){
			if(typeof this.adapters[columnId].postCellFormat != 'undefined'){
				var cell = this.getCell(rowId, columnId);
				this.adapters[columnId].postCellFormat(this, cell, rowId, columnId);
			}
		}
	}
}

/**
 * Get the position of a row
 * @param {String} rowId The target rowId 
 */
TaoGridClass.prototype.getPosition = function(rowId)
{
	var returnValue = -1;
	var i = -1;	//not 0 because the header tr
	$(this.selector).find('tbody:first').children().each(function(){
		if($(this).attr('id') == rowId){
			returnValue = i;
			return;
		}
		i++;
	});
	return returnValue;
}

/**
 * Add data to the grid
 * @param {Array} data 
 */
TaoGridClass.prototype.add = function(data)
{
	var crtLine = 0;
	//this.data = this.data.concat(data); // does not work with associative array
	for(var i in data){
		this.data[i] = data[i];
	}
	
	for(var rowId in data){
		//Pre rendering adapt data
		for(var columnId in this.adapters){
			if(typeof this.adapters[columnId].preFormatter != 'undefined'){
				this.data[rowId][columnId] = this.adapters[columnId].preFormatter(this, this.data[rowId], rowId, columnId);
			}
		}
		//Pre rendering adapt data functions of predefined macros
/*		for(var modelId in this.model){
			var columnId = this.model[modelId]['id'];
//			console.log('my column Id '+columnId);
			if(typeof this.model[columnId] == 'undefined'){
//				console.log('undefined '+columnId);
//				console.log(this.model);
			}
			if(typeof this.model[modelId].preFormatter != 'undefined' && this.model[modelId].preFormatter){
				switch(this.model[modelId].preFormatter){
					case 'empty':
//						console.log('empty');
						this.data[rowId][columnId] = null;
						break;
					case 'rowId':
//						console.log('ROWWWW ID '+rowId);
						this.data[rowId][columnId] = rowId;
						break;
				}
			}
		}*/
		//Render data
//		console.log('add row data', this.data[rowId]);
		jQuery(this.selector).jqGrid('addRowData', rowId, this.data[rowId]);
		//Post rendering adapt content
		for(var columnId in this.adapters){
			if(typeof this.adapters[columnId].postCellFormat != 'undefined'){
				var cell = this.getCell(rowId, columnId);
				this.adapters[columnId].postCellFormat(this, cell, rowId, columnId);
			}
		}
		crtLine ++;
		//return;
	}
}

/**
 * Get row
 * @param {String} rowId
 */
TaoGridClass.prototype.getRow = function(rowId)
{
	return $(this.selector).find('tr[id="'+rowId+'"]');
}

/**
 * Get cell
 * @param {String} rowId
 * @param {String} columnId
 */
TaoGridClass.prototype.getCell = function(rowId, columnId)
{
	return $(this.selector).find('tr[id="'+rowId+'"]').find('td[aria-describedby="'+this.selector.slice(1)+'_'+columnId+'"]');
}

/**
 * Get row data
 * @param {String} rowId
 */
TaoGridClass.prototype.getRowData = function(rowId)
{
	if(typeof this.data[rowId] != 'undefined'){
		return this.data[rowId];
	}
}

/**
 * Get row data
 * @param {String} rowId
 * @param {String} columnId
 */
TaoGridClass.prototype.getCellData = function(rowId, columnId)
{
	var returnValue = null;
	var rowData = this.getRowData(rowId);
	if(rowData){
		if(typeof rowData[columnId] != 'undefined'){
			returnValue = rowData[columnId];
		}
	}
	return returnValue;
}

/**
 * TaoGridClass default options
 */
TaoGridClass.defaultOptions = {
	'height' 	: null
	, 'width'	: null
	, 'title'	: 'GRID'
	, 'callback' : {
		'onSelectRow' : null
	}
};

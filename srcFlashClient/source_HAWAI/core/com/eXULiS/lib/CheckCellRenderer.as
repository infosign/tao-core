import mx.core.UIComponentimport mx.controls.CheckBoxclass com.eXULiS.lib.CheckCellRenderer extends mx.controls.cells.CheckCellRenderer{	function click()	{		super.click()		listOwner.selectedIndex = getCellIndex().itemIndex		listOwner.dispatchEvent({type:"cellPress"});		var _indice=listOwner.selectedIndex; 				trace("CELL_CHANGE," + "id"+_root.FEEDTRACE_PAYLOAD_ATTRIBUTE_NAME_VALUE_SEPARATOR+listOwner.getItemAt(_indice).feedId + "stimulus");		_level0.currentItemRootLevel.feedTrace("CELL_CHANGE","id"+ _root.FEEDTRACE_PAYLOAD_ATTRIBUTE_NAME_VALUE_SEPARATOR+listOwner.getItemAt(_indice).feedId,"stimulus");						//listOwner.setPropertiesAt(_indice, {backgroundColor:0xff0000} );	}}
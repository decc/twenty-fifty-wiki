document.observe('dom:loaded', function() {
  $$(".cost").invoke('observe','mouseover',tableHighlight); 
  $$(".cost").invoke('observe','mouseout',tableRemoveHighlight);  
});

function setField(field,value) {
	new Effect.Highlight(field,{duration:5.0});
	$(field).value = value;
	$(field).removeClassName(name,'blur');
	return false;
}
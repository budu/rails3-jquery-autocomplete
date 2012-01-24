/*
* Unobtrusive autocomplete
*
* To use it, you just have to include the HTML attribute autocomplete
* with the autocomplete URL as the value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete">
*
* Optionally, you can use a jQuery selector to specify a field that can
* be updated with the element id whenever you find a matching value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete" data-id-element="#id_field">
*/
$(document).ready(function(){$("input[data-autocomplete]").railsAutocomplete()}),function(a){var b=null;a.fn.railsAutocomplete=function(){return this.live("focus",function(){this.railsAutoCompleter||(this.railsAutoCompleter=new a.railsAutocomplete(this))})},a.railsAutocomplete=function(a){_e=a,this.init(_e)},a.railsAutocomplete.fn=a.railsAutocomplete.prototype={railsAutocomplete:"0.0.1"},a.railsAutocomplete.fn.extend=a.railsAutocomplete.extend=a.extend,a.railsAutocomplete.fn.extend({init:function(a){function b(b){return b.split(a.delimiter)}function c(a){return b(a).pop().replace(/^\s+/,"")}function d(){var a=this.value;$(this).bind("keyup.clearId",function(){$(this).val().trim()!=a.trim()&&($($(this).attr("data-id-element")).val("").change(),$(this).unbind("keyup.clearId"))})}a.delimiter=$(a).attr("data-delimiter")||null,$(a).autocomplete({source:function(b,d){var f={term:c(b.term)},g=$(a).triggerHandler("railsAutocomplete.source",f);f=g?g:f,$.getJSON($(a).attr("data-autocomplete"),f,function(){$(arguments[0]).each(function(b,c){var d={};d[c.id]=c,$(a).data(d)}),d.apply(null,arguments)})},search:function(){var a=c(this.value);if(a.length<2)return!1},focus:function(){return!1},create:function(){d.call(this)},select:function(c,f){var g=b(this.value);g.pop(),g.push(f.item.value);if(a.delimiter!=null)g.push(""),this.value=g.join(a.delimiter);else{this.value=g.join(""),$(this).attr("data-id-element")&&$($(this).attr("data-id-element")).val(f.item.id).change();if($(this).attr("data-update-elements")){var h=$(this).data(f.item.id.toString()),i=$.parseJSON($(this).attr("data-update-elements"));for(var j in i)$(i[j]).val(h[j])}}return d.call(this),$(this).trigger("railsAutocomplete.select",f),!1}})}})}(jQuery)
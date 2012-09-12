c = require('nct').coffee

exports.field = (name,value,options={type:'text'}) ->
  labelname = options.label || name
  c.div '.control-group.@error:'+name, ->
    c.label '.control-label', for: name, labelname
    c.div '.controls', ->
      c.input '.span4', {name,type: options.type,value}, ''
      c.$if 'error.'+name, ->
        c.span '.help-inline', '@error.'+name+'_message'


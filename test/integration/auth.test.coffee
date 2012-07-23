
fill = (fields={}) ->
  _.each fields, (val,name) ->
    $("input[name=#{name}]").val(val)

describe "Auth Flow", ->
  before (success) ->
    console.log "** Before"
    $.post '/test/reset', {success}

  beforeEach ->
    console.log "**** After"
    $('body').off('show', "**")

  it "should require all four input fields", (done) ->
    $('body').on 'show', ->
      console.log "ON show"
      $('button').trigger('submit')
      expect($('div.error').length).to.equal 4
      expect($('div.alert').text().trim()).to.equal 'Validation Failed'
      $('body').off('show','**')
      done()
    window.router.show('/signup')

  it "should require all four fields", ->
    fill {username: 'wvl', name: 'Wayne'}
    $('button').trigger('submit')
    expect($('input[name=username]').val()).to.equal 'wvl'
    expect($('div.error').length).to.equal 2
    expect($('div.alert').text().trim()).to.equal 'Validation Failed'

  it "should submit signup field", (done) ->
    fill {email: 'wayne@larsen.st', password: 'password'}
    $('body').on 'show', ->
      expect(location.pathname).to.equal '/'
      done()
    $('button').trigger('submit')


fill = (fields={}) ->
  _.each fields, (val,name) ->
    $("input[name=#{name}]").val(val)

describe "Auth Flow", ->
  before (success) ->
    $.post '/test/reset', {success}

  beforeEach -> window.store.off 'show'

  it "should require all four input fields", (done) ->
    window.store.on 'show', ->
      $('button').trigger('submit')
      expect($('div.error').length).to.equal 4
      expect($('div.alert').text().trim()).to.equal 'Validation Failed'
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
    window.store.on 'show', ->
      expect(location.pathname).to.equal '/'
      done()
    $('button').trigger('submit')

  it "should not allow duplicate usernames", (done) ->
    window.router.show '/signup', (err, view) ->
      fill {username: 'wvl', name: 'Wayne', email: 'wayne+two@larsen.st', password: 'password'}
      view.on 'error', (err) ->
        console.log "View error received", err
        expect($('div.error').length).to.equal 2
        expect($('input[name=username]').next().text()).to.equal 'Already exists'
        expect($('input[name=email]').next().text()).to.equal 'Already exists'
        done()
      $('button').trigger('submit')

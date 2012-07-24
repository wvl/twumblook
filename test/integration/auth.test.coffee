
fill = (fields={}) ->
  _.each fields, (val,name) ->
    $("input[name=#{name}]").val(val).trigger('change')

describe "Auth Flow", ->

  before (success) ->
    $.post '/test/reset', {success}

  beforeEach -> window.store.off 'show'

  it "should require all four input fields", (done) ->
    window.store.on 'show', ->
      $('button').trigger('submit')
      expect($('div.error').length).to.equal 4
      expect($('div.alert').text().trim()).to.equal 'Validation Failed'
      expect($("a[href='/settings']").length).to.equal 0
      expect($("a[href='/login']").length).to.equal 2
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
      expect($("a[href='/profile']").text()).to.equal 'wvl'
      expect($("a.logout").length).to.equal 1
      done()
    $('button').trigger('submit')

  it "should logout", (done) ->
    window.store.on 'show', ->
      expect(location.pathname).to.equal '/'
      done()
    $('a.logout').trigger('click')

  it "should login", (done) ->
    window.store.on 'show', (ctx) ->
      if ctx.path=='/login'
        fill {username: 'wvl', password: 'password'}
        $('button').trigger('submit')
      else
        expect(ctx.path).to.equal '/'
        expect($("a[href='/profile']").text()).to.equal 'wvl'
        done()

    router.show('/login')


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

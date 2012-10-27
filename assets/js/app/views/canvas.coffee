define ['backbone'], (Backbone) ->

  class Canvas extends Backbone.View

    el: '#main'

    clickX: []
    clickY: []
    clickDrag: []
    clickColor: []
    paint: false


    events:
      'touchstart #canvas'  : 'drawDot',
      'touchmove  #canvas'  : 'drawLine'
      'mousedown #canvas'   : 'drawDot'
      'mousemove #canvas'   : 'drawLine'
      'mouseup #canvas'     : 'stopDrawing'
      'mouseleave #canvas'  : 'stopDrawing'
      'click #clearCanvas'  : 'clearCanvas'
      'click #submitDrawing': 'submitDrawing'
      'change #colorPicker' : 'setColor'

    initialize: () ->
      @canvas = @$el.find('#canvas')
      @canvasHeight = @canvas.attr('height')
      @canvasWidth = @canvas.attr('width')
      @ctx = @canvas.get(0).getContext('2d')

      @model.bind 'change', (() -> @redraw(true)), @

      @$el.find('#colorPicker').colorPicker()
      @


    setContextDefaultOptions: (color) ->
      @ctx.fillStyle = color
      @ctx.strokeStyle = color
      @ctx.lineJoin = 'round'
      @ctx.lineWidth = 4

    setColor: (e) =>
      e = e or window.event
      color = e.target.value

      @ctx.fillStyle   = color
      @ctx.strokeStyle = color


    drawDot: (e) =>
      e.preventDefault()
      if e.originalEvent.touches
        e = e.originalEvent.touches[0]
      else
        e = e or window.event

      target = e.target or e.srcElement
      x = e.pageX - target.offsetLeft
      y = e.pageY - target.offsetTop


      @setContextDefaultOptions(@$el.find('#colorPicker').val())

      @paint = true
      @addClick x, y, @ctx.fillStyle

      @ctx.beginPath()
      @ctx.arc(x, y, @ctx.lineWidth / 2, 0, Math.PI * 2, true)
      @ctx.closePath()
      @ctx.fill()


    drawLine: (e) =>
      e.preventDefault()
      if e.originalEvent.touches
        e = e.originalEvent.touches[0]
      else
        e = e or window.event

      target = e.target or e.srcElement
      x = e.pageX - target.offsetLeft
      y = e.pageY - target.offsetTop

      if @paint
        @addClick x, y, @ctx.fillStyle, true
        @ctx.beginPath()
        @ctx.moveTo @clickX[@clickX.length - 2], @clickY[@clickY.length - 2]

        @ctx.lineTo x, y
        @ctx.closePath()
        @ctx.stroke()


    stopDrawing: (e) =>
      @paint = false
      @redraw()


    clearCanvas: (e) =>
      @clickX     = []
      @clickY     = []
      @clickDrag  = []
      @clickColor = []
      @canvas.attr 'width', @canvasWidth


    submitDrawing: (e) =>
      @model.save
        currentDrawing:
          clickX: @clickX
          clickY: @clickY
          clickDrag: @clickDrag
          clickColor: @clickColor


    redraw: (datafromModel=false) ->
      @ctx.clearRect 0, 0, @canvasWidth, @canvasHeight # Fill in the canvas with white

      if datafromModel
        @canvas.attr 'width', @canvasWidth
        @refreshPlayerList(@model.get('players'))

        #refresh clickX, clickY, clickDrag and clickColor properties
        for property, value of @model.get('currentDrawing')
          @[property] = value


      i = 0
      while i < @clickX.length
        @setContextDefaultOptions(@clickColor[i])
        @ctx.beginPath()
        if @clickDrag[i] and i
          @ctx.moveTo @clickX[i - 1], @clickY[i - 1]
        else
          @ctx.moveTo @clickX[i] - 1, @clickY[i]
        @ctx.lineTo @clickX[i], @clickY[i]
        @ctx.closePath()
        @ctx.stroke()
        i++


    refreshPlayerList: (players) ->
      players = ("<li>#{p}</li>" for p in players)
      $ul = @$el.find 'ol'
      $ul.html players.join ''


    addClick: (x, y, color, dragging=false) ->
      @clickX.push x
      @clickY.push y
      @clickColor.push color
      @clickDrag.push dragging


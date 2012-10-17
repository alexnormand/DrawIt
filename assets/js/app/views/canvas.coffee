define ['backbone'], (Backbone) ->

  class Canvas extends Backbone.View

    el: '#main'

    clickX: []
    clickY: []
    clickDrag: []
    paint: false


    events:    
      'mousedown #canvas'   : 'drawDot'        
      'mousemove #canvas'   : 'drawLine'        
      'mouseup #canvas'     : 'stopDrawing'
      'mouseleave #canvas'  : 'stopDrawing'
      'click #clearCanvas'  : 'clearCanvas'
      'click #submitDrawing': 'submitDrawing'
        
    initialize: () ->
      @canvas = @$el.find('#canvas')
      @anvasHeight = @canvas.attr('height')
      @canvasWidth = @canvas.attr('width')
      @ctx = @canvas.get(0).getContext('2d')
      @setContextDefaultOptions()

      @model.bind 'change', (() -> @redraw(true)), @


    setContextDefaultOptions: () ->
      @ctx.fillStyle = '#df4b26'
      @ctx.strokeStyle = '#df4b26'
      @ctx.lineJoin = 'round'
      @ctx.lineWidth = 4  


    drawDot: (e) =>
      e = e or window.event
      target = e.target or e.srcElement
      x = e.pageX - target.offsetLeft
      y = e.pageY - target.offsetTop

      @paint = true
      @addClick x, y

      @ctx.fillStyle = '#df4b26'
      @ctx.strokeStyle = '#df4b26'
      @ctx.lineJoin = 'round'
      @ctx.lineWidth = 4

      @ctx.beginPath()
      @ctx.arc(x, y, @.ctx.lineWidth / 2, 0, Math.PI * 2, true)
      @ctx.closePath()
      @ctx.fill()


    drawLine: (e) =>
      e = e or window.event
      target = e.target or e.srcElement
      x = e.pageX - target.offsetLeft
      y = e.pageY - target.offsetTop

      if @paint
        @addClick x, y, true        
        @ctx.beginPath()
        @ctx.moveTo @clickX[@clickX.length - 2], @clickY[@clickY.length - 2]

        @ctx.lineTo x, y
        @ctx.closePath()
        @ctx.stroke()


    stopDrawing: (e) =>
      @paint = false
      @redraw()


    clearCanvas: (e) =>      
      @clickX = []
      @clickY = []
      @clickDrag = []
      @canvas.attr 'width', @canvasWidth


    submitDrawing: (e) =>
      @model.save
        currentDrawing: 
          clickX: @clickX
          clickY: @clickY
          clickDrag: @clickDrag        
        
     
    redraw: (datafromModel) ->
      @ctx.clearRect 0, 0, @canvasWidth, @canvasHeight # Fill in the canvas with white
     
      if datafromModel
        @canvas.attr 'width', @canvasWidth        
        @setContextDefaultOptions()
        @refreshPlayerList(@model.get('players'))
        @clickX = @model.get('currentDrawing').clickX      
        @clickY = @model.get('currentDrawing').clickY
        @clickDrag = @model.get('currentDrawing').clickDrag
        console.log @model


      i = 0

      while i < @clickX.length
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
      players = players.map (p) -> "<li>#{p}</li>"
      $ul = @$el.find 'ol'
      $ul.html players.join ''


    addClick: (x, y, dragging) ->
      @clickX.push x
      @clickY.push y
      @clickDrag.push dragging


   




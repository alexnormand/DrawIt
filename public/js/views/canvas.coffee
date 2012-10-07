define ['backbone'], (Backbone) ->

  class Canvas extends Backbone.View

    el: '#main'

    clickX: []
    clickY: []
    clickDrag: []
    paint: false


    events:    
      'mousedown #canvas' : 'drawDot'        
      'mousemove #canvas': 'drawLine'        
      'mouseup #canvas': 'stopDrawing'
      'mouseleave #canvas': 'stopDrawing'
      'click #clearCanvas': 'clearCanvas'
        
    initialize: () ->
      @canvas = @$el.find('#canvas')
      @anvasHeight = @canvas.attr('height')
      @canvasWidth = @canvas.attr('width')
      @ctx = @canvas.get(0).getContext('2d')


    drawDot: (e) =>
      target = e.target
      @paint = true
      @addClick e.pageX - target.offsetLeft, e.pageY - target.offsetTop
      @redraw()


    drawLine: (e) =>
      target = e.target
      if @paint
        @addClick e.pageX - target.offsetLeft, e.pageY - target.offsetTop, true
        @redraw()

    stopDrawing: (e) =>
      @paint = false

    clearCanvas: (e) =>      
      @clickX = []
      @clickY = []
      @clickDrag = []
      @canvas.attr 'width', @canvasWidth

       
    redraw: () ->
      @ctx.clearRect 0, 0, @canvasWidth, @canvasHeight # Fill in the canvas with white
      @ctx.strokeStyle = '#df4b26'
      @ctx.lineJoin = 'round'
      @ctx.lineWidth = 5
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

    addClick: (x, y, dragging) ->
      @clickX.push x
      @clickY.push y
      @clickDrag.push dragging


   




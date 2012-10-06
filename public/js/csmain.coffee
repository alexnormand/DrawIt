define ['jquery'], () ->
  $ ->
    canvas = document.getElementById("canvas")
    $canvas = $(canvas)
    canvasHeight = $canvas.attr("height")
    canvasWidth = $canvas.attr("width")
    ctx = canvas.getContext("2d")
    clickX = []
    clickY = []
    clickDrag = []
    paint = false
    
    addClick = (x, y, dragging) ->
      clickX.push x
      clickY.push y
      clickDrag.push dragging

    redraw = ->
      ctx.clearRect 0, 0, canvasWidth, canvasHeight # Fill in the canvas with white
      ctx.strokeStyle = "#df4b26"
      ctx.lineJoin = "round"
      ctx.lineWidth = 5
      i = 0

      while i < clickX.length
        ctx.beginPath()
        if clickDrag[i] and i
          ctx.moveTo clickX[i - 1], clickY[i - 1]
        else
          ctx.moveTo clickX[i] - 1, clickY[i]
        ctx.lineTo clickX[i], clickY[i]
        ctx.closePath()
        ctx.stroke()
        i++

    $canvas.mousedown (e) ->
      mouseX = e.pageX - @offsetLeft
      mouseY = e.pageY - @offsetTop
      paint = true
      addClick e.pageX - @offsetLeft, e.pageY - @offsetTop
      redraw()

    $canvas.mousemove (e) ->
      if paint
        addClick e.pageX - @offsetLeft, e.pageY - @offsetTop, true
        redraw()

    $canvas.on "mouseup mouseleave", (e) ->
      paint = false

    $("#clearCanvas").click (e) ->
      clickX = []
      clickY = []
      clickDrag = []
      $canvas.attr "width", $canvas.attr("width")



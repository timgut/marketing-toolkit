window.Toolkit ||= {}

class Toolkit.Job
  constructor: (@el, @job, @document_id) ->
    @create()
    @displayLoading()
    @addJobToUser()

  ###
  # Instance Methods
  ###

  # Poll the server every second until the job is finished.
  create: =>
    poll = setInterval ( =>
      $.ajax({
        url: "/documents/#{@document_id}/job_status",
        type: "GET",
        dataType: "json"
      }).done((data, textStatus, jqXHR) =>
        switch data.status
          when "complete"
            clearInterval(poll)
            @displayResult(data)
            @removeJobFromUser()
          when "incomplete"

          else
            console.log "Don't know what to do with job response."
            console.log data 
      )
    ), 3000

  addJobToUser: ->
    Toolkit.jobs.push(@document_id)

  removeJobFromUser: ->
    index = Toolkit.jobs.indexOf(@document_id)
    Toolkit.jobs.splice(index, 1) if index?

  displayLoading: ->
    $(@el).find(".options>li>a").click()
    
    $(@el).prepend("
     <div class='overlay'>
        <span class='positioner'>
          <img src='/assets/loader.svg' />
          Generating your document                    
        </span>
      </div>
    ")

  displayResult: (data) ->
    $overlay = $(@el).find(".overlay")
    $thumb   = $(@el).find(".document-thumbnail")
    $pdf     = $(@el).find(".options .download")

    # It's possible for this function to be called more than once,
    # so only process the UI callbacks if the overlay is still in the DOM.
    if $overlay.length > 0
      $overlay.remove()
      $thumb.css("background-image", "url('#{data.thumbnail}');")
      $pdf.prop("href", data.pdf).prop("target", "_blank").removeAttr("data-id data-job data-remote")

      window.open(data.pdf)

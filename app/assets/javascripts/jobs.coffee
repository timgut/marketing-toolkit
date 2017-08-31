window.Toolkit ||= {}

class Toolkit.Job
  constructor: (@el, @job, @document_id) ->
    @openedPDF = false

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
    # Hide the 'Download' links
    if Toolkit.isDocumentEditPage()
      $(".download-document").hide()

    # Close the plus menu and display the overlay
    else if Toolkit.isDocumentsIndexPage() and @el?
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
    # Show the download links
    if Toolkit.isDocumentEditPage()
      $(".download-document").prop("href", data.pdf).prop("target", "_blank").show()

    # Hide the overlay; Change the thumbnail; Change the download link; Open the PDF.
    else if Toolkit.isDocumentsIndexPage() and @el?
      $overlay = $(@el).find(".overlay")
      $thumb   = $(@el).find(".document-thumbnail")
      $pdf     = $(@el).find(".options .download")

      $overlay.remove()
      $thumb.attr("style", "background-image: url('#{data.thumbnail}');")
      $pdf.prop("href", data.pdf).prop("target", "_blank").removeAttr("data-id data-job data-remote")

      # Timing issues can cause this function can be called more than once, so ensure that the PDF is only opened once.
      if @openedPDF is false
        window.open(data.pdf)
        @openedPDF = true

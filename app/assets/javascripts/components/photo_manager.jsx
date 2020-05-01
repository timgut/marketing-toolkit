/**
 * TODO NEXT: My idea of uploading a photo in a second form submission isn't panning out.
 * Look into using the FormData class to send the photo upload data via ajax.
 */
class PhotoManager extends React.Component{
  constructor(props={}){
    super(props);
    this.state = {
      step: "open"
    };
    // Toolkit.modalState = "open";

    this.imageFormRef   = React.createRef();
    this.photoInputRef  = React.createRef();
    this.uploadFormRef  = React.createRef();

    this.handleDrop     = this.handleDrop.bind(this);
    this.handleDragOver = this.handleDragOver.bind(this);
  };

  /**
   * LIFECYCLE FUNCTIONS
   */
  componentDidMount(){
    $("#tabs").tabs();
  };

  /**
   * EVENT HANDLERS
   */
  handleDragOver(e){
    e.preventDefault();
    e.stopPropagation();
  };

  handleDrop(e){
    e.preventDefault();
    e.stopPropagation();
    const files = e.dataTransfer.files;

    if(files){
      this.photoInputRef.current.files = files

      const _this = this;
      const uploadForm = this.uploadFormRef.current;

      $.ajax({
        url:      "/images",
        method:   "POST",
        data:     {},
        dataType: "json"
      }).done(function(data){
        _this.setState({step: "uploading"});
        $(uploadForm).attr("action", `/images/${data.id}/upload_photo`)
        $(uploadForm).trigger("submit");
        // uploadForm.dispatchEvent(new Event("submit"));

        const interval = setInterval(function(){
          $.ajax({
            url:      `/images/${data.id}/upload_photo_status`,
            type:     "GET",
            dataType: "json"
          }).done(function(data){
            if(data.uploaded){
              clearInterval(interval);
              _this.setState({step: "uploaded"});
            }
          })
        }, 1500);
      });

    } else {
      console.log("Couldn't find file");
    }
  };

  render(){
    let uploadTab;

    switch(this.state.step){
      case "open":
        uploadTab = (
          <section id="upload-image" className="upload-image">
            <h3>Upload an Image</h3>

            {/* Initial form submission creates an Image record */}
            <form id="create-image-form" ref={this.imageFormRef} action="/images" method="post">
              <input type="hidden" name="utf8" value="✓" />
              <input type="hidden" name="format" value="json" />
              <input type="hidden" name="authenticity_token" value={document.querySelector('[name=csrf-token]').content} />
            </form>

            {/* This form is submitted once an Image is created and creates the photo in the background */}
            <iframe src="about:blank" name="submit-frame" style={{display: "none"}}></iframe>
            <form id="upload-photo-form" target="submit-frame" ref={this.uploadFormRef} className="dropzone dz-clickable" encType="multipart/form-data" action="#" acceptCharset="UTF-8" method="post">
              <input type="hidden" name="utf8" value="✓" />
              <input type="hidden" name="authenticity_token" value={document.querySelector('[name=csrf-token]').content} />
              <input type="file" name="photo" id="image_photo" value="" ref={this.photoInputRef} readOnly={true} style={{display: "none"}} />

              <div className="dz-default dz-message" onDragOver={this.handleDragOver} onDrop={this.handleDrop}>
                <span>
                  <h4>DROP IMAGE HERE TO UPLOAD</h4>
                  <p className="or">or</p>
                  <div className="button">Select File</div>
                </span>
              </div>
            </form>
          </section>
        );
        break;

        case "uploading":
          uploadTab = (
            <div className='loading-box'>
              <div className='vert-align'>
                <div className='loader'>
                  <svg version='1.1' id='loader-1' xmlns='http://www.w3.org/2000/svg' x='0px' y='0px' width='40px' height='40px' viewBox='0 0 50 50'>
                    <path fill='#fff' d='M43.935,25.145c0-10.318-8.364-18.683-18.683-18.683c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615c8.072,0,14.615,6.543,14.615,14.615H43.935z'>
                      <animateTransform
                        attributeType='xml'
                        attributeName='transform'
                        type='rotate' 
                        from='0 25 25' 
                        to='360 25 25' 
                        dur='0.6s' 
                        repeatCount='indefinite' 
                      />
                    </path>
                  </svg>
                </div>
                <div className='loading-text'>
                  Loading Image
                  <small>High Resolution images may take a moment</small>
                </div>
              </div>
            </div>
          );
          break;

        case "uploaded":
          uploadTab = (
            <p>TIME TO CROP!</p>
          );
          break;

      default:
        console.log(`Don't know what to do with ${Toolkit.modalState}`)
    }
    return(
      <React.Fragment>
        <div className="select-image">
          <h2>Select an Image</h2>

          <section className="image-grid cf" data-loaded="true">
            <div id="tabs" className="ui-tabs ui-corner-all ui-widget ui-widget-content">
              <ul role="tablist" className="ui-tabs-nav ui-corner-all ui-helper-reset ui-helper-clearfix ui-widget-header">
                <li role="tab" tabIndex="0" className="ui-tabs-tab ui-corner-top ui-state-default ui-tab ui-tabs-active ui-state-active" aria-controls="upload" aria-labelledby="ui-id-1" aria-selected="true" aria-expanded="true"><a href="#upload" role="presentation" tabIndex="-1" className="ui-tabs-anchor" id="ui-id-1">Upload Photo</a></li>
                <li role="tab" tabIndex="-1" className="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="mine" aria-labelledby="ui-id-2" aria-selected="false" aria-expanded="false"><a href="#mine" role="presentation" tabIndex="-1" className="ui-tabs-anchor" id="ui-id-2">My Photos</a></li>
                <li role="tab" tabIndex="-1" className="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="stock" aria-labelledby="ui-id-3" aria-selected="false" aria-expanded="false"><a href="#stock" role="presentation" tabIndex="-1" className="ui-tabs-anchor" id="ui-id-3">Stock Photos</a></li>
              </ul>

              <div id="upload" aria-labelledby="ui-id-1" role="tabpanel" className="ui-tabs-panel ui-corner-bottom ui-widget-content" aria-hidden="false" style={{display: "block"}}>
                {uploadTab}
              </div>

              <div id="mine" aria-labelledby="ui-id-2" role="tabpanel" className="ui-tabs-panel ui-corner-bottom ui-widget-content" style={{display: "none"}} aria-hidden="true">
                <PhotoChooser type="mine" root={this} />
              </div>

              <div id="stock" aria-labelledby="ui-id-3" role="tabpanel" className="ui-tabs-panel ui-corner-bottom ui-widget-content" style={{display: "none"}} aria-hidden="true">
                <PhotoChooser type="stock" root={this} />
              </div>
            </div>
          </section>
        </div>
      </React.Fragment>
    );
  };
}

class PhotoManager extends React.Component{
  constructor(props={}){
    super(props);
    this.resetState();

    this.handleClick  = this.handleClick.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleSelect = this.handleSelect.bind(this);

    this.previewRef = React.createRef();
  };

  /**
   * LIFECYCLE FUNCTIONS
   */
  componentDidMount(){
    const _this = this;
    $("#tabs").tabs();

    console.log(Toolkit.photoManagerData);

    this.dropzone = new Dropzone("#dropzone", { 
      dictDefaultMessage:    "<h4>DROP IMAGE HERE TO UPLOAD</h4><p class='or'>or</p><div class='button'>Select File</div>",
      createImageThumbnails: false,
      url:       "/images",
      paramName: "photo",
      params:    { authenticity_token: document.querySelector('[name=csrf-token]').content },
      sending:   function(file, xhr, formData){ _this.setState({step: "uploading"}); },
      complete:  function(file){
        if(file.status === "success"){
          const data = JSON.parse(file.xhr.response);
          const image = {
            id: data.id,
            croppedUrl:  data.cropped_image_url,
            originalUrl: data.original_image_url,
            imgixUrl:    `https://afscme.imgix.net/${data.original_image_url.split("https://s3.amazonaws.com/toolkit.afscme.org/")[1]}`,
            meta:        null
          };

          _this.setState({
            image: image,
            step:  "uploaded"
          });
        } else {
          console.log("Figure out how to handle failures");
        }
      }
    });
  };

  componentDidUpdate(){
    const _this = this;

    switch(this.state.step){
      case "uploaded":
        if(this.state.image.meta === null){
          $.ajax({
            url:    `${this.state.image.imgixUrl}?fm=json`,
            method: "GET",
          }).done(function(data){
            _this.setState({image: Object.assign({}, _this.state.image, {meta: data})});
          });
        }
        break;

      case "setup-crop":
        availableHeight = Math.round($("body").height() * 0.8);
        availableWidth  = Math.round($("body").width()  * 0.8);

        if(this.state.image.meta.PixelHeight > availableHeight && this.state.image.meta.PixelWidth > availableWidth){
          // Original photo is too large to crop on both dimensions
          // this.state.imageToCrop = `${this.state.image.imgixUrl}?fit=fill&width=${availableWidth}&height=${availableHeight}`;
          this.state.boxHeight = availableHeight;
          this.state.boxWidth  = availableWidth;

        } else if(this.state.image.meta.PixelHeight > availableHeight){
          // Original photo is too tall to crop
          // this.state.imageToCrop = `${this.state.image.imgixUrl}?fit=clamp&height=${availableHeight}`;
          this.state.boxHeight = availableHeight;
          this.state.boxWidth  = this.state.image.meta.PixelWidth;

        } else if(this.state.image.meta.PixelWidth > availableWidth){
          // Original photo is too wide to crop
          // this.state.imageToCrop = `${this.state.image.imgixUrl}?fit=clamp&width=${availableWidth}`;
          this.state.boxHeight = this.state.image.meta.PixelHeight;
          this.state.boxWidth  = availableWidth;
        
        } else {
          // Original photo is okay to crop
          this.state.imageToCrop = this.state.image.imgixUrl;
        }

        this.state.imageToCrop = this.state.image.imgixUrl;
        this.setState({step: "cropping"});
        break;

      case "cropping":
        if(this.state.jcropApi === null){
          $("#image-to-crop").Jcrop({
            boxWidth:  this.state.boxWidth,
            boxHeight: this.state.boxHeight,
            onSelect:  this.handleSelect,
            onChange:  this.handleChange
          },function(){
            _this.state.jcropApi = this;
          });
        }
        break;

      case "preview":
        $(this.previewRef.current).attr("style", "");
        this.state.jcropApi.destroy();
        this.state.jcropApi = null;
        break;
    }
  }

  /**
   * EVENT HANDLERS
   */
  // Disable the preview button while the user changes the cropping selection.
  handleChange(e){
    if(this.state.canPreview){
      this.setState({canPreview: false});
    }
  };

  handleClick(e){
    switch(e.target.dataset.action){
      case "crop-photo":
        this.setState({cropSetup: false, step: "setup-crop"});
        break;

      case "preview-photo":
        this.setState({step: "preview"});
        break;

      case "select-photo":
        this.setState({step: "selected"});
        break;

      default:
        console.log(e.target.dataset.action);
    }
  };

  // The user is done dragging the cropping tool. Let them preview.
  handleSelect(e){
    this.setState({
      canPreview: true,
      coords: {
        x1: Math.round(e.x),
        y1: Math.round(e.y),
        x2: Math.round(e.x2),
        y2: Math.round(e.y2),
        h:  Math.round(e.h),
        w:  Math.round(e.w)
      }
    });
  };

  /**
   * COMPONENT FUNCTIONS
   */
  /**
   * Takes the current component state and builds a URL where the user's cropped and resized image lives.
   */
  buildPreviewUrl(){
    let params = {};
    if(this.state.coords.x1 && this.state.coords.y1 && this.state.coords.w && this.state.coords.h){
      params.rect = `${this.state.coords.x1},${this.state.coords.y1},${this.state.coords.w},${this.state.coords.h}`;
    }

    if(this.state.resizeHeight && this.state.resizeWidth){
      params.fit = "crop";
      params.h   = this.state.resizeHeight;
      params.w   = this.state.resizeWidth;
    } else if(this.state.resizeHeight){
      params.fit = "clip";
      params.h   = this.state.resizeHeight;
    } else if(this.state.resizeWidth){
      params.fit = "clip";
      params.w   = this.state.resizeWidth;
    }

    let paramsString = [];
    for(key in params){
      paramsString.push(`${key}=${params[key]}`);
    }
    paramsString = paramsString.join("&");
    console.log(paramsString);

    return `${this.state.imageToCrop}?${paramsString}`;
  }

  /**
   * Sets the initial state. SHould be called whenever the step should be set to "open"
   * STEPS:
   * open:       The user opened this modal and is looking at the dropzone.
   * uploading:  The user is looking at the loading screen while their original photo is uploading.
   * uploaded:   The user has uploaded a photo. Let them decide to use it or crop it.
   * setup-crop: The user is looking at the loading screen while the cropping interface loads.
   * cropping:   The user is using the cropping UI.
   * preview:    The user is previewing their cropped photo.
   * selected:   The user has selected an image, either their original or the cropped one
   */
  resetState(){
    this.state = {
      step:       "open",
      image:      null,  // The URL of the user's original image
      coords:     {x1: null, y1: null, x2: null, y2: null, h: null, w: null}, // Set whenever the user selects a crop range
      canPreview: false, // Is the Preview button enabled?
      jcropApi:   null,  // Access to jCrop
      boxHeight:  null,  // The height of the Crop UI
      boxWidth:   null,  // The width of the Crop UI
      canCrop:      Toolkit.photoManagerData.crop         || false,
      target:       Toolkit.photoManagerData.target       || null,
      resizeHeight: Toolkit.photoManagerData.resizeHeight || null,
      resizeWidth:  Toolkit.photoManagerData.resizeWidth  || null
    };
  };

  render(){
    const loading = (<div className='loading-box'>
      <div className='vert-align'>
        <div className='loader'>
          <svg version='1.1' id='loader-1' xmlns='http://www.w3.org/2000/svg' x='0px' y='0px' width='40px' height='40px' viewBox='0 0 50 50'>
            <path fill='#fff' d='M43.935,25.145c0-10.318-8.364-18.683-18.683-18.683c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615c8.072,0,14.615,6.543,14.615,14.615H43.935z'>
              <animateTransform attributeType='xml' attributeName='transform' type='rotate' from='0 25 25' to='360 25 25' dur='0.6s' repeatCount='indefinite' />
            </path>
          </svg>
        </div>
        <div className='loading-text'>
          Loading Image
          <small>High Resolution images may take a moment</small>
        </div>
      </div>
    </div>);

    let uploadTab;

    switch(this.state.step){
      case "open":
        uploadTab = (<React.Fragment>
          <section id="upload-image" className="upload-image">
            <h3>Upload an Image</h3>
              <form id="upload-photo-form" className="dropzone">
                <div className="dz-default dz-message" id="dropzone">
                  <span>
                    <h4>DROP IMAGE HERE TO UPLOAD</h4>
                    <p className="or">or</p>
                    <div className="button">Select File</div>
                  </span>
                </div>
              </form>
          </section>
        </React.Fragment>);
        break;

        case "uploading":
        case "setup-crop":
          uploadTab = loading;
          break;

        case "uploaded":
          uploadTab = (<React.Fragment>
            <div className="buttons">
              <button data-action="crop-photo" onClick={this.handleClick} className="button active">Crop This Photo</button>
              <button data-action="select-photo" onClick={this.handleClick} className="button active">Use This Photo</button>
            </div>
            <img style={{maxWidth: "80%", maxHeight: "80%"}} src={this.state.image.originalUrl} />
          </React.Fragment>);
          break;

        case "cropping":
          uploadTab = (<section className="crop-image">
            <div className="buttons">
              <button data-action="preview-photo" onClick={this.handleClick} disabled={!this.state.canPreview} className="button active">Preview</button>
            </div>
            <img style={{height: "auto", width: "auto"}} src={this.state.imageToCrop} id="image-to-crop" />
          </section>);
          break;

        case "preview":
          uploadTab = (<section className="preview-image">
            <div className="buttons">
              <button data-action="select-photo" onClick={this.handleClick} className="button active">Use This Photo</button>
              <button data-action="crop-photo"   onClick={this.handleClick} className="button active">Crop Original Photo Again</button>
              <button data-action="upload-photo" onClick={this.handleClick} className="button active">Upload New Photo</button>
            </div>
            <img ref={this.previewRef} src={this.buildPreviewUrl()}  />
          </section>);

        case "selected":
          break;
    };

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

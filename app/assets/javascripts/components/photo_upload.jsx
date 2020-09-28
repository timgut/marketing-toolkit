/**
  TODO NEXT:
  1. Organize state
  2. Test with different image sizes/formats
  3. Better user feedback when uploading / processing
  4. Organize / Expand / Remove functions to make the code cleaner
*/
class PhotoUpload extends React.Component{
  constructor(props={}){
    super(props);

    const _this = this;
    this.resetState();

    if(this.props.root.props.contextCrop === true) {
      // Get the metadata for the blank photo
      $.ajax({
        url:    `${this.state.blankImgixUrl}?fm=json`,
        method: "GET",
      }).done(function(data){
        _this.state.blank = {meta: data};
      });
    }

    this.handleClick  = this.handleClick.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleFileChooser = this.handleFileChooser.bind(this);
    this.handleSelect = this.handleSelect.bind(this);
  };

  /**
   * Sets the initial state. Should be called whenever the step should be set to "open"
   * STEPS:    
   * open:       The user opened this modal and is looking at the dropzone.
   * uploading:  The user is looking at the loading screen while their original photo is uploading.
   * processing: The user's photo is getting its metadata from imgix.
   * uploaded:   The user has uploaded a photo. Let them decide to use it or crop it.
   * setup-crop: The user is looking at the loading screen while the cropping interface loads.
   * cropping:   The user is using the cropping UI.
   * placing:    The user is placing the photo behind the blank image (context cropping).
   * preview:    The user is previewing their cropped photo.
   * selected:   The user has selected an image, either their original or the cropped one.
   */
  resetState(){
    this.state = {
      step:          "open",
      image:         null,  // The URL of the user's original image
      coords:        {x1: null, y1: null, x2: null, y2: null, h: null, w: null}, // Set whenever the user selects a crop range
      canPreview:    false, // Is the Preview button enabled?
      jcropApi:      null,  // Access to jCrop
      boxHeight:     null,  // The height of the Crop UI
      boxWidth:      null,  // The width of the Crop UI
      canCrop:       Toolkit.photoManagerData.crop         || false,
      target:        Toolkit.photoManagerData.target       || null,
      resizeHeight:  Toolkit.photoManagerData.resizeHeight || null,
      resizeWidth:   Toolkit.photoManagerData.resizeWidth  || null,
      dragX:         null, // Where the user dragged the photo in context
      dragY:         null,  // Where the user dragged the photo in context
      sizeStrategy:  "hw", // Which size(s) should a cropped photo send to imgix? h = height; w = width;
      flip:          "", // Should the user's photo be flipped horizontally (h), veritcally (v), both (hv), or not at all?
      cropOffset:    $("[data-crop-offset]").attr("data-crop-offset") || 0,
      multiplier:    1.2, // In context cropping, increase the the smaller dimension of the user's photo
      buildImgixUrl: false, // Should the preview url be generated?
      // userResize:    {active: false, width: null, height: null, aspectRatio: true} // Allows the user to resize their photos
    };

    if(this.state.resizeHeight && this.state.resizeWidth) {
      this.state.aspectRatio =  (this.state.resizeWidth / this.state.resizeHeight).toPrecision(3); // 2 decimal places
    }

    if(this.props.root.props.contextCrop === true) {
      this.state.blankImgixUrl = this.props.root.props.blankImage.replace("https://s3.amazonaws.com/toolkit.afscme.org", "https://afscme.imgix.net");
    }
  };

  /**
   * LIFECYCLE FUNCTIONS
   */
  componentDidCatch(error, info) {
    console.log(this.state);
  };

  componentDidMount(){
    const _this = this;
    $("#tabs").tabs();

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
            id:          data.id,
            croppedUrl:  data.cropped_image_url,
            originalUrl: data.original_image_url,
            imgixUrl:    `https://afscme.imgix.net/${data.original_image_url.split("https://s3.amazonaws.com/toolkit.afscme.org/")[1]}`,
            meta:        null
          };

          _this.setState(Object.assign({}, _this.state, {step: "processing", image: image}));
        } else {
          console.log("Figure out how to handle failures");
        }
      }
    });
  };

  componentDidUpdate(prevProps, prevState){
    const _this = this;

    switch(this.state.step){
      // Get the photo's metadata from imgix.
      case "processing":
        if(this.state.image.meta === null) {
          $.ajax({
            url:    `${this.state.image.imgixUrl}?fm=json`,
            method: "GET",
          }).done(function(data){
            const newState = {
              buildImgixUrl: true,
              step: "uploaded",
              userResize: {active: false, width: data.PixelWidth, height: data.PixelHeight},
              image: Object.assign({}, _this.state.image, {
                meta: data,
                orientation: data.PixelWidth > data.PixelHeight ? "landscape" : "portrait"
              })
            };

            _this.props.root.setState(Object.assign({}, _this.props.root.state, {myPhotos: _this.props.root.state.myPhotos.concat(data)}));
            _this.setState(Object.assign({}, _this.state, newState));
          });
        }
        break;

      // Figure out the dimensions for the crop area based off the photo's metafdata.
      case "setup-crop":
        availableHeight = Math.round($("body").height() * 0.8);
        availableWidth  = Math.round($("body").width()  * 0.8);

        if(this.state.image.meta.PixelHeight > availableHeight && this.state.image.meta.PixelWidth > availableWidth){
          // Original photo is too large to crop on both dimensions
          this.state.boxHeight = availableHeight;
          this.state.boxWidth  = availableWidth;

        } else if(this.state.image.meta.PixelHeight > availableHeight){
          // Original photo is too tall to crop
          this.state.boxHeight = availableHeight;
          this.state.boxWidth  = this.state.image.meta.PixelWidth;

        } else if(this.state.image.meta.PixelWidth > availableWidth){
          // Original photo is too wide to crop
          this.state.boxHeight = this.state.image.meta.PixelHeight;
          this.state.boxWidth  = availableWidth;
        }

        this.setState({step: "cropping"});
        break;

      // Initialize JCrop
      case "cropping":
        // console.log(this.state.jcropApi);
        this.loadCrop();
        break;

      // Initialize jQuery UI Drag
      case "placing":
        const $figure = $(`figure[data-target='${Toolkit.photoManagerData.target}']`);
        const $offset = $figure.find("[data-crop-offset]");

        let offset = 0;
        if($offset.length === 1) {
          offset = $offset.val();
        }

        $(".drag").draggable({
          stop: function(e, ui) {
            position = $(".drag").position();
            _this.setState(Object.assign({}, _this.state, {dragX: position.left, dragY: (position.top - offset)}));
          }
        });
        break;

      // Destroy JCrop
      case "preview":
        const photo = document.getElementById("preview-photo");

        if(this.props.root.props.contextCrop === true) {
          photo.onload = function() {
            const marginLeft = (photo.clientWidth - _this.state.blank.meta.PixelWidth) / 2;
            // console.log(marginLeft);
            photo.style.marginLeft = `-${marginLeft}px`;
          }
        }
        
        this.unloadCrop();
        break;

      case "selected":
        let image = {
          id: _this.state.image.id,
          cropped_image_url: _this.state.previewUrl
        };

        if(this.state.dragX && this.state.dragY) {
          image.crop_data = {drag: {x: this.state.dragX, y: (this.state.dragY - this.state.cropOffset)}};
        }

        $.ajax({
          url:    `/images/${_this.state.image.id}`,
          method: "PATCH",
          data:   {
            format: "json",
            image:  image
          }
        }).done(function(data){
          const url     = _this.buildPreviewUrl();
          const $figure = $(`figure[data-target='${Toolkit.photoManagerData.target}']`);
          const name    = $(`#${_this.state.target}`).attr("name"); // e.g. data[photo]

          // Put the target into the select_data
          $(`[name='select_${name}']`).val(_this.state.target);

          // Put the photo into the preview div
          $figure.attr("style", `background-image:url(${url})`);

          // Check the custom photo checkbox and give it the correct value
          $(`#${_this.state.target}`).val(url.replace("https", "http")).prop("checked", true);
          
          // Show controls to edit/remove this photo
          if($figure.parent().find(".controls").length === 0) {
            $figure.parent().append(`
              <div class="controls">
                <div class="change" title="Change Photo">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path d="M245.4,937.5l61.5-61.5L148,717.1l-61.5,61.5V851H173v86.5H245.4z M598.9,310.2c0-9.9-5-14.9-14.9-14.9 c-4.5,0-8.3,1.6-11.5,4.7L206.2,666.4c-3.2,3.2-4.7,7-4.7,11.5c0,9.9,5,14.9,14.9,14.9c4.5,0,8.3-1.6,11.5-4.7l366.3-366.3    C597.3,318.6,598.9,314.7,598.9,310.2z M562.4,180.5l281.2,281.2L281.2,1024H0V742.8L562.4,180.5z M1024,245.4 c0,23.9-8.3,44.2-25,60.8L886.8,418.4L605.6,137.2L717.8,25.7C734,8.6,754.3,0,778.6,0c23.9,0,44.4,8.6,61.5,25.7L999,183.8C1015.7,201.4,1024,221.9,1024,245.4z"></path></svg>
                </div>
                <div class="delete" title="Delete Photo">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path d="M696,512l312.7,312.7c20.3,20.3,20.3,53.3,0,73.6l-110.4,110.4c-20.3,20.3-53.3,20.3-73.6,0L512,696l-312.8,312.7 c-20.3,20.3-53.3,20.3-73.6,0L15.2,898.4c-20.3-20.3-20.3-53.3,0-73.6L328,512L15.2,199.2c-20.3-20.3-20.3-53.3,0-73.6L125.7,15.2c20.3-20.3,53.3-20.3,73.6,0L512,328L824.8,15.2c20.3-20.3,53.3-20.3,73.6,0l110.4,110.4c20.3,20.3,20.3,53.3,0,73.6L696,512 L696,512z"></path></svg>
                </div>
              </div>
            `);
          }

          // Close the modal
          $figure.find(".positioner").hide();
          $(".image-picker_close").click();
        });
        break;
    }
  };

  /**
   * EVENT HANDLERS
   */
  // Disable the preview button while the user changes the cropping selection.
  handleChange(e){
    let newState;
    if(e.target) {
      // Features that are not yet fully implemented.
      switch(e.target.dataset.action){
        // case "size-strategy":
        //   this.setState(Object.assign({}, this.state, {sizeStrategy: e.target.value}));
        //   break;

        // case "flip":
        //   this.setState(Object.assign({}, this.state, {flip: e.target.value}));
        //   break;

        // case "user-aspect":
        //   newState = Object.assign({}, this.state.userResize, {aspectRatio: !this.state.userResize.aspectRatio});
        //   this.setState(Object.assign({}, this.state, {userResize: newState}));
        //   break;

        // case "user-height":
        //   newState = Object.assign({}, this.state.userResize, {height: e.target.value});
        //   this.setState(Object.assign({}, this.state, {userResize: newState}));
        //   break;

        // case "user-width":
        //   newState = Object.assign({}, this.state.userResize, {width: e.target.value});
        //   this.setState(Object.assign({}, this.state, {userResize: newState}));
        //   break;
      }
    } else {
      // JCrop was changed
      if(this.state.canPreview){
        this.setState(Object.assign({}, this.state, {canPreview: false}));
      }      
    }
  };

  handleClick(e){
    let newState;

    switch(e.target.dataset.action){
      case "crop-photo":
        this.setState(Object.assign({}, this.state, {cropSetup: false, step: "setup-crop"}));
        break;

      case "place-photo":
        this.setState(Object.assign({}, this.state, {step: "placing"}));
        break;

      case "preview-photo":
        this.setState(Object.assign({}, this.state, {step: "preview"}));
        break;

      case "select-photo":
        this.setState(Object.assign({}, this.state, {step: "selected"}));
        break;

      case "upload-photo":
        this.setState(Object.assign({}, this.state, {step: "open"}));
        break;

      case "user-resize":
        newState = Object.assign({}, this.state.userResize, {active: true});
        this.setState(Object.assign({}, this.state, {userResize: newState}));
        break;

      case "reset-size":
        newState = Object.assign({}, this.state.userResize, {active: false, height: this.state.image.meta.PixelHeight, width: this.state.image.meta.PixelWidth});
        this.setState(Object.assign({}, this.state, {userResize: newState}));
        break;

      case "confirm-size":
        newState = Object.assign({}, this.state.userResize, {active: false});
        this.setState(Object.assign({}, this.state, {userResize: newState}));
        break;

      default:
        console.log(e.target.dataset.action);
    }
  };

  handleFileChooser(){
    $(this.dropzone.hiddenFileInput).click();
  };

  // The user is done dragging the cropping tool. Let them preview.
  handleSelect(e){
    this.setState(Object.assign({}, this.state, {
      canPreview: true,
      coords: {
        x1: Math.round(e.x),
        y1: Math.round(e.y),
        x2: Math.round(e.x2),
        y2: Math.round(e.y2),
        h:  Math.round(e.h),
        w:  Math.round(e.w)
      }
    }));
  };

  /**
   * COMPONENT FUNCTIONS
   */
  /**
   * Takes the current component state and builds a URL where the user's cropped and resized image lives.
   */
  buildPreviewUrl(){
    const getHeight = this.state.sizeStrategy.indexOf("h") > -1;
    const getWidth  = this.state.sizeStrategy.indexOf("w") > -1;

    let params = {};

    // Crop the user's photo
    if(typeof this.state.coords.x1 === "number" && typeof this.state.coords.y1 === "number" && typeof this.state.coords.w  === "number" && typeof this.state.coords.h  === "number") {
      params.rect = `${this.state.coords.x1},${this.state.coords.y1},${this.state.coords.w},${this.state.coords.h}`;
    }

    // Apply flip selection
    // if(this.state.flip !== "") {
    //   params = Object.assign(params, {flip: this.state.flip});
    // }

    if(this.props.root.props.contextCrop === true) {
      if(this.state.step === "placing") {
        params = Object.assign(params, {h: this.state.userResize.height, w: this.state.userResize.width});
      } else {
        const cropW = this.state.blank.meta.PixelWidth;
        const cropH = this.state.blank.meta.PixelHeight;
        const cropX = parseInt(Math.abs(this.state.dragX));
        const cropY = parseInt(Math.abs(this.state.dragY));

        const targetSize  = {height: this.state.userResize.height, width: this.state.userResize.width};
        const contextSize = {height: this.state.blank.meta.PixelHeight, width: this.state.blank.meta.PixelWidth};
        // console.log(targetSize);
        // console.log(contextSize);
        let newHeight, newWidth;

        switch(this.state.image.orientation) {
          case "landscape":
            newHeight = Math.ceil(contextSize.height * this.state.multiplier);
            newWidth  = Math.ceil((targetSize.width * newHeight) / targetSize.height);
            break;

          case "portrait":
            newWidth  = Math.ceil(contextSize.width * this.state.multiplier);
            newHeight = Math.ceil((targetSize.height * newWidth) / targetSize.width);
            break;
        }

        params = Object.assign(params, {rect: `${cropX},${cropY},${cropW},${cropH}`, h: newHeight, w: newWidth});
      }

      // Put the blank image on top of the user's photo
      if(this.state.step === "preview") {
        params = Object.assign(params, {
          h: this.state.blank.meta.PixelHeight,
          w: this.state.blank.meta.PixelWidth,
          fit: "fillmax",
          fill: "solid",
          blend: this.state.blankImgixUrl,
          "blend-mode": "normal"
        });
      }
    } else {
      // Resize the user's photo
      if(this.state.resizeHeight && this.state.resizeWidth){
        params = Object.assign(params, {fit: "crop"});

        if(getHeight) {
          params = Object.assign(params, {h: this.state.resizeHeight});
        }

        if(getWidth) {
          params = Object.assign(params, {w: this.state.resizeWidth});
        }
      } else if(this.state.resizeHeight){
        params = Object.assign(params, {fit: "clip"});

        if(getHeight) {
          params = Object.assign(params, {h: this.state.resizeHeight});
        }
      } else if(this.state.resizeWidth){
        params = Object.assign(params, {fit: "clip"});

        if(getWidth) {
          params = Object.assign(params, {w: this.state.resizeWidth});
        }
      }
    }

    // console.log(params);

    if(Object.keys(params).length > 0){
      let paramsString = [];
      for(key in params){ paramsString.push(`${key}=${params[key]}`) }
      paramsString = paramsString.join("&");

      return `${this.state.image.imgixUrl.split("?")[0]}?${paramsString}`;
    } else {
      return this.state.image.imgixUrl;
    }
  };

  loadCrop(){
    const _this = this;

    if(this.state.jcropApi === null){
      // console.log("loading crop");
      $("#image-to-crop").Jcrop({
        boxWidth:    this.state.boxWidth,
        boxHeight:   this.state.boxHeight,
        onSelect:    this.handleSelect,
        onChange:    this.handleChange,
        aspectRatio: this.state.aspectRatio,
        setSelect:   [0, 0, 250, 250]
      },function(){
        // console.log("loaded");
        _this.setState(Object.assign({}, _this.state, {jcropApi: this}));
      });
    }
  };

  unloadCrop(){
    if(this.state.jcropApi){
      this.state.jcropApi.destroy();
      this.state.jcropApi = null;
      $(".jcrop-holder").remove();
    }
  };

  render(){
    if(this.state.buildImgixUrl) {
      this.state.previewUrl = this.buildPreviewUrl();
      // console.log(this.state.previewUrl);
    }

    let uploadTab, editButton;
    if(this.props.root.props.contextCrop === true) {
      editButton = (<button data-action="place-photo" onClick={this.handleClick} className="button active">Place Photo</button>);
    } else {
      editButton = (<button data-action="crop-photo" onClick={this.handleClick} className="button active">Crop Photo</button>);
    }
    
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }

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
          Loading...
          <small>Please be patient with high resolution images</small>
        </div>
      </div>
    </div>);

    // const toolbar = (
    //   <section id="toolbar" style={{display: "none"}}>
    //     <select style={{width: "12rem"}} value={this.state.sizeStrategy} onChange={this.handleChange} data-action="size-strategy">
    //       <option value="hw">No Stretch</option>
    //       <option value="w">Stretch Horizontally</option>
    //       <option value="h">Stretch Vertically</option>
    //     </select>

    //     <select style={{width: "12rem", display: "none"}} value={this.state.flip} onChange={this.handleChange} data-action="flip">
    //       <option value="">No Flip</option>
    //       <option value="h">Flip Horizontally</option>
    //       <option value="v">Flip Vertically</option>
    //       <option value="hv">Flip Mirror</option>
    //     </select>
    //   </section>
    // );

    switch(this.state.step){
      case "open":
        uploadTab = (<React.Fragment>
          <section id="upload-image" className="upload-image">
            <h3>Upload an Image</h3>
              <form id="upload-photo-form" className="dropzone" onClick={this.handleFileChooser} data-action="open-filechooser">
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

        case "processing":
        case "uploading":
        case "setup-crop":
        case "selected":
          uploadTab = loading;
          break;

        case "uploaded":
          uploadTab = (<React.Fragment>
            <div className="buttons">
              {editButton}
              <button data-action="select-photo" onClick={this.handleClick} className="button active">Confirm Photo</button>
            </div>
            <img style={{maxWidth: "100%", maxHeight: "100%"}} className="original-image" src={this.state.image.originalUrl} />
          </React.Fragment>);
          break;

        case "placing":
          let buttons, tools;
          // if(this.state.userResize.active === true) {
          //   buttons = (<div className="buttons">
          //     <button onClick={this.handleClick} data-action="confirm-size" className="button">Confirm</button>
          //     <button onClick={this.handleClick} data-action="reset-size"   className="button">Reset</button>
          //   </div>);

          //   tools = (<React.Fragment>
          //     <p>
          //       Width:
          //       <input
          //         id="user-width"
          //         type="range"
          //         onChange={this.handleChange}
          //         value={this.state.userResize.width}
          //         min={1}
          //         max={2000}
          //         step={1}
          //         data-action="user-width"
          //         style={{width: this.state.blank.meta.PixelWidth}}
          //       />
          //     </p>

          //     <p>
          //       Height:
          //       <input
          //         id="user-height"
          //         type="range"
          //         onChange={this.handleChange}
          //         value={this.state.userResize.height}
          //         min={1}
          //         max={2000}
          //         step={1}
          //         data-action="user-height"
          //         style={{transform: "rotate(270deg)", position: "absolute", top: "45%", width: this.state.blank.meta.PixelHeight}}
          //       />
          //       Maintain Aspect Ratio:
          //       <input type="checkbox" data-action="user-aspect" onChnage={this.handleChange} checked={this.state.userResize.aspectRatio} />
          //     </p>
          //   </React.Fragment>);
          // } else {
            buttons = (<div className="buttons">
              <button data-action="upload-photo"  onClick={this.handleClick} className="button">Start Over</button>
              {/*<button data-action="user-resize"   onClick={this.handleClick} className="button">Resize Your Photo</button>*/}
              <button data-action="preview-photo" onClick={this.handleClick} className="button">Preview</button>
            </div>);
          // }

          uploadTab = (<React.Fragment>
            {buttons}
            <div id="cc-croparea" style={{height: `${this.state.blank.meta.PixelHeight}px`, width: `${this.state.blank.meta.PixelWidth}px`}}>
              {/*<div style={{zIndex: 1, position: "relative", top: "50%"}}>Please Wait...<br />Resized photos may take a few seconds to load.</div>*/}
              <div className="drag" style={{zIndex: 2, position: "relative"}}>
                <div id="cc-uploaded" style={{backgroundImage: `url(${this.state.previewUrl})`, height: `${this.state.image.meta.PixelHeight}px`, width: `${this.state.image.meta.PixelWidth}px`}}></div>
              </div>

              <img id="cc-context" src={this.props.root.props.blankImage} />
            </div>

            {tools}
          </React.Fragment>);
          break;

        case "cropping":
          uploadTab = (<section className="crop-image">
            <div className="buttons">
              <button data-action="upload-photo" onClick={this.handleClick} className="button">Start Over</button>
              <button data-action="preview-photo" onClick={this.handleClick} disabled={!this.state.canPreview} className="button active">Preview</button>
            </div>

            <img style={{height: "auto", width: "auto"}} src={this.state.image.imgixUrl} id="image-to-crop" />
          </section>);
          break;

        case "preview":
          let previewStyle;
          if(this.props.root.props.contextCrop === true) {
            previewStyle = {width: this.state.blank.meta.PixelWidth, height: this.state.blank.meta.PixelHeight};
          }

          uploadTab = (<section className="preview-image">
            <div className="buttons">
              <button data-action="upload-photo" onClick={this.handleClick} className="button">Start Over</button>
              {editButton}
              <button data-action="select-photo" onClick={this.handleClick} className="button active">Confirm Photo</button>
            </div>

            <div id="preview" style={previewStyle}>
              <img id="preview-photo" src={this.state.previewUrl} />
            </div>
          </section>);

        case "selected":
          break;
    };

    return uploadTab;
  };
}

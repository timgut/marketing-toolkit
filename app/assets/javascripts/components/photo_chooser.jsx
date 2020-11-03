class PhotoChooser extends React.Component{
  constructor(props={}) {
    super(props);
    
    const _this = this;

    this.state = {
      canChoose: false,
      filter: "",
      chosen: null,
      photos: this.props.photos.map(function(photo) {
        return {
          id:       photo.id,
          title:    _this.props.type === "mine" ? _this.generateTitle(photo) : photo.label,
          url:      _this.props.type === "mine" ? ( photo.croppedImageUrl || photo.originalImageUrl ) : photo.imageUrl,
          filtered: false,
        };
      })
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleClick  = this.handleClick.bind(this);
  };

  handleChange(e) {
    this.state.filter = e.target.value;
    
    if(e.target.value.length > 0) {
      this.state.photos.forEach(function(photo) {
        // Flip to true if the title doesn't match the filter.
        photo.filtered = !photo.title.toLowerCase().match(e.target.value.toLowerCase());
      });
    } else {
      this.state.photos.forEach(function(photo) {
        photo.filtered = false;
      });
    }

    this.forceUpdate();
  };

  handleClick(e) {
    let target;
    if (e.target.dataset.hasOwnProperty("action")) {
      target = e.target;
    } else {
      target = e.target.parentElement;
    }

    switch (target.dataset.action) {
      case "enable-photo":
        // Add .enabled to only the photo that was clicked
        document.querySelectorAll("figure.enabled").forEach(figure => figure.classList.remove("enabled"));
        e.target.closest("figure").classList.add("enabled");

        // Enable the choose button only if a photo is enabled
        this.setState(Object.assign({}, this.state, {
          chosen: target.dataset.id,
          canChoose: true
        }));
        break;

      case "choose-photo":
        const $figure = $(`figure[data-target='${Toolkit.photoManagerData.target}']`);
        const name = $(`#${Toolkit.photoManagerData.target}`).attr("name"); // e.g. data[photo]
        const url = $("figure.enabled > img").attr("src");

        // Put the target into the select_data
        $(`[name='select_${name}']`).val(Toolkit.photoManagerData.target);

        // Put the photo into the preview div
        $figure.attr("style", `background-image:url(${url})`);

        // Check the custom photo checkbox and give it the correct value
        $(`#${Toolkit.photoManagerData.target}`).val(url.replace("https", "http")).prop("checked", true);
        
        // Show controls to edit/remove this photo
        if($figure.parent().find(".controls").length === 0) {
          $figure.append(`
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
        break;

      case "crop-photo":
        const tab = this.props.root.uploadTab;
        
        tab.setState(Object.assign({}, tab.state, {step: "uploading"}));
        $("a[href='#upload']").click();

        $.ajax({
          url:    `/stock_images/${this.state.chosen}/duplicate`,
          method: "POST",
          data:   {id: this.state.chosen, user_id: this.props.root.props.userId}
        }).done(function(data){
          const image = {
            id:          data.id,
            croppedUrl:  data.cropped_image_url,
            originalUrl: data.original_image_url,
            imgixUrl:    `https://afscme.imgix.net/${data.original_image_url.split("https://s3.amazonaws.com/toolkit.afscme.org/")[1]}`,
            meta:        null
          };

          tab.setState(Object.assign({}, tab.state, {cropSetup: false, step: "processing", image: image, autoCrop: true}));
        });
        break;
    }
  };

  generateTitle(photo) {
    const parts = photo.originalImageUrl.split("/");
    return parts[parts.length -1].split(".")[0];
  };

  render() {
    const _this = this;
    const filterStyles = {margin: "1rem 0 1rem 0"};

    let cropPhoto;
    if(this.props.type === "stock"){
      cropPhoto = (<button value="Crop Photo" className="save" data-action="crop-photo" onClick={this.handleClick} disabled={!this.state.canChoose}>Crop Photo</button>);
    }

    const gallery = this.state.photos.filter(function(photo) {
      return photo.filtered === false;
    }).map(function(photo){
      return(<figure key={photo.id} onClick={_this.handleClick} data-action="enable-photo" data-id={photo.id}>
        <img src={photo.url} alt={photo.title} />
        <figcaption>{photo.title}</figcaption>
      </figure>);
    });

    return(<React.Fragment>
      <div className="buttons">
        <input type="text" placeholder="Filter Photos..." value={this.state.filter} onChange={this.handleChange} style={filterStyles} />
        <button data-action="choose-photo" onClick={this.handleClick} disabled={!this.state.canChoose} className="button active">Select Photo</button>
        {cropPhoto}
      </div>
      <div className="gallery">{gallery}</div>
    </React.Fragment>);
  };
}

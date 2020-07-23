class PhotoChooser extends React.Component{
  constructor(props={}) {
    super(props);
    
    const _this = this;

    this.state = {
      filter: "",
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
    this.handleHover  = this.handleHover.bind(this);
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

  handleHover(e) {

  };

  generateTitle(photo) {
    const parts = photo.originalImageUrl.split("/");
    return parts[parts.length -1].split(".")[0];
  }

  render() {
    const _this = this;
    const filterStyles = {margin: "1rem 0 1rem 0"};

    const gallery = this.state.photos.filter(function(photo) {
      return photo.filtered === false;
    }).map(function(photo){
      return(<figure key={photo.id} onMouseOver={_this.handleHover}>
        <img data-id={photo.id} src={photo.url} alt={photo.title} />
        <figcaption>{photo.title}</figcaption>
      </figure>);
    });

    return(<React.Fragment>
      <input type="text" placeholder="Filter Photos..." value={this.state.filter} onChange={this.handleChange} style={filterStyles} />
      <div className="gallery">{gallery}</div>
    </React.Fragment>);
  };
}

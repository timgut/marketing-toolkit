class PhotoManager extends React.Component{
  constructor(props={}){
    super(props);
    this.state = { myPhotos: this.props.myPhotos }
  };

  render(){
    return(
      <React.Fragment>
        <div className="select-image">
          <h2>Select an Image</h2>

          <section className="image-grid cf" data-loaded="true">
            <div id="tabs" className="ui-tabs ui-corner-all ui-widget ui-widget-content">
              <ul role="tablist" className="ui-tabs-nav ui-corner-all ui-helper-reset ui-helper-clearfix ui-widget-header">
                <li role="tab" className="ui-tabs-tab ui-corner-top ui-state-default ui-tab ui-tabs-active ui-state-active" aria-controls="upload" aria-labelledby="ui-id-1" aria-selected="true" aria-expanded="true"><a href="#upload" role="presentation" tabIndex="-1" className="ui-tabs-anchor" id="ui-id-1">Upload Photo</a></li>
                <li role="tab" className="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="mine" aria-labelledby="ui-id-2" aria-selected="false" aria-expanded="false"><a href="#mine" role="presentation" tabIndex="-1" className="ui-tabs-anchor" id="ui-id-2">My Photos</a></li>
                <li role="tab" className="ui-tabs-tab ui-corner-top ui-state-default ui-tab" aria-controls="stock" aria-labelledby="ui-id-3" aria-selected="false" aria-expanded="false"><a href="#stock" role="presentation" tabIndex="-1" className="ui-tabs-anchor" id="ui-id-3">Stock Photos</a></li>
              </ul>

              <div id="upload" aria-labelledby="ui-id-1" role="tabpanel" className="ui-tabs-panel ui-corner-bottom ui-widget-content" aria-hidden="false" style={{display: "block"}}>
                <PhotoUpload root={this} />
              </div>

              <div id="mine" aria-labelledby="ui-id-2" role="tabpanel" className="ui-tabs-panel ui-corner-bottom ui-widget-content" style={{display: "none"}} aria-hidden="true">
                <PhotoChooser type="mine" root={this} photos={this.state.myPhotos} />
              </div>

              <div id="stock" aria-labelledby="ui-id-3" role="tabpanel" className="ui-tabs-panel ui-corner-bottom ui-widget-content" style={{display: "none"}} aria-hidden="true">
                <PhotoChooser type="stock" root={this} photos={this.props.stockPhotos} />
              </div>
            </div>
          </section>
        </div>
      </React.Fragment>
    );
  };
}

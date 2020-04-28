import React from "react";
import PropTypes from "prop-types";

function Image(props) {
  return (
    <div className={"carousel-item" + (props.active ? " active" : "")}>
      <img
        style={{ hight: "500px", width: "100%" }}
        className="d-block"
        src={props.image.image_file_url}
      />
    </div>
  );
}

Image.propTypes = {
  image: PropTypes.object.isRequired,
  active: PropTypes.bool.isRequired,
};

export default Image;

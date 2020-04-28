import React from "react";
import PropTypes from "prop-types";
import Image from "./Image";
import { deleteEvent } from "../actions/events";
import { useDispatch } from "react-redux";

function Event(props) {
  const dispatch = useDispatch();
  const id = "image-carousel-" + props.event.id;
  return (
    <div className="card">
      <div className="card-header">{props.event.dir_name}</div>
      <div className="card-body">
        <div className="row">
          <div
            id={id}
            className="carousel col-12"
            data-ride="carousel"
            style={{ marginBottom: "15px" }}
          >
            <ol
              className="carousel-indicators"
              style={{
                paddingBottom: "7px",
                paddingTop: "7px",
                marginBottom: "0px",
                backgroundColor: "rgba(0, 0, 0, 0.4)",
              }}
            >
              {props.event.images.map((image, index) => (
                <li
                  key={image.id}
                  data-target={"#" + id}
                  data-slide-to={index}
                  className={index == 0 ? "active" : ""}
                ></li>
              ))}
            </ol>
            <div className="carousel-inner" role="listbox">
              {props.event.images.map((image, index) => (
                <Image key={image.id} image={image} active={index == 0} />
              ))}
            </div>
            <a
              className="carousel-control-prev"
              href={"#" + id}
              role="button"
              data-slide="prev"
            >
              <i
                className="material-icons"
                style={{
                  backgroundColor: "rgba(0, 0, 0, 0.4)",
                  padding: "18px",
                  color: "#fff",
                }}
                aria-hidden="true"
              >
                chevron_left
              </i>
              <span className="sr-only">Previous</span>
            </a>
            <a
              className="carousel-control-next"
              href={"#" + id}
              role="button"
              data-slide="next"
            >
              <i
                className="material-icons"
                style={{
                  backgroundColor: "rgba(0, 0, 0, 0.4)",
                  padding: "18px",
                  color: "#fff",
                }}
                aria-hidden="true"
              >
                chevron_right
              </i>
              <span className="sr-only">Next</span>
            </a>
          </div>
        </div>
        <div className="row justify-content-end">
          <div className="col-2">
            <button
              name="delete"
              id=""
              className="btn btn-danger"
              href="#"
              role="button"
              onClick={() => dispatch(deleteEvent(props.event.id))}
            >
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

Event.propTypes = {
  event: PropTypes.object.isRequired,
};

export default Event;

import React from "react";
import PropTypes from "prop-types";
import { syncEvents } from "../../actions/events";
import { useDispatch } from "react-redux";

const Header = (props) => {
  const dispatch = useDispatch();
  return (
    <div className="container">
      <div className="row">
        <div className="col-6">
          <h1>Events</h1>
        </div>
        <div className="col-2 ml-auto">
          <button
            type="button"
            name="sync"
            id=""
            className="btn btn-primary btn-lg btn-block"
            onClick={() => dispatch(syncEvents())}
          >
            <span className="material-icons">sync</span>
          </button>
        </div>
      </div>
    </div>
  );
};

Header.propTypes = {};

export default Header;

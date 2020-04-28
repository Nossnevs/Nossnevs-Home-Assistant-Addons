import React, { useEffect } from "react";
import Event from "./Event";
import { useSelector, useDispatch } from "react-redux";
import { getEvents } from "../actions/events";
import PropTypes from "prop-types";
export const EventList = () => {
  const events = useSelector((state) => state.events);
  const dispatch = useDispatch();
  useEffect(() => {
    dispatch(getEvents());
  }, []);
  return (
    <div className="container">
      {events.events.map((event) => (
        <Event key={event.id} event={event} />
      ))}
    </div>
  );
};

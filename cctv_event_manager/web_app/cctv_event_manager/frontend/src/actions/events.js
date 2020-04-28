import axios from "axios";
import { GET_EVENTS, DELETE_EVENT } from "./types";

const EXTERNAL_BASE_URL = window.external_base_url
  ? window.external_base_url
  : "/";

// GET EVENTS
export const getEvents = () => (dispatch, getState) => {
  axios
    .get(EXTERNAL_BASE_URL + "api/events/")
    .then((res) => {
      dispatch({
        type: GET_EVENTS,
        payload: res.data,
      });
    })
    .catch((err) => console.log(err.response.data, err.response.status));
};

export const deleteEvent = (id) => (dispatch, getState) => {
  axios
    .delete(EXTERNAL_BASE_URL + "api/events/" + id + "/")
    .then((res) => {
      dispatch({
        type: DELETE_EVENT,
        payload: id,
      });
    })
    .catch((err) => console.log(err));
};

// SYNC EVENTS
export const syncEvents = () => (dispatch, getState) => {
  axios
    .get(EXTERNAL_BASE_URL + "api/sync/")
    .then((res) => {
      dispatch(getEvents());
    })
    .catch((err) => console.log(err.response.data, err.response.status));
};

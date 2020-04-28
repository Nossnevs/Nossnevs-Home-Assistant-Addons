import { GET_EVENTS, DELETE_EVENT } from "../actions/types";

const initialState = {
  events: [],
};

export default (state = initialState, { type, payload }) => {
  switch (type) {
    case GET_EVENTS:
      return {
        ...state,
        events: payload,
      };

    case DELETE_EVENT:
      return {
        ...state,
        events: state.events.filter((event) => event.id !== payload),
      };

    default:
      return state;
  }
};

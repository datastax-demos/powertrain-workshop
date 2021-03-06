import {createAction} from 'redux-actions';
import requestActions from './requestActions.js';
import {get} from './requests.js';
import {addDataToMap} from 'kepler.gl/actions';
import Processors from 'kepler.gl/processors';
import KeplerGlSchema from 'kepler.gl/schemas';

//TODO: There are some scaling and splitting hacks in here that aren't needed
// when better data is available
function convertToCSV(objArray) {
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    var str = '';

    //header
    var line = '';
    for (var index in array[0]) {
        if (line != '') line += ','

        if (index == "lat_long"){
            line += "lat,lon"
        }
        else{
            line += [index];
        }
    }
    str += line + '\r\n';
    //csv body
    for (var i = 0; i < array.length; i++) {
        var line = '';
        for (var index in array[i]) {
            if (line != '') line += ','

            if (index == "lat_long"){
                var latlonArray = array[i][index].split(":");
                line += "" + (parseFloat(40.7) + parseFloat(latlonArray[0])/200) + "," + (parseFloat(-74.03) + parseFloat(latlonArray[1])/160);
            }
            else{
                line += array[i][index];
            }
        }

        str += line + '\r\n';
    }

    return str;
}

export function fetchData(url){
   return(dispatch, getState) => {
       var interval = setInterval(function(){
           dispatch(getData(url));
       }, 3000);
       dispatch(updateData("SET_INTERVAL", interval));
   }
}

export function pause(){
   return(dispatch, getState) => {
       clearInterval(getState().interval.value);
       //dispatch(("SET_INTERVAL", null));
   }
}

export function getData(url){
   return(dispatch, getState) => {
        get({
            url:url,
            success: function(res){
                var csvData = convertToCSV(res.data);
                dispatch(updateData("GET_DATA",csvData));
                const data = Processors.processCsvData(csvData);
                const dsedata = {
                  data,
                  info: {
                    id: 'dsedata'
                  }
                };
                var config = KeplerGlSchema.getConfigToSave(getState().keplerGl.map);
                dispatch(addDataToMap({datasets: dsedata, config: config}));
            },
        dispatch: dispatch
        });
   }
}

export const updateData = (type, data) => {
    return {
        type: type,
        data: data
    }
}

export default {getData, pause};

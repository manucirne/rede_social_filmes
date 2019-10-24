module.exports.chunk = (array, step) => {
    const chunked = [];
    let index = 0;
    while (index < array.length) {
      chunked.push(array.slice(index, step + index));
      index += step;
    }
    return chunked;
  };
  module.exports.linspace = (start, stop, step) => {
    const arr = [start];
  
    while (start + step <= stop) {
      start += step;
      arr.push(start);
    }
    return arr;
  };
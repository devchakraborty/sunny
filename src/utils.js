export default class Utils {}

Utils.sample = function(arr) {
  return arr[Math.floor(Math.random() * arr.length)]
}

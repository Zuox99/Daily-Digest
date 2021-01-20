
class DailyWeather {
  var minTemp;
  var maxTemp;
  var main;
  var icon;
  var temp;
  var pressure;
  var humidity;
  var windSpeed;

  DailyWeather(var minTemp, var maxTemp, var main, var icon, var temp, var pressure, var humidity, var windSpeed) {
    this.minTemp = ((minTemp - 273.15) * 1.8 + 32).round();
    this.maxTemp = ((maxTemp - 273.15) * 1.8 + 32).round();
    this.main = main;
    this.icon = icon;
    this.temp = ((temp - 273.15) * 1.8 + 32).round();
    this.pressure = (pressure / 1000).round();
    this.humidity = humidity;
    this.windSpeed = windSpeed;
  }
}
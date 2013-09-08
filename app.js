// Required so we can load our coffee dependencies
require('coffee-script');

try {
    var settings = require('./settings.coffee');

} catch(e) {
    var settings = require('./settings_default.coffee');
    console.log("Please copy the settings_default.coffee > settings.coffee and update the configuration.");
}

var Web = require('./lib/Web.coffee');

var web = new Web(settings);

web.settings.scriptPath = __dirname;
web.configure();
web.createServer()

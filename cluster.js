require('coffee-script');
/*
  If you'd like to run a few instances, then run this instead of
  app.js directly.  In here, we can monitor our processes
  and restart them if necessary.
 */
var cluster = require('cluster');
var workers = []

// Point to the app.js script
cluster.setupMaster({ exec: 'app.js' });

/*
  Here we are manually adding our workers, to keep it simple
 */
console.log("cluster running two instances");
workers.push(cluster.fork());
workers.push(cluster.fork());


var alasql = require("alasql");

alasql.promise('SELECT * FROM TAB("../data/out_tlsv1.tab", {headers:true}) a, TAB("../data/ciphers_to_disable.tab", {headers:true}) b WHERE a.cipher = b.cipher')
.then(function(data){
  if (data.length > 0)
  {
    console.log("Some insecure ciphers are still enabled - maybe you didnt edit the java.security file correctly?\nPlease review the README and try again!");
    console.log("The following are still enabled and should be disabled:");
    console.log(data);
  }
  else
  {
    console.log("The insecure ciphers have been verified as being disabled!");
  }
}).catch(function(err){
     console.log('Error:', err);
});

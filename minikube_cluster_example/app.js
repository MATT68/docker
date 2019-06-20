     var http = require('http');
   
     var mensajeAlMundo = ' Hombreeee Amparo !!! Que haces en este cluster?? ';
	 
     var handleRequest = function(request, response) {
         console.log('Recibida llamada desde URL: ' + request.url);
         response.writeHead(200);
         response.end(mensajeAlMundo.fontsize(5));
     };
	 
     var www = http.createServer(handleRequest);
	 
     www.listen(8080);	 
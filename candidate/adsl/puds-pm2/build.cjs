const fs=require('node:fs');const path=require('node:path');const crypto=require('node:crypto');
const root=__dirname, src=path.join(root,'src'), dist=path.join(root,'dist');fs.mkdirSync(dist,{recursive:true});
const files=['index.html','tokens.css','core.js','runtime.js'];for(const file of files)fs.copyFileSync(path.join(src,file),path.join(dist,file));
let html=fs.readFileSync(path.join(src,'index.html'),'utf8');html=html.replace('<link rel="stylesheet" href="tokens.css">','<style>'+fs.readFileSync(path.join(src,'tokens.css'),'utf8')+'</style>');for(const name of ['core.js','runtime.js'])html=html.replace('<script src="'+name+'"></script>','<script>'+fs.readFileSync(path.join(src,name),'utf8')+'</script>');
fs.writeFileSync(path.join(dist,'puds-pm2-daimac.html'),html);
const entries=files.map(file=>({file,bytes:fs.statSync(path.join(src,file)).size,sha256:crypto.createHash('sha256').update(fs.readFileSync(path.join(src,file))).digest('hex')}));
const digest=crypto.createHash('sha256').update(JSON.stringify(entries)).digest('hex');
fs.writeFileSync(path.join(root,'evidence','source-manifest.json'),JSON.stringify({scope:'static-frontend-source',algorithm:'SHA-256',artifactDigest:digest,files:entries,productionAuthorized:false},null,2)+'\n');
console.log('Build complete. Source digest: '+digest);console.log('No production deployment performed.');

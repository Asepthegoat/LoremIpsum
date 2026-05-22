export let alerts = {}
let senv = []
function getfilevariable(file){
    fetch(file).then(res => res.text())
    .then(str =>{
        let parser = new DOMParser()
        let doc = parser.parseFromString(html, "text/html")
        return str.replace(/\$(\w+)/g, function(match, varcustom) {
            return senv[varcustom]
        })
    })
    
}
alerts.midleAlert = function(title,desc,img,btn1,callback1){
    genv.AlertTitle = title
    genv.AlertImg = img
    genv.AlertBtn1 = btn1
    genv.AlertMessage = desc
    setTimeout(() => {
        alrt.GetReference = ["design.html","Alert"]
    }, 1);
}
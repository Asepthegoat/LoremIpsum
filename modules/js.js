//declare
const docs = document
const docsBody = document.body
const codexRegex = new RegExp()

//class
class Hide {
  constructor(selector) {
    const tags = document.querySelectorAll(selector);

    tags.forEach(tag => {
      const lock = new MutationObserver(() => {
        if (tag.style.display !== "none") {
          tag.style.display = "none";
        }
      });

      lock.observe(tag, {
        attributes: true,
        attributeFilter: ["style"]
      });
    });
  }
}

class UserInput {
    constructor() {
        this.addEventListener("keydown",(...KeyCode) =>{
            this.connections.forEach(func => {
                func(...KeyCode)
            })
        })
        this.connections = []
    }

    Connect(callback) {
        this.connections.push(callback)
    }
}
/*
------------------------------------------------------------------------------------------------------------------------------
Elements
------------------------------------------------------------------------------------------------------------------------------
*/
Object.defineProperty(HTMLElement.prototype, "setColor", {
    set: function(color) {
        this.style.color = color;
    }
});
Object.defineProperty(HTMLElement.prototype, "parentTo",{
    set: function(parent) {
        parent.appendChild(this)
    }
})
Object.defineProperty(HTMLElement.prototype, "setDisplay", {
    set: function(display) {
        this.style.display = display;
    }
});
Object.defineProperty(HTMLElement.prototype, "echo", {
    set: function(text) {
        this.innerHTML = text;
    }
});
Object.defineProperties(HTMLElement.prototype, {
  include: {
    set: async function(file) {
      try {
        await import(file);
      } catch (err) {
        console.error(err);
      }
    }
  }
});
globalThis.genv = []

Object.defineProperty(HTMLElement.prototype, "GetReference", {
set: async function(dom) {
    if (typeof dom === "object" && dom !== null) {
        let html = await fetch(dom[0]).then(res => res.text())
        let parser = new DOMParser()
        let doc = parser.parseFromString(html, "text/html")
        let isi = doc.querySelectorAll("reference")
        let vals = ""
        if (dom[1] != null && dom[1] != "") {
            isi.forEach(element => {
                if (element.getAttribute("name") === dom[1]) {
                    vals += element.innerHTML
                }
            })
        }
        else {
            isi.forEach(element => {
                vals += element.innerHTML
            })
        }
        let reslt = vals.replace(/\$(\w+)/g, function(match, varcustom) {
            return genv[varcustom]
        })
        this.innerHTML = reslt
    }
    else {
        let html = await fetch(dom).then(res => res.text())
        let parser = new DOMParser()
        let doc = parser.parseFromString(html, "text/html")
        let isi = doc.querySelector("reference").innerHTML
        let reslt = isi.replace(/\$(\w+)/g, function(match, varcustom) {
            return genv[varcustom]
        })
        this.innerHTML = reslt

    }
}
})


/*
------------------------------------------------------------------------------------------------------------------------------
Functions
------------------------------------------------------------------------------------------------------------------------------
*/
globalThis.getId = function(id) {
    return document.getElementById(id)
}
globalThis.print = console.log
globalThis.selectAll = function(element, parrent = "") {;
    if (parrent === ""){
        return docs.querySelectorAll(element);
    }
    else{
        return parrent.querySelectorAll(element)
    }
}
globalThis.Select = function(element) {
    return document.querySelector(element)
}

function getls(key){
  return JSON.parse(localStorage.getItem(key))
}
function setls(key,value){
  if (value && value != "") {
   return localStorage.setItem(key,JSON.stringfy(value))
  }
  else{
    return localStorage.removeItem(key)
  }
}

function Sleep(time, command){
    setTimeout(command,time)
}
function createEl(element){
    return document.createElement(element)
}
const varchar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()1234567890<>?/"
function generateVarChar(numb){
    let vartbl = []
    for(i=1;i<=numb;i++){
        let variant = varchar.split("") 
        vartbl[i] = varchar[Math.floor(Math.random() * (variant.length - 1))]
    }
    return vartbl.join("")
}

function UUID(type){
    let r = String(type)
    if(r.toLowerCase() === "hex"|| type === 1){
        return crypto.randomUUID().replaceAll("-","")
    }
    else{
        return crypto.randomUUID()
    }
}
function superUUID(type){
    let r = String(type)
    if(r.toLowerCase() === "hex"|| type === 1){
        return UUID("hex") + UUID("hex") + UUID("hex") 
    }
    else{
        return UUID() + "-" + UUID() + "-" + UUID() 
    }
}
function symbol(var1,var2,var3,var4,node) {
    let name = var1
    let source = var2
    let alt = var3
    let size = var4
    if (node.nodeType === Node.TEXT_NODE) {
        return node.textContent = node.textContent.replace(name, `<img src="${source}" alt ="${alt}" width =${var4} height=${var4}>`);
    } else {
        node.childNodes.forEach(child => symbol(name, source, alt, child));
    }
}
function jsonDo(type,jsonData,obj){
    if(toString(type) === "encode" || type === 1) {
        return JSON.stringify(jsonData,obj)
    }
    if(toString(type) === "decode"|| type === 0){
        return JSON.parse(jsonData,obj)
    }
    else{
        print(`${type} is unknown use encode for encoding and decode for decoding`)
    }
}
function RNG(dataValue){
    let value = dataValue;
    return Math.floor(Math.random() * value);
}

function postJson(URL, json){
    fetch(webhookURL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(json)
    })
    .then(res => res.json())
    .then(data => console.log("Success:", data))
    .catch(error => console.error("Error:", error))
}
function DOMLoaded(func){
    docs.addEventListener("DOMContentLoaded", func)
}
/*
------------------------------------------------------------------------------------------------------------------------------
Methods
------------------------------------------------------------------------------------------------------------------------------
*/
let audioUnlocked = false;

function unlockAudio() {
    if (audioUnlocked) return;

    const a = new Audio();
    a.muted = true;
    a.play().catch(()=>{});
    a.muted = false;

    audioUnlocked = true;

    // hapus listener biar ringan
    window.removeEventListener("click", unlockAudio);
    window.removeEventListener("mousemove", unlockAudio);
    window.removeEventListener("wheel", unlockAudio);
    window.removeEventListener("keydown", unlockAudio);
    window.removeEventListener("touchstart", unlockAudio);
}

window.addEventListener("click", unlockAudio, { passive: true });
window.addEventListener("mousemove", unlockAudio, { passive: true });
window.addEventListener("wheel", unlockAudio, { passive: true });
window.addEventListener("keydown", unlockAudio);
window.addEventListener("touchstart", unlockAudio);

HTMLElement.prototype.hover = function(enter,exit){ //need click input by user first
    this.addEventListener("mouseenter",enter)
    this.addEventListener("mouseleave",exit)
    return this
}
HTMLElement.prototype.setSFX = function(eventName, sfx) {
    const audio = new Audio(sfx);
    this.addEventListener(eventName, () => {
        if (!audioUnlocked) return;
        audio.currentTime = 0; // reset ke awal
        audio.play();
    });
    return this;
};

HTMLElement.prototype.toggleClass = function(className) { // WIP FOREVER
    this.addEventListener("click",()=> {
        this.classList.toggle(className);
    });
    return this;
}
HTMLElement.prototype.Attribute = function(CGD, attribut, value) {
    let t = CGD.toLowerCase().trim()
    let y = attribut.toLowerCase().trim()
    let r = value.toLowerCase().trim()
    if(CGD === "delete"|| CGD === "del"|| CGD ==="remove") {
        this.removeAttribute(attribut)
    }
    if(CGD === "set"||CGD === "new"||CGD === "insert"){
        this.setAttribute(attribut, value)
    }
    if(CGD === "get"||CGD === "select-from"){
        this.getAttribute(attribut)
    }
}
HTMLElement.prototype.writeText = function(text) {
    this.textContent = text;
    return this;
}
EventTarget.prototype.listenEvent = function(type, command) {
    this.addEventListener(type, command)
    return this; 
}
// contoh kalo fungsi di dalam fungsi dengan kodisi
HTMLElement.prototype.addKeyBind = function(keybind, command) {
    this.setAttribute("tabindex", "0"); // biar elemen bisa fokus

    return this.addEventListener("keydown", (keys) => {
        if (keys.key.toLowerCase() === keybind.toLowerCase()) {
            command();
        }
    });

    return this; // biar bisa chaining
}
HTMLElement.prototype.GetChildren = function(){
    return Array.from(this.children)
}
Number.prototype.toCurrency = function (type,country){
  return this.toLocaleString(country, {style: "currency",currency: type})
}
/*
------------------------------------------------------------------------------------------------------------------------------
Tags
------------------------------------------------------------------------------------------------------------------------------
*/
function CodeXTagsLoad() {
// tags + attribute
selectAll("background").forEach(bg =>{
    let color = bg.getAttribute("color")
    let img = bg.getAttribute("url")
    bg.style.backgroundColor = color
    bg.style.backgroundImage = `url("${img}")`
});
selectAll("clipboard").forEach(clipboard => {
    let a = document.createElement("button")
    let code = clipboard.querySelector('code').innerText;

    a.onclick = () => {
        navigator.clipboard.writeText(code);
        a.textContent = 'Copied';
        label = clipboard.getAttribute("label")
        setTimeout(() => a.textContent = 'Copy', 3000);
        a.classList.add(label)
        clipboard.appendChild(a)
    };
});
selectAll("import").forEach(res => {
    let url = res.getAttribute("url");
    let t = res.getAttribute("type").toLowerCase();

    if (t === "image" || t === "img") {
        let alt = res.getAttribute("alt")
        let classes = res.getAttribute("classes")
        let img = document.createElement("img");
        img.src = url;
        img.alt = alt;
        img.classList.add(classes)
        res.appendChild(img);
        res.classList.remove(classes)
        res.removeAttribute("alt")
        res.removeAttribute("alt")
    }

    if (t === "stylesheet" || t === "css") {
        let a = document.createElement("link");
        a.rel = "stylesheet";
        a.href = url;
        document.body.appendChild(a);
    }

    if (t === "script" || t === "js" || t === "javascript") {
        let s = docs.createElement("script");
        s.src = url;
        res.appendChild(s);
    }

    if (t === "background" || t === "bg") {
        res.style.backgroundImage = `url(${url})`;
    }

    if (t === "textcontent") {
    fetch(url)
        .then(resp => resp.text())
        .then(dat => {
            let baris = dat.split(/\r?\n/);
            let hasil = {};

            baris.forEach((line, i) => {
                hasil[i + 1] = line.trim();
            });

            // ambil atribut index dari <import>
            let idx = res.getAttribute("index");
            if (idx && hasil[idx]) {
                res.textContent = hasil[idx];
            }
            else if (idx && hasil[idx] === "") {
                res.textContent = "Index " + idx + " is empty";
            }
            else {
                res.textContent = "Can't find line index " + idx + " line index is nil" 
            }
        })
        .catch(err => console.error("Error", err));
}
});
// <triger event="funcA()" require="click"> 
selectAll("triger").forEach(create => {
    let r = create.getAttribute("event")
    let c = create.getAttribute("require")
    create.addEventListener(c, r)
})
// sample: <var from="myscript.txt" line = "2"></var>
selectAll("transcript").forEach(text => {
    let x = text.getAttribute("line")
    let y = text.getAttribute("from")    
    text.innerHTML = `<import type="textcontent" url="${y}" index="${x}"></import>`
})
selectAll("void").forEach(v => {
    v.style.display = "none"
})
selectAll("str").forEach(str => {
    let string = str.innerHTML
    let pre = document.createElement("pre")
    pre.textContent = string
    str.innerHTML = ""
    str.appendChild(pre)
})
selectAll("fetch").forEach(fe => {
    let url = fe.getAttribute("url");
    let type = fe.getAttribute("type");

    if (type === "text") {
        fetch(url)
            .then(res => res.text())
            .then(dat => {
                print(dat);
                fe.textContent = dat;
            })
            .catch(err => print("Error:", err));
    }

    if (type === "json") {
        fetch(url)
            .then(res => res.json())
            .then(dat => {
                print(dat);
                fe.textContent = JSON.stringify(dat, null, 2);
            })
            .catch(err => print("Error:", err));
    }
});
}

//helper
function help(value){
    if(value.toLowerCase() === "addkeybind"){
        print('addKeyBind(keybind,command) example addKeyBind("k",()=>{print("hello")})')
    }
    if(value.toLowerCase() === "writetext"){
        print('writeText(text) example writeText("hello world")')
    }
    if(value.toLowerCase() === "listenevent"){
        print('listentEvent(type,command) example addKeyBind("click",()=>{print("hello")})')
    }
    if(value.toLowerCase() === "listenevent"){
        print('listentEvent(type,command) example addKeyBind("click",()=>{print("hello")})')
    }
    if(value.toLowerCase() === "listenevent"){
        print('listentEvent(type,command) example addKeyBind("click",()=>{print("hello")})')
    }
    else{
        print("fungsi tidak di temukan")
    }
}

print("ldx added")
docs.addEventListener("DOMContentLoaded", () => {
    CodeXTagsLoad()
})
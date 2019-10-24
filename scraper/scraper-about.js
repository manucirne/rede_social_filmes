const axios = require("axios");
const cheerio = require("cheerio");
const fs = require("fs");
const toNew = "fullcredits"
var item;
var subItem;

classmem = JSON.parse(fs.readFileSync("filmes5.json", "utf8"));

// const { chunk, linspace } = require("./util");
// const max = 7388;
// const stp = 250;
// const concurrent = 5;

const api = axios.create({
  baseURL: "https://www.imdb.com"
});

const parseLinks = str => {
  const doc = cheerio.load(str);
  const arr = [];
  const nome = doc("h3[itemprop=name] a").text();


  const listActor = doc("table.cast_list tr[class] td:not([class])");
  listActor.each((i, el) => {
    const a = doc(el).find('a')
    const actor = a.text()
    const href = a.attr('href')

    if (actor != ""){
      console.log(nome);
      arr.push({
          nome,actor,href
      })
    }

  });
return arr
}

(async () => {
  const responses = [];

  for (item in classmem) {
    for (subItem in classmem[item]) {
        var writeFrom = classmem[item][subItem].href.lastIndexOf("/")+1;
        var newHREF = classmem[item][subItem].href.slice(0,writeFrom).concat(toNew);
        
        const response = await 
          api
            .get(newHREF,{
              params: {
                ref_: "tt_ql_1"
              }
            })
            .then(({ data }) => {
              return parseLinks(data);
            })
        responses.push(response);
        console.log(item,"/",classmem.length)
        fs.writeFileSync("actor_title5.json",JSON.stringify(responses, null, 2));
      }    
      // console.log(`${item}/${classmem.length}`);
  }
})();
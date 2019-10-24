const axios = require("axios");
const cheerio = require("cheerio");
const fs = require("fs");
const { chunk, linspace } = require("./util");
var item;

classmem = JSON.parse(fs.readFileSync("to_scrape.json", "utf8"));

const api = axios.create({
  baseURL: "https://www.imdb.com"
});

const parseLinks = str => {
  const doc = cheerio.load(str);
  const arr = [];
  const nome = doc("h3>a").text();


//   const listActor = doc("table.cast_list tr[class] td:not([class])");
  const origin = doc("table#overviewTable.dataTable.labelValueTable td>a").text();
  // console.log(nome,origin);
  arr.push({
      nome,origin
  })
return arr
}

(async () => {
  const chunks = chunk(classmem, 250);
  const responses = [];
  for (var ck in chunks) {
    // console.log(chunks[ck])
    const response = await Promise.all(
      chunks[ck].map(step =>
        api
          .get(step,{})
          .then(({ data }) => {
            return parseLinks(data);
          })
      )
    );
    responses.push(...response);
    fs.writeFileSync("actor_origin_teste.json", JSON.stringify(responses, null, 2));
    console.log(`${ck+1}/${chunks.length}`);
  }
})();

// (async () => {
//   const responses = [];

//   //Ultimo feito 2760
//   //Proximo 2761
//   //Total a serem feitos: 20664
//   for (item in classmem) {
//         const response = await 
//           api
            // .get(classmem[item],{})
//             .then(({ data }) => {
//               return parseLinks(data);
//             })
//         responses.push(response);
//         console.log(item,"/",classmem.length-1)
//         fs.writeFileSync("actor_origin_teste.json",JSON.stringify(responses, null, 2));
//   }
// })();
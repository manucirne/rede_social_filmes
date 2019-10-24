const axios = require("axios");
const cheerio = require("cheerio");
const fs = require("fs");

const { chunk, linspace } = require("./util");
const max = 7388;
const stp = 250;
const concurrent = 5;

const api = axios.create({
  baseURL: "https://www.imdb.com/search/title/"
});

const parseLinks = str => {
  const doc = cheerio.load(str);
  const arr = [];
  const titulo = doc(".lister-item-header");
  titulo.each((i, el) => {
    const ano = doc(el).find('.lister-item-year.text-muted.unbold').text()
    const a = doc(el).find('a').first()
    const titulo = a.text()
    const href = a.attr('href')

    arr.push({
        titulo,ano,href
    })

});
return arr
}
(async () => {
  const space = linspace(1, max, stp);
  const chunks = chunk(space, concurrent);
  const responses = [];
  for (var ck in chunks) {
    const response = await Promise.all(
      chunks[ck].map(step =>
        api
          .get("/", {
            params: {
              country_of_origin: "il",
              count: stp,
              start: step,
              ref_: "adv_nxt"
            }
          })
          .then(({ data }) => {
            return parseLinks(data);
          })
      )
    );
    responses.push(...response);
    fs.writeFileSync("test.json", JSON.stringify(responses, null, 2));
    console.log("batch");
    console.log(chunks[ck], `${ck}/${chunks.length}`);
  }
})();
import axios from 'axios';
import * as cheerio from 'cheerio';

async function scanDomain(url) {
  try {
    const response = await axios.get(url)
    const content = response.data;
    const $ = cheerio.load(content);

    //this pattern checks for common tells of common build tools, '.length is not strictly necessary but conveys intention better
    const html = $.html();

    const wordpressRegex = /<meta[^>]*name=["']generator["'][^>]*content=["'][^>]*WordPress[^>]*["'][^>]*>/i;
    const jqueryRegex =  /<a[^>]*href=["']https:\/\/api\.jquery\.com\/["'][^>]*>.*<\/a>/i

    let detectedWordpress = false;
    let detectedJquery = false;

    if (wordpressRegex.test(html)) {
      console.log(`${url} is powered by WordPress`);
      detectedWordpress = true;
    }

    if (jqueryRegex.test(html)) {
      console.log(`${url} is using jQuery.`);
      detectedJquery = true;
    }
    // Additional checks can be added here

  } catch (error) {
    console.error(`Failed to scan ${url}. Error: ${error.message}`);
  }
}


(async () => {
  const targetUrl = process.argv[2];
  if (!targetUrl) {
      console.error("Please provide a URL to scan.");
      process.exit(1);
  }
  const url = targetUrl.startsWith('http') ? targetUrl : `https://${targetUrl}`;
  await scanDomain(url);
})();
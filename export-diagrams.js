const puppeteer = require('puppeteer');
const fs = require('fs');

const FILENAME_SUFFIX = '';

const PNG_FORMAT = 'png';
const SVG_FORMAT = 'svg';

const IGNORE_HTTPS_ERRORS = true;
const HEADLESS = "new";

const IMAGE_VIEW_TYPE = 'Image';

if (process.argv.length < 4) {
  console.log("Usage: <structurizrUrl> <png|svg> [username] [password]")
  process.exit(1);
}

const url = process.argv[2];
const format = process.argv[3];

if (format !== PNG_FORMAT && format !== SVG_FORMAT) {
  console.log("The output format must be ' + PNG_FORMAT + ' or ' + SVG_FORMAT + '.");
  process.exit(1);
}

var username;
var password;

if (process.argv.length > 3) {
  username = process.argv[4];
  password = process.argv[5];
}

var expectedNumberOfExports = 0;
var actualNumberOfExports = 0;

(async () => {
  const browser = await puppeteer.launch({ignoreHTTPSErrors: IGNORE_HTTPS_ERRORS, headless: HEADLESS});
  const page = await browser.newPage();

  if (username !== undefined && password !== undefined) {
    // sign in
    const parts = url.split('://');
    const signinUrl = parts[0] + '://' + parts[1].substring(0, parts[1].indexOf('/')) + '/dashboard';
    console.log(' - Signing in via ' + signinUrl);

    await page.goto(signinUrl, { waitUntil: 'networkidle2' });
    await page.type('#username', username);
    await page.type('#password', password);
    await page.keyboard.press('Enter');
    await page.waitForSelector('div#dashboard');
  }

  // visit the diagrams page
  console.log(" - Opening " + url);
  await page.goto(url, { waitUntil: 'domcontentloaded' });
  await page.waitForFunction('structurizr.scripting && structurizr.scripting.isDiagramRendered() === true');

  if (format === PNG_FORMAT) {
    // add a function to the page to save the generated PNG images
    await page.exposeFunction('savePNG', (content, filename) => {
      console.log(" - " + filename);
      content = content.replace(/^data:image\/png;base64,/, "");
      fs.writeFile(filename, content, 'base64', function (err) {
        if (err) throw err;
      });

      actualNumberOfExports++;

      if (actualNumberOfExports === expectedNumberOfExports) {
        console.log(" - Finished");
        browser.close();
      }
    });
  }

  // get the array of views
  const views = await page.evaluate(() => {
    return structurizr.scripting.getViews();
  });

  views.forEach(function(view) {
    if (view.type === IMAGE_VIEW_TYPE) {
      expectedNumberOfExports++; // diagram only
    } else {
      expectedNumberOfExports++; // diagram
      expectedNumberOfExports++; // key
    }
  });

  console.log(" - Starting export");
  for (var i = 0; i < views.length; i++) {
    const view = views[i];

    await page.evaluate((view) => {
      structurizr.scripting.changeView(view.key);
    }, view);

    await page.waitForFunction('structurizr.scripting.isDiagramRendered() === true');

    if (format === SVG_FORMAT) {
      const diagramFilename = FILENAME_SUFFIX + view.key + '.svg';
      const diagramKeyFilename = FILENAME_SUFFIX + view.key + '-key.svg'

      var svgForDiagram = await page.evaluate(() => {
        return structurizr.scripting.exportCurrentDiagramToSVG({ includeMetadata: true });
      });

      console.log(" - " + diagramFilename);
      fs.writeFile(diagramFilename, svgForDiagram, function (err) {
        if (err) throw err;
      });
      actualNumberOfExports++;

      if (view.type !== IMAGE_VIEW_TYPE) {
        var svgForKey = await page.evaluate(() => {
          return structurizr.scripting.exportCurrentDiagramKeyToSVG();
        });

        console.log(" - " + diagramKeyFilename);
        fs.writeFile(diagramKeyFilename, svgForKey, function (err) {
          if (err) throw err;
        });
        actualNumberOfExports++;
      }

      if (actualNumberOfExports === expectedNumberOfExports) {
        console.log(" - Finished");
        browser.close();
      }
    } else {
      const diagramFilename = FILENAME_SUFFIX + view.key + '.png';
      const diagramKeyFilename = FILENAME_SUFFIX + view.key + '-key.png'

      page.evaluate((diagramFilename) => {
        structurizr.scripting.exportCurrentDiagramToPNG({ includeMetadata: true, crop: false }, function(png) {
          window.savePNG(png, diagramFilename);
        })
      }, diagramFilename);

      if (view.type !== IMAGE_VIEW_TYPE) {
        page.evaluate((diagramKeyFilename) => {
          structurizr.scripting.exportCurrentDiagramKeyToPNG(function(png) {
            window.savePNG(png, diagramKeyFilename);
          })
        }, diagramKeyFilename);
      }
    }
  }

})();

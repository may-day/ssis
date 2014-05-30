scd.xsl
=======

This stylesheet extracts the mappings used in the `Slowly Changing Dimension` Components in a SSIS dtsx file along with the SCD-Types used for the fields.
It produces a very simple html document.

Usage:

1. process on the commandline:
```bash
saxonb-xslt -o result.html your_ssis_package.dtsx scd.xsl
```
2. in-document:
  - Add `<?xml-stylesheet type="text/xsl" href="scd.xsl"?>`
    to the dtsx file right after the <?xml version="1.0"?>.
  - Place the scd.xsl file in the same directory as the dtsx file.
  - Open the dtsx in the browser (tested with firefox).


n.b.:
 
- xslt 2.0 is needed
- tested with sql server 2008r2